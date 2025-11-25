import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  // Initialiser avec le token stocké
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Sauvegarder le token
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Supprimer le token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = _token != null 
          ? ApiConfig.getAuthHeaders(_token!)
          : ApiConfig.defaultHeaders;

      print('🌐 GET: $url');
      
      final response = await http.get(url, headers: headers)
          .timeout(ApiConfig.timeout);

      print('📥 Status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ GET Error: $e');
      throw _handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = _token != null 
          ? ApiConfig.getAuthHeaders(_token!)
          : ApiConfig.defaultHeaders;

      print('🌐 POST: $url');
      print('📤 Data: ${jsonEncode(data)}');
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(ApiConfig.timeout);

      print('📥 Status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ POST Error: $e');
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = _token != null 
          ? ApiConfig.getAuthHeaders(_token!)
          : ApiConfig.defaultHeaders;

      print('🌐 PUT: $url');
      
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(ApiConfig.timeout);

      print('📥 Status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ PUT Error: $e');
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = _token != null 
          ? ApiConfig.getAuthHeaders(_token!)
          : ApiConfig.defaultHeaders;

      print('🌐 DELETE: $url');
      
      final response = await http.delete(url, headers: headers)
          .timeout(ApiConfig.timeout);

      print('📥 Status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw _handleError(e);
    }
  }

  // Gérer la réponse
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('📦 Response body: ${response.body}');
    print('📦 Response body type: ${response.body.runtimeType}');
    print('📦 Response body length: ${response.body.length}');
    
    if (response.body.isEmpty) {
      print('⚠️ Response body is empty!');
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Réponse vide du serveur',
      );
    }
    
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      print('📋 Parsed body: $body');
      print('📋 Body keys: ${body.keys}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: body['message'] ?? 'Erreur inconnue',
          errors: body['errors'],
        );
      }
    } catch (e) {
      print('❌ JSON decode error: $e');
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Erreur de décodage JSON: $e',
      );
    }
  }

  // Gérer les erreurs
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return ApiException(
      statusCode: 0,
      message: 'Erreur de connexion au serveur',
    );
  }
}

// Exception personnalisée pour les erreurs API
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errors;

  ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
  });

  @override
  String toString() => message;
}
