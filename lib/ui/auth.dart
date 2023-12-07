import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 136,
            ),
            Container(
              height: 280,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("lib/images/дарт.png"))),
            ),
            const TextFieldAuthWidget(
              hintText: "Login",
            ),
            const SizedBox(
              height: 24,
            ),
            const TextFieldAuthWidget(
              hintText: "Password",
            ),
            const SizedBox(
              height: 24,
            ),
            const SizedBox(
              height: 55,
              width: double.infinity,
              child: AuthButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {

        Navigator.pushReplacementNamed(context, "nav_bar");
      },
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        )),
        backgroundColor:
            MaterialStateProperty.all(Colors.grey.shade800),
      ),
      child: const Text(
        "Войти",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class TextFieldAuthWidget extends StatelessWidget {
  final hintText;

  const TextFieldAuthWidget({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade800,
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white)),
      ),
      style: TextStyle(color: Colors.grey.shade300),
    );
  }
}
