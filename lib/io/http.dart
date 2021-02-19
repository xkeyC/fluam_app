import 'dart:convert';

import 'package:http/http.dart' as http;

/// Custom Http client
class AppHttp {
  http.Client _client = http.Client();

  static const Map<String, String> _defaultHeaders = {
    "User-Agent":
        "Fluam/0.1.x A cross-platform flarum client. (github.com/fluam/fluam_app)"
  };

  Future<http.Response> get(String url, {Map<String, String> headers}) {
    return _client.get(Uri.parse(url), headers: _makeHead(headers));
  }

  Future<http.Response> post(String url,
      {Map<String, String> headers, Object body, Encoding encoding}) {
    return _client.post(Uri.parse(url),
        headers: _makeHead(headers), body: body, encoding: encoding);
  }

  Future<http.Response> head(String url, {Map<String, String> headers}) {
    return _client.head(Uri.parse(url), headers: _makeHead(headers));
  }

  Future<http.Response> delete(String url,
      {Map<String, String> headers, Object body, Encoding encoding}) {
    return _client.delete(Uri.parse(url),
        headers: _makeHead(headers), body: body, encoding: encoding);
  }

  Future<http.Response> put(String url,
      {Map<String, String> headers, Object body, Encoding encoding}) {
    return _client.put(Uri.parse(url),
        headers: _makeHead(headers), body: body, encoding: encoding);
  }

  Future<http.Response> patch(String url,
      {Map<String, String> headers, Object body, Encoding encoding}) {
    return _client.patch(Uri.parse(url),
        headers: _makeHead(headers), body: body, encoding: encoding);
  }

  static Map<String, String> _makeHead(Map<String, String> headers) {
    if (headers == null) {
      return _defaultHeaders;
    }
    return Map.from(_defaultHeaders)..addAll(headers);
  }
}
