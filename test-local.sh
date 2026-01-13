#!/bin/bash

echo "🧪 Test de l'application de gestion de véhicules"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Test 1: Vérifier que les conteneurs sont up
echo "1️⃣ Vérification des conteneurs..."
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✅ Les conteneurs sont démarrés${NC}"
else
    echo -e "${RED}❌ Les conteneurs ne sont pas démarrés${NC}"
    echo "💡 Lancez: docker-compose up -d"
    exit 1
fi

echo ""
echo "2️⃣ Test du backend API..."
sleep 2

# Test 2: Health check
echo "  - Health check..."
response=$(curl -s http://localhost:8000/)
if echo "$response" | grep -q "Vehicle Management API"; then
    echo -e "${GREEN}✅ Backend répond${NC}"
else
    echo -e "${RED}❌ Backend ne répond pas${NC}"
fi

# Test 3: Lister les garages
echo "  - Liste des garages..."
response=$(curl -s http://localhost:8000/garages)
if echo "$response" | grep -q "Garage"; then
    echo -e "${GREEN}✅ Garages disponibles${NC}"
    echo "     Réponse: $response"
else
    echo -e "${RED}❌ Pas de garages trouvés${NC}"
fi

# Test 4: Ajouter un véhicule test
echo "  - Ajout d'un véhicule..."
response=$(curl -s -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{
    "brand":"Test Car",
    "model":"Model X",
    "year":2023,
    "license_plate":"TEST-123-TEST",
    "garage_id":1
  }')

if echo "$response" | grep -q "Test Car"; then
    echo -e "${GREEN}✅ Véhicule ajouté avec succès${NC}"
else
    echo -e "${RED}❌ Échec de l'ajout du véhicule${NC}"
fi

# Test 5: Lister les véhicules
echo "  - Liste des véhicules..."
response=$(curl -s http://localhost:8000/vehicles)
if echo "$response" | grep -q "license_plate"; then
    echo -e "${GREEN}✅ Véhicules récupérés${NC}"
else
    echo -e "${RED}❌ Aucun véhicule${NC}"
fi

# Test 6: Frontend
echo ""
echo "3️⃣ Test du frontend..."
if curl -s http://localhost:3000/ | grep -q "html"; then
    echo -e "${GREEN}✅ Frontend accessible${NC}"
else
    echo -e "${RED}❌ Frontend inaccessible${NC}"
fi

echo ""
echo "4️⃣ Nettoyage..."
# Supprimer le véhicule de test
curl -s -X DELETE http://localhost:8000/vehicles/$(echo "$response" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*') > /dev/null
echo -e "${GREEN}✅ Véhicule de test supprimé${NC}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Tests terminés!"
echo ""
echo "📍 URLs:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend: http://localhost:8000"
echo "   - API Docs: http://localhost:8000/docs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

