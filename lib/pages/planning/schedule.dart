import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';

import 'schedule_details_page.dart';

class SchedulePage extends StatefulWidget {
  static const String routeName = 'home/schedule';

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Seance> sundayHoursList;

  List<Seance> mondayHoursList;

  List<Seance> tuesdayHoursList;

  List<Seance> wednesdayHoursList;

  List<Seance> thursdayHoursList;

  int dropdownValue = 0;

  List<String> dropdownList;

  Widget _loader(BuildContext context) {
    return Center(
      child: AwesomeLoader(
        loaderType: AwesomeLoader.AwesomeLoader3,
        color: Color.fromRGBO(77, 43, 226, 1.0),
      ),
    );
  }

  _prepare(state) {
    final Map<String, dynamic> results = state.schedules;
    dropdownList = results['classes'];
    final List<Schedule> schedules = results['schedules'];
    final theSchedule = schedules
        .firstWhere((element) => element.classe == dropdownList[dropdownValue]);
    final Map<String, List<Seance>> seances = theSchedule.splitToDays();
    sundayHoursList = seances['sunday'];
    mondayHoursList = seances['monday'];
    tuesdayHoursList = seances['tuesday'];
    wednesdayHoursList = seances['wednesday'];
    thursdayHoursList = seances['thursday'];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SchedulesLoaded) {
              _prepare(state);
              return Scaffold(
//        drawer: DrawerClass(),
                appBar: AppBar(
                  title: Text(
                    'Emploi de ',
                    style: TextStyle(
                        color: WHITE,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: MAIN_COLOR_LIGHT,
                  actions: <Widget>[
                    DropdownButton(
                      value: dropdownValue,
                      onChanged: (int newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: dropDownMenuItems,
                      dropdownColor: WHITE,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    )
                  ],
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          'Dim',
                          style: TextStyle(color: WHITE, fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Lun',
                          style: TextStyle(color: WHITE, fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Mar',
                          style: TextStyle(color: WHITE, fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Mer',
                          style: TextStyle(color: WHITE, fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Jeu',
                          style: TextStyle(color: WHITE, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                body: sundayHoursList == null
                    ? _loader(context)
                    : TabBarView(
                        children: <Widget>[
                          ScheduleDetailsPage(hours: sundayHoursList),
                          ScheduleDetailsPage(hours: mondayHoursList),
                          ScheduleDetailsPage(hours: tuesdayHoursList),
                          ScheduleDetailsPage(hours: wednesdayHoursList),
                          ScheduleDetailsPage(hours: thursdayHoursList),
                        ],
                      ),
              );
            } else if (state is SchedulesLoadingFailed) {
              return Scaffold(
                  appBar: AppBar(
                      title: Text('Emploi de'),
                      backgroundColor: MAIN_COLOR_LIGHT),
                  body: Center(child: Text('Echec de chargement')));
            } else {
              return Scaffold(
                  appBar: AppBar(
                      title: Text('Emploi de'),
                      backgroundColor: MAIN_COLOR_LIGHT),
                  body: Center(child: Text('Chargement des emplois')));
            }
          }),
    );
  }

  get dropDownMenuItems => List.generate(
      dropdownList.length,
      (index) => DropdownMenuItem(
            value: index,
            child: Text(dropdownList[index],
                style: TextStyle(fontSize: 19, color: WHITE)),
          ));
}
