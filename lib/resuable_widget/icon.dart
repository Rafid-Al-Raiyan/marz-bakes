import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final double iconSize;

  const IconWidget({Key? key, required this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage("images/marz_bakes.png"),
      height: iconSize,
    );
  }
}
