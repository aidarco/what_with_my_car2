import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text('Восстановление пароля', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              controller: emailController,
              cursorColor: Colors.white,
              decoration: InputDecoration(

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                filled: true,
                fillColor: Colors.grey.shade700,
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey.shade500),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white)),

              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _resetPassword(emailController.text, context);
              },
              child: Text('Восстановить пароль'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ссылка для восстановления пароля отправлена на $email'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
        ),
      );
    }
  }
}