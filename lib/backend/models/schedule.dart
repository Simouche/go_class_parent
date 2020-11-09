import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final String classe;
  final List<dynamic> teachers, rooms, matieres, startTimes, endTimes;

  Schedule(
      {this.classe,
      this.teachers,
      this.rooms,
      this.matieres,
      this.startTimes,
      this.endTimes});

  static Schedule fromJson(Map json) {
    return Schedule(
      classe: json['classe'],
      teachers: json['teachers'],
      rooms: json['rooms'],
      matieres: json['matieres'],
      startTimes: json['startTime'],
      endTimes: json['endTime'],
    );
  }

  Map<String, List<Seance>> splitToDays() {
    final Map<String, List<Seance>> week = {
      'sunday': List<Seance>(),
      'monday': List<Seance>(),
      'tuesday': List<Seance>(),
      'wednesday': List<Seance>(),
      'thursday': List<Seance>(),
    };
    int timings = 0;
    int i = 0;
    while (i < teachers.length) {
      //0
      week['sunday'].add(Seance(
          hour: startTimes[timings],
          matiere: matieres[i],
          teacher: teachers[i]));
      i++; //1
      week['monday'].add(Seance(
          hour: startTimes[timings],
          matiere: matieres[i],
          teacher: teachers[i]));
      i++; //2
      week['tuesday'].add(Seance(
          hour: startTimes[timings],
          matiere: matieres[i],
          teacher: teachers[i]));
      i++; //3
      week['wednesday'].add(Seance(
          hour: startTimes[timings],
          matiere: matieres[i],
          teacher: teachers[i]));
      i++; //4
      week['thursday'].add(Seance(
          hour: startTimes[timings],
          matiere: matieres[i],
          teacher: teachers[i]));
      i++; //5
      timings++;
    }

    return week;
  }

  @override
  List<Object> get props =>
      [classe, teachers, rooms, matieres, startTimes, endTimes];

  @override
  String toString() => classe;
}

class Seance extends Equatable {
  final String hour, matiere, teacher;

  Seance({this.hour, this.matiere, this.teacher});

  @override
  List<Object> get props => throw UnimplementedError();
}
