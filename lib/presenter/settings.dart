import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:easy_study/database/db_helper.dart';
import 'package:easy_study/model/subject.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<List<Subject>> subjects = DBHelper().getSubjects();
    Event event;
    subjects.then((value) {
      for (var subject in value) {
        event = Event(
          title: subject.title,
          description: event.description,
          location: subject.room,
          startDate: DateTime(subject.dueDate.year, subject.dueDate.month,
              subject.dueDate.day, 1, 0, 0, 0, 0),
          endDate: DateTime(subject.dueDate.year, subject.dueDate.month,
              subject.dueDate.day, 1 + subject.hoursWeek, 0, 0, 0, 0),
        );
      }
    });
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            // TODO: 03.05.2019 what could be good settings to set?
            child: RaisedButton(
              child: Text('Export to Calendar'),
              onPressed: () {
                Add2Calendar.addEvent2Cal(event);
              },
            )));
  }
}
