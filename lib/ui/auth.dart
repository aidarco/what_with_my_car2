import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_with_my_car/blocs/authBloc/auth_bloc.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              height: 300, // Половина высоты экрана
              decoration: const BoxDecoration(

                  image: DecorationImage(
                      fit: BoxFit.fill, // Растягивать изображение, чтобы заполнить контейнер

                      image: AssetImage("lib/images/logo.png"))),
            ),
            Text("Авторизация", style: TextStyle(color: Colors.white, fontSize: 36),),
            const SizedBox(
              height: 24,
            ),
            TextFieldAuthWidget(
              controller: emailController,
              hintText: "Login",
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldAuthWidget(
              controller: passwordController,
              hintText: "Password",
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                height: 55,
                width: double.infinity,
                child: AuthPageButton(
                    emailController: emailController,
                    passwordController: passwordController)),
            const SizedBox(
              height: 28,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "reg");
                },
                child: const Text(
                  "Новый пользователь ?",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),

            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "reg");
                },
                child: const Text(
                  "Забыли пароль ?",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),

          ],
        ),
      ),
    );
  }
}

class AuthPageButton extends StatelessWidget {
  const AuthPageButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserLoginSucces) {
          Navigator.pushReplacementNamed(context, "nav_bar");
        }
        if (state is UserLoginError) {
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
       else if (state is UserLoginLoading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
      child: TextButton(
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(UserLogin(
              email: emailController.text, password: passwordController.text));
       //   BlocProvider.of<AuthBloc>(context).add(UserLoginLoading() as AuthEvent);

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
          "Войти",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String email;
  final String password;

  const AuthButton({super.key, required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserLoginSucces) {
          Navigator.pushReplacementNamed(context, "nav_bar");
        }
        if (state is UserLoginError) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text(
                      state.error,
                      style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ));
        }
        if (state is UserLoginLoading) {
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
      child: TextButton(
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(UserLogin(
              email: email.toString(), password: password.toString()));
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
          "Войти",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class TextFieldAuthWidget extends StatelessWidget {
  final hintText;
  final controller;

  const TextFieldAuthWidget(
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
