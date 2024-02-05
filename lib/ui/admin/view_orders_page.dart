import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({Key? key}) : super(key: key);

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  FireStoreService fireStoreService = FireStoreService();
  dynamic allOrders = [];
  late String orderStatus;
  List<String> allStatus = ['cancelled', 'pending', 'confirmed', 'delivered'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrders();
  }

  getAllOrders() async {
    allOrders = await fireStoreService.fetchAllOrders();
    setState(() {});
  }

  viewDetails(Map<String, dynamic> orderDetails) {
    orderStatus = orderDetails['status'];
    List<String> urls = orderDetails['url'].split('_');
    List<String> titles = orderDetails['title'].split('_');
    List<String> quantity = orderDetails['quantity'].toString().split(' ');
    Get.bottomSheet(
        isScrollControlled: true,
        ignoreSafeArea: false,
        backgroundColor: Colors.white,
        Container(
          margin: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (urls.length == 1)
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(orderDetails['url']),
                        radius: 50,
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Text(
                        "Item Name: ${orderDetails['title']}",
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

                                // color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "Quantity: ${quantity[index]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Get.textScaleFactor * 18,

                                // color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // CircleAvatar(
                //   backgroundImage: NetworkImage(orderDetails['url']),
                //   radius: Get.width* 0.15,
                // ),
                // const Divider(color: Colors.transparent),
                // Text(
                //   "Item: ${orderDetails['title']}",
                //   style: TextStyle(
                //     fontSize: Get.textScaleFactor * 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const Divider(color: Colors.transparent),
                // Text(
                //   "Quantity: ${orderDetails['quantity']}",
                //   style: TextStyle(
                //     fontSize: Get.textScaleFactor * 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const Divider(color: Colors.transparent),
                Text(
                  "Payment: ${orderDetails['total']}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),
                Text(
                  "Transaction ID: ${orderDetails['tid']}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),
                Text(
                  "Delivery: ${orderDetails['delivery']}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),
                Text(
                  "Comment: ${orderDetails['comment']}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),
                Text(
                  "Status: ${orderDetails['status'].toUpperCase()}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),
                Text(
                  "Ordered by: ${orderDetails['name']}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),

                Text(
                  "Email: ${orderDetails['ordered-by']}",
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.transparent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Phone: ${orderDetails['phone']}",
                      style: TextStyle(
                        fontSize: Get.textScaleFactor * 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        String number = orderDetails['phone'];
                        final Uri url = Uri(scheme: 'tel', path: number);
                        await launchUrl(url);
                      },
                      icon: const Icon(Icons.call),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField(
                        items: [
                          for (String status in allStatus)
                            DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            )
                        ],
                        onChanged: (value) {
                          orderStatus = value!;
                        },
                        value: orderStatus,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          await fireStoreService.updateOrderStatus(
                            orderDetails['oid'],
                            orderStatus,
                          );
                          allOrders.clear();
                          await getAllOrders();
                          Get.back();
                        },
                        child: const Text("Update"),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: allOrders.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              await viewDetails(allOrders[index]);
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(allOrders[index]['url'].split("_")[0]),
                ),
                title: Text(allOrders[index]['title'].split("_").join(" ")),
                subtitle: Text(allOrders[index]['name']),
                trailing: Text(allOrders[index]['status'].toUpperCase()),
              ),
            ),
          );
        },
      ),
    );
  }
}
