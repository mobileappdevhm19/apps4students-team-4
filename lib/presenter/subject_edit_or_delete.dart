import 'dart:core';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:easy_study/model/exam_type.dart';
import 'package:easy_study/model/priority.dart';
import 'package:easy_study/model/subject.dart';
import 'package:easy_study/store/app_state.dart';
import 'package:easy_study/view/subject_overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class SubjectEditOrDelete extends StatefulWidget {
  final Subject subject;

  const SubjectEditOrDelete({Key key, this.subject}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubjectEditOrDeleteState();
}

class _SubjectEditOrDeleteState extends State<SubjectEditOrDelete> {
  void onChanged(HSVColor value) => _color = value.toColor();

  static const String TITLE = 'title';
  static const String ROOM = 'room';
  static const String DESCRIPTION = 'description';
  static const String HOURS_PER_WEEK = 'hours per week';
  static const String DUE_DATE = 'Due Date';
  final dateFormat = DateFormat("EE, yyyy-MM-dd 'at' h:mm a");
  final formKey = GlobalKey<FormState>();
  String _title, _room, _description, _hoursPerWeek;
  Priority _priority;
  ExamType _type;
  Color _color;
  DateTime _dateTime;
  DateTime _dateOfCreation;
  bool isValidated;

  void initState() {
    super.initState();
    _title = widget.subject.title;
    _room = widget.subject.room;
    _description = widget.subject.description;
    _hoursPerWeek = widget.subject.hoursWeek.toString();
    _priority = widget.subject.priority;
    _type = widget.subject.type;
    _color = widget.subject.color;
    _dateTime = widget.subject.dueDate;
    _dateOfCreation = widget.subject.dateOfCreation;
    isValidated = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
                key: formKey,
                child: ListView.builder(
                    itemBuilder: _buildColumnItems,
                    itemCount: 1,
                    scrollDirection: Axis.vertical))));
  }

  Subject _submit() {
    Subject result;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      result = Subject.name(_title, _type, _room, _priority, _description,
          int.parse(_hoursPerWeek), _dateTime, _dateOfCreation);
      result.color = _color;
      result.id = widget.subject.id;
      result.timeSpent = widget.subject.timeSpent;
      setState(() {
        isValidated = false;
      });
    }
    return result;
  }

  void _checkIfInputIsValid() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        isValidated = true;
      });
    } else {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Please check your input again'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ]);
        },
      );
    }
  }

  String _validateDueDate(DateTime duedate) {
    if (duedate == null) {
      return '$DUE_DATE must not be empty.';
    }
    if (duedate.isBefore(DateTime.now())) {
      return 'the date must be ahead of now';
    }
    return null;
  }

  Widget _buildColumnItems(BuildContext context, int index) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      TextFormField(
        initialValue: _title,
        validator: (String input) =>
            input.length <= 0 ? 'please enter a  $TITLE' : null,
        onFieldSubmitted: (String value) {
          setState(() {
            isValidated = false;
          });
        },
        onSaved: (String value) => _title = value,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(),
            filled: true,
            alignLabelWithHint: true,
            labelText: TITLE),
      ),
      SizedBox(height: 15.0),
      TextFormField(
        initialValue: _room,
        validator: (String input) =>
            input.length <= 0 ? 'please enter a $ROOM' : null,
        onFieldSubmitted: (String value) {
          setState(() {
            isValidated = false;
          });
        },
        onSaved: (String value) => _room = value,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(),
            filled: true,
            alignLabelWithHint: true,
            labelText: ROOM),
      ),
      SizedBox(height: 15.0),
      TextFormField(
        initialValue: _description,
        validator: (String input) =>
            input.length <= 0 ? 'please enter a $DESCRIPTION' : null,
        onFieldSubmitted: (String value) {
          setState(() {
            isValidated = false;
          });
        },
        onSaved: (String value) => _description = value,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(),
            filled: true,
            alignLabelWithHint: true,
            labelText: DESCRIPTION),
      ),
      SizedBox(height: 15.0),
      DropdownButton<ExamType>(
          value: _type,
          items: ExamType.VALUES
              .map((value) => new DropdownMenuItem<ExamType>(
                    child: Text(value.toString()),
                    value: value,
                  ))
              .toList(),
          onChanged: (ExamType value) => setState(() {
                _type = value;
              })),
      SizedBox(height: 15.0),
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
      SizedBox(height: 15.0),
      TextFormField(
        initialValue: _hoursPerWeek,
        validator: (String input) =>
            input.length <= 0 ? 'please enter the $HOURS_PER_WEEK' : null,
        onFieldSubmitted: (String value) {
          setState(() {
            isValidated = false;
          });
        },
        onSaved: (String value) => _hoursPerWeek = value,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(),
            filled: true,
            alignLabelWithHint: true,
            labelText: HOURS_PER_WEEK),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 15.0),
      Container(
          child: DateTimePickerFormField(
        initialValue: _dateTime,
        format: this.dateFormat,
        dateOnly: false,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            border: UnderlineInputBorder(),
            filled: true,
            alignLabelWithHint: true,
            labelText: DUE_DATE),
        validator: _validateDueDate,
        onFieldSubmitted: (DateTime value) {
          setState(() {
            isValidated = false;
          });
        },
        onChanged: (dueDate) => setState(() => _dateTime = dueDate),
      )),
      SizedBox(height: 15.0),
      Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(top: 20),
        width: 500,
        height: 400,
        child: Column(children: <Widget>[
          Text(
            'choose the subjects color:',
            style: TextStyle(fontSize: 25.0),
          ),
          new PaletteValuePicker(
            color: new HSVColor.fromColor(_color),
            onChanged: (value) => super.setState(() => this.onChanged(value)),
          )
        ]),
      ),
      SizedBox(height: 15.0),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Stack(children: <Widget>[
          Visibility(
              visible: !isValidated,
              child: new IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () => _checkIfInputIsValid(),
              )),
          Visibility(
              visible: isValidated,
              child: new StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                return () => store
                  ..dispatch(UpdateSubject(_submit(), new SubjectOverview()));
              }, builder: (context, callback) {
                return new IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 30,
                  ),
                  onPressed: callback,
                );
              }))
        ]),
        Container(
          width: 20.0,
          height: 20.0,
        ),
        StoreConnector<AppState, VoidCallback>(converter: (store) {
          return () => store..dispatch(DeleteSubject(widget.subject.id));
        }, builder: (context, callback) {
          return new IconButton(
            icon: Icon(
              Icons.delete,
              size: 30,
            ),
            onPressed: callback,
          );
        }),
      ])
    ]);
  }
}
