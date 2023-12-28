import 'package:flutter/material.dart';

class Problem extends StatefulWidget {
  const Problem({super.key});

  @override
  State<Problem> createState() => _ProblemState();
}

class _ProblemState extends State<Problem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          "Проблемы",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(24) ),
              child: Column(

                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container( width: double.infinity,
                        height: 330,
                        decoration:  BoxDecoration(borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                                image: AssetImage("lib/images/ss.webp"),
                                fit: BoxFit.cover))),
                  ),
                  const Text("Polo Sedan", style: TextStyle(color: Colors.white, fontSize: 24),),
                  const SizedBox(height: 6,),
                  const Text("Ходовая", style: TextStyle(color: Colors.white, fontSize: 20),),
                  const SizedBox(height: 6,),
                  const Text("Сломались стойки, ничего не могу с этим поделать!", style: TextStyle(color: Colors.white, fontSize: 14),),
                  const SizedBox(height: 6,),

                ],
              ),
            ),
          )),
    );
  }
}
