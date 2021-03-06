import 'package:device_calendar/device_calendar.dart';
import 'package:easy_study/database/db_creator.dart';
import 'package:easy_study/database/db_helper.dart';
import 'package:easy_study/model/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Settings extends StatefulWidget {
  Settings();

  @override
  SettingsPageState createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends State<Settings> {
  DeviceCalendarPlugin _deviceCalendarPlugin;

  List<Calendar> calendars;

  SettingsPageState() {
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
  }

  @override
  initState() {
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    List<Subject> events = new List<Subject>();
    final Future<List<Subject>> subjects =
        DBHelper(DBCreator().database).getSubjects();
    subjects.then((value) {
      for (var subject in value) {
        events.add(subject);
      }
    });
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  child: Text('Privacy'),
                  onPressed: _showDialog,
                ),
                RaisedButton(
                  child: Text('Export to Calendar'),
                  onPressed: () => addEventsToCalendar(events),
                )
              ],
            )));
  }

  void _showDialog() async {
    var html = await DefaultAssetBundle.of(context)
        .loadString('privacy/privacy_policy.html');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Privacy Policy"),
              content: Scrollbar(
                  child: SingleChildScrollView(
                child: Html(
                  data: html,
                ),
              )));
        });
  }

  Future addEventsToCalendar(List<Subject> events) async {
    for (var subject in events) {
      final eventToCreate = new Event(calendars.elementAt(0).id);
      eventToCreate.title = subject.title;
      eventToCreate.start = subject.dueDate;
      eventToCreate.end = DateTime(subject.dueDate.year, subject.dueDate.month,
          subject.dueDate.day, subject.dueDate.hour + subject.hoursWeek);
      eventToCreate.description = subject.description;
      await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);
      SnackBar snackBar =
          SnackBar(content: Text('Successfully added to calendar'));
      Scaffold.of(context)
          .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
      Scaffold.of(context).showSnackBar(snackBar);
    }
    return true;
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          SnackBar snackBar = SnackBar(
            content: Text(
              "Something went wrong. Please accept the permissions.",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          );
          Scaffold.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
          Scaffold.of(context).showSnackBar(snackBar);
          return;
        }
      }
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        calendars = calendarsResult?.data;
      });

      print(calendars);
    } on Exception catch (e) {
      print(e);
    }
  }
}
