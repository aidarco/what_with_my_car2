import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:what_with_my_car/ui/auth.dart';

import 'nav_bar.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)
        {
          if(snapshot.hasData)
            {
              return Nav_bar();
            }
          else {
            return Auth();
          }
        },
      ) ,
    );
  }
}
