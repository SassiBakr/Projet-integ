# SAV Pro - Application Mobile de Service Après-Vente

Application Flutter complète pour la gestion du Service Après-Vente avec suivi en temps réel, communication client-technicien et tableau de bord administrateur.

## 📱 Aperçu du Projet

SAV Pro est une solution mobile moderne développée avec Flutter pour digitaliser le processus complet du service après-vente. L'application offre trois espaces distincts :

- **Espace Client** : Prise de rendez-vous, suivi des réparations, chatbot IA
- **Espace Technicien** : Gestion du planning, mise à jour des réparations
- **Espace Administrateur** : Dashboard, statistiques, gestion des techniciens et offres

## ✨ Fonctionnalités Principales

### 👤 Espace Client

#### F1. Gestion de Compte
- ✅ Inscription avec email/téléphone
- ✅ Connexion sécurisée
- ✅ Authentification biométrique (à venir)
- ✅ Gestion du profil utilisateur

#### F2. Gestion des Rendez-vous (CRUD)
- ✅ **Création** : Prise de rendez-vous avec sélection magasin/technicien/date
- ✅ **Lecture** : Liste des rendez-vous (à venir / passés)
- ⏳ **Modification** : Changement de date/heure
- ⏳ **Annulation** : Annulation avec motif

#### F3. Suivi des Réparations
- ✅ Suivi en temps réel avec timeline visuelle
- ✅ 6 statuts : En attente → Assigné → Diagnostic → Réparation → Réparé → Prêt
- ⏳ Notifications automatiques
- ⏳ Évaluation du service

#### F4. Communication
- ⏳ Chatbot IA 24/7 pour assistance
- ⏳ Messagerie directe avec le technicien
- ⏳ Envoi de photos et fichiers

#### F5. Offres et Promotions
- ⏳ Consultation des offres actives
- ⏳ Notifications pour nouvelles offres

### 🔧 Espace Technicien

- ⏳ Vue calendrier du planning
- ⏳ Liste des réparations assignées
- ⏳ Mise à jour de l'état de réparation
- ⏳ Notes techniques (diagnostic, réparation, tests)
- ⏳ Messagerie avec les clients

### 👨‍💼 Espace Administrateur

- ⏳ Dashboard avec KPIs (nb réparations, rendez-vous, satisfaction)
- ⏳ Gestion CRUD des techniciens
- ⏳ Statistiques et graphiques (fl_chart)
- ⏳ Gestion des offres et promotions
- ⏳ Export de rapports (PDF)

## 🏗️ Architecture du Projet

```
lib/
├── main.dart                      # Point d'entrée de l'application
├── core/
│   ├── theme/
│   │   └── app_theme.dart        # Thème clair et sombre
│   ├── routes/
│   │   └── app_routes.dart       # Configuration des routes
│   ├── localization/
│   │   └── app_translations.dart # Traductions (FR, EN, AR)
│   ├── models/
│   │   ├── user_model.dart       # Modèle utilisateur
│   │   ├── appointment_model.dart # Modèle rendez-vous
│   │   ├── repair_model.dart     # Modèle réparation
│   │   ├── technician_model.dart # Modèle technicien
│   │   ├── offer_model.dart      # Modèle offre
│   │   └── message_model.dart    # Modèle message
│   └── services/
│       ├── auth_service.dart     # Service d'authentification
│       └── notification_service.dart # Service de notifications
│
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   │
│   ├── client/
│   │   ├── screens/
│   │   │   ├── client_home_screen.dart
│   │   │   ├── appointments/
│   │   │   │   ├── appointment_list_screen.dart
│   │   │   │   └── appointment_create_screen.dart
│   │   │   ├── repairs/
│   │   │   │   ├── repair_list_screen.dart
│   │   │   │   └── repair_detail_screen.dart
│   │   │   ├── chat/
│   │   │   │   ├── chatbot_screen.dart
│   │   │   │   └── technician_chat_screen.dart
│   │   │   ├── offers/
│   │   │   │   └── offers_screen.dart
│   │   │   └── profile/
│   │   │       └── profile_screen.dart
│   │   └── providers/
│   │       ├── appointment_provider.dart
│   │       └── repair_provider.dart
│   │
│   ├── technician/
│   │   ├── screens/
│   │   │   ├── technician_home_screen.dart
│   │   │   ├── schedule/
│   │   │   │   └── schedule_screen.dart
│   │   │   └── repairs/
│   │   │       ├── tech_repair_list_screen.dart
│   │   │       └── tech_repair_detail_screen.dart
│   │   └── providers/
│   │       └── technician_provider.dart
│   │
│   └── admin/
│       ├── screens/
│       │   ├── admin_home_screen.dart
│       │   ├── dashboard/
│       │   │   └── dashboard_screen.dart
│       │   ├── technicians/
│       │   │   └── technician_management_screen.dart
│       │   ├── statistics/
│       │   │   └── statistics_screen.dart
│       │   └── offers/
│       │       └── offer_management_screen.dart
│       └── providers/
│           └── admin_provider.dart
```

## 🚀 Installation

### Prérequis

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code avec extensions Flutter
- Compte Firebase pour l'authentification et la base de données

### Étapes d'installation

1. **Cloner le projet**
```bash
git clone <repository-url>
cd GL
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration Firebase**
   - Créer un projet Firebase sur https://console.firebase.google.com
   - Télécharger `google-services.json` (Android) et `GoogleService-Info.plist` (iOS)
   - Placer les fichiers dans les dossiers appropriés
   - Activer Authentication (Email/Password) et Firestore

4. **Lancer l'application**
```bash
# En mode debug
flutter run

# En mode release
flutter run --release
```

## 📦 Dépendances Principales

### UI & Design
- `google_fonts` : Typographie Poppins
- `flutter_svg` : Icônes vectorielles
- `animations` : Animations fluides
- `lottie` : Animations Lottie

### State Management
- `provider` : Gestion d'état
- `get` : Navigation et routing

### Backend & Data
- `firebase_core` : Firebase SDK
- `firebase_auth` : Authentification
- `cloud_firestore` : Base de données NoSQL
- `firebase_messaging` : Push notifications
- `hive` : Base de données locale

### Fonctionnalités
- `google_maps_flutter` : Cartes et géolocalisation
- `geolocator` : Services de localisation
- `image_picker` : Sélection d'images
- `table_calendar` : Calendrier
- `fl_chart` : Graphiques et statistiques
- `pdf` : Génération de PDF
- `flutter_rating_bar` : Notation

### Communication
- `flutter_chat_ui` : Interface de chat
- `dialogflow_flutter` : Chatbot IA

## 🎨 Design System

### Palette de couleurs

- **Primary** : `#2563EB` (Bleu)
- **Secondary** : `#7C3AED` (Violet)
- **Success** : `#10B981` (Vert)
- **Error** : `#EF4444` (Rouge)
- **Warning** : `#F59E0B` (Orange)

### Statuts de réparation

- 🔴 **En attente** : `#EF4444`
- 🟡 **Assigné** : `#F59E0B`
- 🔵 **Diagnostic** : `#3B82F6`
- 🟣 **Réparation** : `#8B5CF6`
- 🟢 **Réparé** : `#10B981`
- ✅ **Prêt** : `#059669`

### Typographie

- **Police** : Poppins (Google Fonts)
- **Tailles** :
  - Display Large: 32px
  - Display Medium: 28px
  - Title Large: 18px
  - Body Large: 16px

## 🌍 Internationalisation

L'application supporte 3 langues :
- 🇫🇷 Français (par défaut)
- 🇬🇧 Anglais
- 🇸🇦 Arabe

Configuration dans `lib/core/localization/app_translations.dart`

## 🔐 Sécurité

- Authentification Firebase
- Validation des formulaires
- Authentification biométrique (à venir)
- Règles de sécurité Firestore
- Storage des tokens sécurisé

## 📊 Base de Données (Firestore)

### Collections principales

#### `users`
```json
{
  "id": "string",
  "fullName": "string",
  "email": "string",
  "phone": "string",
  "role": "client|technician|admin",
  "photoUrl": "string?",
  "createdAt": "timestamp"
}
```

#### `appointments`
```json
{
  "id": "string",
  "clientId": "string",
  "technicianId": "string",
  "storeId": "string",
  "dateTime": "timestamp",
  "reason": "string",
  "status": "pending|confirmed|completed|cancelled",
  "photoUrls": ["string"]
}
```

#### `repairs`
```json
{
  "id": "string",
  "clientId": "string",
  "technicianId": "string",
  "productType": "string",
  "brand": "string",
  "model": "string",
  "status": "waiting|assigned|diagnostic|repairing|repaired|ready",
  "estimatedTime": "string",
  "estimatedCost": "number",
  "rating": "number?"
}
```

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test

# Coverage
flutter test --coverage
```

## 📱 Build Production

### Android (APK)
```bash
flutter build apk --release
```

### Android (Bundle)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT.

## 👥 Auteurs

- Développé selon le cahier des charges SAV Pro

## 📞 Support

Pour toute question ou assistance :
- Email : support@savpro.com
- Documentation : https://docs.savpro.com

---

**Status du Projet** : 🚧 En développement

**Version** : 1.0.0

**Dernière mise à jour** : Novembre 2025
