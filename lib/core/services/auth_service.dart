import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _prefs?.clear();
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> saveUserRole(UserRole role) async {
    await _prefs?.setString('user_role', role.toString().split('.').last);
  }

  static UserRole? getUserRole() {
    final roleString = _prefs?.getString('user_role');
    if (roleString == null) return null;
    return UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == roleString,
    );
  }

  static Future<void> saveUserId(String userId) async {
    await _prefs?.setString('user_id', userId);
  }

  static String? getUserId() {
    return _prefs?.getString('user_id');
  }

  static Future<void> saveOnboardingCompleted() async {
    await _prefs?.setBool('onboarding_completed', true);
  }

  static bool isOnboardingCompleted() {
    return _prefs?.getBool('onboarding_completed') ?? false;
  }
}
