

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestore
{
final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> firebaseAuth({required String email, required String password}) async
{
  final result = await auth.signInWithEmailAndPassword(email: email, password: password);
}


}