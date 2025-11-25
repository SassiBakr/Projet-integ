# 🚀 Guide de Push sur GitHub

## Étapes pour Pousser le Code

### 1️⃣ Vérifier les Fichiers à Ignorer

Assurez-vous que le fichier `.gitignore` est bien configuré pour ne **PAS** pousser :
- ❌ `backend/.env` (contient vos identifiants)
- ❌ `backend/node_modules/`
- ❌ Build files Flutter

### 2️⃣ Ajouter les Fichiers

```bash
# Se positionner à la racine du projet
cd c:\Users\bakrt\OneDrive\Bureau\GL

# Vérifier le statut Git
git status

# Ajouter tous les fichiers (sauf ceux dans .gitignore)
git add .
```

### 3️⃣ Créer un Commit

```bash
# Créer un commit avec un message descriptif
git commit -m "✨ SAV App - Backend Node.js + MySQL + Flutter complet"
```

### 4️⃣ Pousser sur GitHub

```bash
# Pousser sur la branche main
git push origin main
```

---

## 📦 Ce Qui Sera Poussé

### ✅ Fichiers Inclus
- ✅ Code source Flutter (`lib/`)
- ✅ Backend Node.js (`backend/`)
- ✅ Fichier SQL (`backend/database.sql`)
- ✅ **Template de configuration** (`.env.example`)
- ✅ Documentation complète
- ✅ Assets (images, icônes)

### ❌ Fichiers Exclus (`.gitignore`)
- ❌ `backend/.env` (secrets)
- ❌ `backend/node_modules/` (dépendances)
- ❌ `build/` (fichiers compilés)
- ❌ `.dart_tool/`

---

## 👥 Instructions pour Votre Ami

Une fois le code poussé, votre ami devra :

### 1. Cloner le Projet
```bash
git clone https://github.com/SassiBakr/Projet-integ.git
cd Projet-integ
```

### 2. Créer le Fichier `.env`
```bash
cd backend
copy .env.example .env
```

Ensuite, ouvrir `backend/.env` et vérifier la configuration :
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=sav_db
JWT_SECRET=sav_app_secret_key_2024_super_secure_random_string
```

### 3. Installer XAMPP et Créer la Base de Données

1. **Télécharger et installer XAMPP** : https://www.apachefriends.org/
2. **Démarrer XAMPP** et lancer **MySQL**
3. **Accéder à phpMyAdmin** : http://localhost/phpmyadmin
4. **Créer la base de données** :
   - Cliquer sur "Nouvelle base de données"
   - Nom : `sav_db`
   - Collation : `utf8mb4_unicode_ci`
5. **Importer le script SQL** :
   - Sélectionner la base `sav_db`
   - Onglet "Importer"
   - Choisir le fichier `backend/database.sql`
   - Cliquer sur "Exécuter"

✅ **Résultat** : 6 tables créées avec 3 utilisateurs par défaut

### 4. Installer les Dépendances Backend
```bash
npm install
```

### 5. Démarrer le Serveur Backend
```bash
node server-mysql.js
```

✅ **Résultat** : Message "🚀 Serveur SAV démarré avec MySQL" sur http://localhost:3000

### 6. Installer Flutter et Lancer l'App
```bash
cd ..
flutter pub get
flutter run -d chrome
```

### 7. Se Connecter avec les Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Admin** | admin@sav.com | admin123 |
| **Technicien** | tech@sav.com | admin123 |
| **Client** | client@sav.com | admin123 |

---

## 🔍 Vérifications Avant le Push

### Checklist de Sécurité

Avant de pousser, vérifiez que :

- [ ] Le fichier `.env` est bien dans `.gitignore`
- [ ] Pas de mots de passe en dur dans le code
- [ ] Le fichier `.env.example` est présent avec des valeurs par défaut
- [ ] La documentation est complète

### Commande de Vérification

```bash
# Vérifier que .env n'est PAS dans les fichiers à committer
git status

# Si .env apparaît, l'ignorer explicitement
echo "backend/.env" >> .gitignore
git add .gitignore
```

---

## 📖 Documentation pour Votre Ami

Assurez-vous que votre ami consulte ces fichiers après le clone :

1. **QUICK_START_GUIDE.md** - Guide de démarrage rapide (10 minutes)
2. **XAMPP_MYSQL_GUIDE.md** - Configuration détaillée MySQL
3. **BACKEND_CONFIG.md** - Configuration du backend
4. **README.md** - Documentation générale

---

## 🆘 En Cas de Problème

### Problème : `.env` est déjà tracé par Git

Si vous avez déjà commité le fichier `.env` par erreur :

```bash
# Supprimer .env du tracking Git (mais garder le fichier localement)
git rm --cached backend/.env

# Ajouter .env au .gitignore s'il n'y est pas
echo "backend/.env" >> backend/.gitignore

# Committer la suppression
git add backend/.gitignore
git commit -m "🔒 Remove .env from tracking"
git push origin main
```

### Problème : Conflit de Merge

```bash
# Récupérer les dernières modifications
git pull origin main

# Résoudre les conflits dans VS Code
# Puis :
git add .
git commit -m "🔀 Merge conflicts resolved"
git push origin main
```

---

## ✅ Résumé des Commandes Essentielles

```bash
# 1. Vérifier le statut
git status

# 2. Ajouter tous les fichiers
git add .

# 3. Créer un commit
git commit -m "✨ Initial commit - SAV App complet"

# 4. Pousser sur GitHub
git push origin main
```

---

**🎉 Une fois poussé, votre ami pourra cloner et démarrer en 10 minutes avec le QUICK_START_GUIDE.md !**
