import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/pages/attendance/attendances_list.dart';
import 'package:go_class_parent/widgets/widgets.dart';

class AttendanceChildrenPage extends StatelessWidget {
  static const String routeName = 'home/attendance_children';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Liste des enfants', showActions: false),
      body: BlocBuilder<ChildrenBloc, ChildrenState>(
        buildWhen: (context, state) =>
        state is StudentLoadingState ||
            state is StudentLoadingFailedState ||
            state is StudentLoadingSuccessState,
        builder: (context, state) {
          print("called");
          if (state is StudentLoadingState) {
            return Center(child: Text('En cours de chargement.'));
          } else if (state is StudentLoadingFailedState) {
            return Center(
                child: Text('Echec de chargement, reessayez plutard.'));
          } else if (state is StudentLoadingSuccessState) {
            if (state.students.isEmpty) {
              return Center(child: Text('Aucun Enfant a Affiché.'));
            } else if (state.students.length == 1) {
              Future.delayed(Duration(seconds: 3), () {
                //Todo request attendance of a student
                Navigator.pushReplacementNamed(
                  context,
                  AttendanceList.routeName,
                  arguments: state.students.first,
                );
              });
              return Center(child: Text('Chargé, un moment svp.'));
            } else {
              return _AttendanceChildrenListBody(children: state.students);
            }
          } else {
            Navigator.of(context).pop();
            return Center(child: Text('Chargement...'));
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _AttendanceChildrenListBody extends StatefulWidget {
  List<Student> children = List();
  String currentClass;

  _AttendanceChildrenListBody({this.children}) {
    // currentClass = children.first.classe;
  }

  @override
  _AttendanceChildrenListBodyState createState() =>
      _AttendanceChildrenListBodyState();
}

class _AttendanceChildrenListBodyState
    extends State<_AttendanceChildrenListBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                widget.children.length,
                    (index) =>
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<AttendanceBloc>(context).add(
                            LoadAttendanceEvent(
                                id: widget.children[index].serverID));
                        Navigator.pushNamed(
                          context,
                          AttendanceList.routeName,
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
                              Center(
                                child: Text(
                                  widget.children[index].toString(),
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0),
                                  textAlign: TextAlign.center,
                                ),
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
      ),
    );
  }
}
