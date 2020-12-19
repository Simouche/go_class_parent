import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/attachement_file.dart';
import 'package:go_class_parent/backend/models/matiere.dart';

class ClassWithHomeWorks extends Equatable {
  final String name;
  final List<Matiere> matieres;

  ClassWithHomeWorks({this.matieres, this.name});

  @override
  List<Object> get props => [this.matieres, this.name];

  static ClassWithHomeWorks fromJson(Map<String, dynamic> json) {
    return ClassWithHomeWorks(
      name: json["classe"],
      matieres: (json["matieres"] as List)
          .map<Matiere>((e) => Matiere.fromJson(e))
          .toList(),
    );
  }
}

class HomeWork extends Equatable {
  final String unit;
  final List<HomeWorkTask> tasks;

  HomeWork({this.unit, this.tasks});

  @override
  List<Object> get props => [this.unit, this.tasks];

  static HomeWork fromJson(Map<String, dynamic> json) {
    return HomeWork(
      unit: json["unit"],
      tasks: json["duties"]
          .map<HomeWorkTask>((element) => HomeWorkTask.fromJson(element))
          .toList(),
    );
  }
}

class HomeWorkTask extends Equatable {
  final HomeWorkReference reference;
  final List<AttachmentFile> files;
  final String dueDate;
  final String publishDate;
  final String publishTime;

  HomeWorkTask(
      {this.publishTime,
      this.publishDate,
      this.reference,
      this.files,
      this.dueDate});

  @override
  List<Object> get props => [
        this.publishTime,
        this.publishDate,
        this.reference,
        this.files,
        this.dueDate
      ];

  static HomeWorkTask fromJson(Map<String, dynamic> json) {
    return HomeWorkTask(
        reference: HomeWorkReference.fromJson(json["reference"]),
        files: (json["file"] as List)
            .map<AttachmentFile>((element) => AttachmentFile.fromJson(element))
            .toList(),
        dueDate: json["date"]["deadline"],
        publishDate: json["date"]["publishDate"],
        publishTime: json["date"]["publishTime"]);
  }
}

class HomeWorkReference extends Equatable {
  final String description;
  final List<String> links;

  HomeWorkReference({this.description, this.links});

  @override
  List<Object> get props => [links, description];

  static HomeWorkReference fromJson(Map<String, dynamic> json) {
    return HomeWorkReference(
        links: json["links"]
            .map<String>((element) => (element as String))
            .toList(),
        description: json["description"]);
  }
}
