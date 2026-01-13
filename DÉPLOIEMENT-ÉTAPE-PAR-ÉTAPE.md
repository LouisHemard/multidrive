# 🚀 Déploiement - Guide Étape par Étape

## ✅ Ce qui est déjà fait
- [x] Firebase CLI installé
- [x] Connecté à Firebase
- [x] Projet créé: **garagerouge**

## 📋 Reste à faire

### Étape 1: Créer la Base de Données PostgreSQL (5 min)

```bash
# Activer l'API SQL Admin
gcloud services enable sqladmin.googleapis.com

# Créer l'instance PostgreSQL
gcloud sql instances create vehicledb \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=us-central1

# Créer la base de données
gcloud sql databases create vehicledb --instance=vehicledb

# Créer l'utilisateur
gcloud sql users create postgres \
  --instance=vehicledb \
  --password=VotreMotDePasse123!

# Autoriser les connexions
gcloud sql instances patch vehicledb \
  --authorized-networks=0.0.0.0/0

# Obtenir la connection name
gcloud sql instances describe vehicledb | grep connectionName
```

### Étape 2: Initialiser Firebase Hosting (2 min)

```bash
cd frontend

# Initialiser Firebase
firebase init

# Sélectionnez:
# ✓ Hosting: Configure files for Firebase Hosting
# ✓ Use an existing project: garagerouge
# Public directory: build
# Single-page app: Yes
# Automatic builds: Yes
```

### Étape 3: Déployer le Backend (5 min)

```bash
cd ../backend

# Activer les APIs nécessaires
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Créer un fichier .env.production avec vos identifiants
cat > .env << EOF
DATABASE_URL=postgresql://postgres:VotreMotDePasse123!@/[CONNECTION-NAME]:5432/vehicledb
EOF

# Builder et déployer
gcloud builds submit --tag gcr.io/garagerouge/vehicle-backend

# Déployer sur Cloud Run
gcloud run deploy vehicle-backend \
  --image gcr.io/garagerouge/vehicle-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DATABASE_URL=postgresql://postgres:VotreMotDePasse123!@/[CONNECTION-NAME]:5432/vehicledb"

# Notez l'URL retournée (ex: https://vehicle-backend-xxx.run.app)
export BACKEND_URL="https://vehicle-backend-xxx.run.app"
```

### Étape 4: Configurer le Frontend (2 min)

```bash
cd ../frontend

# Créer le fichier .env.production
echo "REACT_APP_API_URL=$BACKEND_URL" > .env.production

# Build
npm run build
```

### Étape 5: Déployer le Frontend (1 min)

```bash
firebase deploy --only hosting
```

🎉 **C'est fait !** Votre app est sur: `https://garagerouge.web.app`

---

## 🔧 Commandes Utiles

```bash
# Voir les logs
firebase logs:open

# Redéployer après modifications
npm run build && firebase deploy --only hosting

# Vérifier le déploiement
curl https://garagerouge.web.app
```

---

## ⚠️ Attention

Pour que la base de données fonctionne, vous devez:
1. Créer l'instance Cloud SQL
2. Remplacer `[CONNECTION-NAME]` par la vraie valeur
3. Mettre le bon mot de passe partout

---

## ✅ Checklist

- [ ] Instance PostgreSQL créée
- [ ] Backend déployé sur Cloud Run
- [ ] Frontend déployé sur Firebase
- [ ] Variables d'environnement configurées
- [ ] Application testée



