import 'package:flutter/material.dart';

import 'line.dart';

class TimeViewer extends StatelessWidget {
  const TimeViewer({required this.time, Key? key}) : super(key: key);
  final int time;

  @override
  Widget build(BuildContext context) {
    const headLineStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.w500);
    const dataStyle = TextStyle(fontSize: 20);
    final minutes = time ~/ 60;
    final seconds = time % 60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Line(title: 'دقيقة', style: headLineStyle),
            Line(title: minutes.toString(), style: dataStyle),
          ],
        ),
        Column(
          children: [
            const Line(title: 'ثانية', style: headLineStyle),
            Line(title: seconds.toString(), style: dataStyle),
          ],
        ),
      ],
    );
  }
}
