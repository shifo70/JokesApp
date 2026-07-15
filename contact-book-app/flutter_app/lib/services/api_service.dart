import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  /// Web/desktop → localhost | Android emulator → 10.0.2.2
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://localhost:3000';
    }
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static String normalizePhone(String phone) =>
      phone.trim().replaceAll(RegExp(r'\s+'), '');

  static Future<List<Contact>> getContacts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/contacts'),
      headers: _headers,
    );
    return _parseList(response);
  }

  static Future<List<Contact>> searchByCategory(String category) async {
    final uri = Uri.parse('$baseUrl/contacts/search').replace(
      queryParameters: {'category': category},
    );
    final response = await http.get(uri, headers: _headers);
    return _parseList(response);
  }

  static Future<Map<String, dynamic>> createContact({
    required String fullName,
    required String phoneNumber,
    required String category,
    required bool isFavorite,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contacts'),
      headers: _headers,
      body: jsonEncode({
        'full_name': fullName.trim(),
        'phone_number': normalizePhone(phoneNumber),
        'category': category,
        'is_favorite': isFavorite,
      }),
    );
    return _handleMap(response);
  }

  static Future<Map<String, dynamic>> updateContact({
    required int id,
    required String fullName,
    required String phoneNumber,
    required String category,
    required bool isFavorite,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/contacts/$id'),
      headers: _headers,
      body: jsonEncode({
        'full_name': fullName.trim(),
        'phone_number': normalizePhone(phoneNumber),
        'category': category,
        'is_favorite': isFavorite,
      }),
    );
    return _handleMap(response);
  }

  static Future<Map<String, dynamic>> deleteContact(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/contacts/$id'),
      headers: _headers,
    );
    return _handleMap(response);
  }

  static List<Contact> _parseList(http.Response response) {
    final data = _decode(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data is! List) {
        throw ApiException('Unexpected server response (expected a list).', response.statusCode);
      }
      return data
          .map((e) => Contact.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    throw ApiException(_message(data), response.statusCode);
  }

  static Map<String, dynamic> _handleMap(http.Response response) {
    final data = _decode(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return {'message': 'OK'};
    }
    throw ApiException(_message(data), response.statusCode);
  }

  static dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return {};
    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw ApiException(
        'Server returned invalid JSON (status ${response.statusCode}). Is the Contact Book backend running on port 3000?',
        response.statusCode,
      );
    }
  }

  static String _message(dynamic data) {
    if (data is Map && data['message'] != null) {
      final detail = data['detail'];
      if (detail != null && detail.toString().isNotEmpty) {
        return '${data['message']} ($detail)';
      }
      return data['message'].toString();
    }
    return 'Request failed';
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
