# 🚀 Déploiement Cloud en 5 Étapes

## 🎯 Démarrage Rapide avec Google Cloud

### Étape 1: Préparer l'Environnement (10 min)

```bash
# 1. Créer un compte GCP
# Allez sur: https://console.cloud.google.com

# 2. Installer les outils
brew install --cask google-cloud-sdk

# 3. Se connecter
gcloud auth login

# 4. Configurer le projet
export PROJECT_ID="votre-project-id"
gcloud config set project $PROJECT_ID
```

### Étape 2: Créer la Base de Données (10 min)

```bash
# Créer l'instance PostgreSQL
gcloud sql instances create vehicledb \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=europe-west1

# Créer la base de données
gcloud sql databases create vehicledb --instance=vehicledb

# Créer un utilisateur
gcloud sql users create postgres \
  --instance=vehicledb \
  --password=MonMotDePasse123!

# Noter la connection name pour plus tard
gcloud sql instances describe vehicledb | grep connectionName
```

### Étape 3: Déployer le Backend (5 min)

```bash
cd backend

# Builder l'image
docker build -t gcr.io/$PROJECT_ID/vehicle-backend .

# Push vers GCR
gcloud builds submit --tag gcr.io/$PROJECT_ID/vehicle-backend

# Déployer sur Cloud Run
gcloud run deploy vehicle-backend \
  --image gcr.io/$PROJECT_ID/vehicle-backend \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --set-env-vars DATABASE_URL="postgresql://postgres:MonMotDePasse123!@/[CONNECTION-NAME]:5432/vehicledb"

# Copier l'URL retournée (ex: https://vehicle-backend-xxx.run.app)
```

### Étape 4: Déployer le Frontend avec Vercel (5 min)

```bash
cd frontend

# Installer Vercel CLI
npm i -g vercel

# Build l'app
npm run build

# Déployer
vercel --prod

# Configurer la variable d'environnement dans Vercel Dashboard:
# REACT_APP_API_URL = [URL du backend de l'étape 3]
```

### Étape 5: Configurer l'Ip de la Database (5 min)

```bash
# Ajouter l'IP de Cloud Run aux ips autorisées
gcloud sql instances patch vehicledb \
  --authorized-networks=0.0.0.0/0

# OU plus sécurisé, ajouter seulement l'IP de Cloud Run
gcloud run services describe vehicle-backend --region europe-west1 | grep ingress
```

### ✅ C'est Fini !

Votre application est accessible via les URLs de Vercel.

---

## 📋 Checklist Simple

- [ ] Compte GCP créé
- [ ] gcloud CLI installé
- [ ] Instance SQL créée
- [ ] Backend déployé sur Cloud Run
- [ ] Frontend déployé sur Vercel
- [ ] Variables d'environnement configurées
- [ ] Application testée

---

## 💰 Coûts

- Cloud Run: **Gratuit** (2M requêtes/mois)
- Cloud SQL db-f1-micro: **~$7/mois** (premier mois gratuit)
- Vercel: **Gratuit**

**Total: $0-10/mois environ**

⚠️ Pensez à supprimer les ressources après la soutenance !

---

## 🗑️ Nettoyer (Après Soutenance)

```bash
# Supprimer Cloud Run
gcloud run services delete vehicle-backend --region europe-west1

# Supprimer Cloud SQL
gcloud sql instances delete vehicledb

# Docker images (via console GCP)
```

---

## 📚 Aide

Pour plus de détails, voir `DEPLOIEMENT-CLOUD.md`

