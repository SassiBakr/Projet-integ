import 'package:flutter/material.dart';

class TechnicianProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Add technician-specific methods
}
