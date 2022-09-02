import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;

  const MediumText(
      {Key? key, this.size = 20, required this.text, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}