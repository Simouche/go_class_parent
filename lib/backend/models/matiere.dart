import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Matiere extends Equatable {
  final String label, level;

  Matiere({this.label, this.level});

  static Matiere fromJson(Map json) {
    return Matiere(label: json['label'], level: json['level']);
  }

  static insert(LocalDB database, json) {}

  @override
  List<Object> get props => [label, level];
}
