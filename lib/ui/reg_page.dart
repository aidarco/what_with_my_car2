import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_with_my_car/blocs/regBloc/reg_bloc.dart';

class UserRegistration extends StatelessWidget {
  const UserRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController repasswordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text("Регистрация"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldRegWidget(
              hintText: "Почта",
              controller: emailController,
            ),
            const SizedBox(
              height: 28,
            ),
            TextFieldRegWidget(
              hintText: "Пароль",
              controller: passwordController,
            ),
            const SizedBox(
              height: 28,
            ),
            TextFieldRegWidget(
              hintText: "Провторите пароль",
              controller: repasswordController,
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                height: 55,
                width: double.infinity,
                child: RegButton(
                  emailController: emailController,
                  passwordController: passwordController,
                  repasswordController: repasswordController,
                ))
          ],
        ),
      ),
    );
  }
}

class TextFieldRegWidget extends StatelessWidget {
  final hintText;
  final controller;

  const TextFieldRegWidget(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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

class RegButton extends StatelessWidget {
  const RegButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.repasswordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController repasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegBloc, RegState>(
      listener: (context, state) {

        if (state is RegSucces)
          {
            Navigator.pushReplacementNamed(context, "/");

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Пользователь создан успешно')
                ));


          }
        if (state is RegError)
          {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(
                    state.error,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ));
          }


      },
      child: TextButton(
          onPressed: () {
            if (repasswordController.text == passwordController.text) {
              BlocProvider.of<RegBloc>(context).add(UserReg(
                  email: emailController.text,
                  password: passwordController.text));
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Пароли не совпадают')
                  ));
            }
          },
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
          ),
          child: const Text(
            "Создать пользователя",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
