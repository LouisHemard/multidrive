# 🚀 Guide de Déploiement : Google Cloud Run + Railway

## 📋 Architecture de Déploiement

```
Frontend (Railway) → Backend (Google Cloud Run) → Base de données (Supabase)
```

## ⚡ Ordre de Déploiement

**1. Backend d'abord** (pour obtenir l'URL de l'API)  
**2. Frontend ensuite** (pour configurer l'URL du backend)

---

## 🔷 PARTIE 1 : Déployer le Backend sur Google Cloud Run

### Prérequis ✅

- [x] Google Cloud SDK installé (`gcloud`)
- [x] Projet GCP configuré : `garagerouge`
- [x] Base de données Supabase configurée

### Étape 1.1 : Vérifier la Configuration GCP

```bash
# Vérifier que vous êtes connecté
gcloud auth list

# Vérifier le projet actif
gcloud config get-value project
# Devrait afficher: garagerouge

# Si ce n'est pas le cas, configurer le projet
gcloud config set project garagerouge
```

### Étape 1.2 : Activer les APIs Nécessaires

```bash
# Activer Cloud Run API
gcloud services enable run.googleapis.com

# Activer Cloud Build API
gcloud services enable cloudbuild.googleapis.com
```

### Étape 1.3 : Préparer la Connection String Supabase

Vous avez déjà votre connection string Supabase (Transaction Pooler) :
```
postgresql://postgres.ozvjwsvbimjrwjycyxbr:mZjECcHQUJ3NdNZx@aws-1-eu-west-1.pooler.supabase.com:6543/postgres
```

**Gardez cette connection string, vous en aurez besoin !**

### Étape 1.4 : Builder et Déployer le Backend

```bash
# Aller dans le dossier backend
cd backend

# Builder l'image Docker et la pousser vers Google Container Registry
gcloud builds submit --tag gcr.io/garagerouge/multidrive-backend

# Déployer sur Cloud Run
gcloud run deploy multidrive-backend \
  --image gcr.io/garagerouge/multidrive-backend \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --set-env-vars "DATABASE_URL=postgresql://postgres.ozvjwsvbimjrwjycyxbr:mZjECcHQUJ3NdNZx@aws-1-eu-west-1.pooler.supabase.com:6543/postgres,CORS_ORIGINS=https://multidrive.railway.app"

# ⚠️ Note: Remplacez "https://multidrive.railway.app" par votre URL Railway finale (on l'ajustera après)
```

### Étape 1.5 : Noter l'URL du Backend

Après le déploiement, vous verrez quelque chose comme :
```
Service [multidrive-backend] revision [multidrive-backend-00001-xxx] has been deployed and is serving 100 percent of traffic.
Service URL: https://multidrive-backend-xxxxx-ew.a.run.app
```

**📝 NOTEZ CETTE URL !** Vous en aurez besoin pour le frontend.

Exemple : `https://multidrive-backend-xxxxx-ew.a.run.app`

---

## 🔷 PARTIE 2 : Déployer le Frontend sur Railway

### Prérequis ✅

- Compte Railway (gratuit) : https://railway.app
- Git (pour connecter votre repo)

### Étape 2.1 : Créer un Compte Railway

1. Allez sur https://railway.app
2. Cliquez sur **"Login"** ou **"Start a New Project"**
3. Connectez-vous avec GitHub (recommandé)

### Étape 2.2 : Créer un Nouveau Projet

1. Dans Railway, cliquez sur **"New Project"**
2. Sélectionnez **"Deploy from GitHub repo"**
3. Sélectionnez votre repository (ou créez-en un si vous n'avez pas encore pushé votre code)
4. Railway va détecter automatiquement que c'est un projet React

### Étape 2.3 : Configurer le Déploiement

Railway va automatiquement :
- Détecter que c'est un projet React
- Builder le projet
- Le déployer

**MAIS** il faut configurer la variable d'environnement pour l'URL du backend.

### Étape 2.4 : Configurer la Variable d'Environnement

1. Dans votre projet Railway, cliquez sur votre service frontend
2. Allez dans l'onglet **"Variables"**
3. Ajoutez une nouvelle variable :
   - **Nom** : `REACT_APP_API_URL`
   - **Valeur** : L'URL de votre backend Cloud Run (ex: `https://multidrive-backend-xxxxx-ew.a.run.app`)

4. Sauvegardez
5. Railway va redéployer automatiquement avec la nouvelle variable

### Étape 2.5 : Noter l'URL du Frontend

Railway génère automatiquement une URL pour votre frontend, quelque chose comme :
- `https://multidrive-production.up.railway.app`
- Ou vous pouvez configurer un domaine custom

**📝 NOTEZ CETTE URL !**

### Étape 2.6 : Mettre à Jour CORS dans Cloud Run (Important !)

Une fois que vous avez l'URL Railway du frontend, il faut autoriser cette URL dans CORS du backend :

```bash
# Mettre à jour le backend avec la vraie URL Railway
gcloud run services update multidrive-backend \
  --region europe-west1 \
  --update-env-vars "CORS_ORIGINS=https://votre-frontend.railway.app"
```

**Remplacez `https://votre-frontend.railway.app` par votre vraie URL Railway.**

---

## ✅ Vérification

### Backend
- [ ] Backend déployé sur Cloud Run
- [ ] URL du backend notée
- [ ] API accessible : `https://votre-backend.run.app/docs`
- [ ] Tests API fonctionnels

### Frontend
- [ ] Frontend déployé sur Railway
- [ ] Variable `REACT_APP_API_URL` configurée
- [ ] Frontend accessible sur Railway
- [ ] CORS mis à jour avec l'URL Railway

---

## 🔄 Mises à Jour Futures

### Mettre à jour le Backend

```bash
cd backend
gcloud builds submit --tag gcr.io/garagerouge/multidrive-backend
gcloud run deploy multidrive-backend \
  --image gcr.io/garagerouge/multidrive-backend \
  --region europe-west1
```

### Mettre à jour le Frontend

Railway détecte automatiquement les changements si vous avez connecté votre repo GitHub. Sinon :
- Push vos changements sur GitHub
- Railway redéploiera automatiquement

---

## 💰 Coûts

### Google Cloud Run
- ✅ **Gratuit** jusqu'à 2 millions de requêtes/mois
- ✅ 400,000 GB-secondes de mémoire gratuite
- ✅ 200,000 vCPU-secondes gratuites

### Railway
- ✅ **Plan gratuit** : $5 de crédits/mois
- ✅ Suffisant pour un projet de démonstration
- ⚠️ Après épuisement, ~$5/mois pour continuer

### Supabase (Base de données)
- ✅ **Plan gratuit** : 500 MB de base de données
- ✅ 2 GB de bande passante/mois

**Total estimé : GRATUIT pour la démonstration !** 🎉

---

## 🆘 Dépannage

### Backend ne démarre pas
- Vérifiez les logs : `gcloud run services logs read multidrive-backend --region europe-west1`
- Vérifiez que la connection string Supabase est correcte
- Vérifiez que les APIs sont activées

### Frontend ne peut pas se connecter au backend
- Vérifiez que `REACT_APP_API_URL` est bien configuré dans Railway
- Vérifiez que CORS autorise l'URL Railway
- Vérifiez que le backend est accessible publiquement

### Erreur CORS
- Mettez à jour `CORS_ORIGINS` avec l'URL exacte du frontend Railway
- N'oubliez pas le `https://`
- Redéployez le backend après modification

---

**Bon déploiement ! 🚀**

