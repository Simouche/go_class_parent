import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/home_work.dart';
import 'package:go_class_parent/widgets/my_app_bar.dart';

import 'matiere_list.dart';

class ClassesListPage extends StatelessWidget {
  static const String routeName = "home/home_work/classes_list_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Travail Maison", showActions: false),
      body: BlocBuilder<HomeWorkBloc, HomeWorkState>(
        buildWhen: (oldState, state) =>
            state is HomeWorkLoadingState ||
            state is HomeWorkLoadedSuccessState ||
            state is HomeWorkLoadedFailedState,
        builder: (context, state) {
          if (state is HomeWorkLoadingState) {
            return Center(child: Text('En cours de chargement.'));
          } else if (state is HomeWorkLoadedFailedState) {
            return Center(
                child: Text('Echec de chargement, reessayez plutard.'));
          } else {
            final list = (state as HomeWorkLoadedSuccessState).homeWorks;
            if (list.isEmpty) {
              return Center(child: Text("Aucun Travail Maison."));
            }
            return _HomeWorkPageBody(homeWorks: list);
          }
        },
      ),
    );
  }
}

class _HomeWorkPageBody extends StatelessWidget {
  final List<ClassWithHomeWorks> homeWorks;

  _HomeWorkPageBody({this.homeWorks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              homeWorks.length,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MatiereListPage.routeName,
                    arguments: homeWorks[index].matieres,
                  );
                },
                child: Card(
                  elevation: 8.0,
                  shadowColor: Color(0x802196F3),
                  margin: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          homeWorks[index].name,
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
