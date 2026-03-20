#!/bin/bash
echo "🔧 Activation des APIs Google Cloud..."

PROJECT=$(gcloud config get-value project)
echo "📋 Projet actif: $PROJECT"

echo "📦 Activation de Cloud Run API..."
gcloud services enable run.googleapis.com --project=$PROJECT

echo "📦 Activation de Cloud Build API..."
gcloud services enable cloudbuild.googleapis.com --project=$PROJECT

echo ""
echo "✅ APIs activées :"
gcloud services list --enabled --project=$PROJECT | grep -E "run\.googleapis\.com|cloudbuild\.googleapis\.com"

echo ""
echo "🎉 Configuration terminée !"

