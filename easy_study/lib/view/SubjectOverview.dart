import 'package:easy_study/Database/DBHelper.dart';
import 'package:easy_study/model/Subject.dart';
import 'package:easy_study/store/AppState.dart';
import 'package:easy_study/view/MainScreen.dart';
import 'package:easy_study/view/SubjectCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class SubjectOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubjectOverviewState();
}

class _SubjectOverviewState extends State<SubjectOverview> {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppStateViewModel>(
      converter: (store) {
        return new AppStateViewModel(store.state);
      },
      builder: (BuildContext context, AppStateViewModel vm) {
        return new Container(
          child: FutureBuilder<List<Subject>>(
            future: vm.state.dbHelper.getSubjects(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return new SubjectCard(subject: snapshot.data[index]);
                      });
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
