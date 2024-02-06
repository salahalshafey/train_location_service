import 'package:flutter/material.dart';

import '../screens/service_screen.dart';

class Button extends StatelessWidget {
  const Button({
    required this.title,
    required this.reversed,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          ServiceScreen.routName,
          arguments: reversed,
        );
      },
      child: Text(title, style: const TextStyle(fontSize: 25)),
    );
  }
}
