import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/auth_services.dart';
import 'package:marz_bakes/ui/authentication/log_in_page.dart';
import 'package:marz_bakes/ui/customer/cart_page.dart';
import 'package:marz_bakes/ui/customer/orders_page.dart';
import 'package:marz_bakes/ui/customer/view_menu_page.dart';
import 'package:marz_bakes/ui/customer/favourite_items_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  List<Widget> screens = const [ViewMenuPage(), CartPage(), FavouriteItemPage(), OrdersPage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merz Bakes"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Dear user",
                middleText: "Are you sure to logout?",
                actions: [
                  TextButton(
                    onPressed: () async {
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
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "Menu",
            icon: Icon(
              Icons.menu,
            ),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: "Favourite",
            icon: Icon(
              Icons.favorite_outline,
            ),
          ),
          BottomNavigationBarItem(
            label: "My Orders",
            icon: Icon(
              Icons.pending,
            ),
          ),

        ],
        currentIndex: currentIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          Uri whatsapp = Uri.parse("https://wa.me/+8801977842497?text= ");
          await canLaunchUrl(whatsapp) ? launchUrl(whatsapp) : throw 'exe';
        },
        child: const Icon(Icons.messenger),
      ),
    );
  }
}
