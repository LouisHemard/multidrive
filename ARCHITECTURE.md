# Architecture du Projet

## Vue d'ensemble

Application de gestion de véhicules avec architecture cloud-native.

## Stack Technique

### Frontend
- **Framework**: React 18
- **Language**: JavaScript
- **Build**: React Scripts
- **Container**: Docker + Alpine Node
- **Deploy**: Vercel / Netlify

### Backend
- **Framework**: FastAPI
- **Language**: Python 3.11
- **Database**: PostgreSQL 15
- **ORM**: SQLAlchemy
- **Container**: Docker + Python Slim
- **Deploy**: AWS App Runner / GCP Cloud Run

### Infrastructure
- **DB**: PostgreSQL (RDS / Cloud SQL)
- **Storage**: S3 / Cloud Storage (pour images futures)
- **CI/CD**: GitHub Actions
- **Monitoring**: CloudWatch / Cloud Monitoring

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   Frontend                      │
│                   (React)                       │
│               vercel.app / s3                   │
└──────────────────┬──────────────────────────────┘
                   │ HTTPS
                   ▼
┌─────────────────────────────────────────────────┐
│                    Backend                      │
│                  (FastAPI)                      │
│            app-runner / cloud-run               │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│                 PostgreSQL                      │
│                (RDS / SQL)                      │
└─────────────────────────────────────────────────┘
```

## Services Utilisés

### Cloud Services
1. **Base de données gérée**: RDS PostgreSQL ou Cloud SQL
2. **Conteneurisation**: Docker
3. **Orchestration**: Docker Compose (local), ECS/Cloud Run (production)
4. **Storage**: S3 pour assets (futur)
5. **CDN**: CloudFront/Cloud CDN (futur)

### CI/CD
- **GitHub Actions**: Pipeline automatique
- **Docker Hub**: Registry des images
- **Automatic Deploy**: Push sur main branch

## Flux de Déploiement

```
Dev → Git Push → GitHub Actions → Tests → Build Docker → 
Push Registry → Deploy Cloud → Update DB
```

## Sécurité

- Variables d'environnement pour secrets
- CORS configuré
- HTTPS uniquement
- Validation des données (Pydantic)

## Scalabilité

- Architecture stateless (backend)
- Load balancing via cloud provider
- Auto-scaling configuré
- Base de données gérée (backups automatiques)

## Monitoring

- Logs: CloudWatch / Cloud Logging
- Métriques: Request rate, latency
- Alerts: Erreurs 5xx, downtime

## Coûts Estimés

- **AWS**: ~$30-50/mois
- **GCP**: ~$30-50/mois
- **Vercel**: Gratuit (tier free)

## Évolutions Futures

- Authentification utilisateurs
- Upload d'images
- Notifications
- Multi-tenant
- API GraphQL
- Mobile app

