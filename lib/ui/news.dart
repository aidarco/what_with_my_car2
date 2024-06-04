import 'package:flutter/material.dart';

import '../models/newsModel.dart';

class News extends StatelessWidget {
   News({Key? key});

  final List<NewsModel> newsList = [
    NewsModel(
      name: "Мнения о Haval Jolion",
      description: "Компактный китайский кроссовер уверенно и, по всей вероятности, надолго закрепился в лидерах рейтинга российских продаж новых автомобилей. По итогам первого квартала этого года c 15 770 проданными экземплярами Джолион уверенно занимает третье место. Популярнее у клиентов только Гранта и Веста, а вот востребованных в России Niva Travel и Geely Monjaro продали меньше  Причины взлета Джолиона лежат на поверхности — на рынке остались только российские и китайские бренды («параллельные» и «серые» машины не в счет — спрос на них из-за высоких цен точечный). К тому же Haval, по сути, единственный локализованный производитель современных китайских автомобилей в России со всеми вытекающими отсюда преференциями..",
      photo: "https://s.auto.drom.ru/i24292/pubs/4483/96768/4213696.jpg",
      date: "21.05.2024",
    ),
    NewsModel(
      name: "Почему китайцы не строят автозаводы в России: кто виноват и что делать",
      description: "Короче говоря, экспозиция такова: на высококонкурентном российском рынке за многие годы работы китайским компаниям удалось отвоевать лишь несущественную часть аудитории. Первый реальный шанс увеличить долю китайцы получили с началом кризиса полупроводников в 2020 году: в то время как «нормальные» компании из-за низкой маржинальности российских продаж сокращали поставки в нашу страну, вынуждая дилеров сидеть на голодном пайке, они агрессивно наращивали отгрузки, забивали склады, попутно предлагая более конкурентные цены. Наиболее успешно этот подарок судьбы использовала Chery, став весомым игроком российского рынка.",
      photo: "https://s.auto.drom.ru/i24292/pubs/4483/96765/4213593.jpg",
      date: "22.05.2024",
    ),
    NewsModel(
      name: "«Москвич»: 60 000 км, полет нормальный!",
      description: "Мы продолжаем эксплуатацию нашего «русского китайца» и параллельно наблюдаем за внезапным всплеском покупательского интереса к этой модели: как долго будет проявляться повышенный спрос на ставший более доступным «Москвич»?",
      photo: "https://s.auto.drom.ru/i24291/pubs/4483/96587/4204682.jpg",
      date: "21.05.2024",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "Новости",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            backgroundColor: Colors.grey.shade800,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 34,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return NewsWidget(newsModel: newsList[index]);
              },
              childCount: newsList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class NewsWidget extends StatefulWidget {
  final NewsModel newsModel;

  const NewsWidget({Key? key, required this.newsModel}) : super(key: key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  bool _isExpanded = false;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                height: 330,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.newsModel.photo ?? ""),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
              (widget.newsModel.name ?? "") + " " + (widget.newsModel.date ?? ""),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_isExpanded)
                    Text(
                      widget.newsModel.description ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _isExpanded ? "Скрыть" : "Показать все",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
