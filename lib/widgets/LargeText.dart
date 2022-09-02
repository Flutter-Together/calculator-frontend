import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight weight;

  const LargeText(
      {Key? key, this.size = 40, required this.text,  this.weight = FontWeight.w900, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      TextStyle(color: color, fontSize: size, fontWeight:weight),
    );
  }
}