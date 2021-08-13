import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/model/event_provider.dart';
import 'package:weather_app/model/event_task.dart';
import 'package:weather_app/model/utils.dart';

class EventEditorPage extends StatefulWidget {
  final EventsTask? event;

  const EventEditorPage({Key? key, this.event}) : super(key: key);

  @override
  _EventEditorPageState createState() => _EventEditorPageState();
}

class _EventEditorPageState extends State<EventEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(
        Duration(hours: 2),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildEditingAction(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTitle(),
                SizedBox(height: 12),
                buildDateTimePicker(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingAction() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: Icon(Icons.done_all),
          label: Text('Save'),
        ),
      ];

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (value) =>
            value != null && value.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  Widget buildDateTimePicker() => Column(
        children: [
          buildForm(),
          buildTo(),
        ],
      );

  Widget buildForm() => buildHeader(
        header: 'Form',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.toDate(fromDate),
                onClicked: () => picFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropDownField(
                text: Utils.toTime(fromDate),
                onClicked: () => picFromDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: 'To',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDataTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropDownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDataTime(pickDate: false),
              ),
            )
          ],
        ),
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );

  Widget buildDropDownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = EventsTask(
        title: titleController.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);
      Navigator.of(context).pop();
    }
  }

  pickToDataTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future picFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        toDate.hour,
        toDate.minute,
      );
    }

    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
}
