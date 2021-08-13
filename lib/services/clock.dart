import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:google_fonts/google_fonts.dart';

class ClockDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterAnalogClock(
      dateTime: DateTime.now(),
      dialPlateColor: Colors.black26,
      hourHandColor: Colors.white,
      minuteHandColor: Colors.white,
      secondHandColor: Colors.white,
      numberColor: Colors.white,
      borderColor: Colors.white,
      tickColor: Colors.white,
      centerPointColor: Colors.white,
      showBorder: true,
      showTicks: false,
      showMinuteHand: true,
      showSecondHand: true,
      showNumber: true,
      borderWidth: 1.0,
      hourNumberScale: MediaQuery.of(context).size.width*0.0015,
      hourNumbers: [
        'I',
        'II',
        'III',
        'IV',
        'V',
        'VI',
        'VII',
        'VIII',
        'IX',
        'X',
        'XI',
        'XII'
      ],
      isLive: true,
      width: MediaQuery.of(context).size.width*0.4,
      height: MediaQuery.of(context).size.width*0.4,
      decoration: const BoxDecoration(),
      child: Center(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Text("Schedule\nTask",softWrap: true,textAlign: TextAlign.center,style: GoogleFonts.lato(color: Colors.white),),
      )),
    );
  }
}
