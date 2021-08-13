import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/model/event_provider.dart';
import 'package:weather_app/model/event_task.dart';
import 'package:weather_app/model/utils.dart';
import 'package:weather_app/pages/event_edit_page.dart';

class EventViewingPage extends StatelessWidget {
  final EventsTask event;

  const EventViewingPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingActions(context, event),
        ),
        body: ListView(
          padding: EdgeInsets.all(32),
          children: [
            buildDateTime(event),
            SizedBox(
              height: 32,
            ),
            Text(
              event.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              event.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );

  List<Widget> buildViewingActions(BuildContext context, EventsTask event) => [
        IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditorPage(
                event: event,
              ),
            ),
          ),
          icon: Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            final provider = Provider.of<EventProvider>(context,listen: false);
            provider.deleteEvent(event);
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
      ];

  Widget buildDateTime(EventsTask event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
        SizedBox(height: 38,),
        Text("${Utils.toDateTime(date)}",style: TextStyle(color: Colors.black,fontSize: 18,),)
      ],
    );
  }
}
