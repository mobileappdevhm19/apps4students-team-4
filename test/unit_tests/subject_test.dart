// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_study/model/exam_type.dart';
import 'package:easy_study/model/priority.dart';
import 'package:easy_study/model/subject.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Subject _getDummySubject() {
    return Subject.name("Software Engineering II", ExamType.WRITTEN_EXAM,
        "T1.011", Priority.MINIMALISM, "A funny subject.", 5);
  }

  test('subject to map', () {
    Subject subject = _getDummySubject();
    var map = subject.toMap();
    var compare = <String, dynamic>{
      'title': "Software Engineering II",
      'type': "Written exam",
      'room': "T1.011",
      'priority': "Minimalism",
      'description': "A funny subject.",
      'hoursWeek': 5,
      'color_alpha': 255,
      'color_red': 0,
      'color_green': 0,
      'color_blue': 0,
      'started_timetracking_at': null,
      'time_spent': 0
    };
    expect(map, compare);
  });
}