import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  FireStoreService fireStoreService = FireStoreService();
  dynamic orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrders();
  }

  getAllOrders() async {
    orderList = await fireStoreService.fetchOrders();
    setState(() {});
  }

  cancelOrder(Map<String, dynamic> orderData) {
    Get.defaultDialog(
        title: "Acknowledgement",
        middleText:
            "Tap yes to cancel order.Before cancelling order contract with seller about refund.",
        actions: [
          TextButton(
            onPressed: () async {
              String response = await fireStoreService.cancelOrder(orderData);
              Get.back();
              if (response == 'success') {
                await getAllOrders();
                Get.snackbar(
                  "Order Cancellation Status",
                  "Your order successfully cancelled",
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  backgroundColor: Colors.green,
                );
              } else {
                Get.snackbar(
                  "Order Cancellation Status",
                  "Your order cancellation failed. Try again later.",
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              }
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("No"),
          ),
        ]);
  }

  showOrderDetails(Map<String, dynamic> orderData) {
    List<String> urls = orderData['url'].split('_');
    List<String> titles = orderData['title'].split('_');
    List<String> quantity = orderData['quantity'].toString().split(' ');
    Get.bottomSheet(
      ignoreSafeArea: false,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.white,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (urls.length == 1)
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(orderData['url']),
                    radius: 50,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Text(
                    "Item Name: ${orderData['title']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Get.textScaleFactor * 18,
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (urls.length > 1)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.pinkAccent.shade100,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(urls[index]),
                          radius: 50,
                        ),
                        title: Text(
                          "Item Name: ${titles[index]}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textScaleFactor * 18,
                              color: Colors.white
                              // color: Colors.white,
                              ),
                        ),
                        subtitle: Text(
                          "Quantity: ${quantity[index]}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Get.textScaleFactor * 18,
                              color: Colors.white
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: Get.height * 0.01),
            Text(
              "Total Cost: ${orderData['total']} TK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.textScaleFactor * 18,
                // color: Colors.white,
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Text(
              "Delivery Address: ${orderData['delivery']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.textScaleFactor * 18,
                // color: Colors.white,
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Text(
              "Delivery Date: ${orderData['date']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.textScaleFactor * 18,
                // color: Colors.white,
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Text(
              'Transaction ID: ${orderData['tid']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.textScaleFactor * 18,
                // color: Colors.white,
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Text(
              'Order Status: ${orderData['status'].toUpperCase()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.textScaleFactor * 18,
                // color: Colors.white,
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            orderData['status'] == 'pending'
                ? ElevatedButton(
                    onPressed: () {
                      Get.back();
                      cancelOrder(orderData);
                    },
                    child: const Text("Cancel Order"),
                  )
                : Text(
                    "To cancel your confirmed order contract with seller",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Get.textScaleFactor * 18,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showOrderDetails(orderList[index]);
          },
          child: Card(
            color: Colors.pinkAccent.shade100,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(orderList[index]['url'].split("_")[0]),
              ),
              title: Text(
                orderList[index]['title'].split("_").join(" "),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Status: ${orderList[index]['status'].toUpperCase()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
