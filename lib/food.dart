import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vulemacro/main.dart';
import 'dart:convert';

class Food {
  String name, imagefile;
  MacroNutrients macros;
  List<FoodPortion> portions;
  late Function onDelete;
  Food(
      {required this.name,
      required this.imagefile,
      required this.macros,
      this.portions = const []});

  void onDeleteButtonPressed() {}

  Food.fromJson(Map<String, dynamic> jsonObject)
      : name = "",
        imagefile = "",
        macros =
            MacroNutrients(calories: 0, protein: 0, carbohidrates: 0, fat: 0),
        portions = [] {
    name = jsonObject['n'];
    imagefile = jsonObject['i'];
    macros = MacroNutrients.fromJson(jsonObject['m']);
    Iterable l = jsonObject["portions"];
    portions =
        List<FoodPortion>.from(l.map((model) => FoodPortion.fromJson(model)));
  }

  Map<String, dynamic> toJson() =>
      {'n': name, 'i': imagefile, 'm': macros, 'portions': portions};

  Future<Widget> getFoodWidget(Function ondelete) async {
    return Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.amber[900]!, width: 2),
              color: Colors.amber[900]),
          child: Stack(children: [
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 100,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(await getFilePath(imagefile))))),
              ),
            ),
            Positioned(
                top: 60, left: 100, child: Text("Protein ${macros.protein}")),
            Positioned(
                top: 60,
                left: 200,
                child: Text("Carbs ${macros.carbohidrates}")),
            Positioned(top: 60, left: 300, child: Text("Fat ${macros.fat}")),
            Positioned(
              top: 40,
              left: 170,
              child: Text("Calories: ${macros.calories}"),
            ),
            Positioned(
                top: 20,
                right: 20,
                width: 30,
                height: 30,
                child: FloatingActionButton(
                    onPressed: () {
                      Foods.remove(this);
                      saveFoods();
                      ondelete();
                    },
                    child: const Icon(Icons.delete)))
          ]),
        ));
  }
}

class FoodPortion {
  String name;
  int grams;
  FoodPortion({required this.name, required this.grams});

  FoodPortion.fromJson(Map<String, dynamic> json)
      : name = json['n'],
        grams = json['g'];

  Map<String, dynamic> toJson() => {'n': name, 'g': grams};
}

class MacroNutrients {
  double protein, carbohidrates, fat, calories;
  MacroNutrients.fromJson(Map<String, dynamic> json)
      : protein = json['p'] + .0,
        carbohidrates = json['c'] + .0,
        fat = json['f'] + .0,
        calories = json['cal'] + .0;
  Map<String, dynamic> toJson() =>
      {'p': protein, 'c': carbohidrates, 'f': fat, 'cal': calories};
  MacroNutrients(
      {required this.calories,
      required this.protein,
      required this.carbohidrates,
      required this.fat});
}

Future<String> getFilePath(String filename) async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/$filename'; // 3

  return filePath;
}
