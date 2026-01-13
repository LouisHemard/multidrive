# ☁️ Guide de Déploiement Cloud - Étapes Détaillées

## 🎯 Objectif

Déployer votre application sur AWS ou Google Cloud pour la soutenance.

---

## 🏆 Option 1: Google Cloud Platform (GCP) - Recommandé

### Pourquoi GCP ?
- ✅ Gratuit pendant 90 jours (300$ de crédits)
- ✅ Plus simple pour commencer
- ✅ Cloud Run gratuit jusqu'à 2 millions de requêtes/mois
- ✅ Cloud SQL - instance gratuite possible

### Étape 1: Créer un compte GCP

1. Allez sur https://console.cloud.google.com
2. Créez un compte Google (ou connectez-vous)
3. Activez la facturation (nécessaire mais utilisation limitée = gratuite)
4. Créez un projet → "vehicle-management"

### Étape 2: Installer Google Cloud SDK

```bash
# macOS
brew install --cask google-cloud-sdk

# Ou télécharger depuis:
# https://cloud.google.com/sdk/docs/install

# Se connecter
gcloud auth login
```

### Étape 3: Déployer la Base de Données (Cloud SQL)

```bash
# Créer une instance PostgreSQL
gcloud sql instances create vehicledb \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=europe-west1

# Créer une base de données
gcloud sql databases create vehicledb --instance=vehicledb

# Créer un utilisateur (gardez le mot de passe!)
gcloud sql users create postgres \
  --instance=vehicledb \
  --password=VotreMotDePasse123!

# Obtenir l'IP de connexion
gcloud sql instances describe vehicledb

# Notez la valeur de "connectionName"
```

### Étape 4: Déployer le Backend (Cloud Run)

```bash
# Se placer dans le dossier backend
cd backend

# Builder l'image Docker
docker build -t gcr.io/[PROJECT-ID]/vehicle-backend .

# Push vers Google Container Registry
gcloud builds submit --tag gcr.io/[PROJECT-ID]/vehicle-backend

# Déployer sur Cloud Run
gcloud run deploy vehicle-backend \
  --image gcr.io/[PROJECT-ID]/vehicle-backend \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --set-env-vars="DATABASE_URL=postgresql://postgres:VotreMotDePasse123!@/[IP-CONNECTION]:5432/vehicledb"

# Notez l'URL retournée: https://vehicle-backend-xxx.run.app
```

### Étape 5: Déployer le Frontend

#### Option A: Sur Cloud Storage + CDN

```bash
cd frontend

# Build
npm run build

# Copier vers Cloud Storage
gsutil mb gs://vehicle-frontend-bucket
gsutil rsync -r build/ gs://vehicle-frontend-bucket

# Configurer le site statique
gsutil web set -m index.html -e index.html gs://vehicle-frontend-bucket
```

#### Option B: Sur Vercel (Plus Simple)

```bash
cd frontend

# Installer Vercel CLI
npm i -g vercel

# Déployer
vercel --prod

# Configurer la variable d'environnement
# Dans Vercel Dashboard → Settings → Environment Variables:
# REACT_APP_API_URL = https://vehicle-backend-xxx.run.app
```

### Étape 6: Tester

Votre application sera accessible via:
- Frontend: URL Vercel ou Cloud Storage
- Backend: URL Cloud Run
- API Docs: URL Cloud Run + /docs

---

## 🏆 Option 2: Amazon Web Services (AWS)

### Pourquoi AWS ?
- ✅ Services très complets
- ✅ Cloud Watch inclus
- ✅ Conçu pour la production

### Étape 1: Créer un compte AWS

1. Allez sur https://aws.amazon.com
2. Créez un compte
3. Configurez la facturation
4. Créez un utilisateur IAM avec accès complet

### Étape 2: Installer AWS CLI

```bash
# macOS
brew install awscli

# Se connecter
aws configure
# Entrez vos credentials
```

### Étape 3: Créer la Base de Données (RDS)

```bash
# Créer une instance PostgreSQL
aws rds create-db-instance \
  --db-instance-identifier vehicledb \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username postgres \
  --master-user-password VotreMotDePasse123! \
  --allocated-storage 20 \
  --vpc-security-group-ids sg-xxxxx

# Attendre la création (5-10 min)
aws rds describe-db-instances --db-instance-identifier vehicledb
```

### Étape 4: Déployer le Backend (App Runner ou ECS)

#### Option A: App Runner (Plus Simple)

```bash
# Créer un repository ECR
aws ecr create-repository --repository-name vehicle-backend

# Login
aws ecr get-login-password | docker login --username AWS --password-stdin [ACCOUNT-ID].dkr.ecr.[REGION].amazonaws.com

# Push l'image
docker build -t vehicle-backend .
docker tag vehicle-backend:latest [ACCOUNT-ID].dkr.ecr.[REGION].amazonaws.com/vehicle-backend:latest
docker push [ACCOUNT-ID].dkr.ecr.[REGION].amazonaws.com/vehicle-backend:latest

# Créer le service App Runner
aws apprunner create-service \
  --service-name vehicle-backend \
  --source-configuration file://apprunner.yaml
```

#### Option B: Elastic Beanstalk

```bash
# Installer EB CLI
pip install awsebcli

# Initialiser
cd backend
eb init -p python

# Créer l'environnement
eb create vehicle-backend-env
```

### Étape 5: Déployer le Frontend

```bash
# Créer un bucket S3
aws s3 mb s3://vehicle-frontend-bucket

# Upload
cd frontend
npm run build
aws s3 sync build/ s3://vehicle-frontend-bucket

# Configurer comme site web statique
aws s3 website s3://vehicle-frontend-bucket \
  --index-document index.html \
  --error-document index.html
```

### Étape 6: Configurer CloudFront (CDN)

```bash
# Créer une distribution CloudFront
aws cloudfront create-distribution \
  --origin-domain-name vehicle-frontend-bucket.s3.amazonaws.com
```

---

## 📋 Checklist de Déploiement

### Avant de commencer
- [ ] Compte cloud créé
- [ ] SDK installé (gcloud ou aws cli)
- [ ] Docker fonctionnel
- [ ] Projet fonctionne en local

### Déploiement
- [ ] Base de données créée
- [ ] Backend déployé
- [ ] Frontend déployé
- [ ] Variables d'environnement configurées
- [ ] URLs testées

### Après déploiement
- [ ] Application accessible publiquement
- [ ] API fonctionne
- [ ] Frontend se connecte au backend
- [ ] Documentation mise à jour avec les URLs

---

## 💰 Coûts Estimés

### GCP (Référence)
- Cloud Run: Gratuit (2M requêtes/mois)
- Cloud SQL db-f1-micro: ~$7/mois (premier mois gratuit)
- **Total estimé: $0-10/mois**

### AWS (Référence)
- App Runner: ~$15-30/mois
- RDS db.t3.micro: ~$13/mois
- S3: ~$1/mois
- **Total estimé: $30-45/mois**

**Note**: N'oubliez pas de supprimer les ressources après la soutenance!

---

## 🔐 Variables d'Environnement

### Backend
```
DATABASE_URL=postgresql://user:pass@host:5432/dbname
CORS_ORIGINS=https://votre-frontend.com
ENVIRONMENT=production
```

### Frontend
```
REACT_APP_API_URL=https://votre-backend.run.app
```

---

## 🧪 Tester le Déploiement

```bash
# Backend
curl https://votre-backend.run.app/
curl https://votre-backend.run.app/garages

# Frontend
# Ouvrir https://votre-app.vercel.app
```

---

## 🗑️ Nettoyer les Ressources

### GCP
```bash
gcloud run services delete vehicle-backend
gcloud sql instances delete vehicledb
gsutil rm -r gs://vehicle-frontend-bucket
```

### AWS
```bash
aws apprunner delete-service --service-arn <arn>
aws rds delete-db-instance --db-instance-identifier vehicledb
aws s3 rb s3://vehicle-frontend-bucket --force
```

---

## 📚 Ressources Utiles

- GCP: https://cloud.google.com/docs
- AWS: https://docs.aws.amazon.com
- Cloud Run: https://cloud.google.com/run/docs
- App Runner: https://docs.aws.amazon.com/apprunner

---

## 🆘 Support

En cas de problème:
1. Vérifier les logs: `gcloud logs read` ou CloudWatch
2. Vérifier les variables d'environnement
3. Tester l'API avec curl
4. Consulter la documentation officielle

**Bon déploiement ! 🚀**

