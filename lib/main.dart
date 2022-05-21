import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_widget.dart';
import 'food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

List<Food> Foods = [];
late SharedPreferences preferenceInstance;

void saveFoods() {
  preferenceInstance.setString("foods", jsonEncode(Foods));
}

void main() async {
  runApp(const MyApp());
  preferenceInstance = await SharedPreferences.getInstance();
  String? foodsJson = preferenceInstance.getString("foods");
  Foods = <Food>[];
  if (foodsJson != null) {
    Iterable l = json.decode(foodsJson);
    Foods = List<Food>.from(l.map((model) => Food.fromJson(model)));
  } else {
    Foods = [];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.amber[900],
    ));
    return const MaterialApp(home: MainWidget());
  }
}
