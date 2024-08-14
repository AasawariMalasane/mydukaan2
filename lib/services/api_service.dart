import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    // print("url==$url");
    final response = await _client.get(
      Uri.parse(url),
      headers: headers ?? AppConfig.headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body}) async {
    // print("url==$url");
    final response = await _client.post(
      Uri.parse(url),
      headers: headers ?? AppConfig.headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> patch(String url, {Map<String, String>? headers, dynamic body}) async {
    // print("url==$url");
    final response = await _client.patch(
      Uri.parse(url),
      headers: headers ?? AppConfig.headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    // print("url==$url");
    final response = await _client.delete(
      Uri.parse(url),
      headers: headers ?? AppConfig.headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 405 || response.statusCode == 406) {
      throw ForceUpdateException();
    } else {
      throw HttpException(response.statusCode, response.body);
    }
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String body;

  HttpException(this.statusCode, this.body);

  @override
  String toString() => 'HttpException: $statusCode\n$body';
}

class ForceUpdateException implements Exception {
  @override
  String toString() => 'ForceUpdateException: App update required';
}