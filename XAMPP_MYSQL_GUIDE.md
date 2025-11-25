# 🚀 Guide Complet: Connexion XAMPP MySQL

## 📋 **Prérequis**

### 1. **XAMPP doit être installé et démarré**
- Télécharger: https://www.apachefriends.org/
- Démarrer **Apache** et **MySQL** dans le panneau de contrôle XAMPP

### 2. **Vérifier que MySQL fonctionne**
- Ouvrir: http://localhost/phpmyadmin
- Vous devriez voir l'interface phpMyAdmin

---

## 🔧 **Configuration en 4 Étapes**

### **Étape 1: Créer la base de données**

#### Option A: Via phpMyAdmin (Interface graphique)
1. Ouvrir http://localhost/phpmyadmin
2. Cliquer sur "Nouvelle base de données"
3. Nom: `sav_db`
4. Interclassement: `utf8mb4_unicode_ci`
5. Cliquer sur "Créer"
6. Sélectionner la base `sav_db`
7. Aller dans l'onglet "SQL"
8. Copier tout le contenu du fichier `backend/database.sql`
9. Coller dans la zone de texte
10. Cliquer sur "Exécuter"

#### Option B: Via Script Node.js (Automatique)
```bash
cd backend
node setup-db.js
```

---

### **Étape 2: Vérifier le fichier .env**

Ouvrir `backend/.env` et vérifier:

```env
# Configuration MySQL (XAMPP)
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=sav_db
DB_PORT=3306
```

**Important:** Par défaut XAMPP n'a pas de mot de passe pour root, laissez `DB_PASSWORD` vide.

---

### **Étape 3: Démarrer le serveur backend**

```bash
cd backend
npm run start:mysql
```

Vous devriez voir:
```
╔════════════════════════════════════════╗
║   🚀 Serveur SAV démarré avec MySQL  ║
╚════════════════════════════════════════╝
📍 Port: 3000
🌐 URL: http://localhost:3000
💾 Base de données: MySQL (XAMPP)

👥 Comptes de test:
   • Admin: admin@sav.com / admin123
   • Technicien: tech@sav.com / admin123
   • Client: client@sav.com / admin123
```

---

### **Étape 4: Vérifier la connexion**

#### Test 1: Health Check
Ouvrir dans le navigateur: http://localhost:3000/health

Réponse attendue:
```json
{
  "status": "ok",
  "message": "Serveur SAV opérationnel avec MySQL",
  "database": "MySQL/XAMPP"
}
```

#### Test 2: Login
```bash
# Dans PowerShell ou un terminal
curl -X POST http://localhost:3000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"email":"admin@sav.com","password":"admin123"}'
```

---

## 🗄️ **Visualiser votre base de données**

### **Option 1: phpMyAdmin**
- URL: http://localhost/phpmyadmin
- Sélectionner la base `sav_db` à gauche
- Cliquer sur les tables pour voir les données

### **Option 2: Viewer HTML (Recommandé)**
1. Démarrer le backend: `npm run start:mysql`
2. Ouvrir `backend/view-database.html` dans votre navigateur
3. Se connecter avec: `admin@sav.com` / `admin123`
4. Parcourir les onglets pour voir toutes les données

---

## 🎯 **Lancer l'application complète**

### Terminal 1: Backend
```bash
cd C:\Users\bakrt\OneDrive\Bureau\GL\backend
npm run start:mysql
```

### Terminal 2: Frontend Flutter
```bash
cd C:\Users\bakrt\OneDrive\Bureau\GL
flutter run -d chrome
```

### Connexion
- Email: `admin@sav.com`
- Password: `admin123`

---

## 📊 **Structure de la base de données MySQL**

### Tables créées:
1. **users** - Utilisateurs (admin, techniciens, clients)
2. **appointments** - Rendez-vous
3. **repairs** - Réparations
4. **offers** - Offres de service
5. **notifications** - Notifications
6. **reviews** - Avis et évaluations

### Vues SQL:
- **technician_stats** - Statistiques des techniciens
- **client_stats** - Statistiques des clients

### Triggers:
- Mise à jour automatique du rating des techniciens après chaque avis

---

## 🔍 **Résolution des problèmes**

### Erreur: "Cannot connect to MySQL"
✅ **Vérifier:**
1. XAMPP est démarré
2. MySQL est en cours d'exécution (voyant vert)
3. Port 3306 n'est pas utilisé par autre chose
4. Fichier `.env` est correct

```bash
# Vérifier si MySQL écoute sur le port 3306
netstat -ano | findstr :3306
```

### Erreur: "Database sav_db does not exist"
✅ **Solution:**
```bash
cd backend
node setup-db.js
```

### Erreur: "Access denied for user 'root'"
✅ **Solution:**
- Ouvrir phpMyAdmin
- Aller dans "Comptes utilisateurs"
- Modifier le mot de passe de root si nécessaire
- Mettre à jour `DB_PASSWORD` dans `.env`

### Erreur: "Table users doesn't exist"
✅ **Solution:**
- Réexécuter le script SQL dans phpMyAdmin
- Ou relancer: `node setup-db.js`

---

## 📝 **Scripts npm disponibles**

```bash
npm run start:mysql       # Démarrer avec MySQL (XAMPP)
npm run dev:mysql         # Mode développement avec MySQL
npm run start:memory      # Mode mémoire (sans base de données)
npm run setup-db          # Créer/réinitialiser la base de données
```

---

## 🔄 **Migration depuis in-memory vers MySQL**

Vos données actuelles en mémoire seront perdues lors du passage à MySQL. Les utilisateurs par défaut seront automatiquement créés:

| Email | Password | Role |
|-------|----------|------|
| admin@sav.com | admin123 | Admin |
| tech@sav.com | admin123 | Technicien |
| client@sav.com | admin123 | Client |

---

## 🎨 **Différences avec MongoDB**

| Aspect | MongoDB | MySQL |
|--------|---------|-------|
| Type | NoSQL | SQL |
| Structure | Documents JSON | Tables relationnelles |
| Relations | Références | Foreign Keys |
| Requêtes | find(), aggregate() | SELECT, JOIN |
| Installation | Séparée | Inclus dans XAMPP |

**Note:** Votre code Flutter reste identique ! Seul le backend change.

---

## ✨ **Prochaines étapes**

1. ✅ XAMPP démarré
2. ✅ Base de données créée
3. ✅ Backend démarré avec MySQL
4. ✅ Frontend Flutter connecté
5. 🎯 Tester toutes les fonctionnalités:
   - Connexion/Inscription
   - Création de rendez-vous
   - Création de réparations
   - Visualisation des offres
   - Notifications

---

## 🆘 **Support**

Si vous rencontrez des problèmes:

1. Vérifier les logs du serveur backend
2. Vérifier les logs phpMyAdmin
3. Tester avec Postman: http://localhost:3000/api/auth/login
4. Vérifier que les ports 3000 et 3306 ne sont pas bloqués

---

## 📞 **Commandes de test rapides**

### Test de connexion MySQL:
```bash
mysql -u root -h localhost
```

### Test du serveur:
```bash
curl http://localhost:3000/health
```

### Test de login:
```bash
curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"admin@sav.com\",\"password\":\"admin123\"}"
```

---

**🎉 Votre application SAV est maintenant connectée à MySQL via XAMPP !**
