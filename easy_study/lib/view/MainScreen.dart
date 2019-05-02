import 'package:easy_study/model/Subject.dart';
import 'package:easy_study/model/Type.dart';
import 'package:easy_study/model/Priority.dart';
import 'package:easy_study/presenter/Settings.dart';
import 'package:easy_study/presenter/SubjectAdd.dart';
import 'package:easy_study/view/SubjectOverview.dart';
import 'package:easy_study/presenter/Map.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Subject> _subjects;
  Widget _widget;
  AppBar _appBar;

  @override
  void initState() {
    super.initState();
    _appBar = AppBar(title: Text("Exam Planer"));
    // TODO: 02.05.2019 hard coded for now. remove later
    _subjects = new List<Subject>();
    _subjects.add(new Subject.name(
        "Software Engineering II",
        Type.WRITTEN_EXAM,
        "T1.011",
        Priority.MINIMALISM,
        "A funny subject.",
        5));
    _subjects.add(new Subject.name(
        "Lineare Algebra",
        Type.PRESENTATION,
        "R1.049",
        Priority.WANT_TO_PASS,
        "I don't know why I am here?",
        7));
    _subjects.add(new Subject.name(
        "Compiler",
        Type.ORAL_EXAM_,
        "A1.001",
        Priority.NORMAL,
        "I love this subject so much. Pls let me pass!",
        13));
    _widget = SubjectOverview(_subjects);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _appBar,
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.storage),
                  onPressed: () => _changeView(SubjectOverview(_subjects))),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _changeView(SubjectAdd(onSubjectAdd: (Subject subject) => _addSubject(subject),))),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => _changeView(Settings()),
              ),
              IconButton(
                icon: Icon(Icons.map),
                onPressed: () => _changeView(Map()),
              )
            ],
          ),
        ),
        body: _widget);
  }

  _addSubject(Subject subject) {
    setState(() {
      _subjects.add(subject);
    });
    _changeView(SubjectOverview(_subjects));
  }

  void _changeView(Widget widget) {
    setState(() {
      _widget = widget;
    });
  }
}
typedef SubjectCallback = void Function(Subject subject);