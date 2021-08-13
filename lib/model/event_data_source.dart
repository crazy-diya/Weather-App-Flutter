import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_task.dart';

class EventDataSource extends CalendarDataSource{
  EventDataSource(List<EventsTask> appointments){
    this.appointments = appointments;
  }

  EventsTask getEvent(int index) => appointments![index] as EventsTask;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  Color getColor(int index)  => getEvent(index).backgroundColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;
}