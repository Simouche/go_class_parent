import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/downloads_provider.dart';

class DownloadsRepository {
  final DownloadsProvider _downloadsProvider = DownloadsProvider();

  Future<bool> downloadFiles(List<AttachmentFile> files) async =>
      _downloadsProvider.downloadFiles(files);

  Future<List<AttachmentFile>> loadFromDatabase() async =>
      _downloadsProvider.loadFilesFromDB();
}
