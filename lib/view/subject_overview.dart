import 'package:easy_study/model/subject.dart';
import 'package:easy_study/store/app_state.dart';
import 'package:easy_study/view/main_screen.dart';
import 'package:easy_study/view/subject_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SubjectOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SubjectOverviewState();
}

class SubjectOverviewState extends State<SubjectOverview> {

  SnackBar snackBar = SnackBar(
    content: Text(
      "Tipp: longpress a subject to edit or delete it.",
      style: TextStyle(color: Colors.white),
    ),
    duration: Duration(seconds: 5),
    backgroundColor: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppStateViewModel>(
      converter: (store) {
        Scaffold.of(context).showSnackBar(snackBar);
        return new AppStateViewModel(store.state);
      },
      builder: (BuildContext context, AppStateViewModel vm) {
         Container(
          child: FutureBuilder<List<Subject>>(
            future: vm.state.dbHelper.getSubjects(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return new SubjectCard(subject: snapshot.data[index]);
                        }),
                  );
                }
              }
              return new Container(
                alignment: AlignmentDirectional.center,
                child: new CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
