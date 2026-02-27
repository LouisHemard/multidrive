MultiDrive - Gestion de flotte de véhicules
===========================================

## 1. But du projet

MultiDrive est une application de **gestion de flotte de véhicules** pour une entreprise ou une organisation :

- **Créer / lister les garages**
- **Créer / lister / modifier / supprimer les véhicules**
- **Déplacer un véhicule d’un garage à un autre**
- Exposer un **backend API** consommé par un **frontend web**.

L’objectif pédagogique est de montrer une architecture **cloud-native** avec :

- Un **backend FastAPI** conteneurisé et déployé sur **Google Cloud Run**
- Un **frontend React** déployé sur **Vercel**
- Une base de données **PostgreSQL** gérée (Supabase)
- Une **CI/CD GitHub Actions** pour tester, builder et déployer automatiquement.

---

## 2. Architecture choisie

### 2.1 Vue d’ensemble

Architecture logique de MultiDrive :

```
                 Utilisateur
                (navigateur)
                     |
                     v
          Frontend React (Vercel)
                     |
     REACT_APP_API_URL = URL Cloud Run
                     |
                     v
        Backend FastAPI (Cloud Run)
     - Service : multidrive-backend
     - Image : gcr.io/multidrive-484209/multidrive-backend
                     |
                     v
          PostgreSQL (Supabase Cloud)
```

### 2.2 Détail des composants

- **Frontend**
  - Framework : **React**
  - Hébergement : **Vercel**
  - Variable d’environnement principale :
    - `REACT_APP_API_URL` : URL publique du backend Cloud Run.

- **Backend**
  - Framework : **FastAPI**
  - Exposé via **Uvicorn** dans un conteneur Docker
  - Hébergement : **Google Cloud Run**
  - Variables d’environnement (Cloud Run) :
    - `DATABASE_URL` : URL de connexion PostgreSQL Supabase
    - `CORS_ORIGINS` : origines autorisées (URL du frontend en production).

- **Base de données**
  - **PostgreSQL** géré par **Supabase**
  - Contient les tables :
    - `garages`
    - `vehicles`
  - Accessible uniquement via `DATABASE_URL` (port transaction pooler recommandé).

- **CI/CD**
  - Plateforme : **GitHub Actions**
  - Fichier : `.github/workflows/ci-cd.yml`
  - Jobs principaux :
    - `test-backend` : installe les dépendances Python, vérifie que l’app FastAPI démarre.
    - `test-frontend` : installe les dépendances Node, build le frontend.
    - `build-backend` : build + push de l’image Docker du backend dans **GCR** (`gcr.io/multidrive-484209/multidrive-backend`).
    - `deploy-backend` : déploiement du service **Cloud Run** `multidrive-backend`.
    - `build-frontend` : build du frontend (les artefacts peuvent être utilisés pour Vercel).

---

## 3. Services utilisés

- **Google Cloud Platform**
  - **Cloud Run** : exécution du backend FastAPI conteneurisé.
  - **Artifact Registry / GCR** : stockage des images Docker du backend.
  - **Cloud Logging** : centralisation des logs du service Cloud Run.
  - **Cloud Monitoring** : métriques et tableaux de bord (latence, nombre de requêtes, erreurs…).

- **Vercel**
  - Hébergement du **frontend React**.
  - Connecté au dépôt GitHub pour déployer automatiquement sur push.

- **Supabase**
  - Base de données **PostgreSQL managée**.
  - Dashboard pour gérer les tables, policies, SQL, etc.

- **GitHub**
  - Hébergement du **code source**.
  - **GitHub Actions** pour la pipeline CI/CD.

---

## 4. Instructions de déploiement

### 4.1 Prérequis

- Compte **Google Cloud** avec un projet configuré (`multidrive-484209` dans cet exemple).
- Compte **Supabase** avec une instance PostgreSQL créée.
- Compte **Vercel**.
- Un dépôt **GitHub** avec le code du projet.

### 4.2 Déploiement du backend (Cloud Run)

1. **Configurer les secrets GitHub** dans les *Settings* du dépôt → **Secrets and variables → Actions** :
   - `GCP_SA_KEY` : contenu JSON de la clé de compte de service GCP utilisée par GitHub Actions.
   - `DATABASE_URL` : URL de connexion PostgreSQL fournie par Supabase (port pooler si utilisé).
   - `CORS_ORIGINS` : URL du frontend (ex. `https://ton-projet.vercel.app`).

2. Vérifier la configuration de `.github/workflows/ci-cd.yml` :
   - `GCP_PROJECT_ID` = `multidrive-484209`
   - `GCP_REGION` = `europe-west1`
   - `BACKEND_SERVICE` = `multidrive-backend`

3. **Pousser sur la branche `main`** :
   - Le push déclenche automatiquement la pipeline :
     - Tests backend & frontend
     - Build de l’image Docker backend
     - Déploiement du service Cloud Run.

4. Récupérer l’**URL publique Cloud Run** :
   - Console GCP → **Cloud Run** → service `multidrive-backend` → copier l’URL.

### 4.3 Déploiement du frontend (Vercel)

1. Aller sur https://vercel.com et se connecter (compte GitHub).
2. **Add New Project** → importer le dépôt GitHub du projet.
3. Configurer le projet :
   - **Root Directory** : `frontend` (ou laisser la racine si le dépôt ne contient que le frontend ; si monorepo, indiquer `frontend`).
   - **Framework Preset** : Create React App (détecté automatiquement).
   - **Build Command** : `npm run build`
   - **Output Directory** : `build`
4. **Environment Variables** :
   - `REACT_APP_API_URL` = URL publique du backend Cloud Run (ex. `https://multidrive-backend-565974867635.europe-west1.run.app`).
5. Déployer : chaque push sur la branche connectée (ex. `main`) déclenche un déploiement automatique.
6. Récupérer l’URL de prod (ex. `https://multidrive-xxx.vercel.app`) et la mettre dans le secret GitHub `CORS_ORIGINS` si le backend restreint les origines CORS.

### 4.4 Configuration de la base de données Supabase

1. Créer un projet Supabase depuis le dashboard.
2. Récupérer l’URL de connexion PostgreSQL (`DATABASE_URL`).
3. Créer les tables nécessaires (exemple simplifié) :

```sql
CREATE TABLE garages (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE vehicles (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  brand TEXT,
  garage_id INTEGER REFERENCES garages(id) ON DELETE SET NULL
);
```

4. Vérifier que `DATABASE_URL` utilisé par le backend pointe bien sur cette base.

---

## 5. Comptes / identifiants de test

Selon la configuration actuelle :

- **API backend**
  - Dans la version de base, l’API est accessible **sans authentification utilisateur** (Cloud Run configuré en `--allow-unauthenticated`).
  - Aucun compte spécifique n’est requis pour tester les routes depuis le frontend.

- **Base de données**
  - L’accès direct à Supabase se fait avec les identifiants générés par Supabase (non exposés dans le README).
  - Pour les tests locaux, il suffit de renseigner une `DATABASE_URL` valide (locale ou Supabase) dans les variables d’environnement.

- **Accès démo**
  - Tu peux documenter ici une URL de démo (frontend) et une éventuelle route de test (ex. `/health` sur le backend) si tu en ajoutes une.

Exemple (à adapter) :

- **Frontend (prod)** : `https://ton-projet.vercel.app`
- **Backend (prod)** : `https://multidrive-backend-xxxx.europe-west1.run.app`

---

## 6. Schéma d’architecture

Schéma ASCII récapitulatif (déployé) :

```
                        +-------------------------+
                        |     Utilisateur        |
                        |   (navigateur web)     |
                        +-----------+------------+
                                    |
                                    v
                        +-------------------------+
                        |   Frontend React        |
                        |      (Vercel)           |
                        +-----------+-------------+
                                    |
                         REACT_APP_API_URL (HTTPS)
                                    |
                                    v
                        +-------------------------+
                        |   Backend FastAPI       |
                        |  Cloud Run (GCP)        |
                        +-----------+-------------+
                                    |
                       DATABASE_URL (PostgreSQL)
                                    |
                                    v
                        +-------------------------+
                        |   Supabase PostgreSQL   |
                        +-------------------------+
```

Monitoring & observabilité (non détaillé dans le schéma) :

- Logs backend → **Cloud Logging**
- Métriques (requêtes, latence, erreurs) → **Cloud Monitoring**
- Tableau de bord personnalisable dans l’onglet **Monitoring** du projet GCP.

---

## 7. Démarrage local (optionnel)

Pour lancer le projet en local (exemple générique) :

1. **Backend**
   - Configurer `DATABASE_URL` (soit vers Supabase, soit vers un PostgreSQL local).
   - Depuis le dossier `backend` :

```bash
python -m venv .venv
source .venv/bin/activate  # sous Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

2. **Frontend**
   - Depuis le dossier `frontend` :

```bash
npm install
npm start
```

3. Ouvrir le navigateur sur l’URL du frontend local (en général `http://localhost:3000`) et vérifier que les appels vers l’API fonctionnent (adapter la variable `REACT_APP_API_URL` si besoin).

