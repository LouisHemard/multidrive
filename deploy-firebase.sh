#!/bin/bash

# Script de déploiement Firebase automatique
# Usage: ./deploy-firebase.sh

set -e  # Arrêter en cas d'erreur

echo "🔥 Déploiement Firebase - Gestion de Véhicules"
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}⚠️  Firebase CLI non trouvé${NC}"
    echo "Installation..."
    npm install -g firebase-tools
fi

# Vérifier que gcloud est installé
if ! command -v gcloud &> /dev/null; then
    echo -e "${YELLOW}⚠️  Google Cloud SDK non trouvé${NC}"
    echo "Installation..."
    brew install --cask google-cloud-sdk
fi

echo -e "${GREEN}✅ Outils installés${NC}"
echo ""

# Se placer dans le dossier frontend
cd frontend

# Vérifier si Firebase est initialisé
if [ ! -f ".firebaserc" ]; then
    echo -e "${YELLOW}⚠️  Firebase non initialisé${NC}"
    echo "Lancement de firebase init..."
    firebase init
fi

echo ""
echo "🏗️  Building de l'application..."
npm run build

echo ""
echo "🚀 Déploiement sur Firebase Hosting..."
firebase deploy --only hosting

echo ""
echo -e "${GREEN}✅ Déploiement terminé!${NC}"
echo ""
echo "🌐 Votre application est accessible sur:"
echo "   $(firebase hosting:channel:list 2>/dev/null | head -n 5)"
echo ""
echo "Pour voir les logs: firebase logs:open"


