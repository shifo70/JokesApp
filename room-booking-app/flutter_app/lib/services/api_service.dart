import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';

class ApiService {
  // Change this to your computer's IP when testing on a physical device/emulator
  // Android emulator: use 10.0.2.2 instead of localhost
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Map<String, String> _headers(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers(null),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers(null),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<List<Room>> getRooms(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: _headers(token),
    );
    final data = _handleResponse(response);
    if (data is List) {
      return data.map((r) => Room.fromJson(r as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> createRoom(
    String token, {
    required String name,
    required double price,
    String status = 'available',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: _headers(token),
      body: jsonEncode({'name': name, 'price': price, 'status': status}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateRoom(
    String token,
    int id, {
    required String name,
    required double price,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: _headers(token),
      body: jsonEncode({'name': name, 'price': price, 'status': status}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> bookRoom(String token, int roomId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: _headers(token),
      body: jsonEncode({'room_id': roomId}),
    );
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body is Map ? (body['message'] ?? 'Request failed') : 'Request failed';
    throw ApiException(message as String, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
