import 'package:dio/dio.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _httpClient = HttpClient._internal();
  final http.Client _client = http.Client();
  final Dio _dio = Dio();

  String _baseUrl = "https://lakkini.com/app/";
  String _baseDownloadUrl = "https://lakkini.com/";

//  String _baseUrl = "http://161.35.197.89/app/";
//  String _baseDownloadUrl = "http://161.35.197.89/";
  Duration _timeOut = Duration(seconds: 60);
  Function _onTimeOut;

  factory HttpClient() {
    return _httpClient;
  }

  HttpClient._internal() {
    LocalDB database = LocalDB();
    Settings.usesCustomDomain(database).then((String value) {
      if (value != null && value.isNotEmpty) {
        _baseUrl = "$value/app/";
        _baseDownloadUrl = value;
      }
    });
  }

  Future<dynamic> post(String route, Map<String, dynamic> body) async {
    //Todo add headers
    print(body);
    print(_buildUrl(route));
    return await _client
        .post(_buildUrl(route), body: body)
        .timeout(_timeOut, onTimeout: _onTimeOut);
  }

  Future<dynamic> get(String route, {Map<String, dynamic> queries}) async {
    print(queries);
    print(_buildUrl(route));
    return await _client
        .get(concatQueries(_buildUrl(route), queries))
        .timeout(_timeOut, onTimeout: _onTimeOut);
  }

  Future<Response> downloadFile(String url, String fileName,
      {ProgressCallback onReceivedProgress}) {
    print("download url is: ${_buildDownloadUrl(url)}");
    if (!url.startsWith("/")) url = "/$url";
    return _dio.download(_buildDownloadUrl(url), fileName);
  }

  String _buildUrl(String route) => "$_baseUrl$route";

  String _buildDownloadUrl(String path) => "$_baseDownloadUrl$path";

  String concatQueries(String url, Map<String, dynamic> queries) {
    if (queries == null) return url;
    String _url = "$url?";
    queries.keys.forEach((element) {
      _url = "$_url$element=${queries[element]}&";
    });
    return _url.endsWith("&") ? _url.substring(0, _url.lastIndexOf('&')) : _url;
  }

  set timeOut(int seconds) => _timeOut = Duration(seconds: seconds);

  set onTimeOut(onTimeOut()) => _onTimeOut = onTimeOut;

  void urls(String baseUrl) {
    _baseUrl = "$baseUrl/app/";
    _baseDownloadUrl = "$baseUrl/";
    print("the url is $_baseUrl");
  }

  void reInitUrls() {
    _baseUrl = "https://lakkini.com/app/";
    _baseDownloadUrl = "https://lakkini.com/";
  }
}
