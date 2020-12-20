import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeWorkListPage extends StatelessWidget {
  static const String routeName = "home/home_work/homework_list_page";

  @override
  Widget build(BuildContext context) {
    final HomeWork homeWorks = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: MyAppBar(title: "Travail Maison", showActions: false),
      body: BlocListener<DownloadsBloc, DownloadsState>(
          listener: (context, state) {
            if (state is DownloadsInProgressState) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Telechargement en cours..."),
              ));
            } else if (state is DownloadsSuccessfulState)
              Scaffold.of(context).showSnackBar(SnackBar(
                content:
                    Text("Fichiers telechargés avec succés, veuillez voir la"
                        " pages des telechargement"),
              ));
          },
          child: ListView.separated(
              itemBuilder: (context, index) => Center(
                    child: Material(
                      elevation: 8.0,
                      child: ListTile(
                        leading: Icon(
                          Icons.cloud_download,
                          color:
                              homeWorks.tasks[index].files?.isNotEmpty ?? false
                                  ? MAIN_COLOR_LIGHT
                                  : Colors.grey,
                        ),
                        title: Text(homeWorks.unit),
                        subtitle:
                            Text(homeWorks.tasks[index].description ?? " "),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("De: ${homeWorks.tasks[index].publishDate}"),
                            Text("à: ${homeWorks.tasks[index].dueDate}")
                          ],
                        ),
                        onTap: () async {
                          if (homeWorks.tasks[index].files.isEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Aucun fichier a telecharger")));
                          } else {
                            if (await Permission.storage.request().isGranted) {
                              BlocProvider.of<DownloadsBloc>(context).add(
                                  TriggerDownloadsEvent(
                                      files: homeWorks.tasks[index].files));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Permission refusée"),
                              ));
                            }
                          }
                        },
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(thickness: 1),
              itemCount: homeWorks.tasks.length)),
    );
  }
}
