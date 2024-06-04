import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:what_with_my_car/repos/firebase_firestore.dart';
import 'package:what_with_my_car/ui/page_of_problem.dart';

import '../models/problemModel.dart';

class UserProblem extends StatefulWidget {
  const UserProblem({super.key});

  @override
  State<UserProblem> createState() => _UserProblemState();
}

class _UserProblemState extends State<UserProblem> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: Text(
            "Ваши проблемы",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: currentUser != null
              ? Firebasefirestore().getUserProblemsStream(currentUser!.uid)
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'ошибка: ${snapshot.error}',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final problems = snapshot.data!.docs
                .map((doc) =>
                    ProblemModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList();
            return ListView.builder(itemCount: problems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(() => PageOfProblem(),
                          arguments: {"id": problems[index].id});
                    },
                    child: Container(
                      height: 185,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Text(problems[index].problemName, style: TextStyle(color: Colors.white, fontSize: 22, overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(height: 10,),
                            Text(problems[index].description, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 18, overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(height: 10,),
                            Text(problems[index].carMark + " " + problems[index].carModel + " " + problems[index].year , maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 16, overflow: TextOverflow.ellipsis),
                            ),
                            Text(DateFormat('yy-MM-dd HH:mm').format(problems[index].date), maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 16, overflow: TextOverflow.ellipsis),
                            ),
                          ],),
                        ),
                      ),
                    ),
                  ),
                ));
          },
        ));
  }
}
