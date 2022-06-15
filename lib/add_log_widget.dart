import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vulemacro/food.dart';
import 'package:vulemacro/food_log.dart';
import 'main.dart';
import 'dart:convert';

class AddLogWidget extends StatefulWidget {
  Function closeCallback;
  AddLogWidget({required this.closeCallback, Key? key}) : super(key: key);

  @override
  State<AddLogWidget> createState() => AddLogWidgetState();
}

class AddLogWidgetState extends State<AddLogWidget> {
  String? selectedValue;
  late Food selectedFood;
  int protein = 0;
  int carbs = 0;
  int fat = 0;
  TextEditingController caloriesController = TextEditingController(),
      gramsController = TextEditingController();

  void calcMacros() {
    double? grams = double.tryParse(gramsController.text);
    if (grams == null) {
      protein = 0;
      carbs = 0;
      fat = 0;
      return;
    }
    final double scale = grams / 100.0;
    setState(() {
      protein = (scale * selectedFood.macros.protein).toInt();
      carbs = (scale * selectedFood.macros.carbohidrates).toInt();
      fat = (scale * selectedFood.macros.fat).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodNames =
        Foods.map((value) => capitalize(value.name)).toList();
    foodNames.sort(((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
    if (foodNames.isNotEmpty && selectedValue == null) {
      selectedValue = foodNames[0];
      selectedFood = Foods[0];
    }
    return WillPopScope(
        onWillPop: () async {
          widget.closeCallback();
          return false;
        },
        child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Scaffold(
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: DropdownButton(
                        value: selectedValue,
                        items: foodNames
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value.toString();
                            selectedFood = Foods.firstWhere((element) =>
                                element.name.toLowerCase() ==
                                value.toString().toLowerCase());
                          });
                        }),
                  ),
                  const Positioned(left: 50, top: 80, child: Text("Grams")),
                  Positioned(
                      left: 50,
                      top: 100,
                      width: 100,
                      height: 30,
                      child: SizedBox(
                          child: TextField(
                              controller: gramsController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                double? grams = double.tryParse(value);
                                if (grams == null) {
                                  caloriesController.text = '0';
                                  return;
                                }
                                double calories = (grams / 100.0) *
                                    selectedFood.macros.calories;
                                caloriesController.text =
                                    calories.toInt().toString();
                                calcMacros();
                              },
                              inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]))),
                  const Positioned(left: 220, top: 80, child: Text("Calories")),
                  Positioned(
                      left: 220,
                      top: 100,
                      width: 100,
                      height: 30,
                      child: SizedBox(
                          child: TextField(
                              //Calories
                              controller: caloriesController,
                              onChanged: (value) {
                                final double? calories = double.tryParse(value);
                                if (calories == null) {
                                  gramsController.text = '0';
                                  return;
                                }
                                double grams = (calories /
                                        selectedFood.macros.calories
                                            .toDouble()) *
                                    100.0;
                                gramsController.text = grams.toInt().toString();
                                calcMacros();
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]))),
                  Positioned(
                      left: 200,
                      top: 200,
                      child: Column(
                        children: [
                          Text(
                            "Protein ${protein}g",
                          ),
                          Text(
                            "Carbs ${carbs}g",
                          ),
                          Text(
                            "Fat ${fat}g",
                          )
                        ],
                      ))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.check),
                onPressed: () {
                  int? grams = int.tryParse(gramsController.text);
                  if (grams != null) {
                    int calories = int.parse(caloriesController.text);
                    preferenceInstance.setInt("caloriesleft",
                        preferenceInstance.getInt("caloriesleft")! - calories);

                    FoodLog log =
                        FoodLog(foodName: selectedFood.name, grams: grams);
                    var time = DateTime.now();
                    log.hour = time.hour;
                    log.minute = time.minute;
                    String? foodsJson =
                        preferenceInstance.getString("todaylog");

                    List<FoodLog> logs = [];
                    if (foodsJson != null) {
                      Iterable l = json.decode(foodsJson);
                      logs = l.map((model) => FoodLog.fromJson(model)).toList();
                    }
                    logs.add(log);
                    preferenceInstance.setString("todaylog", jsonEncode(logs));
                  }
                  widget.closeCallback();
                },
              ),
            )));
  }
}

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}
