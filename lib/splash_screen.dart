import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/ui/customer/home_page.dart';
import 'package:marz_bakes/resuable_widget/icon.dart';
import 'package:marz_bakes/ui/admin/admin_home_page.dart';
import 'package:marz_bakes/ui/authentication/log_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const IconWidget(
        iconSize: 100,
      ),
      duration: 2000,
      splashIconSize: Get.width,
      nextScreen: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget newScreen = const LogInPage();
          if (snapshot.hasError) {
            newScreen = const LogInPage();
          } else if (snapshot.hasData && auth.currentUser!.emailVerified) {
            if (auth.currentUser!.email!.toLowerCase() == 'crystalizedmeteorite@gmail.com') {
              newScreen = const AdminHomePage();
            } else {
              newScreen = const HomePage();
            }
          }
          return newScreen;
        },
      ),
    );
  }
}
