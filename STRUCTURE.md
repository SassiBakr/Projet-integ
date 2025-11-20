# Structure du Projet SAV Pro

```
GL/
│
├── android/                        # Configuration Android
│   └── app/
│       ├── google-services.json   # ⚠️ À ajouter (Firebase)
│       └── build.gradle
│
├── ios/                           # Configuration iOS
│   └── Runner/
│       └── GoogleService-Info.plist  # ⚠️ À ajouter (Firebase)
│
├── lib/                           # Code source principal
│   │
│   ├── main.dart                  # Point d'entrée de l'application
│   │
│   ├── core/                      # Fonctionnalités transversales
│   │   │
│   │   ├── theme/
│   │   │   └── app_theme.dart    # ✅ Thème Material Design 3
│   │   │
│   │   ├── routes/
│   │   │   └── app_routes.dart   # ✅ Configuration GetX
│   │   │
│   │   ├── localization/
│   │   │   └── app_translations.dart  # ✅ FR, EN, AR
│   │   │
│   │   ├── models/                # ✅ Modèles de données
│   │   │   ├── user_model.dart
│   │   │   ├── appointment_model.dart
│   │   │   ├── repair_model.dart
│   │   │   ├── technician_model.dart
│   │   │   ├── offer_model.dart
│   │   │   └── message_model.dart
│   │   │
│   │   └── services/              # ✅ Services globaux
│   │       ├── auth_service.dart
│   │       └── notification_service.dart
│   │
│   └── features/                  # Fonctionnalités par module
│       │
│       ├── auth/                  # 🔐 Authentification
│       │   ├── screens/
│       │   │   ├── splash_screen.dart          # ✅ Écran de démarrage
│       │   │   ├── onboarding_screen.dart      # ✅ Tutoriel (4 pages)
│       │   │   ├── login_screen.dart           # ✅ Connexion
│       │   │   └── register_screen.dart        # ✅ Inscription
│       │   └── providers/
│       │       └── auth_provider.dart          # ✅ État d'authentification
│       │
│       ├── client/                # 👤 Espace Client
│       │   ├── screens/
│       │   │   ├── client_home_screen.dart     # ✅ Dashboard avec BottomNav
│       │   │   │
│       │   │   ├── appointments/
│       │   │   │   ├── appointment_list_screen.dart    # ⏳ Liste
│       │   │   │   └── appointment_create_screen.dart  # ✅ Création
│       │   │   │
│       │   │   ├── repairs/
│       │   │   │   ├── repair_list_screen.dart         # ⏳ Liste
│       │   │   │   └── repair_detail_screen.dart       # ✅ Timeline
│       │   │   │
│       │   │   ├── chat/
│       │   │   │   ├── chatbot_screen.dart             # ⏳ IA Assistant
│       │   │   │   └── technician_chat_screen.dart     # ⏳ Chat 1-1
│       │   │   │
│       │   │   ├── offers/
│       │   │   │   └── offers_screen.dart              # ⏳ Promotions
│       │   │   │
│       │   │   └── profile/
│       │   │       └── profile_screen.dart             # ⏳ Profil
│       │   │
│       │   └── providers/
│       │       ├── appointment_provider.dart   # ✅ État rendez-vous
│       │       └── repair_provider.dart        # ✅ État réparations
│       │
│       ├── technician/            # 🔧 Espace Technicien
│       │   ├── screens/
│       │   │   ├── technician_home_screen.dart         # ⏳ Dashboard
│       │   │   │
│       │   │   ├── schedule/
│       │   │   │   └── schedule_screen.dart            # ⏳ Calendrier
│       │   │   │
│       │   │   └── repairs/
│       │   │       ├── tech_repair_list_screen.dart    # ⏳ Liste
│       │   │       └── tech_repair_detail_screen.dart  # ⏳ Détails
│       │   │
│       │   └── providers/
│       │       └── technician_provider.dart    # ✅ État technicien
│       │
│       └── admin/                 # 👨‍💼 Espace Admin
│           ├── screens/
│           │   ├── admin_home_screen.dart              # ⏳ Dashboard
│           │   │
│           │   ├── dashboard/
│           │   │   └── dashboard_screen.dart           # ⏳ KPIs
│           │   │
│           │   ├── technicians/
│           │   │   └── technician_management_screen.dart  # ⏳ CRUD
│           │   │
│           │   ├── statistics/
│           │   │   └── statistics_screen.dart          # ⏳ Graphiques
│           │   │
│           │   └── offers/
│           │       └── offer_management_screen.dart    # ⏳ CRUD Offres
│           │
│           └── providers/
│               └── admin_provider.dart         # ✅ État admin
│
├── assets/                        # Ressources statiques
│   ├── images/                    # ⚠️ À ajouter
│   ├── icons/                     # ⚠️ À ajouter
│   ├── animations/                # ⚠️ À ajouter (Lottie)
│   └── fonts/                     # ⚠️ À ajouter (Poppins)
│
├── test/                          # Tests unitaires
│   └── widget_test.dart           # ⏳ À implémenter
│
├── integration_test/              # Tests d'intégration
│   └── app_test.dart              # ⏳ À implémenter
│
├── pubspec.yaml                   # ✅ Dépendances Flutter
├── README.md                      # ✅ Documentation principale
├── SETUP.md                       # ✅ Guide de démarrage
└── STRUCTURE.md                   # ✅ Ce fichier

```

## 📊 Légende

- ✅ **Implémenté** : Fonctionnalité complète
- ⏳ **À implémenter** : Structure créée, logique à compléter
- ⚠️ **À ajouter** : Fichier ou dossier manquant

## 🎯 Priorités d'Implémentation

### Phase 1 : Backend (Firebase) ⏳
1. Configurer Firestore avec collections
2. Implémenter les services de données
3. Connecter les providers à Firebase
4. Gérer les états de chargement et erreurs

### Phase 2 : Fonctionnalités Client ⏳
1. Compléter la liste des rendez-vous
2. Compléter la liste des réparations
3. Implémenter le chatbot IA
4. Implémenter la messagerie
5. Ajouter les notifications

### Phase 3 : Fonctionnalités Technicien ⏳
1. Calendrier interactif
2. Gestion des réparations assignées
3. Notes techniques
4. Messagerie avec clients

### Phase 4 : Fonctionnalités Admin ⏳
1. Dashboard avec KPIs
2. CRUD techniciens
3. Graphiques et statistiques (fl_chart)
4. Gestion des offres
5. Export PDF

### Phase 5 : Optimisations 🔄
1. Tests unitaires et d'intégration
2. Performance et optimisation
3. Accessibilité
4. Documentation API

## 📝 Notes Techniques

### State Management
- **Provider** : Pour la gestion d'état globale
- **GetX** : Pour la navigation et le routing

### Architecture
- **Feature-first** : Organisation par fonctionnalité
- **Clean Architecture** : Séparation models/services/UI
- **Provider Pattern** : Pour les états réactifs

### Design Patterns
- **Repository Pattern** : Pour l'accès aux données (à implémenter)
- **Service Locator** : Pour l'injection de dépendances (à implémenter)
- **Singleton** : Pour les services (AuthService, NotificationService)

### Bonnes Pratiques
- Utiliser `const` pour les widgets statiques
- Extraire les widgets réutilisables
- Nommer les couleurs et constantes
- Commenter les TODOs
- Valider tous les formulaires

## 🔗 Liens entre Modules

```
auth_service ──┐
               ├──→ all_providers
notification_service ──┘

client_home ──→ appointment_provider ──→ FirestoreService
            └─→ repair_provider ──────→ FirestoreService

technician_home ──→ technician_provider ──→ FirestoreService

admin_home ──→ admin_provider ──→ FirestoreService
```

## 🎨 Composants Réutilisables à Créer

### Widgets Communs
- `CustomButton` : Bouton personnalisé
- `CustomTextField` : Champ de texte stylisé
- `LoadingIndicator` : Indicateur de chargement
- `EmptyState` : État vide avec illustration
- `ErrorState` : Gestion des erreurs
- `CustomCard` : Card avec style uniforme
- `StatusBadge` : Badge de statut coloré
- `AvatarWidget` : Avatar avec fallback

### Dialogs & Modals
- `ConfirmDialog` : Dialogue de confirmation
- `RatingDialog` : Dialogue de notation
- `DatePickerModal` : Sélecteur de date
- `FilterModal` : Modal de filtres

## 📦 Assets à Ajouter

### Images
- `logo.png` : Logo de l'application
- `onboarding_1.png` : Image onboarding 1
- `onboarding_2.png` : Image onboarding 2
- `onboarding_3.png` : Image onboarding 3
- `onboarding_4.png` : Image onboarding 4
- `empty_state.png` : Illustration état vide

### Animations Lottie
- `loading.json` : Animation de chargement
- `success.json` : Animation de succès
- `error.json` : Animation d'erreur
- `robot.json` : Animation chatbot

### Fonts
- Télécharger Poppins depuis Google Fonts
- Placer dans `assets/fonts/`

## 🔍 Fichiers de Configuration

### `pubspec.yaml`
✅ Configuré avec toutes les dépendances nécessaires

### `android/app/build.gradle`
⚠️ À configurer après ajout de `google-services.json`

### `ios/Runner/Info.plist`
⚠️ À configurer pour les permissions (camera, location, etc.)

---

**Dernière mise à jour** : Novembre 2025
