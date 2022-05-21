import 'package:flutter/material.dart';
import 'main.dart';

class FoodWidget extends StatefulWidget {
  const FoodWidget({Key? key}) : super(key: key);

  @override
  State<FoodWidget> createState() => FoodWidgetState();
}

class FoodWidgetState extends State<FoodWidget> {
  static List<Widget> FoodWidgets = [];

  void buildFoods() {
    setState(() {
      FoodWidgets.clear();
      for (int i = 0; i < Foods.length; i++) {
        FoodWidgets.add(FutureBuilder<Widget>(
            future: Foods[i].getFoodWidget(() {
              setState(() => {build(context)});
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return snapshot.data!;
              } else {
                return const Text("Loading...");
              }
            }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    buildFoods();
    return Scaffold(
        body: ListView(
      children: FoodWidgets,
    ));
  }
}
