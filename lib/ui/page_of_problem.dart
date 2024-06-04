import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:what_with_my_car/ui/user_page.dart';

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
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("problems")
                .doc(id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final problemData =
                    snapshot.data?.data() as Map<String, dynamic>;
                final currentUser = FirebaseAuth.instance.currentUser;
                final isCreator = problemData['userId'] == currentUser?.uid;

                if (isCreator) {
                  return TextButton(
                    onPressed: () {
                      // Добавьте здесь обработчик нажатия на кнопку "Удалить"
                      Firebasefirestore().deleteProblem(id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Удалить",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              }
              // Если пользователь не является создателем проблемы или данные не загружены, вернуть пустой контейнер
              return Container();
            },
          ),
        ],
        backgroundColor: Colors.grey.shade800,
      ),
      backgroundColor: Colors.grey.shade900,
      body: StreamBuilder<ProblemModel?>(
        stream: Firebasefirestore().getProblemStreamFromFirestore(id: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasData) {
            final problem = snapshot.data!;

            return ListView(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    problem.problemName,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  DateFormat('yy-MM-dd HH:mm').format(problem.date),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                  Text(
                    problem.carMark +
                        " " +
                        problem.carModel +
                        " " + problem.year + " " +
                        (problem.year.isNotEmpty
                            ? "г"
                            : ""),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                if (problem.problemType.isNotEmpty)
                  Text(
                    "Тип поломки: " + problem.problemType,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 8),
                  child: Text(
                    problem.description,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                // Отображение изображений
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: problem.imageUrls.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Переход на экран с полноразмерным изображением
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageGallery(
                              imageUrls: problem.imageUrls,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: _buildImageWidget(problem.imageUrls[index]),
                    ),
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

                            if (controller.text.trim().isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Ошибка'),
                                  content: const Text(
                                      'Пожалуйста, введите комментарий'),
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
                              DocumentSnapshot userData =
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(user.uid)
                                      .get();
                              // Создание объекта CommentModel с информацией о пользователе и тексте комментария
                              final comment = CommentModel(
                                userId: userData['id'],
                                userName: userData['name'],
                                date: DateTime.now(),
                                // Предполагается, что у вас есть поле 'avatar' в документе пользователя
                                text: controller.text
                                    .toString(), // Текст комментария
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

class FullScreenImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  FullScreenImageGallery({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PhotoViewGallery.builder(
        pageController: pageController,
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        enableRotation: true,
      ),
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
      itemCount: problem.sortedComments.length,
      itemBuilder: (context, index) {
        final comment = problem.sortedComments[index];
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
                      vertical: 8.0, horizontal: 4.0),
                  child: Container(
                    color: isHelpful
                        ? Colors.lightGreen.shade800
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              Get.to(() => UserPage(),
                                  arguments: {"id": userData['id']});
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: (userData["avatar"] != null)
                                  ? NetworkImage(userData["avatar"])
                                  : const NetworkImage(
                                  "https://www.iephb.ru/wp-content/uploads/2021/01/img-placeholder.png"),
                            ),
                          ),
                          title: Text(
                            userName,
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yy-MM-dd HH:mm')
                                    .format(comment.date),
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              // Добавляем небольшое пространство между датой и текстом комментария
                              Text(
                                comment.text,
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: isCreator && !comment.isHelpful
                              ? IconButton(
                            icon: const Icon(
                                Icons.check_circle, color: Colors.green),
                            onPressed: () async {
                              bool? confirmed = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Подтверждение'),
                                    content: Text(
                                        'Вы уверены, что этот комментарий вам помог?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Нет'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Да'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmed == true) {
                                Firebasefirestore()
                                    .markCommentAsHelpful(comment, id);
                              }
                            },
                          )
                              : null,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.3,
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
