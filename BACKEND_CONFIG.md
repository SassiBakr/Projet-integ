# Configuration Backend + Base de données

## ✅ Backend Node.js configuré et fonctionnel !

Le serveur backend est actuellement en cours d'exécution sur **http://localhost:3000**

### 🔑 Comptes de test disponibles

Utilisez ces comptes pour vous connecter à l'application :

| Rôle          | Email              | Mot de passe |
|---------------|-------------------|--------------|
| **Admin**     | admin@sav.com     | admin123     |
| **Technicien**| tech@sav.com      | admin123     |
| **Client**    | client@sav.com    | admin123     |

## 📦 Base de données

Le backend utilise actuellement une **base de données en mémoire** pour le développement.
Les données sont stockées temporairement et seront perdues au redémarrage du serveur.

### Pour utiliser MongoDB (optionnel)

1. **Installer MongoDB Community Server**
   - Télécharger : https://www.mongodb.com/try/download/community
   - Ou utiliser MongoDB Atlas (cloud gratuit)

2. **Démarrer MongoDB**
   ```bash
   mongod
   ```

3. **Utiliser le serveur avec MongoDB**
   ```bash
   cd backend
   npm run start:mongo
   ```

## 🚀 Démarrage du backend

### Mode développement (base en mémoire)
```bash
cd backend
npm start
```

### Mode développement avec auto-reload
```bash
cd backend
npm run dev
```

Le serveur démarrera automatiquement sur http://localhost:3000

## 🌐 API Endpoints disponibles

### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/me` - Utilisateur connecté

### Utilisateurs
- `GET /api/users/technicians` - Liste des techniciens

### Rendez-vous
- `POST /api/appointments` - Créer un rendez-vous
- `GET /api/appointments` - Liste des rendez-vous
- `GET /api/appointments/:id` - Détails d'un rendez-vous
- `PUT /api/appointments/:id` - Mettre à jour
- `PUT /api/appointments/:id/cancel` - Annuler

### Offres
- `GET /api/offers` - Liste des offres actives
- `POST /api/offers` - Créer une offre (Admin)

### Notifications
- `GET /api/notifications` - Liste des notifications
- `PUT /api/notifications/:id/read` - Marquer comme lue

### Statistiques
- `GET /api/stats/dashboard` - Statistiques admin

## 🔧 Configuration Flutter

L'application Flutter est maintenant configurée pour communiquer avec le backend :

### Services créés
- ✅ `ApiService` - Communication HTTP avec le backend
- ✅ `AuthProvider` - Gestion de l'authentification
- ✅ `AppointmentService` - Gestion des rendez-vous
- ✅ `OfferService` - Gestion des offres

### Fichiers de configuration
- `lib/core/services/api_config.dart` - Configuration de l'API
- `lib/core/services/api_service.dart` - Service HTTP
- `lib/core/providers/auth_provider.dart` - Provider d'authentification

## 📱 Utilisation de l'application

1. **Démarrer le backend**
   ```bash
   cd backend
   npm start
   ```

2. **Démarrer l'application Flutter**
   ```bash
   flutter run -d chrome
   ```

3. **Se connecter avec un compte de test**
   - Email: `admin@sav.com`
   - Mot de passe: `admin123`

## 🐛 Dépannage

### Le backend ne démarre pas
- Vérifiez que le port 3000 n'est pas déjà utilisé
- Vérifiez que Node.js est installé : `node --version`
- Réinstallez les dépendances : `cd backend && npm install`

### L'application ne se connecte pas au backend
- Vérifiez que le backend est en cours d'exécution
- Vérifiez l'URL dans `lib/core/services/api_config.dart`
- Pour Chrome : l'URL devrait être `http://localhost:3000/api`

### Erreur CORS
- Le backend est configuré pour accepter toutes les origines en développement
- Vérifiez que le serveur affiche "CORS: activé" au démarrage

## 📊 Données de test

Le backend initialise automatiquement :
- 3 utilisateurs (admin, technicien, client)
- Aucun rendez-vous (créez-en depuis l'app)
- Aucune offre (créez-en depuis le panel admin)

## 🔐 Sécurité

### En développement
- Token JWT valide 30 jours
- CORS ouvert à toutes les origines
- Rate limiting : 100 req/15min

### Pour la production
1. Changer `JWT_SECRET` dans `.env`
2. Configurer CORS pour votre domaine
3. Utiliser HTTPS
4. Configurer MongoDB avec authentification
5. Activer les logs de production

## 📖 Documentation complète

- **API Documentation** : `backend/API_DOCUMENTATION.md`
- **Backend README** : `backend/README.md`

## 🎉 Prochaines étapes

1. ✅ Backend fonctionnel
2. ✅ Base de données configurée
3. ✅ Frontend connecté
4. ⏳ Tester les fonctionnalités
5. ⏳ Implémenter les fonctionnalités manquantes
6. ⏳ Déployer en production
