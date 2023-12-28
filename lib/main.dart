import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authBloc/auth_bloc.dart';
import 'firebase_firestore.dart';
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
      create: (context) => FirebaseFirestore(),
      child: BlocProvider(
        create: (context) => AuthBloc(repo: RepositoryProvider.of<FirebaseFirestore>(context)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: AppBarTheme(backgroundColor: Colors.cyan)),
          routes: {
            "/": (context) => Auth(),
            "/news": (context) => News(),
            "nav_bar": (context) => Nav_bar(),


          },
          initialRoute: "/",
        ),
      ),
    );
  }
}
