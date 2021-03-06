import 'dart:ui';

import 'package:easy_study/database/db_helper.dart';
import 'package:easy_study/model/exam_type.dart';
import 'package:easy_study/model/priority.dart';

class Subject {
  static Subject copy(Subject org) {
    Subject copy = Subject.name(org.title, org.type, org.room, org.priority,
        org.description, org.hoursWeek, org.dueDate, org.dateOfCreation);
    copy.id = org.id;
    copy.color = org.color;
    copy.timeSpent = org.timeSpent;
    copy.startedTimetrackingAt = org.startedTimetrackingAt;
    return copy;
  }

  String title, room, description;
  int id, timeSpent = 0, hoursWeek;
  ExamType type;
  Priority priority;
  Color color = Color.fromARGB(255, 0, 0, 0);
  String startedTimetrackingAt;
  DateTime dueDate;
  DateTime dateOfCreation;

  Subject.name(this.title, this.type, this.room, this.priority,
      this.description, this.hoursWeek, this.dueDate, this.dateOfCreation);

  //puts the ObjectVariables to a map so the database can read it easily
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map[DBHelper.TITLE] = title;
    map[DBHelper.TYPE] = type.toString();
    map[DBHelper.ROOM] = room;
    map[DBHelper.PRIORITY] = priority.toString();
    map[DBHelper.DESCRIPTION] = description;
    map[DBHelper.HOURS_WEEK] = hoursWeek;
    map[DBHelper.COLOR_ALPHA] = color.alpha;
    map[DBHelper.COLOR_RED] = color.red;
    map[DBHelper.COLOR_GREEN] = color.green;
    map[DBHelper.COLOR_BLUE] = color.blue;
    map[DBHelper.STARTED_TIMETRACKING_AT] = startedTimetrackingAt;
    map[DBHelper.DUE_DATE] = dueDate.toString();
    map[DBHelper.TIME_SPENT] = timeSpent;
    map[DBHelper.DATE_OF_CREATION] = dateOfCreation.toString();

    return map;
  }
}
