import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});

  final String id = Get.arguments["id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade800,),
        backgroundColor: Colors.grey.shade900,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                    radius: 88,
                                    backgroundImage: (userData["avatar"] !=
                                            null)
                                        ? NetworkImage(userData["avatar"])
                                        : const NetworkImage(
                                            "https://www.iephb.ru/wp-content/uploads/2021/01/img-placeholder.png")),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData["name"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              userData["description"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Создал",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Text(
                                      userData["problemsCreated"].toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.red,
                                  thickness: 20,
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Помощи",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Text(
                                      userData["problemsDesided"].toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error" + snapshot.error.toString()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
