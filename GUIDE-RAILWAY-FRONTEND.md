# 🚂 Déploiement du Frontend sur Railway

## 📋 Informations Importantes

- **URL du Backend** : `https://multidrive-backend-565974867635.europe-west1.run.app`
- **Variable d'environnement nécessaire** : `REACT_APP_API_URL`

---

## 🔷 ÉTAPE 1 : Créer un Compte Railway

1. Allez sur **https://railway.app**
2. Cliquez sur **"Login"** ou **"Start a New Project"**
3. **Recommandé** : Connectez-vous avec GitHub (plus simple pour déployer)
   - Cliquez sur **"Login with GitHub"**
   - Autorisez Railway à accéder à votre GitHub

---

## 🔷 ÉTAPE 2 : Créer un Nouveau Projet

1. Une fois connecté, cliquez sur **"New Project"**
2. Vous avez deux options :

### Option A : Déployer depuis GitHub (Recommandé) ⭐

**Si votre code est sur GitHub :**
1. Cliquez sur **"Deploy from GitHub repo"**
2. Autorisez Railway à accéder à vos repositories (si c'est la première fois)
3. Sélectionnez votre repository contenant le projet MultiDrive
4. Railway détectera automatiquement que c'est un projet React

**Si votre code n'est PAS sur GitHub :**
- Vous pouvez d'abord créer un repo GitHub et y pousser votre code
- Ou utiliser l'Option B (déploiement manuel)

### Option B : Déployer depuis le code local

1. Cliquez sur **"Empty Project"**
2. Cliquez sur **"Deploy"** → **"GitHub Repo"** ou **"Local Directory"**

---

## 🔷 ÉTAPE 3 : Configurer le Déploiement

Railway va automatiquement :
- ✅ Détecter que c'est un projet React
- ✅ Installer les dépendances (`npm install`)
- ✅ Builder le projet (`npm run build`)
- ✅ Déployer l'application

**MAIS** il faut configurer le dossier source et les variables d'environnement.

### 3.1 : Configurer le Dossier Source (si nécessaire)

Si Railway ne détecte pas automatiquement le dossier `frontend` :
1. Dans votre service Railway, allez dans **"Settings"**
2. Dans **"Source"**, spécifiez le dossier : `frontend`
3. Sauvegardez

### 3.2 : Configurer la Variable d'Environnement (IMPORTANT !)

1. Dans votre service Railway, allez dans l'onglet **"Variables"**
2. Cliquez sur **"New Variable"**
3. Ajoutez :
   - **Name** : `REACT_APP_API_URL`
   - **Value** : `https://multidrive-backend-565974867635.europe-west1.run.app`
4. Cliquez sur **"Add"**
5. Railway redéploiera automatiquement avec la nouvelle variable

---

## 🔷 ÉTAPE 4 : Vérifier le Déploiement

1. Une fois le déploiement terminé, Railway génère automatiquement une URL
2. Vous verrez l'URL dans l'onglet **"Settings"** → **"Domains"**
3. L'URL ressemble à : `https://multidrive-production.up.railway.app`
4. Cliquez sur l'URL pour tester votre application

---

## 🔷 ÉTAPE 5 : Mettre à Jour CORS dans Cloud Run (Important !)

Une fois que vous avez l'URL Railway du frontend, il faut autoriser cette URL dans CORS du backend :

```bash
# Remplacez [VOTRE-URL-RAILWAY] par votre vraie URL Railway
gcloud run services update multidrive-backend \
  --region europe-west1 \
  --update-env-vars "CORS_ORIGINS=https://votre-url.railway.app"
```

**Exemple :**
```bash
gcloud run services update multidrive-backend \
  --region europe-west1 \
  --update-env-vars "CORS_ORIGINS=https://multidrive-production.up.railway.app"
```

---

## ✅ Checklist

- [ ] Compte Railway créé
- [ ] Projet créé sur Railway
- [ ] Repository GitHub connecté (ou code uploadé)
- [ ] Variable `REACT_APP_API_URL` configurée
- [ ] Déploiement réussi
- [ ] URL Railway notée
- [ ] CORS mis à jour dans Cloud Run avec l'URL Railway
- [ ] Application testée dans le navigateur

---

## 🆘 Dépannage

### Le frontend ne se connecte pas au backend
- Vérifiez que `REACT_APP_API_URL` est bien configurée dans Railway
- Vérifiez que CORS autorise l'URL Railway dans Cloud Run
- Vérifiez les logs Railway : onglet **"Deployments"** → cliquez sur un déploiement → **"View Logs"**

### Erreur de build
- Vérifiez que le dossier source est correct (`frontend`)
- Vérifiez les logs de build dans Railway
- Assurez-vous que `package.json` est dans le dossier `frontend`

### Erreur CORS dans le navigateur
- Mettez à jour `CORS_ORIGINS` dans Cloud Run avec l'URL exacte Railway
- N'oubliez pas le `https://`
- Redéployez le backend après modification

---

## 💰 Coûts Railway

- ✅ **Plan gratuit** : $5 de crédits/mois
- ✅ Suffisant pour un projet de démonstration
- ⚠️ Après épuisement des crédits, ~$5/mois pour continuer

---

## 🎉 Résultat Final

Une fois tout configuré :
- ✅ Frontend accessible sur Railway
- ✅ Backend sur Google Cloud Run
- ✅ Base de données sur Supabase
- ✅ Application complète en production !

**Bon déploiement ! 🚂**

