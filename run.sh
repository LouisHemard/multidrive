#!/bin/bash

echo "🚀 Démarrage de l'application de gestion de véhicules..."
echo ""

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

echo "🐳 Build des images Docker..."
docker-compose build

echo ""
echo "🚀 Démarrage des services..."
docker-compose up -d

echo ""
echo "⏳ Attente du démarrage complet..."
sleep 5

echo ""
echo "✅ Application démarrée!"
echo ""
echo "📍 Frontend: http://localhost:3000"
echo "📍 Backend API: http://localhost:8000"
echo "📍 Documentation API: http://localhost:8000/docs"
echo ""
echo "Pour arrêter: docker-compose down"
echo "Pour voir les logs: docker-compose logs -f"

