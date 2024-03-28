import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:what_with_my_car/ui/add_problem.dart';
import 'package:what_with_my_car/ui/mainPage.dart';
import 'package:what_with_my_car/ui/reg_page.dart';
import 'blocs/authBloc/auth_bloc.dart';
import 'blocs/regBloc/reg_bloc.dart';
import 'repos/firebase_firestore.dart';
import 'firebase_options.dart';
import 'ui/nav_bar.dart';
import 'ui/news.dart';
import 'ui/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => Firebasefirestore(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(
                    repo: RepositoryProvider.of<Firebasefirestore>(context)),
          ),
          BlocProvider(
            create: (context) => RegBloc(repo: RepositoryProvider.of<Firebasefirestore>(context)),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          ),
          routes: {
            "/": (context) => const Auth(),
            "news": (context) => const News(),
            "nav_bar": (context) => const Nav_bar(),
            "reg": (context) => const UserRegistration(),
            "add": (context) =>  AddProblem(),
            "main": (context) => MainPage(),


          },
          initialRoute: "main",
        ),
      ),
    );
  }
}
