# MultiDrive

Application de gestion de flotte de vehicules (garages + vehicules) avec frontend React et backend FastAPI.

## Objectif

Le projet permet de :
- creer, lister, modifier et supprimer des garages ;
- creer, lister, modifier et supprimer des vehicules ;
- deplacer un vehicule vers un autre garage ;
- exposer une API REST et une interface web.

## Stack technique

- Frontend : React (Create React App), Axios
- Backend : FastAPI, SQLAlchemy, Uvicorn
- Base de donnees : PostgreSQL (local Docker ou Supabase)
- Conteneurisation : Docker / Docker Compose
- CI/CD : GitHub Actions
- Hebergement prod :
  - frontend sur Vercel
  - backend sur Google Cloud Run
  - base de donnees sur Supabase

## Architecture

```text
Utilisateur (navigateur)
        |
        v
Frontend React (Vercel / localhost:3001)
        |
        v
Backend FastAPI (Cloud Run / localhost:8000)
        |
        v
PostgreSQL (Supabase en prod, conteneur db en local)
```

## URLs utiles

### Local
- Frontend : `http://localhost:3001`
- Backend API : `http://localhost:8000`
- Swagger : `http://localhost:8000/docs`
- Endpoint test : `http://localhost:8000/garages`

### Production (actuel)
- Backend : `https://multidrive-backend-565974867635.europe-west1.run.app`
- Frontend : URL Vercel de ton projet

## Lancer le projet en local (recommande)

Depuis la racine du projet :

```bash
docker compose up -d db backend frontend
```

Verifier :

```bash
docker compose ps
docker compose logs --tail=100 backend frontend
```

Arreter :

```bash
docker compose down
```

## Variables d'environnement

### Local (docker-compose)

- `DATABASE_URL` (optionnel)  
  Par defaut, le backend utilise la base locale Docker :  
  `postgresql://postgres:postgres@db:5432/vehicledb`

- `CORS_ORIGINS` (optionnel)  
  Valeur par defaut : `http://localhost:3001`

- `REACT_APP_API_URL` (build frontend Docker)  
  Valeur par defaut : `http://localhost:8000`

Tu peux creer un fichier `.env` a la racine si besoin (exemple dans `.env.example`).

### Production (GitHub Secrets)

Dans `Settings > Secrets and variables > Actions` :

- `GCP_SA_KEY` : cle JSON du service account GCP
- `DATABASE_URL` : URL PostgreSQL Supabase
- `CORS_ORIGINS` : URL du frontend Vercel

## Deploiement

## Backend (Cloud Run via GitHub Actions)

Le workflow `.github/workflows/ci-cd.yml` :
1. teste backend et frontend ;
2. build l'image Docker backend ;
3. push l'image ;
4. deploie sur Cloud Run.

Un push sur `main` declenche le process.

## Frontend (Vercel)

1. Importer le repo GitHub dans Vercel.
2. Configurer le root directory sur `frontend`.
3. Ajouter la variable :
   - `REACT_APP_API_URL=https://multidrive-backend-565974867635.europe-west1.run.app`
4. Deployer.

## API principale

### Garages
- `GET /garages`
- `POST /garages`
- `GET /garages/{id}`
- `PUT /garages/{id}`
- `DELETE /garages/{id}`
- `GET /garages/{id}/vehicles`

### Vehicules
- `GET /vehicles`
- `POST /vehicles`
- `PUT /vehicles/{id}`
- `DELETE /vehicles/{id}`

## Depannage rapide

### Les garages ne s'affichent pas sur le frontend

Verifier :
1. `http://localhost:8000/garages` repond bien.
2. Le frontend est bien build avec `REACT_APP_API_URL=http://localhost:8000`.
3. Rebuild frontend :

```bash
docker compose up -d --build frontend
```

### Erreur Supabase "Tenant or user not found"

Ta `DATABASE_URL` Supabase est invalide (project ref, user ou mot de passe incorrect).
Reprendre l'URL depuis Supabase (transaction pooler port `6543`) et mettre a jour la valeur.

## Comptes / identifiants de test

- Pas de compte utilisateur applicatif requis (pas d'auth metier actuellement).
- Acces techniques requis :
  - compte GitHub,
  - compte GCP,
  - compte Vercel,
  - compte Supabase.

Ne jamais versionner de secrets dans le repo.

