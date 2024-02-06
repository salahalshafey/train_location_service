import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  const Line({
    required this.title,
    required this.style,
    Key? key,
  }) : super(key: key);
  final String title;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );
  }
}
