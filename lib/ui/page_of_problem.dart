import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/commentModel.dart';
import '../models/problemModel.dart';
import '../repos/firebase_firestore.dart';

class PageOfProblem extends StatelessWidget {
  PageOfProblem({super.key});

  final String id = Get.arguments["id"];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
      ),
      backgroundColor: Colors.grey.shade900,
      body: StreamBuilder<ProblemModel?>(
        stream: Firebasefirestore().getProblemStreamFromFirestore(id: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final problem = snapshot.data!;
            return ListView(
              children: [
                SizedBox(height: 12),
                Text(
                  problem.problemName,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  problem.description,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                // Отображение изображений
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: problem.imageUrls.length,
                  itemBuilder: (context, index) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildImageWidget(problem.imageUrls[index]),
                      ),
                ),
                // Поле ввода комментария
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Напишите комментарий",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(18))),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),

                // Кнопка для добавления комментария
                TextButton(onPressed: () async {
                  // Получение информации о текущем пользователе
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Получение данных о пользователе из Firestore
                    DocumentSnapshot userData = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
                    // Создание объекта CommentModel с информацией о пользователе и тексте комментария
                    final comment = CommentModel(
                      userId: userData['id'],
                      userName: userData['name'],
                      userAvatar: userData['avatar'], // Предполагается, что у вас есть поле 'avatar' в документе пользователя
                      text: controller.text.toString(), // Текст комментария
                    );

                    // Передача объекта CommentModel в функцию addCommentToProblem
                    await Firebasefirestore().addCommentToProblem(problemId: id, comment: comment);
                    controller.clear() ;
                  } else {
                    // Пользователь не аутентифицирован, выполните необходимые действия
                  }
                }, child: Text("Добавить", style: TextStyle(color: Colors.white, fontSize: 24),)),
                const SizedBox(height: 12),

                // Заголовок "Комментарии"
                const Text(
                  'Комментарии',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center  ,
                ),
                const SizedBox(height: 12),

                // Отображение комментариев
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: problem.comments.length,
                  itemBuilder: (context, index) {
                    final comment = problem.comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30, // Увеличиваем радиус аватара
                              backgroundImage: NetworkImage(comment.userAvatar),
                            ),
                            title: Text(
                              comment.userName,
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            subtitle: Text(
                              comment.text,
                              style: TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Виджет для отображения изображения
  Widget _buildImageWidget(String imageUrl) {
    return Image.network(
      imageUrl,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Column(
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'Загрузка изображения',
              style: TextStyle(color: Colors.white),
            ),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          Image.asset(
            "lib/images/noimage.png",
            fit: BoxFit.cover,
          ),
      fit: BoxFit.cover,
    );
  }
}
