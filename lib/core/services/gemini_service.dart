import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyDsroIjcwbTtkNH-5uNa-4XnBu3WOlDek8';
  
  // Utiliser l'API v1 stable
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1/models';
  
  // Initialiser le service
  static void initialize() {
    if (_apiKey.isEmpty || _apiKey == 'YOUR_GEMINI_API_KEY') {
      print('⚠️ ATTENTION : Clé API Gemini non configurée');
      return;
    }
    print('✅ Gemini API initialisée avec succès !');
  }

  // Contexte système pour le chatbot SAV
  static const String _systemContext = '''
Tu es un assistant virtuel expert en service après-vente (SAV) pour SAV Pro.
Tu es spécialisé dans les domaines suivants :
- Électroménager (réfrigérateurs, lave-linge, lave-vaisselle, fours, micro-ondes, etc.)
- Électronique grand public (TV, ordinateurs, consoles de jeu, etc.)
- Téléphonie (smartphones, tablettes, accessoires)
- Petits appareils électriques (cafetières, aspirateurs, fer à repasser, etc.)

Tes responsabilités :
1. Diagnostiquer les problèmes techniques décrits par les clients
2. Proposer des solutions de dépannage simples
3. Conseiller sur la prise de rendez-vous pour réparation
4. Informer sur les garanties et les coûts estimés
5. Répondre aux questions sur l'utilisation et l'entretien des appareils

Ton style de communication :
- Professionnel mais chaleureux
- Clair et concis
- Patient et compréhensif
- Toujours en français
- Utilise des emojis occasionnellement pour rendre la conversation agréable

Limites :
- Ne donne jamais de diagnostic définitif sans inspection physique
- Recommande toujours un technicien pour les problèmes complexes ou dangereux
- Ne promets jamais de coûts exacts sans évaluation

Ton objectif principal est d'aider le client et de l'orienter vers la meilleure solution.
''';

  // Envoyer un message et obtenir une réponse
  static Future<String> sendMessage(String userMessage, List<String> conversationHistory) async {
    try {
      print('🤖 Envoi de la requête à Gemini API v1...');
      
      // Construire le prompt avec historique
      final fullPrompt = StringBuffer(_systemContext);
      fullPrompt.writeln('\n\nHistorique de la conversation :');
      
      for (int i = 0; i < conversationHistory.length; i++) {
        if (i % 2 == 0) {
          fullPrompt.writeln('Client : ${conversationHistory[i]}');
        } else {
          fullPrompt.writeln('Assistant : ${conversationHistory[i]}');
        }
      }
      
      fullPrompt.writeln('\nQuestion actuelle du client : $userMessage');
      fullPrompt.writeln('\nRéponds de manière professionnelle et utile :');

      // Préparer la requête (API v1 utilise gemini-pro sans "models/" prefix dans l'URL)
      final url = Uri.parse('$_baseUrl/gemini-pro:generateContent?key=$_apiKey');
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': fullPrompt.toString()}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 2048,
        }
      };

      print('📤 URL : $url');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Statut : ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['candidates'] != null && 
            jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0]['content'] != null &&
            jsonResponse['candidates'][0]['content']['parts'] != null &&
            jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
          
          final responseText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          print('✅ Réponse reçue (${responseText.length} caractères)');
          return responseText;
        }
        
        print('⚠️ Réponse vide');
        return _getFallbackResponse(userMessage);
      } else {
        print('❌ Erreur ${response.statusCode}: ${response.body}');
        return _getFallbackResponse(userMessage);
      }
      
    } catch (e) {
      print('❌ Exception: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  // Réponse de secours intelligente
  static String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('telephone') || lowerMessage.contains('smartphone') || lowerMessage.contains('iphone')) {
      return '📱 **Réparation smartphone**\n\nNous réparons écrans, batteries, et problèmes de charge.\n📅 Prenez rendez-vous pour un diagnostic gratuit !';
    }

    if (lowerMessage.contains('lave-linge') || lowerMessage.contains('machine')) {
      return '🌀 **Panne de lave-linge ?**\n\nProblèmes de fuites, bruits, essorage ?\n📅 Intervention rapide à domicile !';
    }

    if (lowerMessage.contains('frigo') || lowerMessage.contains('refrigerateur')) {
      return '❄️ **Panne de réfrigérateur ?**\n\nProblèmes de refroidissement ?\n⚠️ Intervention sous 24h !';
    }

    return '🤖 Je suis votre assistant SAV Pro !\n\nPosez vos questions sur smartphones, électroménager, ou prenez rendez-vous. 💬';
  }

  // Questions rapides
  static List<String> getQuickQuestions() {
    return [
      '📱 Mon iPhone ne charge plus',
      '💧 Mon lave-linge fuit',
      '❄️ Mon frigo ne refroidit plus',
      '📅 Prendre rendez-vous',
      '💰 Quels sont vos tarifs ?',
      '🔧 Où en est ma réparation ?',
    ];
  }
}
