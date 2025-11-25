import '../services/api_service.dart';
import '../models/offer_model.dart';

class OfferService {
  static final ApiService _api = ApiService();

  // Obtenir toutes les offres actives
  static Future<List<OfferModel>> getActiveOffers() async {
    try {
      final response = await _api.get('/offers?active=true');
      
      if (response['success'] == true && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => OfferModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ Erreur récupération offres: $e');
      return [];
    }
  }

  // Obtenir une offre par ID
  static Future<OfferModel?> getOfferById(String id) async {
    try {
      final response = await _api.get('/offers/$id');
      if (response['success'] == true) {
        return OfferModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Erreur récupération offre: $e');
      return null;
    }
  }

  // Créer une offre (Admin)
  static Future<OfferModel?> createOffer(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/offers', data);
      if (response['success'] == true) {
        return OfferModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('❌ Erreur création offre: $e');
      rethrow;
    }
  }

  // Utiliser une offre
  static Future<bool> redeemOffer(String id) async {
    try {
      final response = await _api.put('/offers/$id/redeem', {});
      return response['success'] == true;
    } catch (e) {
      print('❌ Erreur utilisation offre: $e');
      return false;
    }
  }
}
