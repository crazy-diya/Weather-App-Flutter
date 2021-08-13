import 'package:flutter/cupertino.dart';
import 'package:weather_app/model/event_task.dart';
class EventProvider extends ChangeNotifier {
  final List<EventsTask> _events = [];

  List<EventsTask> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<EventsTask> get eventsOfSelectedDate => _events;

  void addEvent(EventsTask eventsTask) {
    _events.add(eventsTask);

    notifyListeners();
  }

  void deleteEvent(EventsTask eventsTask){
    _events.remove(eventsTask);
  }

  void editEvent(EventsTask newEvent, EventsTask oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }
}