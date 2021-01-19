import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/cubits/cubits.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';

import 'wave_view.dart';

class MarksTab extends StatelessWidget {
  final List<Student> students;
  final int tabNumber;

  const MarksTab({Key key, this.students, this.tabNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsCubit, int>(
      builder: (context, studentIndex) => BlocConsumer<MatiereCubit, int>(
        listener: (context, state) {
          if (students[state].notes.isEmpty) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Aucune note disponible pour l'etudiant")));
          }
        },
        buildWhen: (oldState, newState) {
          return students[newState].notes.isNotEmpty;
        },
        builder: (context, MatiereIndex) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Les élèves:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Détails',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.black54,
                        size: 18.0,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: students.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DisplayStudent(
                          index: index, student: students[index]);
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Les matieres:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Glisser ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black54,
                        size: 18.0,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: students[context
                                .select((StudentsCubit cubit) => cubit.state)]
                            .notes
                            .isNotEmpty
                        ? students[context
                                .select((StudentsCubit cubit) => cubit.state)]
                            .notes[0]
                            .length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Builder(builder: (context) {
                        return DisplayMatiere(
                            index: index,
                            student: students[context
                                .select((StudentsCubit cubit) => cubit.state)]);
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Les notes:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Détails ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                      ),
                      Icon(
                        Icons.list,
                        color: Colors.black54,
                        size: 18.0,
                      ),
                    ],
                  ),
                ],
              ),
              MarkCard(
                  mark: students[context
                              .select((StudentsCubit cubit) => cubit.state)]
                          .notes
                          .isNotEmpty
                      ? students[context
                                  .select((StudentsCubit cubit) => cubit.state)]
                              .notes[tabNumber]
                          [context.select((MatiereCubit cubit) => cubit.state)]
                      : null),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayStudent extends StatelessWidget {
  final int index;
  final Student student;

  const DisplayStudent({Key key, this.index, this.student}) : super(key: key);

  @override
  Widget build(context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        RaisedButton(
          onPressed: () {
            context.read<StudentsCubit>().selectStudent(index);
          },
          child: Text(
            student.firstName,
            style: TextStyle(
                color: context.select((StudentsCubit cubit) => cubit.state) ==
                        index
                    ? Colors.white
                    : Colors.lightBlue),
          ),
          color: context.select((StudentsCubit cubit) => cubit.state) == index
              ? Colors.lightBlue
              : Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              side: BorderSide(color: Colors.lightBlue)),
        ),
      ],
    );
  }
}

class DisplayMatiere extends StatelessWidget {
  final int index;
  final Student student;

  const DisplayMatiere({Key key, this.index, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        RaisedButton(
          onPressed: () {
            context.read<MatiereCubit>().selectMatiere(index);
          },
          child: Text(
            "${student.notes[0][index].labelMatiere}",
            style: TextStyle(
                color:
                    context.select((MatiereCubit cubit) => cubit.state) == index
                        ? Colors.white
                        : Colors.lightBlue),
          ),
          color: context.select((MatiereCubit cubit) => cubit.state) == index
              ? Colors.lightBlue
              : Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              side: BorderSide(color: Colors.lightBlue)),
        ),
      ],
    );
  }
}

class MarkCard extends StatelessWidget {
  final Note mark;

  const MarkCard({Key key, this.mark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _contatinerMarks(
                context,
                'Devoir 01',
                mark.stateD1
                    ? _convertNoteToColor(mark?.d1 ?? 0.0, base: mark?.baremD1)
                    : _convertNoteToColor(0),
                mark.stateD1
                    ? _convertNoteToWater(mark?.d1 ?? 0.0, base: mark?.baremD1)
                    : _convertNoteToWater(0),
                mark.stateD1 ? mark?.d1 ?? 0.0 : 0.0,
                mark.stateD1
                    ? _convertNoteToGrade(mark?.d1 ?? 0.0, base: mark?.baremD1)
                    : _convertNoteToGrade(0),
              ),
              _contatinerMarks(
                context,
                'Devoir 02',
                mark.stateD2
                    ? _convertNoteToColor(mark?.d2 ?? 0.0, base: mark?.baremD2)
                    : _convertNoteToColor(0),
                mark.stateD2
                    ? _convertNoteToWater(mark?.d2 ?? 0.0, base: mark?.baremD2)
                    : _convertNoteToWater(0),
                mark.stateD2 ? mark?.d2 ?? 0.0 : 0.0,
                mark.stateD2
                    ? _convertNoteToGrade(mark?.d2 ?? 0.0, base: mark?.baremD2)
                    : _convertNoteToGrade(0),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Opacity(
                child: _contatinerMarks(
                    context,
                    'Autre',
                    _convertNoteToColor(0),
                    _convertNoteToWater(0),
                    0,
                    _convertNoteToGrade(0)),
                opacity: 0,
              ),
              _contatinerMarks(
                context,
                'Composition',
                mark.stateEx
                    ? _convertNoteToColor(mark?.ex ?? 0.0, base: mark?.baremeEx)
                    : _convertNoteToColor(0),
                mark.stateEx
                    ? _convertNoteToWater(mark?.ex ?? 0.0, base: mark?.baremeEx)
                    : _convertNoteToWater(0),
                mark.stateEx ? mark?.ex ?? 0.0 : 0.0,
                mark.stateEx
                    ? _convertNoteToGrade(mark?.ex ?? 0.0, base: mark?.baremeEx)
                    : _convertNoteToGrade(0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contatinerMarks(
      context, String dev, Color color, int water, double mark, String grade) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        color: WHITE,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(40.0),
            topRight: Radius.circular(40.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey, offset: Offset(1.1, 1.1), blurRadius: 10.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    dev,
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Divider(),
                  Text(
                    grade,
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 50,
              height: 160,
              decoration: BoxDecoration(
                color: SPECIAL_WHITE,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    bottomLeft: Radius.circular(80.0),
                    bottomRight: Radius.circular(80.0),
                    topRight: Radius.circular(80.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey, offset: Offset(2, 2), blurRadius: 4),
                ],
              ),
              child: WaveView(water, water, color, mark),
            ),
          ),
        ],
      ),
    );
  }

  int _convertNoteToWater(double note, {base = 20}) {
    if (base == 10) return _convertNoteToWater10(note);
    return (160 - (note * 2 * 4)).toInt();
  }

  Color _convertNoteToColor(double note, {base = 20}) {
    if (base == 10) return _convertNoteToColor10(note);

    if (note >= 17.0) {
      return Colors.greenAccent;
    } else if (note >= 10.0 && note <= 17.0) {
      return Colors.lightBlue;
    } else if (note >= 7.0 && note <= 10.0) {
      return Colors.orangeAccent;
    } else if (note <= 7.0) {
      return Colors.redAccent;
    }
  }

  String _convertNoteToGrade(double note, {base = 20}) {
    if (base == 10) return _convertNoteToGrade10(note);
    if (note >= 17.0) {
      return 'Très Bien';
    } else if (note >= 10.0 && note <= 17.0) {
      return 'Bien';
    } else if (note >= 7.0 && note <= 10.0) {
      return 'Assez Bien';
    } else if (note <= 7.0) {
      return 'Faible';
    }
  }

  int _convertNoteToWater10(double note) {
    return (160 - (note * 2 * 8)).toInt();
  }

  String _convertNoteToGrade10(double note) {
    if (note >= 8.5) {
      return 'Très Bien';
    } else if (note >= 5.0 && note <= 8.5) {
      return 'Bien';
    } else if (note >= 3.5 && note <= 5.0) {
      return 'Assez Bien';
    } else if (note <= 3.5) {
      return 'Faible';
    }
  }

  Color _convertNoteToColor10(double note) {
    if (note >= 8.5) {
      return Colors.greenAccent;
    } else if (note >= 5.0 && note <= 8.5) {
      return Colors.lightBlue;
    } else if (note >= 3.5 && note <= 5.5) {
      return Colors.orangeAccent;
    } else if (note <= 3.5) {
      return Colors.redAccent;
    }
  }
}
