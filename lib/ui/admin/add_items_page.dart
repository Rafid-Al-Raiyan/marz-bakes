import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';
import 'package:marz_bakes/backend_services/storage_services.dart';
import 'package:marz_bakes/resuable_widget/utility.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  StorageServices storageServices = StorageServices();
  FireStoreService fireStoreService = FireStoreService();

  List<String> category = ["Basic Cake", "Basic Cupcake", "Donut", "Jarcake"];
  String selectedCategory = "Basic Cake";
  File? img;
  bool imageSelected = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  addItem() async {
    String? url = await storageServices.uploadItemPhoto(img!);
    Map<String, dynamic> productData = {
      "id": '',
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "category": selectedCategory,
      "price": int.parse(priceController.text.trim()),
      "unit": unitController.text.trim(),
      "url": url!,
    };
    await fireStoreService.addNewItem(productData);
    Get.snackbar(
      "Attention",
      "Item added successfully.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    setState(() {
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      unitController.clear();
      img = null;
      imageSelected = false;
    });
  }

  pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      img = File(pickedImage!.path);
      imageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  image: imageSelected
                      ? FileImage(img!) as ImageProvider
                      : const AssetImage('images/marz_bakes.png'),
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
              ElevatedButton(
                onPressed: addItem,
                style: buttonStyle(),
                child: const Text("Add to Menu"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
