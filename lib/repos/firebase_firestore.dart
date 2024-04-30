import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> firebaseReg(
      {required String email, required String password}) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = result.user!.uid;
    final user = db.collection("Users").doc(uid);
    final model = UserModel(
        name: email.toString().split("@")[0],
        description: "",
        id: uid,
        problemsDesided: 0,
        problemsCreated: 0);
    await user.set(model.toJson());
  }

  Future<void> addProblemToFirestore({
    required String problemName,
    required String description,
    required List<String> imagePaths,
    required String carMark,
    required String carModel,
    required String problemType,
    required String year,


  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String id = FirebaseFirestore.instance
        .collection('problems')
        .doc()
        .id;

    List<String> imageUrls = [];
    try {
      for (final imagePath in imagePaths) {
        final ref = FirebaseStorage.instance.ref().child(
            'problem_images/$id/${basename(imagePath)}');
        final uploadTask = ref.putFile(
            File(imagePath)); // Use File instance for upload
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

      ).toMap());
    } catch (e) {
      print('Error adding problem to Firestore: $e');
      // Handle Firestore write errors gracefully (e.g., show a snackbar to the user)
    }
  }


  Future<List<ProblemModel>> getProblemsFromFirestore() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('problems');
      final snapshot = await collectionRef.get();

      final problems = snapshot.docs.map((doc) =>
          ProblemModel.fromMap(doc.data())).toList();
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
      final problemRef = FirebaseFirestore.instance.collection('problems').doc(
          problemId);

      // Добавляем комментарий к списку комментариев проблемы
      await problemRef.update({
        'comments': FieldValue.arrayUnion([comment.toJson()])
      });
    } catch (e) {
      print('Error adding comment to problem: $e');
      rethrow; // Re-throw the exception for further handling
    }
  }


  Stream<QuerySnapshot> getFilteredProblemsStream(String selectedBrand,
      String selectedModel,
      String selectedTypeOfBreakdown,
      String searchString,) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
        'problems');

    // Фильтрация по названию проблемы (поиск)
    if (searchString.isNotEmpty) {
      query = query
          .where('problemName', isGreaterThanOrEqualTo: searchString)
          .where('problemName', isLessThan: searchString + 'z');
    }

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

    return query.snapshots();
  }


Future<void> userCreateProblemPlus({required String userId})
async{
  final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
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
      final problemDocRef = FirebaseFirestore.instance.collection('problems').doc(id);

      // Находим индекс комментария, который нужно обновить
      final problemSnapshot = await problemDocRef.get();
      final List<dynamic> comments = problemSnapshot.data()?['comments'] ?? [];
      final int commentIndex = comments.indexWhere((item) => item['text'] == comment.text);

      if (commentIndex != -1) {
        // Обновляем поле isHelpful для соответствующего комментария в коллекции comments
        comments[commentIndex]['isHelpful'] = true;

        // Обновляем документ проблемы с обновленным массивом комментариев
        await problemDocRef.update({'comments': comments});

        // Увеличиваем счетчик problemsDesided у пользователя
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userDocRef = FirebaseFirestore.instance.collection("Users").doc(user.uid);
          await userDocRef.update({'problemsDesided': FieldValue.increment(1)});
        }
      } else {
        print('Комментарий не найден');
      }
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при отметке комментария как полезного: $e');
    }
  }

}
