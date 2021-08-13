import 'package:flutter/cupertino.dart';
import 'package:weather_app/model/event_task.dart';
class EventProvider extends ChangeNotifier {
  final List<EventsTask> _event = [];

  List<EventsTask> get events => _event;

  void addEvent(EventsTask eventsTask) {
    _event.add(eventsTask);

    notifyListeners();
  }
}