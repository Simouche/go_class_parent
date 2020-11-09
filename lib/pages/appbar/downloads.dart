import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/attachement_file.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:open_file/open_file.dart';

class DownloadsPage extends StatelessWidget {
  static const String routeName = 'home/downloads';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Téléchargements", showActions: false),
      body: BlocBuilder<DownloadsBloc, DownloadsState>(
        buildWhen: (oldState, newState) => newState is DownloadsPageOpenState,
        builder: (context, state) {
          var newState = (state as DownloadsPageOpenState);
          if (state is DownloadsPageOpenState)
            return SafeArea(
                child: newState.files?.isNotEmpty ?? false
                    ? _DownloadsList(files: newState.files)
                    : Center(child: Text("aucun fichier telechargé.")));
          else
            return Center(child: Text("aucun fichier telechargé."));
        },
      ),
    );
  }
}

class _DownloadsList extends StatelessWidget {
  final List<AttachmentFile> files;

  const _DownloadsList({Key key, this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.insert_drive_file, color: MAIN_COLOR_DARK),
          title: Text(files[index].name),
          subtitle: Text(fromSource(files[index].type)),
          trailing: Icon(Icons.open_in_new, color: MAIN_COLOR_DARK),
          onTap: () => OpenFile.open(files[index].path),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: files.length,
    );
  }

  String fromSource(String type) {
    switch (type) {
      case "N":
        return "Notifications";
      case "M":
        return "Messages";
      default:
        return " ";
    }
  }
}
