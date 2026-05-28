import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import 'package:http/http.dart' as http;

/// Central HTTP client for all backend API calls.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String get baseUrl => kIsWeb ? Constants.webApiBaseUrl : Constants.apiBaseUrl;
  String? _authToken;

  void setAuthToken(String token) => _authToken = token;
  void clearAuthToken() => _authToken = null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // ── GET ─────────────────────────────────────────────
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ── POST ────────────────────────────────────────────
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  // ── PUT ─────────────────────────────────────────────
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  // ── DELETE ──────────────────────────────────────────
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ── MULTIPART (for image uploads) ───────────────────
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String filePath,
    String fieldName, {
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    request.headers.addAll(_headers..remove('Content-Type'));
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    if (fields != null) request.fields.addAll(fields);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  // ── Response Handler ────────────────────────────────
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      clearAuthToken();
      throw ApiException('Session expired. Please log in again.', response.statusCode);
    } else {
      final message = body['error'] ?? body['message'] ?? 'An error occurred';
      throw ApiException(message as String, response.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
