import 'package:flutter/material.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:random_color/random_color.dart';

class ScheduleDetailsPage extends StatelessWidget {
  final List<Seance> hours;

  const ScheduleDetailsPage({Key key, this.hours}) : super(key: key);

  Widget _buildPlanBox(
      String heure, String hoursEnd, String matiere, String prof) {
    return Card(
      elevation: 2,
      child: Row(
        children: <Widget>[
          Container(
            height: 60,
            width: 10,
            color: RandomColor().randomColor(),
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Text(
                heure,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                hoursEnd,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(width: 10),
          Container(
              height: 50,
              child: VerticalDivider(color: RandomColor().randomColor())),
          SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(matiere,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(prof),
            ],
          )
          //Text('Math'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: hours == null ? 0 : hours.length,
        itemBuilder: (BuildContext context, int index) {
          return hours[index].matiere == ''
              ? SizedBox(height: 60)
              : _buildPlanBox(hours[index].hourStart, hours[index].hourEnd,
                  hours[index].matiere, hours[index].teacher);
        },
      ),
    );
  }
}
