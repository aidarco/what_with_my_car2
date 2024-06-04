import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../repos/firebase_firestore.dart';

class AddProblem extends StatefulWidget {
  AddProblem({Key? key});

  @override
  State<AddProblem> createState() => _AddProblemState();
}

class _AddProblemState extends State<AddProblem> {
  final picker = ImagePicker();
  List<String> selectedImagePaths = [];
  bool isUploading = false;

  final TextEditingController problemNameController = TextEditingController();
  final TextEditingController problemDescriptionController =
  TextEditingController();
  final TextEditingController yearController =
  TextEditingController();
  Future<void> pickImage() async {
    setState(() {
      isUploading = true;
    });
    final result = await picker.pickMultiImage();
    if (result != null) {
      setState(() {
        selectedImagePaths = result.map((image) => image.path).toList();
        isUploading = false;
      });
    } else {
      setState(() {
        isUploading = false;
      });
    }
  }


  String? selectedModel;
  String? selectedTypeOfBreakdown;

  List<String> typesOfBreakdowns = [
    "Ходовая часть (подвеска)",
    'Тормозная система',
    'Двигатель',
    'Кузовные поломки',
    'Электрика и электроника',
    'Трансмиссия и привод',
    'Система охлаждения',
    'Система выпуска',
    'Система подачи топлива',
    'Система вентиляции салона',
    'Система эмиссии',
    'Система управления',
  ];

  List<String> brands = [
    "Лада",
    'Audi',
    'BMW',
    'Mercedes-Benz',
    'Toyota',
    'Honda',
  ];

  String? selectedBrand; // Providing a default value

  Map<String, List<String>> modelsByBrand = {
    'Лада': [
      'Granta',
      'Vesta',
      '2104',
      '2105',
      '2106',
      '2107',
      'Samara'
    ],
    'Audi': ['A1', 'A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7'],
    'BMW': [
      '1 Series',
      '3 Series',
      '5 Series',
      '7 Series',
      'X1',
      'X3',
      'X5'
    ],
    'Mercedes-Benz': [
      'A-Class',
      'C-Class',
      'E-Class',
      'S-Class',
      'GLA',
      'GLC',
      'GLE'
    ],
    'Toyota': [
      'Corolla',
      'Camry',
      'Rav4',
      'Highlander',
      'Prius',
      'Land Cruiser'
    ],
    'Honda': [
      'Civic',
      'Accord',
      'CR-V',
      'Pilot',
      'HR-V',
      'Odyssey'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          "Добавление проблемы",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                TextFieldAddWidget(
                  hintText: "Название проблемы",
                  controller: problemNameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldAddWidget(
                  hintText: "Описание проблемы",
                  controller: problemDescriptionController,
                  maxLines: 8,
                ),
                const SizedBox(
                  height: 24,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  DropdownButtonFormField<String>(
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.grey.shade700,
                    decoration: const InputDecoration(
                        labelText: 'Марка машины',
                        labelStyle: TextStyle(
                            color: Colors.white),
                        contentPadding:
                        EdgeInsets.symmetric(
                            vertical: 10),
                        focusedBorder:
                        UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                Colors.white))),
                    value: selectedBrand,
                    items: brands.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedBrand = value;
                        selectedModel =
                        null; // Reset selected model when brand changes
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  DropdownButtonFormField<String>(
                      style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.grey.shade700,
                    decoration: const InputDecoration(
                        labelText: 'Модель',
                        labelStyle: TextStyle(
                            color: Colors.white),
                        contentPadding:
                        EdgeInsets.symmetric(
                            vertical: 10),
                        focusColor: Colors.white,

                        hoverColor: Colors.white,
                        focusedBorder:
                        UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                Colors.white))),
                    value: selectedModel,
                    items: selectedBrand != null
                        ? modelsByBrand[selectedBrand!]!
                        .map((String model) {
                      return DropdownMenuItem<
                          String>(
                        value: model,
                        child: Text(model),
                      );
                    }).toList()
                        : null,
                    // If selectedBrand is null, don't display models
                    onChanged: (String? value) {
                      setState(() {
                        selectedModel = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  DropdownButtonFormField<String>(
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.grey.shade700,
                    decoration: const InputDecoration(
                        labelText: 'Тип поломки',
                        labelStyle: TextStyle(
                            color: Colors.white),
                        contentPadding:
                        EdgeInsets.symmetric(
                            vertical: 10),
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        focusedBorder:
                        UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                Colors.white))),
                    value: selectedTypeOfBreakdown,
                    items: typesOfBreakdowns
                        .map((String typesOfBreakdown) {
                      return DropdownMenuItem<String>(
                        value: typesOfBreakdown,
                        child: Text(typesOfBreakdown),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedTypeOfBreakdown = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: yearController,
                    decoration: InputDecoration(
                      hintText: "Год выпуска",
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    keyboardType: TextInputType.number, // Устанавливаем тип клавиатуры
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Фильтруем только цифры
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: isUploading ? null : pickImage,
                  child: Text("Выбрать фотографии"),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImagePaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(
                          File(selectedImagePaths[index]),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                isUploading
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator( color:  Colors.white,),
                    ) // Индикатор загрузки
                    : TextButton(
                  onPressed: () async {
                    if (problemNameController.text.trim().isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ошибка'),
                          content: Text('Пожалуйста, введите название проблемы'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    if (problemDescriptionController.text.trim().isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ошибка'),
                          content: Text('Пожалуйста, введите описание проблемы'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    setState(() {
                      isUploading = true;
                    });
                    await Firebasefirestore()
                        .addProblemToFirestore(
                      carMark: selectedBrand ?? "",
                      carModel: selectedModel ?? "",
                      problemType: selectedTypeOfBreakdown ?? "",
                      problemName: problemNameController.text,
                      description: problemDescriptionController.text,
                      imagePaths: selectedImagePaths,
                      year: yearController.text,
                      date: DateTime.now(),
                    );

                  await   Firebasefirestore().userCreateProblemPlus(userId: FirebaseAuth.instance.currentUser!.uid);
                    setState(() {
                      isUploading = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Добавить проблему",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldAddWidget extends StatelessWidget {
  final hintText;
  final controller;
  final maxLines;

  const TextFieldAddWidget(
      {Key? key,
        required this.hintText,
        required this.controller,
        this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      cursorColor: Colors.white,
      maxLines: maxLines,
      decoration: InputDecoration(
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade800,
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white)),
      ),
      style: TextStyle(color: Colors.grey.shade300),
    );
  }
}
