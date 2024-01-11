import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({Key? key}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  FireStoreService fireStoreService = FireStoreService();
  TextEditingController addressController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime deliveryDate = DateTime.now().add(const Duration(days: 7));

  Map<String, dynamic> item = Get.arguments;
  int quantity = 1;
  bool isPickUp = false;
  int deliveryFee = 80;

  final form = GlobalKey<FormState>();
  final phoneRegex = RegExp(r'^01[3-9]\d{8}$');

  addOrder() async {
    print(isPickUp);
    Map<String, dynamic> orderData = {
      'title': item['title'],
      'url': item['url'],
      'id': item['id'],
      'total': deliveryFee + (item['price'] * quantity),
      'date': dateController.text.trim(),
      'delivery': isPickUp ? "On spot Pickup" : addressController.text.trim(),
      'phone': numberController.text.trim(),
      'tid': transactionController.text.trim(),
      'status': 'pending',
    };
    await fireStoreService.addOrders(orderData);
  }

  datePicker() async {
    deliveryDate = (await showDatePicker(
      context: context,
      initialDate: deliveryDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
    ))!;
    dateController.text = DateFormat('yMMMd').format(deliveryDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Order"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: form,
            child: Column(
              children: [
                Text(
                  "Place order 1 week before your event".toUpperCase(),
                  style: TextStyle(
                      fontSize: Get.textScaleFactor * 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(item['url']),
                  radius: Get.width * 0.12,
                ),
                Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Price: ${item['price']} TK ${item['unit'].toString().toUpperCase()}',
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    Text(
                      "Quantity: $quantity",
                      style: TextStyle(
                        fontSize: Get.textScaleFactor * 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter phone number';
                    } else if (phoneRegex.hasMatch(value.trim()) == false) {
                      return 'Enter correct phone number, avoid +88';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Phone Number"),
                    prefixIcon: Icon(Icons.call),
                    // helperText: "Delivery inside Sylhet only."
                  ),
                ),
                TextFormField(
                  controller: transactionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter transaction ID";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Bkash Transaction ID"),
                    prefixIcon: Icon(Icons.abc_sharp),
                    // helperText: "Delivery inside Sylhet only."
                  ),
                ),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: datePicker,
                  decoration: const InputDecoration(
                    label: Text("Delivery Date"),
                    prefixIcon: Icon(Icons.date_range),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter delivery address";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text("Delivery Address"),
                        prefixIcon: Icon(Icons.home_filled),
                        helperText: "Delivery inside Sylhet only."),
                  ),
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
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          addOrder();
                        }
                      },
                      // style: buttonStyle(),
                      child: const Text("Place Order"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String number = "+8801977842497";
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
        ),
      ),
    );
  }
}
