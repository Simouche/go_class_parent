import 'package:equatable/equatable.dart';

class Canteen extends Equatable {
  final String classe;
  final List<Menu> menus;

  Canteen({this.classe, this.menus});

  static Canteen fromJson(Map<String, dynamic> json) {
    return Canteen(
      classe: json['classe'],
      menus: json['Menu'].map<Menu>((e) => Menu.fromJson(e)).toList(),
    );
  }

  @override
  List<Object> get props => [this.classe, this.menus];
}

class Menu extends Equatable {
  final String serverId, day;
  final Plats plats;

  Menu({this.serverId, this.day, this.plats});

  static Menu fromJson(Map<String, dynamic> json) {
    return Menu(
      serverId: json['_id'],
      day: json['day'],
      plats: Plats.fromJson(json['Plats']),
    );
  }

  @override
  List<Object> get props => [this.serverId, this.day, this.plats];
}

class Plats extends Equatable {
  final String first, second, dessert;

  Plats({this.first, this.second, this.dessert});

  static Plats fromJson(Map<String, dynamic> json) {
    return Plats(
      first: json['first'],
      second: json['second'],
      dessert: json['dessert'],
    );
  }

  @override
  List<Object> get props => [first, second, dessert];
}
