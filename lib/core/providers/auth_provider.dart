import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null && _token != null;

  // Initialiser le provider
  Future<void> init() async {
    await _apiService.init();
    // Vérifier si un token existe dans SharedPreferences
    // Si oui, on récupère l'utilisateur, sinon on affiche juste l'écran de connexion
    // Note: _apiService.init() charge déjà le token depuis SharedPreferences
    // On peut tenter de récupérer l'utilisateur, si ça échoue c'est qu'il n'y a pas de token valide
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        await getCurrentUser();
      }
    } catch (e) {
      // Pas de token ou token invalide - c'est normal au premier démarrage
      // Pas besoin d'afficher d'erreur
    }
  }

  // Inscription
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    String role = 'client',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/register', {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
      });

      if (response['success'] == true) {
        // Backend returns token and user directly, not nested in 'data'
        _token = response['token'];
        _currentUser = UserModel.fromJson(response['user']);
        await _apiService.setToken(_token!);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = response['message'] ?? 'Erreur lors de l\'inscription';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      print('🔍 Response type: ${response.runtimeType}');
      print('🔍 Response keys: ${response.keys}');
      print('🔍 Response success: ${response['success']}');
      print('🔍 Response token: ${response['token']}');
      print('🔍 Response user: ${response['user']}');

      if (response['success'] == true) {
        // Backend returns token and user directly, not nested in 'data'
        _token = response['token'];
        _currentUser = UserModel.fromJson(response['user']);
        await _apiService.setToken(_token!);
        
        print('✅ Connexion réussie: ${_currentUser?.email} (${_currentUser?.role})');
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = response['message'] ?? 'Erreur lors de la connexion';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      print('❌ Erreur de connexion: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Obtenir l'utilisateur connecté
  Future<void> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');
      
      if (response['success'] == true) {
        // Backend returns user directly, not nested in 'data'
        _currentUser = UserModel.fromJson(response['user']);
        notifyListeners();
      }
    } catch (e) {
      print('❌ Erreur récupération utilisateur: $e');
      await logout();
    }
  }

  // Déconnexion
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    await _apiService.clearToken();
    notifyListeners();
  }

  // Vérifier le rôle
  bool hasRole(String role) {
    return _currentUser?.role == role;
  }

  bool get isAdmin => hasRole('admin');
  bool get isTechnician => hasRole('technician');
  bool get isClient => hasRole('client');
}
