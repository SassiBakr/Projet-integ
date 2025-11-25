# Backend SAV App - Node.js + Express + MongoDB

Backend complet pour l'application SAV mobile développée avec Node.js, Express et MongoDB.

## 🚀 Fonctionnalités

- ✅ **Authentification JWT** - Inscription, connexion, gestion de session
- 👥 **Gestion des utilisateurs** - Clients, Techniciens, Administrateurs
- 📅 **Rendez-vous** - Création, assignation, suivi des interventions
- 🔧 **Réparations** - Gestion complète du cycle de vie des réparations
- 🎁 **Offres promotionnelles** - Création et gestion des promotions
- 🔔 **Notifications** - Système de notifications en temps réel
- 📊 **Statistiques** - Tableaux de bord pour admin et techniciens
- 🔒 **Sécurité** - Helmet, rate limiting, validation des données
- 📝 **Validation** - Express-validator pour toutes les entrées

## 📋 Prérequis

- Node.js >= 16.x
- MongoDB >= 5.x (local ou MongoDB Atlas)
- npm ou yarn

## 🛠️ Installation

1. **Cloner le projet et naviguer vers le dossier backend**
```bash
cd backend
```

2. **Installer les dépendances**
```bash
npm install
```

3. **Configurer les variables d'environnement**
```bash
cp .env.example .env
```

Puis modifier le fichier `.env` avec vos configurations :
```env
PORT=3000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/sav_app
JWT_SECRET=votre_secret_jwt_tres_securise
JWT_EXPIRE=30d
```

4. **Démarrer MongoDB** (si local)
```bash
mongod
```

5. **Démarrer le serveur**

Mode développement (avec nodemon) :
```bash
npm run dev
```

Mode production :
```bash
npm start
```

Le serveur sera accessible sur `http://localhost:3000`

## 📁 Structure du projet

```
backend/
├── models/              # Modèles Mongoose
│   ├── User.js         # Utilisateurs (clients, techniciens, admin)
│   ├── Appointment.js  # Rendez-vous
│   ├── Repair.js       # Réparations
│   ├── Offer.js        # Offres promotionnelles
│   └── Notification.js # Notifications
├── routes/             # Routes Express
│   ├── auth.routes.js
│   ├── user.routes.js
│   ├── appointment.routes.js
│   ├── repair.routes.js
│   ├── offer.routes.js
│   ├── notification.routes.js
│   └── stats.routes.js
├── middleware/         # Middlewares personnalisés
│   ├── auth.middleware.js        # Authentification JWT
│   ├── error.middleware.js       # Gestion des erreurs
│   └── validation.middleware.js  # Validation des données
├── server.js          # Point d'entrée de l'application
├── package.json
├── .env.example
└── README.md
```

## 🔑 API Endpoints

### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/me` - Obtenir l'utilisateur connecté (Protected)

### Utilisateurs
- `GET /api/users` - Liste des utilisateurs (Admin)
- `GET /api/users/technicians` - Liste des techniciens disponibles
- `GET /api/users/:id` - Détails d'un utilisateur
- `PUT /api/users/:id` - Mettre à jour un utilisateur
- `DELETE /api/users/:id` - Supprimer un utilisateur (Admin)

### Rendez-vous
- `POST /api/appointments` - Créer un rendez-vous (Client)
- `GET /api/appointments` - Liste des rendez-vous (filtré par rôle)
- `GET /api/appointments/:id` - Détails d'un rendez-vous
- `PUT /api/appointments/:id` - Mettre à jour un rendez-vous
- `PUT /api/appointments/:id/assign` - Assigner un technicien (Admin)
- `PUT /api/appointments/:id/cancel` - Annuler un rendez-vous
- `DELETE /api/appointments/:id` - Supprimer un rendez-vous (Admin)

### Réparations
- `POST /api/repairs` - Créer une réparation (Technician)
- `GET /api/repairs` - Liste des réparations
- `GET /api/repairs/:id` - Détails d'une réparation
- `PUT /api/repairs/:id` - Mettre à jour une réparation
- `PUT /api/repairs/:id/complete` - Marquer comme terminée
- `DELETE /api/repairs/:id` - Supprimer une réparation (Admin)

### Offres
- `POST /api/offers` - Créer une offre (Admin)
- `GET /api/offers` - Liste des offres (Public)
- `GET /api/offers/:id` - Détails d'une offre
- `GET /api/offers/code/:promoCode` - Obtenir une offre par code promo
- `PUT /api/offers/:id` - Mettre à jour une offre (Admin)
- `PUT /api/offers/:id/redeem` - Utiliser une offre
- `DELETE /api/offers/:id` - Supprimer une offre (Admin)

### Notifications
- `POST /api/notifications` - Créer une notification
- `GET /api/notifications` - Liste des notifications de l'utilisateur
- `PUT /api/notifications/:id/read` - Marquer comme lue
- `PUT /api/notifications/read-all` - Marquer toutes comme lues
- `DELETE /api/notifications/:id` - Supprimer une notification

### Statistiques
- `GET /api/stats/dashboard` - Statistiques du tableau de bord (Admin)
- `GET /api/stats/technician/:id` - Statistiques d'un technicien

## 🔐 Authentification

L'API utilise JWT (JSON Web Tokens) pour l'authentification. Après connexion, incluez le token dans les headers :

```
Authorization: Bearer <votre_token_jwt>
```

## 📝 Exemples de requêtes

### Inscription
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Jean",
    "lastName": "Dupont",
    "email": "jean.dupont@example.com",
    "password": "motdepasse123",
    "phone": "0612345678",
    "role": "client"
  }'
```

### Connexion
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jean.dupont@example.com",
    "password": "motdepasse123"
  }'
```

### Créer un rendez-vous
```bash
curl -X POST http://localhost:3000/api/appointments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <votre_token>" \
  -d '{
    "deviceType": "smartphone",
    "brand": "iPhone",
    "model": "13 Pro",
    "issueDescription": "Écran cassé",
    "preferredDate": "2024-01-15",
    "preferredTime": "afternoon"
  }'
```

## 🔧 Configuration MongoDB

### MongoDB Local
```bash
mongod --dbpath /path/to/data
```

### MongoDB Atlas (Cloud)
1. Créez un compte sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Créez un cluster gratuit
3. Récupérez votre URI de connexion
4. Mettez à jour la variable `MONGODB_URI` dans `.env`

## 🚀 Déploiement

### Heroku
```bash
heroku create nom-de-votre-app
heroku config:set MONGODB_URI=votre_uri_mongodb
heroku config:set JWT_SECRET=votre_secret
git push heroku main
```

### Vercel / Railway / Render
Suivez la documentation de la plateforme et configurez les variables d'environnement.

## 🧪 Tests

```bash
npm test
```

## 📦 Dépendances principales

- **express** - Framework web
- **mongoose** - ODM MongoDB
- **bcryptjs** - Hash des mots de passe
- **jsonwebtoken** - Authentification JWT
- **express-validator** - Validation des données
- **helmet** - Sécurité des headers HTTP
- **cors** - Gestion CORS
- **dotenv** - Variables d'environnement
- **morgan** - Logger HTTP

## 🔒 Sécurité

- ✅ Hash des mots de passe avec bcrypt
- ✅ Tokens JWT avec expiration
- ✅ Rate limiting pour prévenir les abus
- ✅ Helmet pour sécuriser les headers
- ✅ Validation de toutes les entrées utilisateur
- ✅ Protection CORS

## 📝 Variables d'environnement

| Variable | Description | Exemple |
|----------|-------------|---------|
| PORT | Port du serveur | 3000 |
| NODE_ENV | Environnement | development / production |
| MONGODB_URI | URI de connexion MongoDB | mongodb://localhost:27017/sav_app |
| JWT_SECRET | Secret pour JWT | votre_secret_securise |
| JWT_EXPIRE | Durée de validité du JWT | 30d |

## 🐛 Debugging

Pour activer les logs détaillés en mode développement :
```bash
NODE_ENV=development npm run dev
```

## 📄 Licence

MIT

## 👨‍💻 Support

Pour toute question ou problème, veuillez ouvrir une issue sur le repository.
