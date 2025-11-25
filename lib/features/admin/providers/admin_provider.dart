import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  final bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Add admin-specific methods
}
