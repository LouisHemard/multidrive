#!/bin/bash

# Script de déploiement automatique complet
# Usage: ./deploy-all.sh

set -e  # Arrêter en cas d'erreur

echo "🚀 Déploiement automatique - Gestion de Véhicules"
echo "================================================"
echo ""

# Variables
PROJECT_ID="garagerouge"
GCP_PROJECT_ID="garagerouge"  # Même ID que Firebase
REGION="us-central1"
DB_PASSWORD="VehiclePass123!"  # À changer en production!
INSTANCE_NAME="vehicledb"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}📋 Étapes du déploiement:${NC}"
echo "1. Créer la base de données PostgreSQL"
echo "2. Déployer le backend sur Cloud Run"
echo "3. Configurer le frontend"
echo "4. Déployer le frontend sur Firebase"
echo ""

# read -p "Appuyez sur Entrée pour continuer (Ctrl+C pour annuler)..."

# Étape 1: Activer les APIs nécessaires
echo ""
echo -e "${GREEN}✅ Étape 1/4: Activation des APIs...${NC}"
gcloud config set project $GCP_PROJECT_ID
gcloud services enable sqladmin.googleapis.com --quiet
gcloud services enable run.googleapis.com --quiet
gcloud services enable cloudbuild.googleapis.com --quiet
echo "OK"

# Étape 2: Créer la base de données
echo ""
echo -e "${GREEN}✅ Étape 2/4: Création de la base de données...${NC}"
echo "Cela peut prendre 2-3 minutes..."

if gcloud sql instances describe $INSTANCE_NAME &>/dev/null; then
    echo "Instance SQL existe déjà"
else
    gcloud sql instances create $INSTANCE_NAME \
      --database-version=POSTGRES_15 \
      --tier=db-f1-micro \
      --region=$REGION \
      --quiet
    echo "Instance créée"
fi

# Créer la base de données
gcloud sql databases create vehicledb --instance=$INSTANCE_NAME --quiet 2>/dev/null || echo "Base de données existe déjà"

# Créer l'utilisateur
gcloud sql users create postgres \
  --instance=$INSTANCE_NAME \
  --password=$DB_PASSWORD \
  --quiet 2>/dev/null || echo "Utilisateur existe déjà"

# Autoriser les connexions
gcloud sql instances patch $INSTANCE_NAME \
  --authorized-networks=0.0.0.0/0 \
  --quiet

# Obtenir la connection name
CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME --format="value(connectionName)")
echo "Connection Name: $CONNECTION_NAME"

# Construire la connection string
DATABASE_URL="postgresql://postgres:$DB_PASSWORD@$CONNECTION_NAME/$INSTANCE_NAME"

echo "Base de données prête!"

# Étape 3: Déployer le backend
echo ""
echo -e "${GREEN}✅ Étape 3/4: Déploiement du backend...${NC}"

cd backend

# Builder l'image
echo "Build de l'image Docker..."
gcloud builds submit --tag gcr.io/$GCP_PROJECT_ID/vehicle-backend --quiet

# Déployer sur Cloud Run
echo "Déploiement sur Cloud Run..."
gcloud run deploy vehicle-backend \
  --image gcr.io/$GCP_PROJECT_ID/vehicle-backend \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --set-env-vars "DATABASE_URL=$DATABASE_URL" \
  --quiet

# Obtenir l'URL du backend
BACKEND_URL=$(gcloud run services describe vehicle-backend --region=$REGION --format="value(status.url)")
echo "Backend déployé: $BACKEND_URL"

# Étape 4: Déployer le frontend
echo ""
echo -e "${GREEN}✅ Étape 4/4: Déploiement du frontend...${NC}"

cd ../frontend

# Créer .env.production
echo "REACT_APP_API_URL=$BACKEND_URL" > .env.production

# Build
echo "Build de l'application React..."
npm run build

# Initialiser Firebase si nécessaire
if [ ! -f ".firebaserc" ]; then
    echo "Initialisation de Firebase..."
    echo "{\"projects\":{\"default\":\"$PROJECT_ID\"}}" > .firebaserc
fi

# Déployer
echo "Déploiement sur Firebase Hosting..."
firebase deploy --only hosting --project $PROJECT_ID --non-interactive

echo ""
echo -e "${GREEN}✅ Déploiement terminé!${NC}"
echo ""
echo "🌐 URLs de votre application:"
echo "   Frontend: https://$PROJECT_ID.web.app"
echo "   Backend: $BACKEND_URL"
echo "   API Docs: $BACKEND_URL/docs"
echo ""
echo "📊 Test:"
echo "   curl $BACKEND_URL/"
echo "   curl $BACKEND_URL/garages"
echo ""

