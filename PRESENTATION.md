# Présentation du Projet - Gestion de Véhicules

## 🎯 Objectif

Application web cloud-native pour gérer des véhicules dans différents garages.

## 🏗️ Architecture

```
                    ┌─────────────────────┐
                    │     Frontend        │
                    │   React App         │
                    │  (Port 3000)        │
                    └──────────┬──────────┘
                               │
                               │ HTTP/REST
                               │
                    ┌──────────▼──────────┐
                    │     Backend         │
                    │   FastAPI           │
                    │  (Port 8000)        │
                    └──────────┬──────────┘
                               │
                               │ SQL
                               │
                    ┌──────────▼──────────┐
                    │   PostgreSQL        │
                    │   (Port 5432)       │
                    └─────────────────────┘
```

## 🛠️ Technologies

### Frontend
- React 18
- HTML5/CSS3
- Axios pour API calls

### Backend
- FastAPI (Python 3.11)
- SQLAlchemy ORM
- PostgreSQL 15

### Infrastructure
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- Cloud ready (AWS/GCP/Azure)

## 📋 Fonctionnalités

1. ✅ Liste des garages
2. ✅ Gestion des véhicules par garage
3. ✅ Ajout de nouveaux véhicules
4. ✅ Suppression de véhicules
5. ✅ Interface moderne et responsive

## 🚀 Déploiement Cloud

### Services Utilisés

1. **Frontend**: Vercel ou Netlify
2. **Backend**: AWS App Runner / GCP Cloud Run
3. **Database**: RDS PostgreSQL / Cloud SQL

### CI/CD Pipeline

```
Git Push → GitHub Actions → Tests → Build Docker → 
Push Registry → Deploy Cloud → Monitor
```

## 📊 Critères de Soutenance

| Critère | Points | État |
|---------|--------|------|
| Architecture & Conception | /6 | ✅ Complété |
| Déploiement Cloud | /6 | ✅ Configuré |
| CI/CD | /4 | ✅ Pipeline prête |
| Monitoring & Observabilité | /2 | ⚠️ À déployer |
| Documentation & Présentation | /2 | ✅ Complété |

## 💰 Coûts Estimés

- **Développement local**: Gratuit
- **Cloud (AWS/GCP)**: ~$30-50/mois
- **Hébergement Frontend**: Gratuit (Vercel)

## 🎓 Points Clés à Présenter

1. **Architecture scalable** avec conteneurisation
2. **Séparation frontend/backend** pour déploiement indépendant
3. **API REST** avec documentation automatique (Swagger)
4. **Pipeline CI/CD** automatisée
5. **Prêt pour le cloud** avec Docker

## 📝 Notes pour la Soutenance

### Introduction (2 min)
- Présentation du projet
- Problématique: gestion de véhicules
- Stack technique

### Architecture (5 min)
- Schéma de l'architecture
- Choix techniques (FastAPI, React, PostgreSQL)
- Services cloud utilisés

### Démos (5 min)
- Interface utilisateur
- API fonctionnelle
- Déploiement local et cloud

### CI/CD (3 min)
- Pipeline GitHub Actions
- Tests automatiques
- Déploiement automatisé

### Conclusion (2 min)
- Points forts
- Évolutions futures
- Questions

**Total: 17 minutes** ✅ (Conforme au timing demandé)

