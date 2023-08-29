import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';

class BaseAPIClient {
  static const Duration _timeout = Duration(seconds: 30);

  const BaseAPIClient();

  static Future<http.Response> getAPI({
    required String url,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    final http.Response result = await http
        .get(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> postAPI({
    required String url,
    required dynamic body,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    _removeBodyNullValues(body);
    final http.Response result = await http
        .post(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> putAPI({
    required String url,
    required dynamic body,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    _removeBodyNullValues(body);
    final http.Response result = await http
        .put(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
      body: jsonEncode(body),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> deleteAPI({
    required String url,
    required dynamic body,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    _removeBodyNullValues(body);
    final http.Response result = await http
        .delete(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
      body: jsonEncode(body),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> postMultipartAPI({
    required String url,
    required Map<String, dynamic> fields,
    required List<http.MultipartFile> files,
  }) async {
    final Uri uri = Uri.parse(url);
    final String token = AccountHelper.instance.getToken();
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    if (fields.isNotEmpty) {
      for (String key in fields.keys) {
        request.fields[key] = fields[key];
      }
    }
    if (files.isNotEmpty) {
      for (http.MultipartFile multipartFile in files) {
        request.files.add(multipartFile);
      }
    }
    final http.Response result =
        await http.Response.fromStream(await request.send());
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Map<String, String>? _getHeader(
      {AuthenticationType? type, Map<String, String>? header}) {
    Map<String, String>? result = {};
    type ??= AuthenticationType.NONE;
    final String token = AccountHelper.instance.getToken();

    switch (type) {
      case AuthenticationType.SYSTEM:
        result['Authorization'] = 'Bearer $token';
        result['Content-Type'] = 'application/json';
        result['Accept'] = '*/*';
        break;
      case AuthenticationType.NONE:
        result['Content-Type'] = 'application/json';
        result['Accept'] = '*/*';
        break;
      case AuthenticationType.CUSTOM:
        result = header;
        break;
      default:
        break;
    }
    return result;
  }

  static void _removeBodyNullValues(body) {
    if (body is Map<String, dynamic>) {
      body.removeWhere(_isMapValueNull);
    } else if (body is List<Map<String, dynamic>>) {
      for (var element in body) {
        element.removeWhere(_isMapValueNull);
      }
    }
  }

  static bool _isMapValueNull(String _, dynamic value) =>
      value == null && value is! String;

  static void logAPI(
      {required String url, required int statusCode, required String body}) {
    String message = 'URL: $url - STATUS CODE: $statusCode\nRESPONSE: $body';
    if (statusCode >= 200 && statusCode <= 299) {
      LOG.info(message);
    } else {
      LOG.error(message);
    }
  }
}
