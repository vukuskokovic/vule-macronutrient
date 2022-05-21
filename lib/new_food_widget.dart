import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vulemacro/food.dart';
import 'main.dart';

class NewFoodWidget extends StatefulWidget {
  const NewFoodWidget({Key? key}) : super(key: key);

  @override
  State<NewFoodWidget> createState() => NewFoodState();
}

class NewFoodState extends State<NewFoodWidget> {
  static ImageProvider image = const AssetImage("assets/blank.png");
  static late File imageFile;
  static late BuildContext buildContext;
  static bool imageInited = false;
  static TextEditingController proteinController = TextEditingController(),
      carbController = TextEditingController(),
      fatController = TextEditingController(),
      nameController = TextEditingController(),
      calorieController = TextEditingController();
  Widget getInputField(String label, TextEditingController controller,
      {bool isnumber = true}) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: isnumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isnumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null);
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Stack(
      children: [
        Positioned(
            top: 50,
            left: 10,
            child:
                Image(image: image, width: 150, height: 150, fit: BoxFit.fill)),
        Positioned(
            top: 200,
            left: 45,
            child: TextButton(
              onPressed: () => addImagePressed(),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amber[900]!),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              child: const Text("Add Image"),
            )),
        Positioned(
            top: 60,
            left: 180,
            width: 140,
            height: 50,
            child: getInputField("Name", nameController, isnumber: false)),
        Positioned(
            left: 180,
            top: 120,
            width: 100,
            height: 50,
            child: getInputField("Calories", calorieController)),
        Positioned(
            left: 180,
            top: 170,
            width: 100,
            height: 50,
            child: getInputField("🥩", proteinController)),
        Positioned(
            left: 180,
            top: 220,
            width: 100,
            height: 50,
            child: getInputField("🥔", carbController)),
        Positioned(
            left: 180,
            top: 270,
            width: 100,
            height: 50,
            child: getInputField("🧀", fatController)),
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton(
                  onPressed: addFoodPressed, child: const Icon(Icons.check)),
            ))
      ],
    );
  }

  void addFoodPressed() async {
    final manager = ScaffoldMessenger.of(buildContext);
    if (proteinController.text == "" ||
        carbController.text == "" ||
        fatController.text == "" ||
        nameController.text == "" ||
        calorieController.text == "" ||
        !imageInited) {
      manager.showSnackBar(
          const SnackBar(content: Text("Please fill in all the inputs above")));
      return;
    }
    int protein = int.parse(proteinController.text);
    int carbs = int.parse(carbController.text);
    int fat = int.parse(fatController.text);
    int calories = int.parse(calorieController.text);
    String name = nameController.text;
    String path = await getFilePath(name + extension(imageFile.path));
    imageFile = await imageFile.copy(path);
    Food newFood = Food(
        imagefile: basename(imageFile.path),
        name: name,
        macros: MacroNutrients(
            protein: protein,
            fat: fat,
            carbohidrates: carbs,
            calories: calories));
    for (int i = 0; i < Foods.length; i++) {
      if (Foods[i].name == name) {
        Foods.removeAt(i);
        break;
      }
    }
    Foods.add(newFood);
    saveFoods();
    manager.showSnackBar(const SnackBar(content: Text("Food added")));
  }

  void addImagePressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (photo != null) {
        imageFile = File(photo.path);
        image = FileImage(imageFile);
        imageInited = true;
      }
    });
  }
}
