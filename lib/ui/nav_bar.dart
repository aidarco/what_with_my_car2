import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:what_with_my_car/ui/problems_page.dart';
import 'package:what_with_my_car/ui/profile_page.dart';
import 'auth.dart';
import 'news.dart';





class Nav_bar extends StatefulWidget {
   Nav_bar({super.key});

  @override
  State<Nav_bar> createState() => _Nav_barState();
}

class _Nav_barState extends State<Nav_bar> {
  int _curentInxed = 0;

  final tabs = [ Problem(), News(),  User_Profile (), ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,

      bottomNavigationBar: CurvedNavigationBar(
        index: _curentInxed,
        onTap: (index)
        {
          setState(() {
            _curentInxed = index;
          });
        },
        backgroundColor: Colors.grey.shade900,
        color: Colors.white10,
        buttonBackgroundColor: Colors.white,
        items: const [
        Icon(Icons.newspaper),
        Icon(Icons.report_problem),
        Icon(Icons.person),
      ],) ,

    body: tabs[_curentInxed],);
  }
}
