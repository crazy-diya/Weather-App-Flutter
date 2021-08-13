import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weather_app/model/event_data_source.dart';
import 'package:weather_app/model/event_provider.dart';

import '../tsak_widget.dart';

class Calender extends StatelessWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider
        .of<EventProvider>(context)
        .events;
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onLongPress: (calendarLongPressDetails) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(calendarLongPressDetails.date!);

        showModalBottomSheet(context: context, builder: (context) =>TaskWidget(),);
      },
    );
  }
}
