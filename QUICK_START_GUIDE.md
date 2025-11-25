# 🚀 Guide de Démarrage Rapide - SAV App

Ce guide permet à votre ami de configurer et lancer l'application en **moins de 10 minutes**.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

1. **XAMPP** (pour MySQL) - [Télécharger](https://www.apachefriends.org/)
2. **Node.js** (v16 ou supérieur) - [Télécharger](https://nodejs.org/)
3. **Flutter** (v3.0 ou supérieur) - [Télécharger](https://flutter.dev/)
4. **Git** - [Télécharger](https://git-scm.com/)

---

## 🎯 Installation en 5 Étapes

### Étape 1️⃣ : Cloner le Projet

```bash
git clone https://github.com/SassiBakr/Projet-integ.git
cd Projet-integ
```

### Étape 2️⃣ : Configurer la Base de Données MySQL

1. **Démarrer XAMPP** :
   - Ouvrir XAMPP Control Panel
   - Démarrer **Apache** et **MySQL**

2. **Créer la base de données** :
   - Ouvrir http://localhost/phpmyadmin
   - Créer une nouvelle base de données nommée `sav_db`
   - Aller dans l'onglet **SQL**
   - Copier tout le contenu du fichier `backend/database.sql`
   - Coller et exécuter

✅ **Résultat attendu** : 6 tables créées (users, repairs, appointments, offers, notifications, repair_history)

### Étape 3️⃣ : Configurer le Backend

```bash
cd backend

# Copier le fichier de configuration
copy .env.example .env

# Installer les dépendances
npm install

# Démarrer le serveur
node server-mysql.js
```

✅ **Résultat attendu** : Message "🚀 Serveur SAV démarré avec MySQL" sur le port 3000

### Étape 4️⃣ : Configurer Flutter

```bash
# Retourner à la racine du projet
cd ..

# Installer les dépendances Flutter
flutter pub get

# Vérifier la configuration
flutter doctor
```

### Étape 5️⃣ : Lancer l'Application

```bash
# Lancer sur Chrome (développement web)
flutter run -d chrome

# OU lancer sur Windows
flutter run -d windows

# OU lancer sur Android/iOS
flutter run
```

---

## 👥 Comptes de Test par Défaut

Une fois l'application lancée, utilisez ces comptes :

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Administrateur** | admin@sav.com | admin123 |
| **Technicien** | tech@sav.com | admin123 |
| **Client** | client@sav.com | admin123 |

---

## 🔧 Configuration Avancée

### Modifier le fichier `.env` du Backend

Si nécessaire, modifiez `backend/.env` :

```env
# Port du serveur
PORT=3000

# Connexion MySQL
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=        # Laisser vide par défaut avec XAMPP
DB_NAME=sav_db
DB_PORT=3306

# Sécurité JWT
JWT_SECRET=votre_cle_secrete_ici
JWT_EXPIRE=30d
```

### Vérifier la Connexion à l'API

Ouvrir dans le navigateur : http://localhost:3000/health

✅ **Résultat attendu** : `{"status": "OK", "database": "MySQL"}`

---

## 🐛 Résolution de Problèmes Courants

### ❌ Erreur "ERR_CONNECTION_REFUSED"

**Problème** : Le serveur backend n'est pas démarré.

**Solution** :
```bash
cd backend
node server-mysql.js
```

### ❌ Erreur "Access denied for user 'root'@'localhost'"

**Problème** : Configuration MySQL incorrecte.

**Solution** :
1. Vérifier que MySQL est démarré dans XAMPP
2. Vérifier les identifiants dans `backend/.env`
3. Par défaut avec XAMPP : user=`root`, password=`` (vide)

### ❌ Erreur "Table 'sav_db.users' doesn't exist"

**Problème** : Base de données non créée.

**Solution** :
1. Aller sur http://localhost/phpmyadmin
2. Créer `sav_db`
3. Importer `backend/database.sql`

### ❌ Erreur Flutter "Packages not found"

**Problème** : Dépendances non installées.

**Solution** :
```bash
flutter pub get
flutter clean
flutter pub get
```

---

## 📂 Structure du Projet

```
Projet-integ/
├── backend/               # Serveur Node.js + Express
│   ├── server-mysql.js   # Point d'entrée du serveur
│   ├── database.sql      # Script de création de la BDD
│   ├── .env              # Configuration (NE PAS COMMIT)
│   └── package.json      # Dépendances Node.js
│
├── lib/                  # Code Flutter
│   ├── main.dart         # Point d'entrée de l'app
│   ├── core/             # Services, providers, routes
│   └── features/         # Fonctionnalités par rôle
│
└── assets/               # Images, icônes, animations
```

---

## 🚀 Commandes Utiles

### Backend
```bash
# Démarrer le serveur
node server-mysql.js

# Vérifier les utilisateurs
node check-users.js

# Réinitialiser les mots de passe
node fix-passwords.js

# Vérifier les vulnérabilités
npm audit
```

### Flutter
```bash
# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run

# Builder pour production
flutter build web
flutter build windows
flutter build apk
```

---

## 📞 Support

En cas de problème :

1. Vérifier la section **Résolution de Problèmes** ci-dessus
2. Consulter les fichiers de documentation :
   - `XAMPP_MYSQL_GUIDE.md` - Guide détaillé MySQL
   - `BACKEND_CONFIG.md` - Configuration backend
   - `SETUP.md` - Instructions complètes
3. Vérifier que tous les services sont démarrés :
   - XAMPP MySQL ✅
   - Backend Node.js ✅
   - Flutter App ✅

---

## ✅ Checklist de Vérification

Avant de commencer le développement, vérifier que :

- [ ] XAMPP MySQL est démarré
- [ ] Base de données `sav_db` créée avec les tables
- [ ] Backend répond sur http://localhost:3000/health
- [ ] `flutter doctor` ne montre pas d'erreurs critiques
- [ ] Connexion réussie avec admin@sav.com / admin123

---

**🎉 Félicitations ! Votre application SAV est prête à être utilisée.**
