# 🔐 Guide d'Authentification GitHub

## Problème Rencontré

```
fatal: Authentication failed for 'https://github.com/SassiBakr/Projet-integ.git/'
```

GitHub a désactivé l'authentification par mot de passe. Vous devez utiliser un **Personal Access Token (PAT)**.

---

## ✅ Solution 1 : GitHub Desktop (RECOMMANDÉ)

C'est la méthode la plus simple :

1. **Télécharger GitHub Desktop** : https://desktop.github.com/
2. **Se connecter** avec votre compte GitHub
3. **Ouvrir le projet** : File → Add Local Repository → Sélectionner `C:\Users\bakrt\OneDrive\Bureau\GL`
4. **Push** : Cliquer sur "Push origin" en haut à droite

✅ **Avantage** : Pas de configuration, tout est automatique !

---

## 🔑 Solution 2 : Personal Access Token (CLI)

Si vous préférez la ligne de commande :

### Étape 1 : Créer un Token GitHub

1. Aller sur : https://github.com/settings/tokens
2. Cliquer sur **"Generate new token"** → **"Generate new token (classic)"**
3. Donner un nom : `Projet-integ-token`
4. Cocher les permissions :
   - ✅ `repo` (accès complet aux dépôts)
   - ✅ `workflow` (si vous utilisez GitHub Actions)
5. Cliquer sur **"Generate token"**
6. **COPIER LE TOKEN** (vous ne le verrez plus jamais !)
   - Format : `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Étape 2 : Utiliser le Token

```powershell
# Remplacer YOUR_TOKEN par le token copié
git remote set-url origin https://YOUR_TOKEN@github.com/SassiBakr/Projet-integ.git

# Puis pousser
git push origin main
```

### Étape 3 : Ou Entrer le Token Manuellement

```powershell
git push origin main

# Quand demandé :
# Username: SassiBakr
# Password: [COLLER LE TOKEN ICI, PAS LE MOT DE PASSE]
```

---

## 🔐 Solution 3 : GitHub CLI (Moderne)

```powershell
# Installer GitHub CLI
winget install --id GitHub.cli

# Se connecter
gh auth login

# Suivre les instructions interactives
# Puis :
git push origin main
```

---

## 🆘 En Cas de Problème

### Erreur : "Permission denied"
- Vérifier que le token a la permission `repo`
- Régénérer un nouveau token

### Erreur : "Repository not found"
- Vérifier que le dépôt existe : https://github.com/SassiBakr/Projet-integ
- Vérifier l'orthographe du nom d'utilisateur et du dépôt

### Le Token ne Fonctionne Pas
- Vérifier qu'il n'y a pas d'espaces avant/après le token
- Le token doit commencer par `ghp_`
- Créer un nouveau token si nécessaire

---

## 📌 Recommandation

**Utilisez GitHub Desktop** pour éviter tous ces problèmes d'authentification. C'est plus simple et plus sécurisé !

---

## ✅ Après le Push Réussi

Votre ami pourra cloner le projet avec :

```bash
git clone https://github.com/SassiBakr/Projet-integ.git
cd Projet-integ
```

Puis suivre le **QUICK_START_GUIDE.md** pour installer en 10 minutes !
