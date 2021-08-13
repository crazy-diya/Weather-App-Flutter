import 'package:flutter/material.dart';

class EventsTask {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  EventsTask(
      {required this.title,
      required this.description,
      required this.from,
      required this.to,
        this.backgroundColor = Colors.lightGreen,
      this.isAllDay = false});
}
