import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/auth_services.dart';
import 'package:marz_bakes/ui/admin/add_items_page.dart';
import 'package:marz_bakes/ui/admin/view_items_page.dart';
import 'package:marz_bakes/ui/admin/view_orders_page.dart';
import 'package:marz_bakes/ui/authentication/log_in_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AuthService authService = AuthService();
  int index = 0;
  List<Widget> screens = const [ViewItems(), AddItems(), ViewOrders()];

  logOut() async {
    Get.defaultDialog(
      // backgroundColor: Colors.red,
      title: "Confirmation",
      middleText: "To logout press yes",
      actions: [
        TextButton(
          onPressed: () async{
            await authService.logoutUser();
            Get.offAll(const LogInPage());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marz Bakes"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (currentIndex) {
          index = currentIndex;
          setState(() {});
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "All Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Add Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: "Orders",
          ),
        ],
      ),
    );
  }
}
