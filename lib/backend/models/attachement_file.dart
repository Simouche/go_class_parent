import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class AttachmentFile extends Equatable {
  final int id;
  final String date;
  final String path;
  final String type;
  final String extension;
  final String url;
  final String name;
  final String owner;
  final bool downloaded;

  static const String TABLE_NAME = "files";

  AttachmentFile({
    this.downloaded,
    this.owner,
    this.id,
    this.date,
    this.path,
    this.type,
    this.extension,
    this.url,
    this.name,
  });

  @override
  List<Object> get props => [
        this.id,
        this.date,
        this.path,
        this.type,
        this.extension,
        this.url,
        this.name,
        this.owner,
        this.downloaded,
      ];

  @override
  String toString() => "url = $url name = $name";

  Map<String, dynamic> toMap() {
    return {
      "DATE": date,
      "PATH": path,
      "TYPE": type,
      "EXTENSION": extension,
      "NAME": name,
      "URL": url,
      "OWNER": owner,
      "DOWNLOADED": downloaded,
    };
  }

  static AttachmentFile fromMap(Map<String, dynamic> map) {
    return AttachmentFile(
      id: map["ID"],
      date: map["DATE"],
      path: map["PATH"],
      type: map["TYPE"],
      extension: map["EXTENSION"],
      url: map["URL"],
      name: map["NAME"],
      owner: map["NOTIFICATION_ID"],
      downloaded: map["DOWNLOADED"],
    );
  }

  Future<bool> saveToDB(LocalDB db) async {
    final int result = await db.insert(tableName: "downloads", values: toMap());
    return result > 0;
  }

  static Future<List<AttachmentFile>> loadFromDB(LocalDB db) async {
    final List<Map<String, dynamic>> result =
        await db.query(tableName: "downloads", columns: ["*"]);
    final List<AttachmentFile> files = result.map((e) => fromMap(e)).toList();
    return files;
  }

  static Future<List<AttachmentFile>> loadNotificationsFiles(
      LocalDB db, int notificationID) async {
    final List<Map<String, dynamic>> result = await db.query(
        tableName: "downloads",
        columns: ["*"],
        where: "OWNER = ?",
        whereArgs: [notificationID]);
    return result.map((e) => fromMap(e)).toList();
  }
}
