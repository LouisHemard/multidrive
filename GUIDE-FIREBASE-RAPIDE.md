# 🔥 Déploiement Firebase - Guide Rapide

## 🎯 En 7 Étapes Simples

### 1️⃣ Installer Firebase CLI (2 min)

```bash
npm install -g firebase-tools
firebase login
```

### 2️⃣ Créer un projet Firebase (5 min)

1. Allez sur https://console.firebase.google.com
2. "Ajouter un projet"
3. Nom: `vehicle-management`
4. Activez Google Analytics (optionnel)
5. Notez l'ID du projet

### 3️⃣ Initialiser Firebase (2 min)

```bash
cd frontend
firebase init

# Sélectionnez:
# ✓ Hosting
# ✓ Use an existing project → votre-projet
# ✓ build comme public directory
# ✓ Configure as single-page app: Yes
```

### 4️⃣ Créer la Base de Données (5 min)

```bash
# Créer l'instance PostgreSQL
gcloud sql instances create vehicledb \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=us-central1

# Créer la DB
gcloud sql databases create vehicledb --instance=vehicledb

# Créer l'utilisateur
gcloud sql users create postgres \
  --instance=vehicledb \
  --password=VotreMotDePasse123!

# Autoriser les connexions
gcloud sql instances patch vehicledb \
  --authorized-networks=0.0.0.0/0
```

### 5️⃣ Déployer le Backend (5 min)

```bash
cd backend

# Obtenir le PROJECT_ID
export PROJECT_ID=$(gcloud config get-value project)

# Builder et déployer
gcloud builds submit --tag gcr.io/$PROJECT_ID/vehicle-backend

# Déployer sur Cloud Run
gcloud run deploy vehicle-backend \
  --image gcr.io/$PROJECT_ID/vehicle-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DATABASE_URL=postgresql://postgres:VotreMotDePasse123!@/[IP]:5432/vehicledb"

# Copier l'URL (ex: https://vehicle-backend-xxx.run.app)
```

### 6️⃣ Configurer le Frontend (2 min)

```bash
cd frontend

# Créer .env.production
echo "REACT_APP_API_URL=https://vehicle-backend-xxx.run.app" > .env.production

# Build
npm run build
```

### 7️⃣ Déployer le Frontend (2 min)

```bash
firebase deploy --only hosting
```

🎉 **C'est fait !** Votre app est sur: `https://your-project.web.app`

---

## 📝 Commandes Utiles

```bash
# Voir les logs
firebase logs:open

# Déployer une mise à jour
npm run build && firebase deploy --only hosting

# Revenir à une version précédente
firebase hosting:channel:list
```

---

## ✅ Votre Application

- **Frontend**: https://your-project.web.app
- **Backend**: https://vehicle-backend-xxx.run.app
- **API Docs**: https://vehicle-backend-xxx.run.app/docs

---

## 💡 Astuce

Pour un déploiement encore plus rapide, utilisez:
- Frontend: Vercel (gratuit, 1 commande)
- Backend: Railway (gratuit, inclut la DB)

Voir: Déploiement rapide sans config

---

Bon déploiement ! 🔥


