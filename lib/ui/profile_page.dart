import 'package:flutter/material.dart';

class User_Profile extends StatefulWidget {
  const User_Profile({super.key});

  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 88,
                    backgroundImage: AssetImage("lib/images/ss.webp"),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Aidarco",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "aidarzt@gmail.com",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade800,borderRadius: BorderRadius.circular(12) ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Создал",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Text(
                          "12",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      ],

                    ),
                    VerticalDivider(
                      color: Colors.red,
                      thickness: 20,
                      width: 20,
                    ),

                    Column(
                      children: [
                        Text(
                          "Комментариев",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),

                        Text(
                          "24",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                },
                child: const Text("Выйти",
                    style: TextStyle(color: Colors.white, fontSize: 24)))
          ],
        ));
  }
}
