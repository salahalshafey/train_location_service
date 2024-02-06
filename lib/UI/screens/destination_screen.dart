import 'package:flutter/material.dart';
import 'package:train_location_service/UI/widgets/button.dart';

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 160;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حدد وجهتك'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height / 6),
              const Button(
                title: 'أنا رايح الإسكندرية 🤓🤓🤓🤓',
                reversed: false,
              ),
              const SizedBox(height: 60),
              const Button(
                title: ' أنا رايح  القاهرة  😵😵😵😵 ',
                reversed: true,
              ),
              SizedBox(height: height * 0.45),
            ],
          ),
        ),
      ),
    );
  }
}
