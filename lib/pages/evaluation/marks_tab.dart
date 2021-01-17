import 'package:flutter/material.dart';
import 'package:go_class_parent/backend/models/models.dart';

class MarksTab extends StatelessWidget {
  final List<Student> students;

  const MarksTab({Key key, this.students}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
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
                itemCount: students.length,
                itemBuilder: (BuildContext context, int index) {
                  return _displayStudent(index, studentObject);
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
}

class DisplayStudent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

  }

}
