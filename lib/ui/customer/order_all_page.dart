import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../backend_services/firestore_services.dart';

class OrderAllPage extends StatefulWidget {
  const OrderAllPage({Key? key}) : super(key: key);

  @override
  State<OrderAllPage> createState() => _OrderAllPageState();
}

class _OrderAllPageState extends State<OrderAllPage> {
  List<dynamic> allCartItems = Get.arguments;

  FireStoreService fireStoreService = FireStoreService();
  TextEditingController addressController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime deliveryDate = DateTime.now().add(const Duration(days: 7));

  List<int> quantity = [];
  bool isPickUp = false;
  int deliveryFee = 80;
  int subTotal = 0;

  final form = GlobalKey<FormState>();
  final phoneRegex = RegExp(r'^01[3-9]\d{8}$');

  addOrder() async {
    String title = "";
    String url = "";
    String id = "";

    for(int i=0; i<allCartItems.length; i++){
      if(quantity[i] > 0){
        title += allCartItems[i]['title'] + '_';
        url += allCartItems[i]['url'] + '_';
        id += allCartItems[i]['id'] + '_';
      }
    }

    Map<String, dynamic> orderData = {
      'name': '',
      'ordered-by': '',
      'oid': '',
      'comment': descriptionController.text.trim(),
      'quantity': quantity.join(" "),
      'title': title,
      'url': url,
      'id': id,
      'total': deliveryFee + subTotal,
      'date': dateController.text.trim(),
      'delivery': isPickUp ? "On spot Pickup" : addressController.text.trim(),
      'phone': numberController.text.trim(),
      'tid': transactionController.text.trim(),
      'status': 'pending',
    };
    String response = await fireStoreService.addOrders(orderData);
    if (response == 'success') {
      Get.snackbar(
        "Your order added successfully.",
        "Check your order details from orders tab",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Your order adding operation failed.",
        "Try again. Thank you.",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeQuantity();
  }

  initializeQuantity() {
    for (var cartItem in allCartItems) {
      quantity.add(0);
    }
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
          height: Get.height * 1.2,
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: form,
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.01),
                Text(
                  "Place order 1 week before your event".toUpperCase(),
                  style: TextStyle(
                    fontSize: Get.textScaleFactor * 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bkash (Personal): +880 1977-842497",
                      style: TextStyle(
                        fontSize: Get.textScaleFactor * 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(const ClipboardData(text: "01977842497"));
                      },
                      icon: const Icon(
                        Icons.copy,
                        size: 15,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allCartItems.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                            color: Colors.pinkAccent.shade100,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(allCartItems[index]['url']),
                                radius: Get.width * 0.1,
                              ),
                              title: Text(
                                allCartItems[index]['title'],
                                style: TextStyle(
                                  fontSize: Get.textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'Price: ${allCartItems[index]['price']} TK ${allCartItems[index]['unit'].toString().toUpperCase()}',
                                style: TextStyle(
                                  fontSize: Get.textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Text(
                                "Cost: ${quantity[index] * allCartItems[index]['price']} TK",
                                style: TextStyle(
                                  fontSize: Get.textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (quantity[index] > 1) quantity[index]--;
                                  for (int i = 0; i < quantity.length; i++) {
                                    int k = allCartItems[i]['price'];
                                    subTotal += quantity[i] * k;
                                  }
                                  setState(() {});
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                "Quantity: ${quantity[index]}",
                                style: TextStyle(
                                  fontSize: Get.textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  quantity[index]++;
                                  for (int i = 0; i < quantity.length; i++) {
                                    // print(allCartItems[i]['price']);
                                    int k = allCartItems[i]['price'];
                                    subTotal += quantity[i] * k;
                                  }
                                  setState(() {});
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    label: Text("Description/Comment/Instruction"),
                    prefixIcon: Icon(Icons.description_outlined),

                    // helperText: "Delivery inside Sylhet only."
                  ),
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
                      helperText: "Must pay 50% of total amount when placing order",
                      helperStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      )
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
                        helperText: "Delivery inside Sylhet only.",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        )),
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
                  "Sub total: ${subTotal} TK",
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
                  "Total: ${deliveryFee + subTotal} TK",
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
