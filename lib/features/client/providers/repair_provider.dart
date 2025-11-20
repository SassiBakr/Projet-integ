import 'package:flutter/material.dart';
import '../../../core/models/repair_model.dart';

class RepairProvider extends ChangeNotifier {
  List<RepairModel> _repairs = [];
  bool _isLoading = false;
  String? _error;

  List<RepairModel> get repairs => _repairs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<RepairModel> get activeRepairs {
    return _repairs.where((r) => 
      r.status != RepairStatus.completed
    ).toList();
  }

  List<RepairModel> get completedRepairs {
    return _repairs.where((r) => 
      r.status == RepairStatus.completed
    ).toList();
  }

  Future<void> fetchRepairs(String clientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch from Firebase
      await Future.delayed(const Duration(seconds: 1));
      _repairs = _getMockRepairs();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> rateRepair(String repairId, double rating, String feedback) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Update in Firebase
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _repairs.indexWhere((r) => r.id == repairId);
      if (index != -1) {
        // Update rating and feedback
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<RepairModel> _getMockRepairs() {
    return [
      RepairModel(
        id: '1',
        clientId: 'client1',
        clientName: 'Jean Dupont',
        technicianId: 'tech1',
        technicianName: 'Marc Martin',
        productType: 'Smartphone',
        brand: 'Apple',
        model: 'iPhone 12',
        problemDescription: 'Écran cassé suite à une chute',
        status: RepairStatus.repairing,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        assignedAt: DateTime.now().subtract(const Duration(days: 1)),
        diagnosticAt: DateTime.now().subtract(const Duration(hours: 12)),
        repairingAt: DateTime.now().subtract(const Duration(hours: 2)),
        estimatedTime: '2-3 jours',
        estimatedCost: 150.0,
      ),
      RepairModel(
        id: '2',
        clientId: 'client1',
        clientName: 'Jean Dupont',
        productType: 'Ordinateur portable',
        brand: 'HP',
        model: 'Pavilion 15',
        problemDescription: 'Ne s\'allume plus',
        status: RepairStatus.waiting,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }
}
