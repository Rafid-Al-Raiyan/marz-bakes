import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/ui/customer/view_single_item.dart';

import '../../backend_services/firestore_services.dart';
import '../admin/update_item_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<String> admins = [
    'crystalizedmeteorite@gmail.com',
    'cse_2012020024@lus.ac.bd',
    'marzbakes@gmail.com',
  ];
  String currentUser = FirebaseAuth.instance.currentUser!.email!;
  FireStoreService fireStoreService = FireStoreService();
  TextEditingController searchController = TextEditingController();
  dynamic allItems = [];
  dynamic basicCake = [];
  dynamic basicCupCake = [];
  dynamic donuts = [];
  dynamic jarCake = [];
  dynamic cartItems = [];
  dynamic favouriteItems = [];
  List<int> searchResult = [];

  int activeIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllItems();
  }

  search(String key) {
    searchResult.clear();
    int price = int.tryParse(key) ?? 0;
    if (price != 0) {
      for (int i = 0; i < allItems.length; i++) {
        if (allItems[i]['price'] <= price) {
          searchResult.add(i);
        }
      }
    } else {
      for (int i = 0; i < allItems.length; i++) {
        if (allItems[i]['title'].toString().toLowerCase().contains(key.toLowerCase())) {
          searchResult.add(i);
        }
      }
    }
    setState(() {});
    // print(searchResult);
  }

  filter() {
    for (var items in allItems) {
      if (items['category'] == 'Basic Cake') {
        basicCake.add(items);
      } else if (items['category'] == 'Basic Cupcake') {
        basicCupCake.add(items);
      } else if (items['category'] == 'Donut') {
        donuts.add(items);
      } else {
        jarCake.add(items);
      }
    }
  }

  fetchAllItems() async {
    allItems = await fireStoreService.fetchItems();
    cartItems = await fireStoreService.fetchItemsFromCart();
    favouriteItems = await fireStoreService.fetchItemsFromFavourite();
    filter();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  allItems.clear();
                  searchResult.clear();
                  basicCupCake.clear();
                  jarCake.clear();
                  basicCake.clear();
                  donuts.clear();
                  activeIndex = 1;
                  await fetchAllItems();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      activeIndex == 1 ? Colors.pinkAccent.shade100 : Colors.transparent,
                ),
                child: const Text("All"),
              ),
              SizedBox(width: Get.width * 0.02),
              OutlinedButton(
                onPressed: () {
                  allItems.clear();
                  searchResult.clear();
                  allItems = List.from(basicCake);
                  activeIndex = 2;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      activeIndex == 2 ? Colors.pinkAccent.shade100 : Colors.transparent,
                ),
                child: const Text("Basic Cake"),
              ),
              SizedBox(width: Get.width * 0.02),
              OutlinedButton(
                onPressed: () {
                  allItems.clear();
                  searchResult.clear();
                  allItems = List.from(basicCupCake);
                  activeIndex = 3;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      activeIndex == 3 ? Colors.pinkAccent.shade100 : Colors.transparent,
                ),
                child: const Text("Basic Cupcake"),
              ),
              SizedBox(width: Get.width * 0.02),
              OutlinedButton(
                onPressed: () {
                  allItems.clear();
                  searchResult.clear();
                  allItems = List.from(donuts);
                  activeIndex = 4;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      activeIndex == 4 ? Colors.pinkAccent.shade100 : Colors.transparent,
                ),
                child: const Text("Donuts"),
              ),
              SizedBox(width: Get.width * 0.02),
              OutlinedButton(
                onPressed: () {
                  allItems.clear();
                  searchResult.clear();
                  allItems = List.from(jarCake);
                  activeIndex = 5;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      activeIndex == 5 ? Colors.pinkAccent.shade100 : Colors.transparent,
                ),
                child: const Text("Jar cake"),
              ),
            ],
          ),
        ),
        if (activeIndex == 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    search(searchController.text.trim());
                  },
                  icon: const Icon(Icons.send),
                ),
                label: const Text("Search items by name or price"),
              ),
            ),
          ),
        if (searchResult.isEmpty)
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              padding: const EdgeInsets.all(8.0), // padding around the grid
              itemCount: allItems.length, // total number of items
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (admins.contains(currentUser.toLowerCase())) {
                      Get.to(
                        const UpdateItemPage(),
                        arguments: [allItems[index], index],
                      );
                    } else {
                      Get.to(const ViewSingleItem(), arguments: [allItems[index], index]);
                    }
                  },
                  child: Card(
                    color: Colors.pinkAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              cartItems.contains(allItems[index]['id'])
                                  ? const Icon(Icons.shopping_cart, color: Colors.white)
                                  : SizedBox(height: Get.height * 0.02),
                              favouriteItems.contains(allItems[index]['id'])
                                  ? const Icon(Icons.favorite, color: Colors.white)
                                  : SizedBox(height: Get.height * 0.02),
                            ],
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              allItems[index]['url'],
                            ),
                            radius: Get.width * 0.1,
                          ),
                          Text(
                            allItems[index]['title'],
                            style: TextStyle(
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${allItems[index]['price']} TK ${allItems[index]['unit'].toString().toUpperCase()}',
                            style: TextStyle(
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (searchResult.isNotEmpty)
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              padding: const EdgeInsets.all(8.0), // padding around the grid
              itemCount: searchResult.length, // total number of items
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (admins.contains(currentUser.toLowerCase())) {
                      Get.to(
                        const UpdateItemPage(),
                        arguments: [
                          allItems[searchResult[index]],
                          searchResult[index],
                        ],
                      );
                    } else {
                      Get.to(() => const ViewSingleItem(), arguments: [
                        allItems[searchResult[index]],
                        searchResult[index],
                      ]);
                    }
                  },
                  child: Card(
                    color: Colors.pinkAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              cartItems.contains(allItems[index]['id'])
                                  ? const Icon(Icons.shopping_cart, color: Colors.white)
                                  : SizedBox(height: Get.height * 0.026),
                              favouriteItems.contains(allItems[index]['id'])
                                  ? const Icon(Icons.favorite, color: Colors.white)
                                  : SizedBox(height: Get.height * 0.026),
                            ],
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              allItems[searchResult[index]]['url'],
                            ),
                            radius: Get.width * 0.12,
                          ),
                          Text(
                            allItems[searchResult[index]]['title'],
                            style: TextStyle(
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${allItems[searchResult[index]]['price']} TK ${allItems[searchResult[index]]['unit'].toString().toUpperCase()}',
                            style: TextStyle(
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
