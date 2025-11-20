import 'package:flutter/material.dart';
import '../../../core/models/appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<AppointmentModel> get upcomingAppointments {
    return _appointments.where((a) => 
      a.status != AppointmentStatus.cancelled && 
      a.status != AppointmentStatus.completed &&
      a.dateTime.isAfter(DateTime.now())
    ).toList();
  }

  List<AppointmentModel> get pastAppointments {
    return _appointments.where((a) => 
      a.status == AppointmentStatus.completed ||
      a.dateTime.isBefore(DateTime.now())
    ).toList();
  }

  Future<void> fetchAppointments(String clientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch from Firebase
      await Future.delayed(const Duration(seconds: 1));
      _appointments = _getMockAppointments();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Save to Firebase
      await Future.delayed(const Duration(seconds: 1));
      _appointments.add(appointment);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Update in Firebase
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        // Update status to cancelled
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<AppointmentModel> _getMockAppointments() {
    return [
      AppointmentModel(
        id: '1',
        clientId: 'client1',
        clientName: 'Jean Dupont',
        technicianId: 'tech1',
        technicianName: 'Marc Martin',
        storeId: 'store1',
        storeName: 'SAV Paris Centre',
        storeAddress: '123 Rue de Rivoli, 75001 Paris',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        reason: 'Écran cassé sur iPhone 12',
        status: AppointmentStatus.confirmed,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
