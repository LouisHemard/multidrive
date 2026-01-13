# Schéma d'Architecture - Gestion de Véhicules

## Architecture Cloud Native

```
┌──────────────────────────────────────────────────────────────────┐
│                          FRONTEND                                 │
│                      (React + Vercel)                             │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Interface Utilisateur                                    │   │
│  │  - Liste des garages                                      │   │
│  │  - Gestion des véhicules                                  │   │
│  │  - Ajout/Suppression véhicules                            │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                         │ HTTPS/REST API
                         │
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│                          BACKEND                                  │
│                    (FastAPI + Cloud Run)                          │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  API REST                                                 │   │
│  │  - GET /garages                                           │   │
│  │  - POST /vehicles                                         │   │
│  │  - DELETE /vehicles/:id                                   │   │
│  │  - GET /garages/:id/vehicles                              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  ORM (SQLAlchemy)                                        │   │
│  │  - Modèles Garage, Vehicle                               │   │
│  │  - Relations Many-to-One                                  │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                         │ SQL Query
                         │
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│                      BASE DE DONNÉES                             │
│                   (PostgreSQL - RDS/Cloud SQL)                   │
│                                                                   │
│  ┌────────────────────┐    ┌──────────────────────┐            │
│  │    garages         │    │    vehicles           │            │
│  ├────────────────────┤    ├──────────────────────┤            │
│  │ id (PK)            │◄───│ garage_id (FK)        │            │
│  │ name               │    │ id (PK)               │            │
│  │ address            │    │ brand                 │            │
│  └────────────────────┘    │ model                 │            │
│                             │ year                  │            │
│                             │ license_plate (UNIQUE)│            │
│                             └──────────────────────┘            │
└──────────────────────────────────────────────────────────────────┘
```

## Flux de Données

### 1. Affichage des Garages
```
User → Frontend → API: GET /garages → Backend → Database → PostgreSQL
                                           ↓
User ← Frontend ← API Response ← Backend ← Database ← PostgreSQL
```

### 2. Ajout d'un Véhicule
```
User → Frontend → API: POST /vehicles → Backend → Validation
                                                 ↓
                                    Database → INSERT INTO vehicles
                                                 ↓
User ← Frontend ← API Response ← Backend ← Database
```

### 3. Suppression d'un Véhicule
```
User → Frontend → API: DELETE /vehicles/:id → Backend
                                                   ↓
                                    Database → DELETE FROM vehicles
                                                   ↓
User ← Frontend ← Success ← Backend ← Database
```

## Infrastructure Cloud

```
┌─────────────────────────────────────────────────────────────┐
│                      CI/CD Pipeline                          │
│                  (GitHub Actions)                            │
│                                                              │
│  Push → Tests → Build Docker Images → Deploy                 │
└──────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────┐
│                      CLOUD DEPLOYMENT                        │
│                                                              │
│  ┌─────────────┐    ┌─────────────┐   ┌─────────────┐     │
│  │   Vercel    │    │ Cloud Run   │   │ Cloud SQL   │     │
│  │ (Frontend)  │◄──►│  (Backend)  │◄─►│(PostgreSQL) │     │
│  │             │    │             │   │             │     │
│  └─────────────┘    └─────────────┘   └─────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## Sécurité

```
┌───────────────────────────────────────────────────────────┐
│  HTTPS/TLS                                                 │
│  - Certificats SSL automatiques (Let's Encrypt)          │
│  - Chiffrement des données en transit                     │
└───────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────┐
│  Variables d'Environnement                                 │
│  - DATABASE_URL (secret)                                  │
│  - API Keys                                                │
│  - Credentials                                             │
└───────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────┐
│  Validation des Données                                    │
│  - Pydantic schemas                                        │
│  - SQLAlchemy models                                       │
│  - CORS configuration                                      │
└───────────────────────────────────────────────────────────┘
```

## Monitoring & Observabilité

```
┌─────────────────────────────────────────────────────────┐
│  CloudWatch / Cloud Monitoring                          │
│                                                         │
│  - Logs: Request/Response                              │
│  - Métriques: Latency, Throughput                      │
│  - Alertes: Erreurs 5xx, Downtime                     │
└─────────────────────────────────────────────────────────┘
```

## Scalabilité

- **Horizontal Scaling**: Load Balancer → Multiples instances
- **Database**: Connection pooling, Read replicas
- **Caching**: Redis (futur)
- **CDN**: CloudFront pour assets statiques

