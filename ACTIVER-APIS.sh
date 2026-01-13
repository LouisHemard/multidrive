#!/bin/bash
# Script pour activer les APIs nécessaires sur Google Cloud

echo "🔧 Activation des APIs Google Cloud..."

# Vérifier que le projet est configuré
PROJECT=$(gcloud config get-value project)
echo "📋 Projet actif: $PROJECT"

# Activer Cloud Run API
echo "📦 Activation de Cloud Run API..."
gcloud services enable run.googleapis.com --project=$PROJECT

# Activer Cloud Build API
echo "📦 Activation de Cloud Build API..."
gcloud services enable cloudbuild.googleapis.com --project=$PROJECT

# Vérifier les APIs activées
echo ""
echo "✅ APIs activées :"
gcloud services list --enabled --project=$PROJECT | grep -E "run\.googleapis\.com|cloudbuild\.googleapis\.com"

echo ""
echo "🎉 Configuration terminée !"

