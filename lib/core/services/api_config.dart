class ApiConfig {
  // URL de base de l'API
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String appointments = '/appointments';
  static const String repairs = '/repairs';
  static const String offers = '/offers';
  static const String notifications = '/notifications';
  static const String stats = '/stats';
  
  // Timeout
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers par défaut
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers avec authentification
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
