# 🤖 Configuration du Chatbot IA avec Gemini

## 📝 Obtenir une Clé API Gemini (GRATUIT)

### Étape 1 : Créer un compte Google AI
1. Allez sur : https://makersuite.google.com/app/apikey
2. Connectez-vous avec votre compte Google
3. Cliquez sur **"Get API Key"** ou **"Create API Key"**
4. Sélectionnez **"Create API key in new project"**
5. Copiez votre clé API (format : `AIza...`)

### Étape 2 : Configurer la clé dans l'application
1. Ouvrez le fichier : `lib/core/services/gemini_service.dart`
2. Trouvez la ligne 4 :
   ```dart
   static const String _apiKey = 'YOUR_GEMINI_API_KEY';
   ```
3. Remplacez `YOUR_GEMINI_API_KEY` par votre vraie clé :
   ```dart
   static const String _apiKey = 'AIzaSyD...votre_clé...';
   ```
4. Sauvegardez le fichier

### Étape 3 : Relancer l'application
```bash
flutter run -d chrome
```

---

## ✨ Fonctionnalités du Chatbot

### 🎯 Spécialisations
Le chatbot est expert dans :
- **Électroménager** : Réfrigérateurs, lave-linge, lave-vaisselle, fours, etc.
- **Électronique** : TV, ordinateurs, consoles, équipements audio/vidéo
- **Téléphonie** : Smartphones, tablettes, accessoires
- **Petit électroménager** : Cafetières, aspirateurs, fers à repasser, etc.

### 💬 Capacités
- Diagnostic de pannes
- Conseils de dépannage
- Recommandations de prise de rendez-vous
- Informations sur les garanties
- Estimation des coûts
- Conseils d'entretien

### 🚀 Questions rapides prédéfinies
- 📅 Comment prendre rendez-vous ?
- 🔧 Où en est ma réparation ?
- 💰 Quel est le coût d'une réparation ?
- 📱 Vous réparez les smartphones ?
- ❄️ Mon frigo ne refroidit plus
- 🌀 Ma machine à laver fait du bruit
- ✅ Quelle est la garantie ?
- 📍 Où se trouvent vos magasins ?

---

## 🔧 Mode Secours (Sans Clé API)

Si vous n'avez pas encore configuré la clé API, le chatbot fonctionne en **mode secours** avec :
- Réponses préprogrammées basées sur des mots-clés
- Détection intelligente du contexte
- Suggestions automatiques
- Redirection vers les fonctionnalités de l'app

---

## 📊 Limites Gratuites Gemini

- **Gratuit** : 60 requêtes par minute
- **Modèle** : gemini-pro (le plus performant gratuit)
- **Contexte** : Jusqu'à 30,720 tokens
- **Langues** : Français natif supporté

---

## 🎨 Personnalisation

### Modifier le contexte système
Éditez `_systemContext` dans `gemini_service.dart` :
```dart
static const String _systemContext = '''
Tu es un assistant...
[Personnalisez ici]
''';
```

### Ajouter des questions rapides
Modifiez `getQuickQuestions()` dans `gemini_service.dart` :
```dart
static List<String> getQuickQuestions() {
  return [
    'Votre nouvelle question',
    // ...
  ];
}
```

### Modifier les réponses de secours
Éditez `_getFallbackResponse()` dans `gemini_service.dart`

---

## 🔒 Sécurité

### ⚠️ IMPORTANT : Ne commitez JAMAIS votre clé API

**Méthode recommandée pour la production :**

1. Créez un fichier `.env` :
```
GEMINI_API_KEY=AIzaSyD...votre_clé...
```

2. Ajoutez `.env` dans `.gitignore`

3. Utilisez `flutter_dotenv` pour charger la clé :
```dart
await dotenv.load();
final apiKey = dotenv.env['GEMINI_API_KEY'];
```

---

## 🧪 Tester le Chatbot

### Exemples de tests

**1. Test diagnostic** :
```
"Mon lave-linge fait un bruit étrange pendant l'essorage"
```
Réponse attendue : Diagnostic + conseils de vérification + recommandation technicien

**2. Test prise de rendez-vous** :
```
"Comment prendre rendez-vous ?"
```
Réponse attendue : Instructions claires avec navigation

**3. Test garantie** :
```
"Est-ce que c'est couvert par la garantie ?"
```
Réponse attendue : Explications sur les conditions + documents nécessaires

**4. Test technique** :
```
"Mon iPhone ne charge plus"
```
Réponse attendue : Vérifications basiques + orientation vers le service

---

## 📚 Ressources

- **Documentation Gemini** : https://ai.google.dev/docs
- **Console Google AI** : https://makersuite.google.com/
- **Exemples d'utilisation** : https://ai.google.dev/tutorials
- **Limites et quotas** : https://ai.google.dev/pricing

---

## 💡 Conseils d'utilisation

### Pour les utilisateurs
- Soyez précis dans vos descriptions
- Mentionnez la marque et le modèle si possible
- Décrivez les symptômes clairement
- Indiquez ce qui a été tenté

### Pour les développeurs
- Testez avec différents types de pannes
- Ajustez le contexte système selon les retours
- Surveillez les logs pour améliorer les réponses
- Utilisez l'historique pour le contexte

---

## 🔄 Prochaines améliorations possibles

- [ ] Upload d'images de l'appareil défectueux
- [ ] Historique des conversations sauvegardé
- [ ] Boutons d'action rapide (Prendre RDV directement)
- [ ] Notation des réponses pour amélioration
- [ ] Intégration avec la base de données des pannes connues
- [ ] Mode vocal (speech-to-text)
- [ ] Réponses multilingues
- [ ] Suggestions de tutoriels vidéo

---

**Le chatbot est maintenant prêt ! Configurez votre clé API et testez-le ! 🚀**
