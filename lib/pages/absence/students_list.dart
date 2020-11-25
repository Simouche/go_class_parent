import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class StudentsListPage extends StatelessWidget {
  static const String routeName = 'home/students_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "List des Enfants", showActions: false),
      body: BlocConsumer<ChildrenBloc, ChildrenState>(
        buildWhen: (oldState, newState) {
          return newState is StudentLoadingState ||
              newState is StudentLoadingFailedState ||
              newState is StudentLoadingSuccessState;
        },
        listenWhen: (oldState, newState) {
          return newState is CheckQrCodeSuccessState ||
              newState is CheckQrCodeFailedState;
        },
        listener: (context, state) async {
          String text = "";
          var color = WHITE;

          if (state is CheckQrCodeSuccessState) {
            text = "Votre demande a etait envoyée a l'administration...";
            BlocProvider.of<ChildrenBloc>(context).add(
              RequestStudentPermissionEvent(
                  parent: (await BlocProvider.of<AuthenticationBloc>(context)
                          .parent)
                      .serverId,
                  students: state.selectedStudents),
            );
          } else if (state is CheckQrCodeFailedState) text = "Action refusée.";

          Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
        },
        builder: (context, state) {
          if (state is StudentLoadingState)
            return Center(child: Text("En cours de chargment..."));
          else if (state is StudentLoadingFailedState)
            return Center(
                child: Text("Echec de chargement, veuillez reessayer."));
          else {
            final rState = state as StudentLoadingSuccessState;
            return _StudentListBody(students: rState.students);
          }
        },
      ),
    );
  }
}

class _StudentListBody extends StatefulWidget {
  final List<Student> students;
  final List<bool> values = List();

  _StudentListBody({Key key, this.students}) : super(key: key) {
    students.forEach((element) => values.add(false));
  }

  @override
  __StudentListBodyState createState() => __StudentListBodyState();
}

class __StudentListBodyState extends State<_StudentListBody> {
  final List<String> selectedStudents = List();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(widget.students[index].toString()),
                onChanged: widget.students[index].state == "En Classe"
                    ? (bool value) {
                        value
                            ? selectedStudents
                                .add(widget.students[index].serverID)
                            : selectedStudents
                                .remove(widget.students[index].serverID);
                        setState(() {
                          widget.values[index] = value;
                        });
                        print(selectedStudents);
                      }
                    : null,
                value: widget.values[index],
                activeColor: MAIN_COLOR_LIGHT,
                subtitle: Text(widget.students[index].state),
              );
            },
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
              // color: BLACK,
            ),
            itemCount: widget.students.length,
          ),
        ),
        RaisedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/qr_code.png",
                width: 24.0,
                color: WHITE,
              ),
              SizedBox(width: 5.0),
              Text(
                "Valider",
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () async {
            print("demander!");
            String cameraScanResult = await scanner.scan();
            if (cameraScanResult.isNotEmpty)
              BlocProvider.of<ChildrenBloc>(context).add(
                CheckQrCodeEvent(
                    selectedStudents: selectedStudents,
                    qrCode: cameraScanResult,
                    parentCode:
                        (await BlocProvider.of<AuthenticationBloc>(context)
                                .parent)
                            .serverId),
              );
            else
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Aucun code detecté.")));
          },
          color: MAIN_COLOR_MEDIUM,
          textColor: WHITE,
        ),
        SizedBox(height: 150.0),
      ],
    );
  }
}
