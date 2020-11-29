import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/widgets.dart';

class AttendanceList extends StatelessWidget {
  static const String routeName = 'home/attendance_children/attendance_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Historique", showActions: false),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        buildWhen: (oldState, newState) {
          return newState is AttendanceLoadingState ||
              newState is AttendanceLoadedState ||
              newState is AttendanceLoadingFailedState;
        },
        builder: (context, state) {
          if (state is AttendanceLoadingState)
            return Center(child: Text("En cours de chargment..."));
          else if (state is AttendanceLoadingFailedState)
            return Center(
                child: Text("Echec de chargement, veuillez reessayer."));
          else {
            final rState = state as AttendanceLoadedState;
            return _AttendanceListBody(attendances: rState.attendances);
          }
        },
      ),
    );
  }
}

class _AttendanceListBody extends StatelessWidget {
  final List<Attendance> attendances;
  final List<bool> values = List();

  _AttendanceListBody({Key key, this.attendances}) : super(key: key) {
    attendances.forEach((element) => values.add(false));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text("${attendances[index].state} le:"),
          title: Text(attendances[index].attendanceDate.day),
          trailing:
              Text("${attendances[index].attendanceDate.scanTime}"),
          subtitle: Text(attendances[index].description),
        );
      },
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
        // color: BLACK,
      ),
      itemCount: attendances.length,
    );
  }
}
