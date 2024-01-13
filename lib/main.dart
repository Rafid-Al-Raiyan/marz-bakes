import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "marz-bakes",
    options: const FirebaseOptions(
      apiKey: "AIzaSyCjg777Klguyh3ryQPCr_JRtQ-N7CP9bEA",
      appId: "1:984654248389:android:ed3d270c1b0faf0778b3ac",
      messagingSenderId: "984654248389",
      projectId: "marz-bakes",
      storageBucket: "gs://marz-bakes.appspot.com",
    ),
  );
  runApp(const MarzBakes());
}

class MarzBakes extends StatefulWidget {
  const MarzBakes({Key? key}) : super(key: key);

  @override
  State<MarzBakes> createState() => _MarzBakesState();
}

class _MarzBakesState extends State<MarzBakes> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor:  Colors.pinkAccent.shade100,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
