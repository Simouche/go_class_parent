import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/models/attachement_file.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsProvider extends BaseDownloadsProvider {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<bool> downloadFiles(List<AttachmentFile> urls) async {
    for (var element in urls) {
      final thePath = Platform.isAndroid
          ? (await ExtStorage.getExternalStoragePublicDirectory(
                  ExtStorage.DIRECTORY_DOWNLOADS)) +
              "/" +
              (element.name)
          : (await getApplicationDocumentsDirectory()).path +
              "/downloads/" +
              element.name;
      await client.downloadFile(element.url, thePath);
      AttachmentFile(
        url: element.url,
        name: element.name,
        type: element.type,
        path: thePath,
        extension: thePath.substring(thePath.lastIndexOf(".")),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      ).saveToDB(database);
    }
    switch (urls.first.type) {
      case "M":
        Message.markFilesAsDownloaded(database, urls.first.owner);
        break;
      case "N":
        Notification.markFilesAsDownloaded(database, urls.first.owner);
        break;
    }
    return true;
  }

  @override
  Future<List<AttachmentFile>> loadFilesFromDB() async {
    return await AttachmentFile.loadFromDB(database);
  }
}
