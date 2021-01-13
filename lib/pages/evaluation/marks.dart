import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'wave_view.dart';

class MarksPage extends StatefulWidget {
  static const String routeName = 'home/evaluation';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MarksPage> {
  int count = 0;
  List matieres = [];
  List student = [];
  var studentData;
  List studentObject = [];
  List matiereObject = [];
  Color btnColor = Colors.lightBlue;

  String _niveau = '';

  Map<String, double> marks = {
    'devoire1': 0.0,
    'devoire2': 0.0,
    'exam': 0.0,
    'activite': 0.0,
  };

  Map<String, dynamic> _formData = {
    'username': '',
    'prenomEleve': '',
    'numInscription': '',
    'classId': '',
  };

  Widget _loader(BuildContext context) {
    return Center(
      child: AwesomeLoader(
        loaderType: AwesomeLoader.AwesomeLoader3,
        color: Colors.lightBlue,
      ),
    );
  }

  Widget _contatinerMarks(
      String dev, Color color, int water, double mark, String grade) {
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

  Widget _appBar() {
    return AppBar(
      elevation: 2.0,
      backgroundColor: Theme.of(context).primaryColorLight,
      iconTheme: new IconThemeData(color: Colors.black),
      title: Text(
        'Relevé de note',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 26.0),
      ),
      actions: <Widget>[
        Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.mail),
              iconSize: 30.0,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/messaging');
              },
            ),
            count != 0 ? _noificationPositioned(count) : Container()
          ],
        ),
        Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              iconSize: 30.0,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/notices');
              },
            ),
            count != 0 ? _noificationPositioned(count) : Container()
          ],
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
              '1er Trimestre',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          Tab(
            child: Text(
              '2eme Trimestre',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          Tab(
            child: Text(
              '3eme Trimestre',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noificationPositioned(int counter) {
    return Positioned(
      right: 6,
      top: 6,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        constraints: BoxConstraints(
          minWidth: 15,
          minHeight: 15,
        ),
        child: Text(
          '$counter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _displayStudent(int index, List list) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              list[index].isSelected = !list[index].isSelected;
              _listResetStudent(index, list);
              _niveau = studentObject[index].niveau.split(" ")[2];
              marks = {
                'devoire1': 0.0,
                'devoire2': 0.0,
                'exam': 0.0,
                'activite': 0.0,
              };
              matieres = studentObject[index].matiereTab;
              matiereObject = _getMatiere(matieres);
              _displayMatiere(0, matiereObject);
//              _listResetMatiere(0, matiereObject);
              _listResetAllMatiere(matiereObject);
            });
          },
          child: Text(
            list[index].data,
            style: TextStyle(
                color:
                    list[index].isSelected ? Colors.white : Colors.lightBlue),
          ),
          color: list[index].isSelected ? Colors.lightBlue : Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              side: BorderSide(color: Colors.lightBlue)),
        ),
      ],
    );
  }

  Widget _displayMatiere(int index, List list) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              list[index].isSelected = !list[index].isSelected;
              _listResetStudent(index, list);
              for (int i = 0; i < studentObject.length; i++) {
                if (studentObject[i].isSelected) {
                  for (int j = 0; j < studentData['result'].length; j++) {
                    if (studentData['result'][j]['idMatiere'] ==
                            list[index].data &&
                        studentObject[i].numIns ==
                            studentData['result'][j]['idStudent']) {
                      marks['devoire1'] =
                          double.parse(studentData['result'][j]['devoire1']);
                      marks['devoire2'] =
                          double.parse(studentData['result'][j]['devoire2']);
                      marks['exam'] =
                          double.parse(studentData['result'][j]['exam']);
                      marks['activite'] =
                          double.parse(studentData['result'][j]['activite']);
                    }
                  }
                }
              }
            });
          },
          child: Text(
            list[index].data,
            style: TextStyle(
                color:
                    list[index].isSelected ? Colors.white : Colors.lightBlue),
          ),
          color: list[index].isSelected ? Colors.lightBlue : Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              side: BorderSide(color: Colors.lightBlue)),
        ),
      ],
    );
  }

  Widget _expanded() {
    return Expanded(
      flex: 8,
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _contatinerMarks(
                  'Devoir 01',
                  _convertNoteToColor(marks['devoire1']),
                  _convertNoteToWater(marks['devoire1']),
                  marks['devoire1'],
                  _convertNoteToGrade(marks['devoire1'])),
              _contatinerMarks(
                  'Devoir 02',
                  _convertNoteToColor(marks['devoire2']),
                  _convertNoteToWater(marks['devoire2']),
                  marks['devoire2'],
                  _convertNoteToGrade(marks['devoire2'])),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _contatinerMarks(
                  'Autre',
                  _convertNoteToColor(marks['exam']),
                  _convertNoteToWater(marks['exam']),
                  marks['exam'],
                  _convertNoteToGrade(marks['exam'])),
              _contatinerMarks(
                  'Composition',
                  _convertNoteToColor(marks['activite']),
                  _convertNoteToWater(marks['activite']),
                  marks['activite'],
                  _convertNoteToGrade(marks['activite'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expandedPrimaire() {
    return Expanded(
      flex: 8,
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _contatinerMarks(
                  'Devoir 01',
                  _convertNoteToColorPrimaire(marks['devoire1']),
                  _convertNoteToWaterPrimaire(marks['devoire1']),
                  marks['devoire1'],
                  _convertNoteToGradePrimaire(marks['devoire1'])),
              _contatinerMarks(
                  'Devoir 02',
                  _convertNoteToColorPrimaire(marks['devoire2']),
                  _convertNoteToWaterPrimaire(marks['devoire2']),
                  marks['devoire2'],
                  _convertNoteToGradePrimaire(marks['devoire2'])),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _contatinerMarks(
                  'Autre',
                  _convertNoteToColorPrimaire(marks['exam']),
                  _convertNoteToWaterPrimaire(marks['exam']),
                  marks['exam'],
                  _convertNoteToGradePrimaire(marks['exam'])),
              _contatinerMarks(
                  'Composition',
                  _convertNoteToColorPrimaire(marks['activite']),
                  _convertNoteToWaterPrimaire(marks['activite']),
                  marks['activite'],
                  _convertNoteToGradePrimaire(marks['activite'])),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _appBar(),
        body: TabBarView(
          children: <Widget>[
            Container(
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
                            'Details',
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
                        itemCount: studentObject.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _displayStudent(index, studentObject);
                        }
//                          student == []
//                              ? _loader(context)
//                              :

                        ),
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
                        itemCount: matieres.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _displayMatiere(index, matiereObject);
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
                            'Details ',
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
                  _niveau == 'Primaire' ? _expandedPrimaire() : _expanded(),
                ],
              ),
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  int _convertNoteToWater(double note) {
    return (160 - (note * 2 * 4)).toInt();
  }

  Color _convertNoteToColor(double note) {
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

  String _convertNoteToGrade(double note) {
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

  int _convertNoteToWaterPrimaire(double note) {
    return (160 - (note * 2 * 8)).toInt();
  }

  String _convertNoteToGradePrimaire(double note) {
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

  Color _convertNoteToColorPrimaire(double note) {
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

  List _studentList(var studentTab) {
    List studentList = [];
    for (int i = 0; i < studentTab["student"].length; i++) {
      List matiereTab = [];
      for (int j = 0; j < studentTab["result"].length; j++) {
        if (studentTab["result"][j]["idStudent"] ==
            studentTab["student"][i]["numeroInscription"]) {
          matiereTab.add(studentTab["result"][j]["idMatiere"]);
        }
      }
      studentList.add(StudentItem<String>(
          studentTab["student"][i]["prenom"],
          studentTab["student"][i]["numeroInscription"],
          matiereTab,
          studentTab["student"][i]["niveau"]));
    }
    return studentList;
  }

  _listResetStudent(int index, List studentObject) {
    for (int i = 0; i < studentObject.length; i++) {
      if (index != i) {
        studentObject[i].isSelected = false;
      } else {
        studentObject[index].isSelected = true;
      }
    }
  }

  List _getMatiere(List matiere) {
    List matiereObject = [];
    for (int i = 0; i < matiere.length; i++) {
      matiereObject.add(MatiereItem<String>(matiere[i]));
    }
    return matiereObject;
  }

  _listResetMatiere(int index, List matiereObject) {
    for (int i = 0; i < matiereObject.length; i++) {
      if (index != i) {
        matiereObject[i].isSelected = false;
      } else {
        matiereObject[index].isSelected = true;
      }
    }
  }

  _listResetAllMatiere(List matiereObject) {
    for (int i = 0; i < matiereObject.length; i++) {
      matiereObject[i].isSelected = false;
    }
  }
}

class StudentItem<T> {
  bool isSelected = true; //Selection property to highlight or not
  T data;
  T numIns;
  T niveau;
  List matiereTab;

  StudentItem(this.data, this.numIns, this.matiereTab,
      this.niveau); //Constructor to assign the data
}

class MatiereItem<T> {
  bool isSelected = true; //Selection property to highlight or not
  T data; //Data of the user
  MatiereItem(this.data); //Constructor to assign the data
}
