import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marz_bakes/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "marzbakes",
    options: const FirebaseOptions(
      apiKey: "AIzaSyAWo8UhucCC0RaK2KF6E2Y1pSvAd8yx400",
      appId: "1:503886288311:android:359c44888f95bf12938432",
      messagingSenderId: "503886288311",
      projectId: "marzbakes-18bf9",
      storageBucket: "gs://marzbakes-18bf9.appspot.com",
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
      theme: ThemeData.light(
        useMaterial3: false,
      ).copyWith(
        textTheme: GoogleFonts.acmeTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor:  Colors.pinkAccent.shade100,

        ),
      ),
      home: const SplashScreen(),
    );
  }
}
