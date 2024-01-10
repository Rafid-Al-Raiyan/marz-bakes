import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  addUserData(Map<String, dynamic> user) async {
    await fireStore.collection('users').doc(user['email']).set(user);
  }

  addNewItem(Map<String, dynamic> productData) async {
    try {
      DocumentReference documentReference = fireStore.collection('products').doc();
      productData['id'] = documentReference.id;
      await documentReference.set(productData);
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  fetchItems() async {
    dynamic allItems = [];
    try {
      QuerySnapshot querySnapshot = await fireStore.collection('products').get();
      allItems = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allItems;
    } catch (e) {
      print(e);
      return allItems;
    }
  }

  updateItem(Map<String, dynamic> productData) async {
    try {
      await fireStore.collection('products').doc(productData['id']).update(productData);
      return 'success';
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  deleteItem(Map<String, dynamic> productData) async {
    try {
      await fireStore.collection('products').doc(productData['id']).delete();
      return 'success';
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  addItemsToCart(Map<String, dynamic> productData) async {
    String currentUser = FirebaseAuth.instance.currentUser!.email!;
    List<dynamic> items = await fetchItemsFromCart();

    if (items.contains(productData['id']) == false) items.add(productData['id']);
    await fireStore.collection('cart').doc(currentUser).set({'items': items});
  }

  fetchItemsFromCart() async {
    String currentUser = FirebaseAuth.instance.currentUser!.email!;
    List<dynamic> items = [];
    try {
      DocumentSnapshot documentSnapshot =
          await fireStore.collection('cart').doc(currentUser).get();
      items = documentSnapshot.get('items');

      return items;
    } catch (e) {
      return items;
    }
  }

  removeItemsFromCart(Map<String, dynamic> productData) async {
    String currentUser = FirebaseAuth.instance.currentUser!.email!;
    List<dynamic> items = await fetchItemsFromCart();
    items.remove(productData['id']);
    await fireStore.collection('cart').doc(currentUser).set({'items': items});
  }

  addItemsToFavourite(Map<String, dynamic> productData) async {
    String currentUser = FirebaseAuth.instance.currentUser!.email!;
    List<dynamic> items = await fetchItemsFromFavourite();

    if (items.contains(productData['id']) == false) items.add(productData['id']);
    await fireStore.collection('favourite').doc(currentUser).set({'items': items});
  }

  fetchItemsFromFavourite() async {
    String currentUser = FirebaseAuth.instance.currentUser!.email!;
    List<dynamic> items = [];
    try {
      DocumentSnapshot documentSnapshot =
          await fireStore.collection('favourite').doc(currentUser).get();
      items = documentSnapshot.get('items');
      return items;
    } catch (e) {
      return items;
    }
  }

  removeItemsFromFavourite(Map<String, dynamic> productData) async {
    String currentUser = FirebaseAuth.instance.currentUser!.email!;
    List<dynamic> items = await fetchItemsFromFavourite();
    items.remove(productData['id']);
    await fireStore.collection('favourite').doc(currentUser).set({'items': items});
  }
}