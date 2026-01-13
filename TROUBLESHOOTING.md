# 🔧 Dépannage - Problèmes Courants

## ✅ Firebase CLI Installé !

Votre Firebase CLI est maintenant installé correctement (version 14.22.0)

---

## 🚀 Prochaines Étapes

### 1. Se connecter à Firebase

```bash
firebase login
```

Une fenêtre de navigateur s'ouvrira pour se connecter avec votre compte Google.

### 2. Créer un projet Firebase

1. Allez sur https://console.firebase.google.com
2. Cliquez sur "Ajouter un projet"
3. Nommez-le: `vehicle-management`
4. Activez Google Analytics (optionnel)
5. Créez le projet

### 3. Initialiser Firebase dans votre projet

```bash
cd frontend
firebase init
```

**Sélectionnez:**
- ✅ Hosting: Configure files for Firebase Hosting
- ✅ Use an existing project → Sélectionnez votre projet
- ✅ What do you want to use as your public directory? → **build**
- ✅ Set up automatic builds and deploys? → Yes
- ✅ Configure as a single-page app? → **Yes**

---

## 🔧 Problèmes Résolus

### ✅ Problème de permissions lors de l'installation

**Solution utilisée:**
```bash
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
npm install -g firebase-tools
```

**Aucun sudo nécessaire !** ✅

---

## 🎯 Commandes Essentielles

```bash
# Se connecter
firebase login

# Initialiser
cd frontend
firebase init

# Build et déployer
npm run build
firebase deploy --only hosting

# Voir les logs
firebase logs:open

# Lister les déploiements
firebase hosting:channel:list
```

---

## 📚 Suite du Déploiement

Une fois Firebase initialisé, suivez:
- `GUIDE-FIREBASE-RAPIDE.md` pour les étapes 4-7
- Créer la base de données PostgreSQL
- Déployer le backend
- Déployer le frontend

---

**Bon courage ! 🚀**


