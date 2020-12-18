import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/widgets.dart';

class HomeWorkListPage extends StatelessWidget {
  static const String routeName = "home/home_work/homework_list_page";

  @override
  Widget build(BuildContext context) {
    final List<HomeWork> homeWorks = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: MyAppBar(title: "Travail Maison", showActions: false),
      body: ListView.separated(
          itemBuilder: (context, index) => Center(
                child: Material(
                  elevation: 8.0,
                  child: ListTile(
//                    tileColor: Colors.green[100],
//                   leading: Text(homeWorks[index].task.),
                    title: Text(homeWorks[index].unit),
                    subtitle: Text("test"),
                  ),
                ),
              ),
          separatorBuilder: (context, index) => const Divider(thickness: 1),
          itemCount: homeWorks.length),
    );
  }
}
