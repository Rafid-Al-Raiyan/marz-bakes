import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

Color color1 = Colors.pinkAccent.shade100;

buttonStyle() => ElevatedButton.styleFrom(
  minimumSize: Size(
    Get.width * 0.6,
    Get.height * 0.07,
  ),
  textStyle: GoogleFonts.acme(
    fontSize: Get.textScaleFactor * 20,
  ),
);