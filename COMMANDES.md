# Commandes Utiles

## Développement Local

### Démarrer l'application
```bash
# Méthode 1: Script automatique
./run.sh

# Méthode 2: Docker Compose
docker-compose up -d
```

### Voir les logs
```bash
# Tous les services
docker-compose logs -f

# Backend seulement
docker-compose logs -f backend

# Frontend seulement
docker-compose logs -f frontend
```

### Rebuild après modification
```bash
docker-compose up -d --build
```

### Arrêter l'application
```bash
docker-compose down

# Supprimer les volumes (données)
docker-compose down -v
```

### Accéder à la base de données
```bash
docker-compose exec db psql -U postgres -d vehicledb

# Dans psql:
\dt          # Lister les tables
\d garages   # Décrire une table
SELECT * FROM garages;
\q           # Quitter
```

## Tests API

### Liste des garages
```bash
curl http://localhost:8000/garages
```

### Ajouter un garage
```bash
curl -X POST http://localhost:8000/garages \
  -H "Content-Type: application/json" \
  -d '{"name":"Mon Garage","address":"123 Rue Test"}'
```

### Liste des véhicules
```bash
curl http://localhost:8000/vehicles
```

### Ajouter un véhicule
```bash
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{
    "brand":"Toyota",
    "model":"Corolla",
    "year":2023,
    "license_plate":"AA-123-BB",
    "garage_id":1
  }'
```

### Supprimer un véhicule
```bash
curl -X DELETE http://localhost:8000/vehicles/1
```

### Véhicules d'un garage
```bash
curl http://localhost:8000/garages/1/vehicles
```

## Dépannage

### Problème de port déjà utilisé
```bash
# Voir qui utilise le port
lsof -i :3000  # Frontend
lsof -i :8000  # Backend
lsof -i :5432  # Database

# Tuer le processus
kill -9 <PID>
```

### Réinitialiser la base de données
```bash
docker-compose down -v
docker-compose up -d
```

### Voir les conteneurs
```bash
docker ps
docker-compose ps
```

### Accéder à un conteneur
```bash
docker-compose exec backend bash
docker-compose exec frontend sh
```

### Nettoyer Docker
```bash
# Supprimer les images inutilisées
docker image prune

# Tout nettoyer (ATTENTION!)
docker system prune -a
```

## Production

### Build des images
```bash
cd backend
docker build -t vehicle-backend:latest .

cd frontend
docker build -t vehicle-frontend:latest .
```

### Push vers Docker Hub
```bash
docker login
docker tag vehicle-backend:latest username/vehicle-backend:latest
docker push username/vehicle-backend:latest
```

### Déploiement sur AWS App Runner
```bash
# Créer le service
aws apprunner create-service \
  --service-name vehicle-backend \
  --source-image pull.username/vehicle-backend

# Voir les logs
aws apprunner describe-service --service-arn <arn>
```

## CI/CD

### Vérifier les workflows GitHub Actions
```bash
# Localement (avec act)
act push

# Sur GitHub
# Allez sur https://github.com/<repo>/actions
```

### Secrets GitHub
Allez sur: Settings → Secrets and variables → Actions

Ajouter:
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Monitoring

### Logs en temps réel
```bash
# CloudWatch (AWS)
aws logs tail /aws/apprunner/vehicle-backend --follow

# Cloud Run (GCP)
gcloud logging read --follow
```

### Métriques
```bash
# AWS
aws cloudwatch get-metric-statistics ...

# GCP
gcloud monitoring metrics list
```

