# Gestion de Véhicules - Application Cloud

Application web pour gérer des véhicules dans différents garages.

## Architecture

- **Frontend**: React (Interface utilisateur)
- **Backend**: FastAPI (API REST)
- **Base de données**: PostgreSQL
- **Deployment**: Docker + Cloud (AWS/GCP/Azure)
- **CI/CD**: GitHub Actions

## Fonctionnalités

- Liste des garages
- Gestion des véhicules par garage
- Ajout/Modification/Suppression de véhicules
- Interface simple et moderne

## Déploiement

### Prérequis
- Docker
- Docker Compose
- PostgreSQL

### Lancement local

```bash
# Backend
cd backend
pip install -r requirements.txt
uvicorn main:app --reload

# Frontend
cd frontend
npm install
npm start
```

### Avec Docker

```bash
docker-compose up
```

L'application sera accessible sur http://localhost:3000

## Services Cloud

- **Frontend**: Déployé sur Vercel/Netlify
- **Backend**: Déployé sur AWS App Runner / Cloud Run
- **Base de données**: PostgreSQL managé (RDS/Cloud SQL)
- **Storage**: S3/Bucket pour images
- **CI/CD**: GitHub Actions

## Monitoring

- Logs via CloudWatch
- Métriques de performance
- Dashboard basique

# Test CI/CD Pipeline - Tue Jan 13 15:06:42 CET 2026
