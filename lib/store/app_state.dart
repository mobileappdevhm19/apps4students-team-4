import 'package:easy_study/database/db_creator.dart';
import 'package:easy_study/database/db_helper.dart';
import 'package:easy_study/model/subject.dart';
import 'package:easy_study/view/home.dart';
import 'package:easy_study/view/subject_overview.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AppState {
  final DBHelper dbHelper;
  final Widget widget;

  AppState({this.widget, this.dbHelper});

  factory AppState.initial() => new AppState(
      dbHelper: DBHelper(DBCreator().database), widget: new Home());
}

final searchReducer = combineReducers<AppState>([
  TypedReducer<AppState, AddNewSubject>(_addNewSubject),
  TypedReducer<AppState, UpdateSubject>(_updateSubject),
  TypedReducer<AppState, DeleteSubject>(_deleteSubject),
  TypedReducer<AppState, ChangeView>(_changeView),
]);

class AddNewSubject {
  final Subject subject;

  AddNewSubject(this.subject);
}

class UpdateSubject {
  final Widget widget;
  final Subject subject;

  UpdateSubject(this.subject, this.widget);
}

class DeleteSubject {
  final int id;

  DeleteSubject(this.id);
}

class ChangeView {
  final Widget widget;

  ChangeView(this.widget);

  bool showFAB() {
    return widget.toString() == "SubjectOverview";
  }
}

AppState _addNewSubject(AppState state, AddNewSubject action) =>
    new AppState(dbHelper: state.dbHelper, widget: new SubjectOverview())
      ..dbHelper.addNewSubject(action.subject);

AppState _updateSubject(AppState state, UpdateSubject action) => new AppState(
    dbHelper: state.dbHelper,
    widget: action.widget == null ? state.widget : action.widget)
  ..dbHelper.updateSubject(action.subject);

AppState _deleteSubject(AppState state, DeleteSubject action) =>
    new AppState(dbHelper: state.dbHelper, widget: new SubjectOverview())
      ..dbHelper.deleteSubject(action.id);

AppState _changeView(AppState state, ChangeView action) =>
    new AppState(dbHelper: state.dbHelper, widget: action.widget);
