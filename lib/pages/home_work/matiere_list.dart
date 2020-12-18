import 'package:flutter/material.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/widgets.dart';

class MatiereListPage extends StatelessWidget {
  static const String routeName = "home/home_work/matiere_list_page";

  @override
  Widget build(BuildContext context) {
    final List<Matiere> matieres = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: MyAppBar(title: "Travail Maison", showActions: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                matieres.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MatiereListPage.routeName,
                      arguments: matieres[index].homeWorks,
                    );
                  },
                  child: Card(
                    elevation: 8.0,
                    shadowColor: Color(0x802196F3),
                    margin: EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            matieres[index].label,
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
