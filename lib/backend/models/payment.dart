import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String type;
  final List<Paid> paids;

  Payment({this.type, this.paids});

  static Payment fromJson(Map json) {
    return Payment(
        type: json['type'],
        paids: json['paid'].map<Paid>((e) => Paid.fromJson(e)).toList());
  }

  @override
  List<Object> get props => [type, paids];

  @override
  String toString() => "$type:$paids";
}

class Paid extends Equatable {
  final String paid, date;

  Paid({this.paid, this.date});

  @override
  List<Object> get props => [paid, date];

  static Paid fromJson(Map json) {
    return Paid(paid: json['paid'], date: json['date']);
  }

  @override
  String toString() => "$date:$paid";
}
