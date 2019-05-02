import 'package:easy_study/model/Priority.dart';
import 'package:easy_study/model/Subject.dart';
import 'package:easy_study/model/Type.dart';
import 'package:easy_study/view/MainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubjectAdd extends StatefulWidget {
  final SubjectCallback onSubjectAdd;

  const SubjectAdd({this.onSubjectAdd});

  @override
  State<StatefulWidget> createState() => _SubjectAddState();
}

class _SubjectAddState extends State<SubjectAdd> {
  String _title, _room, _description, _hoursPerWeek;
  Priority _priority;
  Type _type;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              TextField(
                onChanged: (String value) => _title = value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'title',
                ),
              ),
              TextField(
                onChanged: (String value) => _room = value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'room',
                ),
              ),
              TextField(
                onChanged: (String value) => _description = value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'description',
                ),
              ),
              DropdownButton<Type>(
                  value: _type,
                  items: Type.VALUES
                      .map((value) => new DropdownMenuItem<Type>(
                            child: Text(value.toString()),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (Type value) => setState(() {
                        _type = value;
                      })),
              DropdownButton<Priority>(
                  value: _priority,
                  items: Priority.VALUES
                      .map((value) => new DropdownMenuItem<Priority>(
                            child: Text(value.toString()),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (Priority value) => setState(() {
                        _priority = value;
                      })),
              TextField(
                onChanged: (String value) => _hoursPerWeek = value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'hours per week',
                ),
              ),
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () => widget.onSubjectAdd(getSubject()),
              )
            ])));
  }

  Subject getSubject() {
    return Subject.name(_title, _type, _room, _priority, _description,
        int.parse(_hoursPerWeek));
  }
}
