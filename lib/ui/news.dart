import 'package:flutter/material.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("НОВОСТИ", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 24),),
              backgroundColor: Colors.grey.shade800,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 34,
              ),
            ),
            SliverList.builder(
                itemCount: 4,
                itemBuilder: (context, index) => NewsWidget())
          ],
        ));
  }
}

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, right: 8, left: 8),
      child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade800,
    ),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                  width: double.infinity,
                  height: 330,
                  decoration: BoxDecoration(
                    image: const DecorationImage(image: AssetImage("lib/images/ss.webp"),
                      fit: BoxFit.cover
                    ),
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Тест тест текст тесте тест  ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white ) ,),
            )
          ],
        ),
      ),
    );
  }
}

