# Guide de Test

## Tests Manuels

### 1. Démarrer l'application

```bash
docker-compose up -d
```

Attendre que tous les services soient prêts (~10 secondes)

### 2. Vérifier le backend

#### Documentations API
Visitez http://localhost:8000/docs pour la documentation interactive Swagger

#### Healthcheck
```bash
curl http://localhost:8000/
```
Devrait retourner: `{"message":"Vehicle Management API"}`

#### Lister les garages
```bash
curl http://localhost:8000/garages
```
Devrait retourner un JSON avec 2 garages (initialisés au démarrage)

### 3. Vérifier le frontend

Visitez http://localhost:3000

Vous devriez voir:
- Header "Gestion de Véhicules"
- Sidebar avec 2 garages
- Zone de contenu principale

### 4. Tests Fonctionnels

#### Test 1: Ajouter un véhicule

1. Cliquer sur "Ajouter un véhicule"
2. Remplir le formulaire:
   - Marque: Toyota
   - Modèle: Corolla
   - Année: 2023
   - Plaque: AA-123-BB
3. Cliquer sur "Ajouter"

Vérifier: Le véhicule apparaît dans la liste

#### Test 2: Changer de garage

1. Cliquer sur un autre garage dans la sidebar
2. Vérifier que la liste des véhicules change
3. Les véhicules précédents ne sont plus visibles

#### Test 3: Supprimer un véhicule

1. Cliquer sur "Supprimer" sur un véhicule
2. Confirmer la suppression
3. Vérifier que le véhicule disparaît de la liste

### 5. Tests API

#### Créer un garage via API
```bash
curl -X POST http://localhost:8000/garages \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Garage Test",
    "address": "789 Test Street"
  }'
```

#### Créer un véhicule via API
```bash
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "Honda",
    "model": "Civic",
    "year": 2022,
    "license_plate": "HH-456-HH",
    "garage_id": 1
  }'
```

#### Lister les véhicules d'un garage
```bash
curl http://localhost:8000/garages/1/vehicles
```

#### Supprimer un véhicule
```bash
curl -X DELETE http://localhost:8000/vehicles/1
```

### 6. Tests de Validation

#### Test: Plaque déjà existante (erreur attendue)
```bash
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "BMW",
    "model": "X5",
    "year": 2023,
    "license_plate": "AA-123-BB",
    "garage_id": 1
  }'
```
Devrait retourner une erreur car la plaque existe déjà

#### Test: Garage inexistant (erreur attendue)
```bash
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{
    "brand": "Audi",
    "model": "A4",
    "year": 2023,
    "license_plate": "XX-999-XX",
    "garage_id": 999
  }'
```
Devrait retourner 404: "Garage not found"

## Tests de Performance

### Load Test (si Apache Bench installé)

```bash
# Test sur l'endpoint de listing
ab -n 100 -c 10 http://localhost:8000/garages

# Test sur l'endpoint de véhicules
ab -n 100 -c 10 http://localhost:8000/vehicles
```

## Tests d'Intégration

1. Stopper tous les services: `docker-compose down`
2. Relancer: `docker-compose up -d`
3. Vérifier que les données persistent (garages restent)
4. Vérifier que les véhicules ajoutés précédemment sont toujours là

## Checklist de Validation

- [ ] Backend répond sur http://localhost:8000
- [ ] Frontend s'affiche sur http://localhost:3000
- [ ] 2 garages sont visibles au démarrage
- [ ] Ajout de véhicule fonctionne
- [ ] Suppression de véhicule fonctionne
- [ ] Changement de garage fonctionne
- [ ] API retourne les bonnes données
- [ ] Validation des doublons fonctionne
- [ ] Validation des données invalides fonctionne
- [ ] Pas d'erreurs dans la console du navigateur
- [ ] Pas d'erreurs dans les logs Docker

