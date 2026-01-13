# Guide de Déploiement Cloud

## Architecture de Déploiement

```
┌─────────────┐
│   Frontend  │ (Vercel/Netlify)
│   React     │
└─────────────┘
       │
       ▼
┌─────────────┐
│   Backend   │ (AWS App Runner / Cloud Run)
│   FastAPI   │
└─────────────┘
       │
       ▼
┌─────────────┐
│ PostgreSQL  │ (RDS / Cloud SQL)
└─────────────┘
```

## Déploiement Local

### Avec Docker Compose

```bash
docker-compose up -d
```

- Frontend: http://localhost:3000
- Backend: http://localhost:8000
- API Docs: http://localhost:8000/docs

### Sans Docker

#### Backend
```bash
cd backend
pip install -r requirements.txt
export DATABASE_URL="postgresql://user:pass@localhost:5432/dbname"
uvicorn main:app --reload
```

#### Frontend
```bash
cd frontend
npm install
export REACT_APP_API_URL="http://localhost:8000"
npm start
```

## Déploiement Cloud AWS

### Prérequis
- Compte AWS
- AWS CLI configuré
- Docker Hub account

### 1. Base de données RDS

```bash
aws rds create-db-instance \
  --db-instance-identifier vehicledb \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username admin \
  --master-user-password YourPassword \
  --allocated-storage 20
```

### 2. Backend sur AWS App Runner

1. Créer un Dockerfile (déjà présent)
2. Push vers Docker Hub
3. Créer service App Runner depuis la console AWS
4. Configurer les variables d'environnement:
   - DATABASE_URL
   - CORS_ORIGINS

### 3. Frontend sur Vercel

```bash
cd frontend
npm install -g vercel
vercel
```

Configurer les variables d'environnement:
- REACT_APP_API_URL: URL du backend déployé

## Déploiement sur GCP

### 1. Cloud SQL (PostgreSQL)

```bash
gcloud sql instances create vehicledb \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=europe-west1
```

### 2. Cloud Run (Backend)

```bash
cd backend
gcloud builds submit --tag gcr.io/PROJECT_ID/vehicle-backend
gcloud run deploy vehicle-backend \
  --image gcr.io/PROJECT_ID/vehicle-backend \
  --platform managed \
  --region europe-west1
```

### 3. Frontend sur Cloud Storage + CDN

```bash
cd frontend
npm run build
gsutil rsync -r build/ gs://vehicle-frontend-bucket
```

## Secrets et Variables d'Environnement

### Backend
- DATABASE_URL: Connection string PostgreSQL
- CORS_ORIGINS: Origins autorisées
- ENVIRONMENT: production/development

### Frontend
- REACT_APP_API_URL: URL de l'API backend

## Monitoring

### CloudWatch (AWS)
- Logs automatiques via ECS/App Runner
- Dashboard custom pour métriques API

### Cloud Monitoring (GCP)
- Logs via Cloud Run
- Alertes sur erreurs 5xx

## CI/CD

GitHub Actions configuré pour:
- Tests automatiques
- Build Docker images
- Push vers registries
- Déploiement automatique sur push main

## URLs de Test

- Production: https://your-app.vercel.app
- API: https://your-backend.run.app
- Docs API: https://your-backend.run.app/docs

