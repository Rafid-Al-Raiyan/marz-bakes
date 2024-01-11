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
              }
              else{
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
    Get.bottomSheet(

      backgroundColor: Colors.white,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            'Order Status: ${orderData['status']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textScaleFactor * 18,
              // color: Colors.white,
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          ElevatedButton(onPressed: () {
            Get.back();
            cancelOrder(orderData);
          }, child: const Text("Cancel Order"))
        ],
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
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(orderList[index]['url']),
              ),
              title: Text(orderList[index]['title']),
              subtitle: Text("Status: ${orderList[index]['status']}"),
            ),
          ),
        );
      },
    );
  }
}
