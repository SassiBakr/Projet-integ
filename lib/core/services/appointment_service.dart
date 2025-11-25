import '../services/api_service.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  static final ApiService _api = ApiService();

  // Créer un rendez-vous
  static Future<AppointmentModel?> createAppointment(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/appointments', data);
      if (response['success'] == true) {
        return AppointmentModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Erreur création rendez-vous: $e');
      rethrow;
    }
  }

  // Obtenir tous les rendez-vous
  static Future<List<AppointmentModel>> getAppointments({String? status}) async {
    try {
      final endpoint = status != null ? '/appointments?status=$status' : '/appointments';
      final response = await _api.get(endpoint);
      
      if (response['success'] == true && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ Erreur récupération rendez-vous: $e');
      return [];
    }
  }

  // Obtenir un rendez-vous par ID
  static Future<AppointmentModel?> getAppointmentById(String id) async {
    try {
      final response = await _api.get('/appointments/$id');
      if (response['success'] == true) {
        return AppointmentModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Erreur récupération rendez-vous: $e');
      return null;
    }
  }

  // Mettre à jour un rendez-vous
  static Future<AppointmentModel?> updateAppointment(String id, Map<String, dynamic> data) async {
    try {
      final response = await _api.put('/appointments/$id', data);
      if (response['success'] == true) {
        return AppointmentModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Erreur mise à jour rendez-vous: $e');
      rethrow;
    }
  }

  // Annuler un rendez-vous
  static Future<bool> cancelAppointment(String id, String reason) async {
    try {
      final response = await _api.put('/appointments/$id/cancel', {
        'cancellationReason': reason,
      });
      return response['success'] == true;
    } catch (e) {
      print('❌ Erreur annulation rendez-vous: $e');
      return false;
    }
  }
}
