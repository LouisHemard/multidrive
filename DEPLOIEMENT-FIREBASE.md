# 🔥 Déploiement Firebase - Guide Complet

## 🎯 Pourquoi Firebase ?

Firebase est parfait pour ce projet:
- ✅ Gratuit (plan Spark)
- ✅ Hosting pour le frontend
- ✅ Intégré avec Google Cloud
- ✅ Simple et rapide
- ✅ HTTPS automatique

## 📋 Architecture Firebase

```
Frontend (Firebase Hosting) → Backend (Cloud Run) → PostgreSQL (Cloud SQL)
```

---

## 🚀 Étape 1: Installer Firebase CLI

```bash
# Installation
npm install -g firebase-tools

# Ou avec Homebrew (macOS)
brew install firebase-cli

# Se connecter
firebase login
```

---

## 🚀 Étape 2: Initialiser Firebase (Frontend)

```bash
cd frontend

# Initialiser Firebase
firebase init

# Options à sélectionner:
# ✓ Hosting: Configure files for Firebase Hosting
# ✓ Use an existing project
# Project: vehicle-management (ou créer un nouveau)
# Public directory: build
# Single-page app: Yes
# Automatic builds: Yes
# GitHub: Yes (optionnel)
```

---

## 🚀 Étape 3: Créer le fichier firebase.json

Si pas créé automatiquement:

```json
{
  "hosting": {
    "public": "build",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

Placez-le dans le dossier `frontend/`.

---

## 🚀 Étape 4: Créer la Base de Données (Cloud SQL)

```bash
# Activer l'API SQL Admin
gcloud services enable sqladmin.googleapis.com

# Créer l'instance PostgreSQL
gcloud sql instances create vehicledb \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --network=default

# Créer la base de données
gcloud sql databases create vehicledb --instance=vehicledb

# Créer l'utilisateur
gcloud sql users create postgres \
  --instance=vehicledb \
  --password=VotreMotDePasse123!

# Obtenir la connection name
gcloud sql instances describe vehicledb

# Autoriser toutes les IPs (pour le dev)
gcloud sql instances patch vehicledb \
  --authorized-networks=0.0.0.0/0
```

---

## 🚀 Étape 5: Déployer le Backend (Cloud Run)

```bash
cd backend

# Activer les APIs nécessaires
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Définir le projet
export PROJECT_ID="votre-project-id"
gcloud config set project $PROJECT_ID

# Builder et déployer
gcloud builds submit --tag gcr.io/$PROJECT_ID/vehicle-backend

# Déployer sur Cloud Run
gcloud run deploy vehicle-backend \
  --image gcr.io/$PROJECT_ID/vehicle-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DATABASE_URL=postgresql://postgres:VotreMotDePasse123!@/[IP-CONNECTION]:5432/vehicledb"

# Notez l'URL retournée: https://vehicle-backend-xxx.run.app
export BACKEND_URL="https://vehicle-backend-xxx.run.app"
```

---

## 🚀 Étape 6: Configurer et Déployer le Frontend

```bash
cd frontend

# Créer le fichier .env.production
echo "REACT_APP_API_URL=$BACKEND_URL" > .env.production

# Build l'application
npm run build

# Déployer sur Firebase
firebase deploy --only hosting
```

Votre frontend sera accessible sur: `https://votre-projet.web.app`

---

## 🚀 Étape 7: Configurer Firebase Hosting (Opcionnel)

Créez un fichier `.firebaserc` dans `frontend/`:

```json
{
  "projects": {
    "default": "votre-project-id"
  }
}
```

---

## 🎯 Résumé des Commandes

### Déploiement Initial

```bash
# 1. Installer Firebase CLI
npm install -g firebase-tools

# 2. Se connecter
firebase login

# 3. Initialiser le projet
cd frontend
firebase init

# 4. Build et déployer
npm run build
firebase deploy --only hosting
```

### Mises à Jour Futures

```bash
# Backend
cd backend
gcloud builds submit --tag gcr.io/$PROJECT_ID/vehicle-backend
gcloud run deploy vehicle-backend --image gcr.io/$PROJECT_ID/vehicle-backend

# Frontend
cd frontend
npm run build
firebase deploy --only hosting
```

---

## 🌐 URLs Finales

- **Frontend**: https://votre-projet.web.app
- **Backend**: https://vehicle-backend-xxx.run.app
- **API Docs**: https://vehicle-backend-xxx.run.app/docs

---

## 💰 Coûts Firebase (Plan Spark - Gratuit)

- ✅ Firebase Hosting: **10 GB storage gratuit**
- ✅ Firebase Bandwidth: **10 GB/mois gratuit**
- ✅ Cloud Run: **Gratuit** (2M requêtes/mois)
- ✅ Cloud SQL: **~$7/mois** (db-f1-micro)

**Total: ~$7-10/mois**

---

## 📝 Configuration Firebase Hosting

### Structure du projet

```
frontend/
├── .firebaserc
├── firebase.json
├── public/
│   └── index.html
├── src/
├── build/          ← Déployé sur Firebase
└── package.json
```

### firebase.json complet

```json
{
  "hosting": {
    "public": "build",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(jpg|jpeg|gif|png)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=7200"
          }
        ]
      }
    ]
  }
}
```

---

## 🧪 Tester le Déploiement

```bash
# Backend
curl https://vehicle-backend-xxx.run.app/
curl https://vehicle-backend-xxx.run.app/garages

# Frontend (ouvrir dans le navigateur)
open https://votre-projet.web.app
```

---

## 🗑️ Nettoyer après la Soutenance

```bash
# Supprimer Cloud Run
gcloud run services delete vehicle-backend --region us-central1

# Supprimer Cloud SQL
gcloud sql instances delete vehicledb

# Supprimer Firebase Hosting (via console)
firebase hosting:channel:delete <channel-id>
```

---

## 🔧 Problèmes Courants

### Erreur: "Permission denied"
```bash
gcloud auth login
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:votre@email.com" \
  --role="roles/owner"
```

### Frontend ne se connecte pas au backend
Vérifier que `REACT_APP_API_URL` est bien configuré dans `.env.production`

### Base de données inaccessible
```bash
# Vérifier les IPs autorisées
gcloud sql instances describe vehicledb

# Ajouter votre IP
gcloud sql instances patch vehicledb \
  --authorized-networks=VOTRE-IP/32
```

---

## 📚 Ressources Firebase

- Documentation: https://firebase.google.com/docs/hosting
- Console: https://console.firebase.google.com
- CLI: `firebase --help`

---

## ✅ Checklist de Déploiement

- [ ] Firebase CLI installé
- [ ] Compte Firebase créé
- [ ] Projet Firebase initialisé
- [ ] Instance Cloud SQL créée
- [ ] Backend déployé sur Cloud Run
- [ ] Variables d'environnement configurées
- [ ] Frontend déployé sur Firebase Hosting
- [ ] Application testée
- [ ] URLs notées pour la documentation

---

## 🎓 Pour la Soutenance

Mentionnez:
- ✅ Firebase Hosting pour le frontend (gratuit, rapide, HTTPS)
- ✅ Cloud Run pour le backend (scalable, serveurless)
- ✅ Cloud SQL pour PostgreSQL (base de données managée)
- ✅ Architecture cloud-native

**Bon déploiement ! 🔥**


