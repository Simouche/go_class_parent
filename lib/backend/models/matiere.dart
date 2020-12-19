import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

import 'home_work.dart';

class Matiere extends Equatable {
  final String label, level;
  final List<HomeWork> homeWorks;

  Matiere({this.homeWorks, this.label, this.level});

  static Matiere fromJson(Map json) {
    return Matiere(
      label: json['label'] ?? json["matiere"],
      level: json['level'],
      homeWorks: (json["units"] as List)
          .map<HomeWork>((e) => HomeWork.fromJson(e))
          .toList(),
    );
  }

  static insert(LocalDB database, json) {}

  @override
  List<Object> get props => [label, level];
}
