import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:what_with_my_car/models/userModel.dart';

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
    UserCredential  result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = result.user!.uid;
    final user = db.collection("Users").doc(uid);
    final model = UserModel(
        name: email.toString().split("@")[0],
        description: "",
        id: uid,
        problemsDesided: "0",
        problemsCreated: "0");
    await user.set(model.toJson());
  }



}
