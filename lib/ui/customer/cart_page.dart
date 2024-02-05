import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';
import 'package:marz_bakes/ui/customer/order_all_page.dart';
import 'package:marz_bakes/ui/customer/place_order.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FireStoreService fireStoreService = FireStoreService();
  List<dynamic> cartItems = [];
  List<dynamic> allItems = [];
  List<dynamic> showItems = [];

  getAllItems() async {
    allItems = await fireStoreService.fetchItems();
    cartItems = await fireStoreService.fetchItemsFromCart();
    for (var items in allItems) {
      if (cartItems.contains(items['id'])) {
        showItems.add(items);
      }
    }
    setState(() {});
  }

  removeItems(Map<String, dynamic> productData) async {
    Get.defaultDialog(
        title: "Acknowledgement",
        middleText: "To remove item from cart tap on yes",
        actions: [
          TextButton(
            onPressed: () async {
              await fireStoreService.removeItemsFromCart(productData);
              Get.back();
              Get.snackbar(
                "${productData['title']}",
                "Successfully removed from cart",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );

              cartItems.clear();
              allItems.clear();
              showItems.clear();
              getAllItems();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('No'),
          ),
        ]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showItems.isNotEmpty
          ? Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: showItems.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.pinkAccent.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(showItems[index]['url']),
                        radius: Get.width * 0.1,
                      ),
                      Text(
                        showItems[index]['title'],
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 16,
                            color: Colors.white),
                      ),
                      Text(
                        '${showItems[index]['price']} TK ${showItems[index]['unit'].toString().toUpperCase()}',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 16,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                              onPressed: () {
                                Get.to(const PlaceOrder(), arguments: showItems[index]);
                              },
                              child: const Text("Order")),
                          SizedBox(width: Get.width * 0.01),
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                            onPressed: () async {
                              await removeItems(showItems[index]);
                            },
                            child: const Text("Remove"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (showItems.length > 1)
            ElevatedButton(
              onPressed: () {
                Get.to(() => const OrderAllPage(), arguments: showItems);
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(Get.width * 0.5, 50)),
              child: const Text(
                "Order All",
                style: TextStyle(fontSize: 20),
              ),
            )
        ],
      )
          : const Center(
        child: Text('No Cart Items'),
      ),
    );
  }
}