import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:what_with_my_car/models/userModel.dart';

import '../models/commentModel.dart';
import '../models/problemModel.dart';

class Firebasefirestore {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> firebaseAuth(
      {required String email, required String password}) async {
    final result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<void> firebaseReg({required String email, required String password}) async {
    try {
      // Пытаемся зарегистрировать нового пользователя
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Проверяем, успешно ли зарегистрирован новый пользователь
      if (result.user == null) {
        throw Exception('Не удалось зарегистрировать пользователя.');
      }

      // Дополнительные действия после успешной регистрации
      String uid = result.user!.uid;
      final user = db.collection("Users").doc(uid);
      final model = UserModel(
        name: email.toString().split("@")[0],
        description: "",
        id: uid,
        problemsDesided: 0,
        problemsCreated: 0,
      );
      await user.set(model.toJson());

      // Отправка подтверждающего письма
      await result.user!.sendEmailVerification();
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при регистрации: $e');

    }
  }


  Future<void> addProblemToFirestore({
    required String problemName,
    required String description,
    required List<String> imagePaths,
    required String carMark,
    required String carModel,
    required String problemType,
    required String year,
    required DateTime date,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String id =
        FirebaseFirestore.instance.collection('problems').doc().id;

    List<String> imageUrls = [];
    try {
      for (final imagePath in imagePaths) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('problem_images/$id/${basename(imagePath)}');
        final uploadTask =
            ref.putFile(File(imagePath)); // Use File instance for upload
        final snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      }
    } on FirebaseException catch (e) {
      print('Error uploading images: $e');
      // Handle upload errors gracefully (e.g., show a snackbar to the user)
    }

    // Store problem data with image URLs in Firestore
    try {
      final docRef = FirebaseFirestore.instance.collection('problems').doc(id);
      await docRef.set(ProblemModel(
        id: id,
        userId: auth.currentUser!.uid,
        description: description,
        problemName: problemName,
        imageUrls: imageUrls,
        carMark: carMark,
        carModel: carModel,
        problemType: problemType,
        year: year,
        date: date,
      ).toMap());
    } catch (e) {
      print('Error adding problem to Firestore: $e');
      // Handle Firestore write errors gracefully (e.g., show a snackbar to the user)
    }
  }

  Future<Map<String, dynamic>> getUserDataByUserId(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching user data: $e');
      return {}; // Возвращаем пустой Map в случае ошибки
    }
  }

  Future<List<ProblemModel>> getProblemsFromFirestore() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('problems');
      final snapshot = await collectionRef.get();

      final problems =
          snapshot.docs.map((doc) => ProblemModel.fromMap(doc.data())).toList();
      return problems;
    } catch (e) {
      print('Error fetching problems: $e');
      rethrow; // Re-throw the exception for further handling
    }
  }

  Stream<ProblemModel?> getProblemStreamFromFirestore({required String id}) {
    try {
      final docRef = FirebaseFirestore.instance.collection('problems').doc(id);
      return docRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          return ProblemModel.fromMap(snapshot.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } catch (e) {
      print('Error fetching problem: $e');
      throw e; // Re-throw the exception for further handling
    }
  }

  Future<void> addCommentToProblem({
    required String problemId,
    required CommentModel comment,
  }) async {
    try {
      final problemRef =
          FirebaseFirestore.instance.collection('problems').doc(problemId);

      // Добавляем комментарий к списку комментариев проблемы
      await problemRef.update({
        'comments': FieldValue.arrayUnion([comment.toJson()])
      });
    } catch (e) {
      print('Error adding comment to problem: $e');
      rethrow; // Re-throw the exception for further handling
    }
  }

  Stream<QuerySnapshot> getFilteredProblemsStream(
      String selectedBrand,
      String selectedModel,
      String selectedTypeOfBreakdown,
      String searchString,
      int? fromYear,
      int? toYear) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('problems');

    // Фильтрация по марке
    if (selectedBrand.isNotEmpty) {
      query = query.where('carMark', isEqualTo: selectedBrand);
    }

    // Фильтрация по модели (если выбрана марка)
    if (selectedBrand.isNotEmpty && selectedModel.isNotEmpty) {
      query = query.where('carModel', isEqualTo: selectedModel);
    }

    // Фильтрация по типу поломки
    if (selectedTypeOfBreakdown.isNotEmpty) {
      query = query.where('problemType', isEqualTo: selectedTypeOfBreakdown);
    }

    // Фильтрация по году
    if (fromYear != null && toYear != null) {
      query = query
          .where('year', isGreaterThanOrEqualTo: fromYear.toString())
          .where('year', isLessThanOrEqualTo: toYear.toString());
    } else if (fromYear != null) {
      query = query.where('year', isGreaterThanOrEqualTo: fromYear.toString());
    } else if (toYear != null) {
      query = query.where('year', isLessThanOrEqualTo: toYear.toString());
    }

    // Фильтрация по названию проблемы (поиск)
    if (searchString.isNotEmpty) {
      query = query.where('problemName', isEqualTo: searchString);
    }

    return query.snapshots();
  }

  Future<void> userCreateProblemPlus({required String userId}) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    final userData = userDoc.data();

// Проверяем, существует ли поле problemsCreated
    final currentProblemsCreated = userData?['problemsCreated'] ?? 0;

// Увеличиваем значение problemsCreated на 1
    final newProblemsCreated = currentProblemsCreated + 1;

// Обновляем поле problemsCreated в Firestore
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'problemsCreated': newProblemsCreated,
    });
  }

  Future<void> markCommentAsHelpful(CommentModel comment, String id) async {
    try {
      // Получаем ссылку на документ проблемы
      final problemDocRef =
      FirebaseFirestore.instance.collection('problems').doc(id);

      // Находим индекс комментария, который нужно обновить
      final problemSnapshot = await problemDocRef.get();
      final List<dynamic> comments = problemSnapshot.data()?['comments'] ?? [];
      final int commentIndex =
      comments.indexWhere((item) => item['text'] == comment.text);

      if (commentIndex != -1) {
        // Обновляем поле isHelpful для соответствующего комментария в коллекции comments
        comments[commentIndex]['isHelpful'] = true;

        // Обновляем документ проблемы с обновленным массивом комментариев
        await problemDocRef.update({'comments': comments});

        // Увеличиваем счетчик problemsDesided у пользователя, оставившего комментарий
        final commentUserId = comments[commentIndex]['userId'];
        final userDocRef =
        FirebaseFirestore.instance.collection("Users").doc(commentUserId);
        await userDocRef.update({'problemsDesided': FieldValue.increment(1)});
      } else {
        print('Комментарий не найден');
      }
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при отметке комментария как полезного: $e');
    }
  }

  Future<void> deleteProblem(String problemId) async {
    // Получение текущего пользователя
    final currentUser = FirebaseAuth.instance.currentUser;
    // Получение информации о проблеме из Firestore
    DocumentSnapshot problemSnapshot = await FirebaseFirestore.instance
        .collection('problems')
        .doc(problemId)
        .get();
    // Проверка, является ли текущий пользователь создателем проблемы
    if (problemSnapshot.exists && currentUser != null) {
      // Приведение типа объекта data() к Map<String, dynamic>
      final Map<String, dynamic>? problemData =
          problemSnapshot.data() as Map<String, dynamic>?;
      // Проверка наличия данных о проблеме и соответствия текущего пользователя создателю проблемы
      if (problemData != null && problemData['userId'] == currentUser.uid) {
        // Удаление проблемы из Firestore
        await FirebaseFirestore.instance
            .collection('problems')
            .doc(problemId)
            .delete();
      } else {
        // Пользователь не является создателем проблемы, выполните необходимые действия (например, ничего не делайте или покажите сообщение об ошибке)
        print('Только создатель проблемы может удалить её.');
      }
    } else {
      // Проблема не найдена или текущий пользователь не аутентифицирован, выполните необходимые действия (например, ничего не делайте или покажите сообщение об ошибке)
      print('Проблема не найдена или пользователь не аутентифицирован.');
    }
  }

  Stream<QuerySnapshot> getUserProblemsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('problems')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
