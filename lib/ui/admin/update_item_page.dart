import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../backend_services/firestore_services.dart';
import '../../backend_services/storage_services.dart';
import '../../resuable_widget/utility.dart';
import 'admin_home_page.dart';

class UpdateItemPage extends StatefulWidget {
  const UpdateItemPage({Key? key}) : super(key: key);

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  StorageServices storageServices = StorageServices();
  FireStoreService fireStoreService = FireStoreService();

  List<String> category = ["Basic Cake", "Basic Cupcake", "Donut", "Jarcake"];
  String selectedCategory = "Basic Cake";
  File? img;
  bool imageSelected = false;

  Map<String, dynamic> item = Get.arguments[0];
  int productIndex = Get.arguments[1];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  String imageUrl = '';

  updateItem() async {
    if (imageSelected) {
      imageUrl = await storageServices.uploadItemPhoto(img!);
    }
    Map<String, dynamic> productData = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "category": selectedCategory,
      "price": int.parse(priceController.text.trim()),
      "unit": unitController.text.trim(),
      "url": imageUrl,
      "id": item['id'],
    };
    String result = await fireStoreService.updateItem(productData);
    Get.snackbar(
      "Updating status",
      "Details updating operation $result",
      backgroundColor: result == 'success' ? Colors.green : Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  deleteItem() {
    Get.defaultDialog(
      title: "Deletion Confirmation",
      middleText: "Are you sure to delete this item",
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
           String result = await fireStoreService.deleteItem(item);
            Get.snackbar(
              "Updating status",
              "Details updating operation $result",
              backgroundColor: result == 'success' ? Colors.green : Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("No"),
        ),
      ],
    );
  }

  pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return null;
    setState(() {
      img = File(pickedImage.path);
      imageSelected = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = item['title'];
    descriptionController.text = item['description'];
    priceController.text = item['price'].toString();
    unitController.text = item['unit'];
    imageUrl = item['url'];
    selectedCategory = item['category'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.offAll(const AdminHomePage());
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.3,
                  width: Get.width * 0.6,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  child: Image(
                    image:
                        imageSelected ? FileImage(img!) as ImageProvider : NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
                TextButton(
                  onPressed: pickImage,
                  child: const Text("Add Photo"),
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Provide title";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.cake,
                      color: color1,
                    ),
                    label: const Text("Title of Cake"),
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  minLines: null,
                  maxLines: null,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Provide description";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: color1,
                    ),
                    label: const Text("Description"),
                  ),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.category_rounded,
                      color: color1,
                    ),
                    label: const Text("Category"),
                  ),
                  value: selectedCategory,
                  items: [
                    for (String item in category)
                      DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      )
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                Row(
                  children: [
                    SizedBox(width: Get.width * 0.01),
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Provide price";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.money,
                            color: color1,
                          ),
                          label: const Text("Price"),
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * 0.01),
                    Expanded(
                      child: TextFormField(
                        controller: unitController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Provide unit";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.scale,
                            color: color1,
                          ),
                          hintText: "KG or PCS",
                          label: const Text("Unit"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.width * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: updateItem,
                      // style: buttonStyle(),
                      child: const Text("Update"),
                    ),
                    SizedBox(width: Get.width * 0.03),
                    ElevatedButton(
                      onPressed: deleteItem,
                      // style: buttonStyle(),
                      child: const Text("Delete"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
