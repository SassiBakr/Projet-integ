# Guide de Démarrage - SAV Pro

## 🎯 Objectif

Ce guide vous aidera à configurer et lancer l'application SAV Pro sur votre environnement de développement.

## ⚙️ Configuration Initiale

### 1. Installation de Flutter

Si Flutter n'est pas encore installé :

```bash
# Windows (avec Chocolatey)
choco install flutter

# Ou téléchargez depuis https://flutter.dev
```

Vérifiez l'installation :
```bash
flutter doctor
```

### 2. Installation des Dépendances

Dans le dossier du projet :

```bash
cd GL
flutter pub get
```

### 3. Configuration Firebase

#### Étape A : Créer un projet Firebase

1. Allez sur https://console.firebase.google.com
2. Cliquez sur "Ajouter un projet"
3. Nommez votre projet "SAV Pro"
4. Suivez les étapes de configuration

#### Étape B : Configurer Authentication

1. Dans Firebase Console, allez dans **Authentication**
2. Cliquez sur **Commencer**
3. Activez **E-mail/Mot de passe**
4. Sauvegardez

#### Étape C : Configurer Firestore

1. Dans Firebase Console, allez dans **Firestore Database**
2. Cliquez sur **Créer une base de données**
3. Choisissez le mode **Test** (pour le développement)
4. Sélectionnez une région proche de vous

#### Étape D : Télécharger les fichiers de configuration

**Pour Android :**
1. Dans Firebase Console → Paramètres du projet
2. Ajoutez une application Android
3. Nom du package : `com.example.sav_app`
4. Téléchargez `google-services.json`
5. Placez-le dans `android/app/`

**Pour iOS :**
1. Dans Firebase Console → Paramètres du projet
2. Ajoutez une application iOS
3. Bundle ID : `com.example.savApp`
4. Téléchargez `GoogleService-Info.plist`
5. Placez-le dans `ios/Runner/`

### 4. Configuration des Règles Firestore

Dans Firebase Console → Firestore Database → Règles :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Appointments collection
    match /appointments/{appointmentId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.clientId == request.auth.uid || 
         resource.data.technicianId == request.auth.uid);
    }
    
    // Repairs collection
    match /repairs/{repairId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        (resource.data.clientId == request.auth.uid || 
         resource.data.technicianId == request.auth.uid);
    }
    
    // Offers collection (public read)
    match /offers/{offerId} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Messages collection
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🚀 Lancer l'Application

### Mode Debug

```bash
# Démarrer un émulateur ou connecter un appareil
flutter devices

# Lancer l'application
flutter run
```

### Mode Release

```bash
flutter run --release
```

## 📱 Créer les Premiers Comptes

### 1. Compte Client

```dart
Email: client@test.com
Mot de passe: test123
Rôle: client
```

### 2. Compte Technicien

```dart
Email: technicien@test.com
Mot de passe: test123
Rôle: technician
```

### 3. Compte Admin

```dart
Email: admin@test.com
Mot de passe: test123
Rôle: admin
```

## 🗃️ Données de Test

### Ajouter des données de test dans Firestore

#### Collection : `stores`

```json
{
  "id": "store1",
  "name": "SAV Paris Centre",
  "address": "123 Rue de Rivoli, 75001 Paris",
  "phone": "+33 1 23 45 67 89",
  "latitude": 48.8606,
  "longitude": 2.3376
}
```

#### Collection : `technicians`

```json
{
  "id": "tech1",
  "fullName": "Marc Martin",
  "email": "marc.martin@sav.com",
  "phone": "+33 6 12 34 56 78",
  "storeId": "store1",
  "storeName": "SAV Paris Centre",
  "specialties": ["Smartphones", "Tablettes"],
  "averageRating": 4.8,
  "totalRepairs": 120
}
```

## 🐛 Résolution des Problèmes Courants

### Problème 1 : Erreur "google-services.json not found"

**Solution :**
- Vérifiez que le fichier est dans `android/app/`
- Nettoyez le build : `flutter clean`
- Relancez : `flutter pub get`

### Problème 2 : Erreur Firebase Auth

**Solution :**
- Vérifiez que Authentication est activé dans Firebase Console
- Vérifiez les règles Firestore
- Redémarrez l'application

### Problème 3 : Packages manquants

**Solution :**
```bash
flutter pub get
flutter pub upgrade
flutter clean
flutter pub get
```

### Problème 4 : Erreurs de build Android

**Solution :**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

## 📋 Checklist de Vérification

- [ ] Flutter SDK installé et à jour
- [ ] Émulateur ou appareil connecté
- [ ] Projet Firebase créé
- [ ] Authentication activée
- [ ] Firestore configuré
- [ ] Fichiers de config téléchargés et placés
- [ ] `flutter pub get` exécuté avec succès
- [ ] Application démarre sans erreur
- [ ] Connexion fonctionne
- [ ] Navigation entre écrans fonctionne

## 🎓 Prochaines Étapes

1. **Implémenter les TODO** : Recherchez `// TODO:` dans le code
2. **Connecter Firestore** : Remplacer les données mock par des appels Firestore
3. **Ajouter les notifications** : Configurer Firebase Cloud Messaging
4. **Implémenter le chatbot** : Intégrer Dialogflow
5. **Ajouter les tests** : Créer des tests unitaires et d'intégration

## 📚 Ressources Utiles

- [Documentation Flutter](https://flutter.dev/docs)
- [Documentation Firebase](https://firebase.google.com/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)

## 💡 Conseils de Développement

### Hot Reload
Tapez `r` dans le terminal pour recharger l'application sans perdre l'état.

### Logs
```bash
# Voir les logs
flutter logs

# Logs détaillés
flutter run -v
```

### Analyse du Code
```bash
# Analyser le code
flutter analyze

# Formater le code
flutter format .
```

### Performance
```bash
# Profiler l'application
flutter run --profile

# Analyser la taille de l'APK
flutter build apk --analyze-size
```

## 🆘 Support

En cas de problème :
1. Consultez le README.md
2. Vérifiez la documentation Flutter
3. Recherchez l'erreur sur Stack Overflow
4. Contactez l'équipe de développement

---

**Bon développement ! 🚀**
