# 🎬 Guide de Démonstration

## Scénario de Démo (10 minutes)

Ce guide vous aide à présenter votre application de manière fluide et professionnelle.

---

## 🎯 Objectif de la Démo

Montrer que l'application est **fonctionnelle**, **cloud-ready**, et **bien architecturée**.

---

## 📋 Préparation

### 1. Avant la Démo
```bash
# Démarrer l'application
docker-compose up -d

# Vérifier que tout fonctionne
curl http://localhost:8000/garages
```

### 2. Ouvrir les fenêtres
- **Terminal 1**: Logs Docker (`docker-compose logs -f`)
- **Terminal 2**: Commandes de test
- **Navigateur**: http://localhost:3000
- **Navigateur 2**: http://localhost:8000/docs

---

## 🎬 Scénario de Démo

### Partie 1: Interface Utilisateur (3 min)

**Séquence 1.1: Présenter l'interface**
- Ouvrir http://localhost:3000
- Montrer le header "Gestion de Véhicules"
- Expliquer la sidebar avec les garages
- Montrer que 2 garages sont déjà créés automatiquement

**Séquence 1.2: Ajouter un véhicule**
```
1. Cliquer sur "Garage Central"
2. Cliquer sur "Ajouter un véhicule"
3. Remplir:
   - Marque: Toyota
   - Modèle: Corolla
   - Année: 2023
   - Plaque: AA-123-BB
4. Cliquer sur "Ajouter"
5. Montrer que le véhicule apparaît dans la liste
```

**Séquence 1.3: Changer de garage**
```
1. Cliquer sur "Garage Auto"
2. Montrer que la liste est vide
3. Expliquer que les véhicules sont liés aux garages
```

**Séquence 1.4: Ajouter un véhicule dans le 2ème garage**
```
1. Ajouter un véhicule dans "Garage Auto"
   - Marque: Honda
   - Modèle: Civic
   - Année: 2022
   - Plaque: BB-456-CC
2. Montrer les deux garages avec leurs véhicules
```

---

### Partie 2: API Backend (2 min)

**Séquence 2.1: Documentation Swagger**
- Ouvrir http://localhost:8000/docs
- Montrer la documentation interactive
- Expliquer les endpoints disponibles

**Séquence 2.2: Test d'API manuel**
- Dans la terminal, exécuter:
```bash
# Lister les garages
curl http://localhost:8000/garages

# Lister les véhicules
curl http://localhost:8000/vehicles

# Véhicules d'un garage spécifique
curl http://localhost:8000/garages/1/vehicles
```

**Séquence 2.3: Test d'ajout via API**
```bash
curl -X POST http://localhost:8000/vehicles \
  -H "Content-Type: application/json" \
  -d '{
    "brand":"BMW",
    "model":"X5",
    "year":2023,
    "license_plate":"CC-789-DD",
    "garage_id":1
  }'
```

Montrer que le véhicule apparaît dans l'interface.

---

### Partie 3: Architecture & Cloud (3 min)

**Séquence 3.1: Architecture**
- Ouvrir `SCHÉMA.md` ou `ARCHITECTURE.md`
- Expliquer:
  ```
  Frontend (React) → Backend (FastAPI) → PostgreSQL
        ↓                 ↓                    ↓
    Vercel         Cloud Run/App Runner    RDS/Cloud SQL
  ```

**Séquence 3.2: Docker & Conteneurisation**
```bash
# Voir les conteneurs
docker ps

# Voir les logs
docker-compose logs backend
```

Expliquer que:
- Chaque service est conteneurisé
- Facilement déployable dans le cloud
- Isolement des dépendances

**Séquence 3.3: CI/CD**
- Ouvrir `.github/workflows/ci-cd.yml`
- Expliquer la pipeline:
  - Tests automatiques
  - Build des images Docker
  - Déploiement automatique

**Séquence 3.4: Base de données**
```bash
# Accéder à PostgreSQL
docker-compose exec db psql -U postgres -d vehicledb

# Dans PostgreSQL:
\dt                    # Voir les tables
SELECT * FROM garages;
SELECT * FROM vehicles;
\q                     # Quitter
```

---

### Partie 4: Fonctionnalités Avancées (2 min)

**Séquence 4.1: Validation des données**
- Tester une plaque en double (devrait échouer)
- Tester un garage inexistant (devrait échouer)

**Séquence 4.2: Suppression**
- Supprimer un véhicule
- Vérifier qu'il disparaît

**Séquence 4.3: Interface responsive**
- Réduire la taille de la fenêtre
- Montrer que l'interface s'adapte

---

## 🎯 Points à Mettre en Avant

✅ **Architecture propre**
- Séparation claire frontend/backend
- API REST bien structurée
- Base de données relationnelle

✅ **Cloud Native**
- Conteneurisé avec Docker
- Prêt pour le déploiement cloud
- Scalable horizontalement

✅ **CI/CD Automatisé**
- Pipeline GitHub Actions
- Tests automatiques
- Déploiement continu

✅ **Code de qualité**
- Framework moderne (FastAPI, React)
- Validation des données
- Documentation auto-générée

✅ **Expérience utilisateur**
- Interface moderne
- Fonctionnalités intuitives
- Responsive

---

## 📊 Timing Recommandé

| Partie | Durée | Contenu |
|--------|-------|---------|
| Intro | 2 min | Présentation du projet |
| Démo UI | 3 min | Interface utilisateur |
| Démo API | 2 min | Backend et API |
| Architecture | 3 min | Architecture et cloud |
| Q&A | Reste | Questions |

**Total: 15-20 minutes**

---

## 🎤 Script de Présentation

### Introduction (30 sec)
_"Bonjour, je vais vous présenter mon projet de gestion de véhicules. C'est une application web cloud-native qui permet de gérer des véhicules dans différents garages."_

### Architecture (1 min)
_"L'application utilise une architecture moderne: Frontend en React, Backend en FastAPI, et PostgreSQL. Tout est conteneurisé avec Docker et prêt pour le déploiement cloud."_

### Démonstration (5 min)
_[Suivre le scénario ci-dessus]_

### Code & CI/CD (2 min)
_"L'application est versionnée sur GitHub avec une pipeline CI/CD. Chaque commit déclenche des tests et un déploiement automatique."_

### Conclusion (1 min)
_"Cette application démontre ma maîtrise du cloud: architecture scalable, déploiement automatisé, et utilisation de services managés."_

---

## ✅ Checklist Avant la Démo

- [ ] Application démarrée (`docker-compose up -d`)
- [ ] Navigation testée (Frontend accessible)
- [ ] API fonctionne (Tests curl OK)
- [ ] Données initiales présentes (2 garages)
- [ ] Terminal prêt pour démonstrations
- [ ] Navigateur avec onglets ouverts
- [ ] Documentation accessible (`ARCHITECTURE.md`, `SCHÉMA.md`)
- [ ] Relecture du timing

---

## 🎬 Plan B (Si Problème)

**Si l'application ne démarre pas:**
1. Montrer le code (`backend/main.py`, `frontend/src/App.js`)
2. Expliquer l'architecture avec les schémas
3. Montrer les workflows GitHub Actions
4. Parler du déploiement cloud prévu

**Si la DB est vide:**
1. Expliquer que normalement 2 garages sont créés
2. Ajouter des données manuellement
3. Continuer la démo

---

## 💡 Conseils

✅ **Préparez-vous**
- Testez tout avant la soutenance
- Préparez vos réponses aux questions courantes
- Ayez un plan B

✅ **Montrez votre maîtrise**
- Expliquez les choix techniques
- Parlez des défis rencontrés
- Montrez que vous savez pourquoi vous avez fait ça

✅ **Restez calme**
- Parlez lentement et clairement
- N'hésitez pas à demander si vous ne comprenez pas une question
- Vous connaissez votre projet!

---

**Bonne chance pour votre soutenance! 🚀**

