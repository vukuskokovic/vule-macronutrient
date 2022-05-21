import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vulemacro/food.dart';
import 'main.dart';

class FoodLog {
  late String foodName;
  late int grams;
  late int hour, minute;

  FoodLog({required this.grams, required this.foodName});

  FoodLog.fromJson(Map<String, dynamic> json)
      : foodName = json['name'],
        grams = json['grams'],
        hour = json['hour'],
        minute = json['minute'];

  Map<String, dynamic> toJson() =>
      {'name': foodName, 'grams': grams, 'hour': hour, 'minute': minute};

  MacroNutrients calculateMacros() {
    int protein = -1;
    int carbs = 0;
    int fat = 0;
    int calories = 0;
    for (int i = 0; i < Foods.length; i++) {
      if (Foods[i].name == foodName) {
        double foodRatio = grams.toDouble() / 100.0;
        protein = (Foods[i].macros.protein * foodRatio).toInt();
        carbs = (Foods[i].macros.carbohidrates * foodRatio).toInt();
        fat = (Foods[i].macros.fat * foodRatio).toInt();
        calories = (Foods[i].macros.calories * foodRatio).toInt();
        return MacroNutrients(
            calories: calories,
            protein: protein,
            carbohidrates: carbs,
            fat: fat);
      }
    }
    return MacroNutrients(
        calories: -1, protein: -1, carbohidrates: -1, fat: -1);
  }

  Widget getLogWidget() {
    var macros = calculateMacros();
    if (macros.protein == -1) {
      return Text('Food $foodName not found');
    }
    return Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.amber[900],
                borderRadius: BorderRadius.circular(6)),
            child: Stack(children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "$foodName(${grams}g)",
                    style: GoogleFonts.robotoMono(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "${hour < 10 ? "0$hour" : hour.toString()}:${minute < 10 ? "0$minute" : minute.toString()}",
                      style: GoogleFonts.mukta(color: Colors.white),
                    ),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text("${macros.calories}cal",
                        style: GoogleFonts.mukta(color: Colors.white))),
              ),
              Positioned(
                top: 20,
                width: 350,
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Text("🥩${macros.protein}",
                        style: GoogleFonts.bebasNeue(color: Colors.white)),
                    Text("🥔${macros.carbohidrates}",
                        style: GoogleFonts.bebasNeue(color: Colors.white)),
                    Text("🧀${macros.fat}",
                        style: GoogleFonts.bebasNeue(color: Colors.white))
                  ],
                ),
              )
            ])));
  }
}
