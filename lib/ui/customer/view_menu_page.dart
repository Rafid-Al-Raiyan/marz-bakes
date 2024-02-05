import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/ui/shared/item_page.dart';

class ViewMenuPage extends StatefulWidget {
  const ViewMenuPage({Key? key}) : super(key: key);

  @override
  State<ViewMenuPage> createState() => _ViewMenuPageState();
}

class _ViewMenuPageState extends State<ViewMenuPage> {
  List<String> images = [
    'images/cake.jpg',
    'images/cup-cake.jpg',
    'images/pastry.jpg',
    'images/cake2.jpg',
    'images/cup-cake2.jpg',
    'images/pastry2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            CarouselSlider(
              items: images.map((String url) {
                return SizedBox(
                  height: Get.height * 0.2,
                  width: Get.width * 0.7,
                  child: Image(
                    image: AssetImage(url),
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: Get.height * 0.2,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 1600),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Menu",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.textScaleFactor * 30,
                ),
              ),
            ),
            const Expanded(child: ItemPage())
          ],
        ),
      ),
    );
  }
}
