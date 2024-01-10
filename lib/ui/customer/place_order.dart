import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({Key? key}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  TextEditingController addressController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  Map<String, dynamic> item = Get.arguments;
  int quantity = 1;
  bool isPickUp = false;
  int deliveryFee = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Order"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(item['url']),
              radius: Get.width * 0.12,
            ),
            Text(item['title']),
            Text('Price: ${item['price']} TK ${item['unit'].toString().toUpperCase()}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text("Quantity: $quantity"),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            TextFormField(
              controller: numberController,
              decoration: const InputDecoration(
                label: Text("Phone Number"),
                prefixIcon: Icon(Icons.call),
                // helperText: "Delivery inside Sylhet only."
              ),
            ),
            TextFormField(
              controller: transactionController,
              decoration: const InputDecoration(
                label: Text("BKash Transaction ID"),
                prefixIcon: Icon(Icons.abc_sharp),
                // helperText: "Delivery inside Sylhet only."
              ),
            ),
            SwitchListTile(
              value: isPickUp,
              onChanged: (value) {
                setState(() {
                  isPickUp = value;
                  if (isPickUp) {
                    deliveryFee = 0;
                  } else {
                    deliveryFee = 80;
                  }
                });
              },
              title: const Text('Pickup on spot'),
            ),
            if (isPickUp == false)
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                    label: Text("Delivery Address"),
                    prefixIcon: Icon(Icons.home_filled),
                    helperText: "Delivery inside Sylhet only."),
              ),
            const Spacer(),
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: Get.textScaleFactor * 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text(
              "Sub total: ${item['price'] * quantity} TK",
              style: TextStyle(
                fontSize: Get.textScaleFactor * 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Delivery fee: $deliveryFee TK",
              style: TextStyle(
                fontSize: Get.textScaleFactor * 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Total: ${deliveryFee + (item['price'] * quantity)} TK",
              style: TextStyle(
                fontSize: Get.textScaleFactor * 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton(
                  onPressed: () {},
                  // style: buttonStyle(),
                  child: const Text("Place Order"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String number = "+8801869241202";
                    final Uri url = Uri(scheme: 'tel', path: number);
                    await launchUrl(url);
                  },
                  // style: buttonStyle(),
                  child: const Text("Call Seller"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
