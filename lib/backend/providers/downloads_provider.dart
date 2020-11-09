import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/models/attachement_file.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsProvider extends BaseDownloadsProvider {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<bool> downloadFiles(List<dynamic> urls) async {
    urls.forEach((element) async {
      final thePath = Platform.isAndroid
          ? (await ExtStorage.getExternalStoragePublicDirectory(
                  ExtStorage.DIRECTORY_DOWNLOADS)) +
              "/" +
              element.name
          : (await getApplicationDocumentsDirectory()).path +
              "/downloads/" +
              element.name;
      print(thePath);
      print(element);
      await client.downloadFile(element.url, thePath);
      AttachmentFile(
              url: element.url,
              name: element.name,
              type: element.type,
              path: thePath,
              extension: thePath.substring(thePath.lastIndexOf(".")),
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
          .saveToDB(database);
    });
    return true;
  }

  @override
  Future<List<AttachmentFile>> loadFilesFromDB() async {
    return await AttachmentFile.loadFromDB(database);
  }
}
