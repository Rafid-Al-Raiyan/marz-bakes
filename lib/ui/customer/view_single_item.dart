import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';

class ViewSingleItem extends StatefulWidget {
  const ViewSingleItem({Key? key}) : super(key: key);

  @override
  State<ViewSingleItem> createState() => _ViewSingleItemState();
}

class _ViewSingleItemState extends State<ViewSingleItem> {
  FireStoreService fireStoreService = FireStoreService();
  Map<String, dynamic> item = Get.arguments[0];
  int productIndex = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Item"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              CircleAvatar(
                backgroundImage: NetworkImage(item['url']),
                radius: Get.width * 0.3,
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.cake),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: Get.textScaleFactor * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(
                    '${item['category']}',
                    style: TextStyle(
                      fontSize: Get.textScaleFactor * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(
                    '${item['description']}',
                    style: TextStyle(
                      fontSize: Get.textScaleFactor * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.price_change_sharp),
                  title: Text(
                    "${item['price']} TK ${item['unit'].toString().toUpperCase()}",
                    style: TextStyle(
                      fontSize: Get.textScaleFactor * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await fireStoreService.addItemsToCart(item);
                      Get.snackbar(
                        "${item['title']}",
                        "Successfully added to cart",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    label: const Text("Add to Cart"),
                    icon: const Icon(Icons.shopping_cart_checkout),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await fireStoreService.addItemsToFavourite(item);
                      Get.snackbar(
                        "${item['title']}",
                        "Successfully added to favourite",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    label: const Text("Add to Favorite"),
                    icon: const Icon(Icons.favorite),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
