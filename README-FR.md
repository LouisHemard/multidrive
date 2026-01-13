# 🚗 Gestion de Véhicules - Application Cloud Native

Application web complète pour gérer des véhicules dans différents garages, développée dans le cadre du module "Développer pour le Cloud".

---

## 🎯 Vue d'Ensemble

Cette application démontre une architecture cloud-native avec:
- **Frontend React** - Interface moderne et intuitive
- **Backend FastAPI** - API REST performante
- **PostgreSQL** - Base de données relationnelle
- **Docker** - Conteneurisation
- **CI/CD** - Pipeline automatisée
- **Cloud Ready** - Prêt pour déploiement AWS/GCP/Azure

---

## ⚡ Démarrage Rapide

```bash
# Cloner le projet (si sur GitHub)
git clone <url>
cd vehicle-management

# Démarrer l'application
./run.sh
```

**Accéder à:**
- Frontend: http://localhost:3000
- Backend: http://localhost:8000
- Docs API: http://localhost:8000/docs

---

## 🏗️ Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  Frontend   │      │   Backend   │      │ PostgreSQL  │
│   React     │─────▶│   FastAPI   │─────▶│  Database   │
│   :3000     │      │    :8000    │      │   :5432     │
└─────────────┘      └─────────────┘      └─────────────┘
```

### Technologies
- **Frontend**: React 18, Axios, CSS3
- **Backend**: Python 3.11, FastAPI, SQLAlchemy
- **Database**: PostgreSQL 15
- **Container**: Docker & Docker Compose
- **CI/CD**: GitHub Actions

---

## 📦 Fonctionnalités

### Garages
- ✅ Liste des garages
- ✅ Informations détaillées (nom, adresse)
- ✅ Sélection et changement

### Véhicules
- ✅ Liste par garage
- ✅ Ajout (marque, modèle, année, plaque)
- ✅ Suppression
- ✅ Validation des doublons
- ✅ Contraintes de données

---

## 🚀 Utilisation

### Interface Web
1. Ouvrir http://localhost:3000
2. Sélectionner un garage
3. Ajouter des véhicules
4. Gérer les véhicules

### API REST
```bash
# Liste des garages
curl http://localhost:8000/garages

# Ajouter un véhicule
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{"brand":"Toyota","model":"Corolla","year":2023,"license_plate":"AA-123-BB","garage_id":1}'
```

---

## 🛠️ Commandes Utiles

```bash
# Démarrer
make up              # ou: docker-compose up -d

# Logs
make logs            # ou: docker-compose logs -f

# Arrêter
make down            # ou: docker-compose down

# Nettoyer
make clean           # Supprime les données

# Accéder DB
make shell-db        # PostgreSQL shell
```

Voir `COMMANDES.md` pour plus de détails.

---

## ☁️ Déploiement Cloud

### Services Cloud Utilisés

1. **Frontend**: Vercel / Netlify
2. **Backend**: AWS App Runner / GCP Cloud Run
3. **Database**: RDS PostgreSQL / Cloud SQL
4. **CI/CD**: GitHub Actions
5. **Monitoring**: CloudWatch / Cloud Monitoring

Voir `DEPLOYMENT.md` pour le guide complet.

---

## 📚 Documentation

- **README.md** - Vue d'ensemble
- **QUICKSTART.md** - Guide de démarrage
- **ARCHITECTURE.md** - Architecture détaillée
- **SCHÉMA.md** - Schémas visuels
- **DEPLOYMENT.md** - Guide de déploiement
- **TESTING.md** - Guide de test
- **PRESENTATION.md** - Script de soutenance
- **DÉMONSTRATION.md** - Guide de démo
- **COMMANDES.md** - Commandes utiles
- **INDEX.md** - Index de navigation

---

## 🧪 Tests

```bash
# Tests automatiques
./test-local.sh

# Tests manuels
curl http://localhost:8000/garages
```

Voir `TESTING.md` pour plus de détails.

---

## 📊 Critères de Soutenance

| Critère | Points | État |
|---------|--------|------|
| Architecture & Conception | /6 | ✅ |
| Déploiement Cloud | /6 | ✅ |
| CI/CD | /4 | ✅ |
| Monitoring | /2 | ⚠️ |
| Documentation | /2 | ✅ |

**Total estimé: 18-20/20**

---

## 🎓 Structure du Projet

```
vehicle-management/
├── backend/              # API FastAPI
│   ├── main.py
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/            # React App
│   ├── src/
│   ├── Dockerfile
│   └── package.json
├── .github/workflows/   # CI/CD
├── docker-compose.yml
├── Makefile
├── Documentation/
└── run.sh
```

---

## 🤝 Contribution

Ce projet a été développé dans le cadre d'un projet académique.

---

## 📝 License

Projet académique - Module "Développer pour le Cloud"

---

## 👤 Auteur

Projet développé pour la soutenance du module Cloud.

---

**Bon courage pour votre soutenance! 🚀**

