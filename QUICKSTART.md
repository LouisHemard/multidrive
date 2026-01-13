# Guide de démarrage rapide

## Installation et lancement

### Prérequis
- Docker et Docker Compose installés
- Git

### Étapes

1. **Cloner le projet**
```bash
git clone <url-du-repo>
cd vehicle-management
```

2. **Lancer l'application**
```bash
docker-compose up -d
```

3. **Accéder à l'application**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Documentation API: http://localhost:8000/docs
- Dashboard BDD (Adminer): http://localhost:8080

4. **Arrêter l'application**
```bash
docker-compose down
```

## Données de test

Le système crée automatiquement 2 garages au démarrage:
- Garage Central (123 Rue Principale)
- Garage Auto (456 Avenue Auto)

Vous pouvez ajouter des véhicules via l'interface web.

## Commandes utiles

```bash
# Voir les logs
docker-compose logs -f

# Rebuild après modification
docker-compose up -d --build

# Accéder à la base de données (ligne de commande)
docker-compose exec db psql -U postgres -d vehicledb

# Accéder au dashboard web (Adminer)
# Ouvrir http://localhost:8080
# Système: PostgreSQL
# Serveur: db
# Utilisateur: postgres
# Mot de passe: postgres
# Base de données: vehicledb

# Supprimer tout (données incluses)
docker-compose down -v
```

## Structure du projet

```
vehicle-management/
├── backend/          # API FastAPI
│   ├── main.py      # Code principal
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/         # React App
│   ├── src/
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml
├── README.md
└── ARCHITECTURE.md
```

## Tests manuels

### API Backend
```bash
# Lister les garages
curl http://localhost:8000/garages

# Ajouter un véhicule
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{"brand":"Toyota","model":"Corolla","year":2023,"license_plate":"ABC-123","garage_id":1}'
```

## Déploiement

Voir DEPLOYMENT.md pour les instructions de déploiement cloud.

