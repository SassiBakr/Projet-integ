# 🧪 Comptes de Test - SAV Pro

## 📝 Mode Test Activé

L'application accepte maintenant **n'importe quel email et mot de passe** pour faciliter les tests.
Les validations de formulaire restent actives (format email, longueur minimale, etc.).

## 👤 Types de Comptes

Le type de compte est déterminé automatiquement selon l'email utilisé :

### 🔧 Compte Technicien
**Email contenant "tech"** → Accès Technicien

Exemples :
- `tech@test.com` / `123456`
- `technicien@sav.com` / `password`
- `marie.tech@email.fr` / `test123`

**Fonctionnalités :**
- Dashboard technicien
- Calendrier des interventions
- Liste des réparations assignées
- Gestion des rendez-vous

---

### 👨‍💼 Compte Administrateur
**Email contenant "admin"** → Accès Admin

Exemples :
- `admin@test.com` / `123456`
- `administrateur@sav.com` / `password`
- `admin.sav@email.fr` / `test123`

**Fonctionnalités :**
- Dashboard avec KPIs
- Gestion des techniciens
- Statistiques et graphiques
- Gestion des offres promotionnelles

---

### 👥 Compte Client (Par défaut)
**Tous les autres emails** → Accès Client

Exemples :
- `client@test.com` / `123456`
- `jean.dupont@email.fr` / `password`
- `user@gmail.com` / `test123`

**Fonctionnalités :**
- Dashboard client
- Prise de rendez-vous
- Suivi des réparations
- Chatbot assistance
- Messagerie avec techniciens
- Promotions

---

## ✅ Validation des Formulaires

### Connexion
- ✔️ Email au format valide (contient @)
- ✔️ Mot de passe minimum 6 caractères
- ✔️ Tous les champs requis

### Inscription
- ✔️ Nom complet requis
- ✔️ Email au format valide
- ✔️ Téléphone requis (10 chiffres minimum)
- ✔️ Mot de passe minimum 6 caractères
- ✔️ Confirmation de mot de passe identique

---

## 🚀 Instructions de Test

### 1. Tester le Client
```
Email: client@test.com
Mot de passe: 123456
```
➡️ Accède au dashboard client avec :
- Vue des réparations en cours
- Boutons d'actions rapides
- Cartes de statut

### 2. Tester le Technicien
```
Email: tech@sav.com
Mot de passe: password
```
➡️ Accède à l'interface technicien avec :
- Calendrier des tâches
- Liste des réparations assignées

### 3. Tester l'Admin
```
Email: admin@sav.com
Mot de passe: admin123
```
➡️ Accède au panneau admin avec :
- Vue d'ensemble (dashboard)
- Gestion complète

---

## 🔄 Inscription

Pour créer un nouveau compte :
1. Cliquez sur "Créer un compte"
2. Remplissez tous les champs
3. Utilisez n'importe quel email/mot de passe valide
4. Le compte sera automatiquement créé comme **Client**

---

## 📱 Navigation

Après connexion :
- **Client** : Bottom navigation avec 4 onglets (Dashboard, Rendez-vous, Réparations, Profil)
- **Technicien** : Interface spécialisée avec calendrier
- **Admin** : Panneau de gestion complet

---

## ⚠️ Note Importante

**Ce mode test est temporaire !**

Pour la production, vous devrez :
1. Configurer Firebase Authentication
2. Créer une base de données Firestore
3. Implémenter la vraie logique d'authentification
4. Gérer les rôles dans Firestore
5. Ajouter la sécurité appropriée

Instructions complètes dans **SETUP.md**

---

## 🐛 Dépannage

### L'écran reste vide ?
1. Vérifiez la console du navigateur (F12)
2. Rechargez la page (Ctrl+R)
3. Videz le cache (Ctrl+Shift+R)

### La connexion ne fonctionne pas ?
1. Vérifiez le format de l'email (doit contenir @)
2. Vérifiez la longueur du mot de passe (min 6 caractères)
3. Consultez les erreurs dans la console

### Changement de rôle ?
Déconnectez-vous et reconnectez-vous avec un email différent.

---

**Bon test ! 🎉**
