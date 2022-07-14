import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularTimeIndicator extends StatefulWidget {
  const CircularTimeIndicator({
    Key? key,
    required this.remainingTimeSec,
    required this.totalTime, required this.onTimerEnd,
  }) : super(key: key);

  final int remainingTimeSec;
  final int totalTime;
  final Function onTimerEnd;

  @override
  _CircularTimeIndicatorState createState() => _CircularTimeIndicatorState();
}

class _CircularTimeIndicatorState extends State<CircularTimeIndicator> {
  ValueNotifier<int> remainingTimeSecNotifier = ValueNotifier(0);

  late Timer myTimer;

  @override
  void initState() {
    super.initState();
    remainingTimeSecNotifier.value = (widget.remainingTimeSec);

    int timeToUpdate;
    if(remainingTimeSecNotifier.value <=600&& remainingTimeSecNotifier.value>=0){
      //time range is seconds >> then update each sec
      timeToUpdate =1;

    }else if(remainingTimeSecNotifier.value>600 && remainingTimeSecNotifier.value<=3600){
      //time range is minutes >> then update each half min
      timeToUpdate = 30;
    }
    else{
      //time range is hours >> then update each 2 min
      timeToUpdate = 120;
    }
    myTimer = Timer.periodic(Duration(seconds: timeToUpdate), (timer) {
      print(timer.tick);
      remainingTimeSecNotifier.value -= (timeToUpdate);
      if (remainingTimeSecNotifier.value <= 0) {
        remainingTimeSecNotifier.value = 0;
        print('remaining is 0');
        if (mounted) {
          widget.onTimerEnd();
          // Navigator.of(context).pop();

          timer.cancel();
        }
      }
    });
  }


  @override
  void dispose() {
    myTimer.cancel();
    remainingTimeSecNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    remainingTimeSecNotifier.value = (widget.remainingTimeSec);
    return ValueListenableBuilder(
        valueListenable: remainingTimeSecNotifier,
        builder: (BuildContext context, int hasError, Widget? child) {
          double percent = 0;
          double remainingTime = 0;
          String unit = '';
          if (remainingTimeSecNotifier.value > 0 &&
              remainingTimeSecNotifier.value < 60) {
            unit = 'sec';
            remainingTime = remainingTimeSecNotifier.value.toDouble();
          } else if (remainingTimeSecNotifier.value >= 60 &&
              remainingTimeSecNotifier.value < 3600) {
            unit = 'min';
            remainingTime = remainingTimeSecNotifier.value.toDouble() / 60.0;
          } else if (remainingTimeSecNotifier.value >= 3600) {
            unit = 'hr';
            remainingTime = remainingTimeSecNotifier.value.toDouble() / 3600.0;
          } else {
            print('timer is zero, given:${widget.remainingTimeSec} ');
          }
          percent = remainingTimeSecNotifier.value / widget.totalTime;
          print('percent is: $percent and remaining: $remainingTime and total: ${widget.totalTime}');
          return CircularPercentIndicator(
            radius: 45.0,
            lineWidth: 4.0,
            animation: true,
            animateFromLastPercent: true,
            backgroundColor: Colors.grey[350]!,
            percent: percent,
            center: Container(
              height: 90,
              width: 90,
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  "${remainingTime.toStringAsFixed(1)}\n$unit",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ),
            restartAnimation: false,

            progressColor: Color.fromARGB(230, 157, 55, 204),
            // progressColor: Colors.pinkAccent.withBlue(100).withGreen(50),
            circularStrokeCap: CircularStrokeCap.round,
          );
        });
  }
}
