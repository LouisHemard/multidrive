# Checklist Projet - À Faire

## ✅ Développement Local (Terminé)
- [x] Structure du projet créée
- [x] Backend FastAPI fonctionnel
- [x] Frontend React créé
- [x] Base de données PostgreSQL configurée
- [x] Docker Compose configuré
- [x] Interface utilisateur complète

## 📝 Pour la Production

### 1. Préparer le déploiement
- [ ] Créer compte AWS/GCP/Azure
- [ ] Configurer CLI cloud (aws-cli, gcloud, az-cli)
- [ ] Créer bucket S3 / Cloud Storage pour frontend
- [ ] Créer instance RDS / Cloud SQL pour PostgreSQL

### 2. Variables d'environnement
- [ ] Ajouter secrets GitHub Actions:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `DOCKER_USERNAME`
  - `DOCKER_PASSWORD`

### 3. CI/CD
- [ ] Push du code sur GitHub
- [ ] Vérifier que les workflows GitHub Actions passent
- [ ] Personnaliser le workflow de déploiement si besoin

### 4. Déploiement Cloud
- [ ] Déployer base de données PostgreSQL
  ```bash
  # AWS
  aws rds create-db-instance ...

  # GCP
  gcloud sql instances create vehicledb ...
  ```

- [ ] Déployer backend
  ```bash
  # AWS
  aws apprunner create-service ...

  # GCP
  gcloud run deploy vehicle-backend ...
  ```

- [ ] Déployer frontend
  ```bash
  # Vercel
  vercel --prod

  # Netlify
  netlify deploy --prod
  ```

### 5. Monitoring
- [ ] Configurer CloudWatch / Cloud Monitoring
- [ ] Créer des alarmes
- [ ] Configurer les logs

### 6. Documentation finale
- [ ] Mettre à jour README avec URLs de production
- [ ] Créer screenshot de l'application
- [ ] Préparer slides de présentation

## 🎯 Pour la Soutenance

### Présentation (15-20 min)
- [ ] Introduction (2 min)
- [ ] Architecture (5 min)
- [ ] Démo de l'application (5 min)
- [ ] CI/CD et déploiement (3 min)
- [ ] Monitoring (2 min)
- [ ] Conclusion et Q&A (3 min)

### Préparez
- [ ] Code source sur GitHub
- [ ] Application déployée accessible via URL
- [ ] Schémas d'architecture (SCHÉMA.md)
- [ ] Documentation complète
- [ ] Slides de présentation

## 🚀 Bonus (Optionnel)
- [ ] Authentification utilisateurs
- [ ] Upload d'images de véhicules
- [ ] Cache avec Redis
- [ ] Tests automatisés (unitaires, intégration)
- [ ] Infrastructure as Code (Terraform)
- [ ] Auto-scaling configuré

