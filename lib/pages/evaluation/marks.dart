import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/cubits/cubits.dart';
import 'package:go_class_parent/pages/evaluation/marks_tab.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'wave_view.dart';

class MarksPage extends StatelessWidget {
  static const String routeName = 'home/evaluation';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildrenBloc, ChildrenState>(
      builder: (context, state) {
        if (state is StudentLoadingState) {
          return Container(
              child: Center(child: Text("En cours de chargement...")));
        } else if (state is StudentLoadingFailedState) {
          return Container(
              child: Center(
                  child: Text("Echec de Chargement reessayez plutard...")));
        } else {
          StudentLoadingSuccessState _state =
              (state as StudentLoadingSuccessState);
          return DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: _appBar(context),
                body: MultiBlocProvider(
                  providers: [
                    BlocProvider<MatiereCubit>(
                      create: (_) => MatiereCubit(0),
                    ),
                    BlocProvider<StudentsCubit>(
                      create: (_) => StudentsCubit(0),
                    )
                  ],
                  child: TabBarView(
                    children: <Widget>[
                      MarksTab(students: _state.students, tabNumber: 0),
                      MarksTab(students: _state.students, tabNumber: 1),
                      MarksTab(students: _state.students, tabNumber: 2),
                    ],
                  ),
                )),
          );
        }
      },
    );
  }

  Widget _appBar(context) {
    return AppBar(
      elevation: 2.0,
      backgroundColor: Theme.of(context).primaryColorLight,
      iconTheme: new IconThemeData(color: WHITE),
      title: Text(
        'Relevé de note',
        style: TextStyle(
            color: WHITE, fontWeight: FontWeight.w700, fontSize: 26.0),
      ),
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            child: Text(
              '1er Trimestre',
              style: TextStyle(color: WHITE, fontSize: 18),
            ),
          ),
          Tab(
            child: Text(
              '2eme Trimestre',
              style: TextStyle(color: WHITE, fontSize: 18),
            ),
          ),
          Tab(
            child: Text(
              '3eme Trimestre',
              style: TextStyle(color: WHITE, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
