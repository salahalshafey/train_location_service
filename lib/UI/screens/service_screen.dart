// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../model/train.dart';
import '../widgets/line.dart';
import '../widgets/time_viewer.dart';

enum ChoiceOption {
  Time,
  Distance,
}

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  static const routName = '/service';

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  var showTime = true;
  var reversed = false;
  late Stream<Train> getLiveTrain;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reversed = ModalRoute.of(context)!.settings.arguments as bool;
    getLiveTrain = Train.getLiveTrain(reversed);
  }

  void selectChoice(ChoiceOption choice) {
    if (choice == ChoiceOption.Time) {
      setState(() {
        showTime = true;
      });
    } else {
      setState(() {
        showTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const headLineStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
    const dataStyle = TextStyle(fontSize: 20);

    return StreamBuilder(
      stream: getLiveTrain,
      builder: (context, AsyncSnapshot<Train> snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen(
            error: 'فيه مشكلة حصلت\nممكن يكون بسبب التليفون في وضع الطيران',
            reversed: reversed,
            selectChoice: selectChoice,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ErrorScreen(
            error:
                'انتظر قليلاً قد يستغرق الأمر بضع ثواني\nلو استغرق الأمر وقتاً طويلاً قم بتشغيل الإنترنت لتسريع تحديد الموقع',
            reversed: reversed,
            selectChoice: selectChoice,
          );
        }

        final train = snapshot.data!;
        return Scaffold(
          appBar: appBarBuilder(reversed, selectChoice),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Line(title: 'المحطة الحالية', style: headLineStyle),
                  Line(title: train.currentStation, style: dataStyle),
                  const SizedBox(height: 20),
                  const Line(title: 'المحطة التالية', style: headLineStyle),
                  Line(title: train.nextStation, style: dataStyle),
                  const SizedBox(height: 20),
                  if (showTime == true)
                    Column(
                      children: [
                        const Line(
                            title: 'الوقت المتبقى إلى المحطة التالية',
                            style: headLineStyle),
                        (train.timeToNextStation == null)
                            ? const Line(title: 'غير معروف', style: dataStyle)
                            : TimeViewer(time: train.timeToNextStation!),
                      ],
                    ),
                  if (showTime == false)
                    Column(
                      children: [
                        const Line(
                            title: 'المسافة المتبقية إلى المحطة التالية',
                            style: headLineStyle),
                        (train.distanceToNextStation == null)
                            ? const Line(title: 'غير معروف', style: dataStyle)
                            : Line(
                                title: train.distanceToNextStation! < 1000
                                    ? train.distanceToNextStation!
                                            .toStringAsFixed(0) +
                                        '  متر'
                                    : (train.distanceToNextStation! / 1000)
                                            .toStringAsFixed(1) +
                                        '  كيلومتر',
                                style: dataStyle),
                      ],
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: CircleAvatar(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  train.speed.round().toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  'كم/س',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            maxRadius: 40,
          ),
        );
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.error,
    required this.reversed,
    required this.selectChoice,
    Key? key,
  }) : super(key: key);

  final String error;
  final bool reversed;
  final void Function(ChoiceOption) selectChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(reversed, selectChoice),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

AppBar appBarBuilder(
        final bool reversed, void Function(ChoiceOption) selectChoice) =>
    AppBar(
      title: SizedBox(
        width: double.infinity,
        child: FittedBox(
          child: Text(
            reversed
                ? 'أهلاً يوسف توصل القاهرة بالسلامة إن شاء الله'
                : 'أهلاً يوسف توصل وجهتك بالسلامة إن شاء الله',
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
      actions: [
        PopupMenuButton(
            color: Colors.grey[200],
            onSelected: selectChoice,
            itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: ChoiceOption.Time,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('أظهر الوقت فقط'),
                        Icon(
                          Icons.timer_sharp,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: ChoiceOption.Distance,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('أظهر المسافة فقط'),
                        Icon(
                          Icons.swap_calls_outlined,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ])
      ],
    );
