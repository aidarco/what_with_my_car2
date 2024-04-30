import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final problem = snapshot.data!;
            return ListView(
              children: [
                const SizedBox(height: 12),
                Text(
                  problem.problemName,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  problem.description,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                // Отображение изображений
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: problem.imageUrls.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildImageWidget(problem.imageUrls[index]),
                  ),
                ),
                // Поле ввода комментария
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            // Получение информации о текущем пользователе
                            User? user = FirebaseAuth.instance.currentUser;

                            if (controller.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Ошибка'),
                                  content:
                                  const Text('Пожалуйста, введите комментарий'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            if (user != null) {
                              // Получение данных о пользователе из Firestore
                              DocumentSnapshot userData = await FirebaseFirestore
                                  .instance
                                  .collection("Users")
                                  .doc(user.uid)
                                  .get();
                              // Создание объекта CommentModel с информацией о пользователе и тексте комментария
                              final comment = CommentModel(
                                userId: userData['id'],
                                userName: userData['name'],
                                userAvatar: userData['avatar'],
                                // Предполагается, что у вас есть поле 'avatar' в документе пользователя
                                text: controller.text.toString(), // Текст комментария
                              );

                              // Передача объекта CommentModel в функцию addCommentToProblem
                              await Firebasefirestore().addCommentToProblem(
                                  problemId: id, comment: comment);
                              controller.clear();
                            } else {
                              // Пользователь не аутентифицирован, выполните необходимые действия
                            }
                          },
                        ),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 48, 12),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white)),
                        hintText: "Напишите комментарий",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(18))),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),

                // Кнопка для добавления комментария
                TextButton(
                    onPressed: () async {
                      // Получение информации о текущем пользователе
                      User? user = FirebaseAuth.instance.currentUser;

                      if (controller.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Ошибка'),
                            content:
                                const Text('Пожалуйста, введите комментарий'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (user != null) {
                        // Получение данных о пользователе из Firestore
                        DocumentSnapshot userData = await FirebaseFirestore
                            .instance
                            .collection("Users")
                            .doc(user.uid)
                            .get();
                        // Создание объекта CommentModel с информацией о пользователе и тексте комментария
                        final comment = CommentModel(
                          userId: userData['id'],
                          userName: userData['name'],
                          userAvatar: userData['avatar'],
                          // Предполагается, что у вас есть поле 'avatar' в документе пользователя
                          text: controller.text.toString(), // Текст комментария
                        );

                        // Передача объекта CommentModel в функцию addCommentToProblem
                        await Firebasefirestore().addCommentToProblem(
                            problemId: id, comment: comment);
                        controller.clear();
                      } else {
                        // Пользователь не аутентифицирован, выполните необходимые действия
                      }
                    },
                    child: const Text(
                      "Добавить",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )),
                const SizedBox(height: 12),

                // Заголовок "Комментарии"
                const Text(
                  'Комментарии',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Отображение комментариев
                CommentsWidget(problem: problem, id: id),
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
        return const Column(
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
      errorBuilder: (context, error, stackTrace) => Image.asset(
        "lib/images/noimage.png",
        fit: BoxFit.cover,
      ),
      fit: BoxFit.cover,
    );
  }
}

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({
    super.key,
    required this.problem,
    required this.id,
  });

  final ProblemModel problem;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: problem.comments.length,
      itemBuilder: (context, index) {
        final comment = problem.comments[index];
        final isCreator =
            FirebaseAuth.instance.currentUser?.uid == problem.userId;
        bool isHelpful = comment.isHelpful;

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(comment.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? userData =
                  snapshot.data?.data() as Map<String, dynamic>;
              if (userData != null) {
                final userName = userData['name'];
                final userAvatar = userData['avatar'];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    color: isHelpful
                        ? Colors.lightGreen.shade900
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(userAvatar),
                          ),
                          title: Text(
                            userName,
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            comment.text,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          trailing: isCreator && !comment.isHelpful
                              ? IconButton(
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () {
                                    Firebasefirestore()
                                        .markCommentAsHelpful(comment, id);
                                  },
                                )
                              : null,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Text('User data not found');
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
