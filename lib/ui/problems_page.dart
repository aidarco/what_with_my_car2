import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_with_my_car/ui/page_of_problem.dart';

import '../models/problemModel.dart';
import '../repos/firebase_firestore.dart';

class Problem extends StatefulWidget {
  const Problem({super.key});

  @override
  State<Problem> createState() => _ProblemState();
}

class _ProblemState extends State<Problem> {



  void updateFilters(String? brand, String? model, String? typeOfBreakdown) {
    setState(() {
      selectedBrand = brand;
      selectedModel = model;
      selectedTypeOfBreakdown = typeOfBreakdown;
    });
  }


  String? selectedBrand;
  String? selectedModel;
  String? selectedTypeOfBreakdown;


  @override
  void initState() {
    super.initState();
  }
  var searchController = "";

  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
              child: TextField(
                onChanged: (value)
                {
                  setState(() {
                    searchController = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print(selectedBrand);
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

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {

                                return AlertDialog(
                                  backgroundColor: Colors.grey.shade600,
                                  title: const Text(
                                    "Фильтры",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState)  {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [

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
                                                            vertical: 6),
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
                                                    selectedModel = null; // Сбросить выбранную модель при смене марки
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
                                                    labelText: 'Модель машины',
                                                    labelStyle: TextStyle(
                                                        color: Colors.white),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6),
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
                                                            vertical: 6),
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
                                                    selectedTypeOfBreakdown = value;
                                                },
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    hintText: "Год выпуска",
                                                    hintStyle: TextStyle(
                                                        color: Colors.white),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.white))),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        updateFilters(selectedBrand, selectedModel, selectedTypeOfBreakdown);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Применить',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedBrand = null; // Сбросить выбранную марку
                                          selectedModel = null; // Сбросить выбранную модель
                                          selectedTypeOfBreakdown = null; // Сбросить выбранный тип поломки
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Отменить',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },

                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 12),
                    hintText: "Поиск",
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    hintStyle: const TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    )),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firebasefirestore().getFilteredProblemsStream(selectedBrand ?? "", selectedModel ?? "", selectedTypeOfBreakdown ?? "",searchController) ,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('ошибка: ${snapshot.error}', style: TextStyle(color: Colors.white, fontSize: 15),));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final problems = snapshot.data!.docs
              .map((doc) =>
                  ProblemModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              await Firebasefirestore().getProblemsFromFirestore();
            },
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: problems.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16, right: 4, left: 4),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => PageOfProblem(),
                            arguments: {"id": problems[index].id});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                width: double.infinity,
                                height: 330,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  image: problems[index].imageUrls.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              problems[index].imageUrls.first),
                                          fit: BoxFit.cover)
                                      : const DecorationImage(
                                          image: AssetImage(
                                              "lib/images/noimage.png"),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Text(
                                  problems[index].problemName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20,  // Максимальное количество строк
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  problems[index].carMark + " " + problems[index].carModel,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20, overflow: TextOverflow.ellipsis,),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  problems[index].description,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis, ),
                                ),
                                const SizedBox(height: 6),
                              ],),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    right: 20,
                    bottom: 20,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "add");
                          },
                          child: const Text(
                            "+",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          )),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
