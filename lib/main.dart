import 'package:flutter/material.dart';
import 'package:train_location_service/UI/screens/service_screen.dart';
import 'UI/screens/destination_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train GPS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DestinationScreen(),
      routes: {
        ServiceScreen.routName: (ctx) => const ServiceScreen(),
      },
    );
  }
}
