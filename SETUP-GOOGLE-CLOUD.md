# ☁️ Configuration Google Cloud - Guide Complet

## 📋 Étapes pour Configurer Google Cloud

### Étape 1 : Créer un Compte Google Cloud

1. **Allez sur** : https://console.cloud.google.com
2. **Connectez-vous** avec votre compte Google (ou créez-en un)
3. **Acceptez les conditions** d'utilisation de Google Cloud

### Étape 2 : Activer la Facturation (Nécessaire)

⚠️ **Important** : Même pour le free tier, vous DEVEZ avoir une carte de crédit enregistrée.

1. Dans la console Google Cloud, cliquez sur le **menu hamburger** (☰) en haut à gauche
2. Allez dans **"Billing"** (Facturation)
3. Cliquez sur **"Link a billing account"** (Lier un compte de facturation)
4. Si vous n'avez pas de compte de facturation :
   - Cliquez sur **"Create billing account"**
   - Remplissez les informations (nom, pays, adresse)
   - Ajoutez une carte de crédit
   - Validez

✅ **Note** : Google Cloud offre **$300 de crédits gratuits** pour les nouveaux comptes (valables 90 jours). Cloud Run est gratuit jusqu'à 2 millions de requêtes/mois, donc vous ne devriez pas être facturé pour ce projet.

### Étape 3 : Créer un Projet (si vous n'avez pas encore "garagerouge")

Vous avez mentionné avoir un projet "garagerouge" (peut-être via Firebase). Vérifions :

1. Dans la console Google Cloud, en haut à gauche, cliquez sur le **sélecteur de projet**
2. Si vous voyez "garagerouge" → c'est bon, passez à l'étape 4
3. Si vous ne voyez pas "garagerouge" ou voulez créer un nouveau projet :

   **Créer un nouveau projet :**
   - Cliquez sur **"New Project"**
   - **Nom du projet** : `multidrive` (ou gardez "garagerouge" si vous préférez)
   - **Project ID** : Google génère un ID automatiquement (ex: `multidrive-123456`)
   - Cliquez sur **"Create"**
   - Attendez quelques secondes que le projet soit créé

### Étape 4 : Lier la Facturation au Projet

1. Allez dans **"Billing"** (menu hamburger → Billing)
2. Sélectionnez votre projet dans la liste
3. Si le projet n'est pas lié, cliquez sur **"Link billing account"**
4. Sélectionnez votre compte de facturation

### Étape 5 : Configurer gcloud CLI (Déjà Installé ✅)

Vous avez déjà gcloud installé, il faut juste se connecter :

```bash
# Se connecter à Google Cloud
gcloud auth login

# Cela ouvrira votre navigateur pour vous authentifier
# Acceptez les permissions
```

### Étape 6 : Configurer le Projet par Défaut

```bash
# Lister les projets disponibles
gcloud projects list

# Sélectionner votre projet (garagerouge ou multidrive)
gcloud config set project garagerouge
# OU si vous avez créé multidrive:
# gcloud config set project multidrive-XXXXXX

# Vérifier la configuration
gcloud config list
```

### Étape 7 : Activer les APIs Nécessaires

```bash
# Activer Cloud Run API (pour déployer le backend)
gcloud services enable run.googleapis.com

# Activer Cloud Build API (pour builder les images Docker)
gcloud services enable cloudbuild.googleapis.com

# Vérifier que les APIs sont activées
gcloud services list --enabled
```

### Étape 8 : Vérifier que Tout Fonctionne

```bash
# Vérifier que vous êtes bien connecté
gcloud auth list

# Vérifier le projet actif
gcloud config get-value project

# Vérifier la facturation (devrait afficher votre compte)
gcloud billing accounts list
```

---

## ✅ Checklist de Configuration

- [ ] Compte Google Cloud créé
- [ ] Facturation activée (avec carte de crédit)
- [ ] Projet créé (garagerouge ou multidrive)
- [ ] Facturation liée au projet
- [ ] gcloud CLI connecté (`gcloud auth login`)
- [ ] Projet configuré (`gcloud config set project`)
- [ ] APIs activées (Cloud Run, Cloud Build)
- [ ] Configuration vérifiée

---

## 🆘 Problèmes Courants

### "Billing account not in good standing"
- Vérifiez que votre carte de crédit est valide
- Vérifiez que la facturation est bien liée au projet
- Attendez quelques minutes après la création du compte

### "Project not found"
- Vérifiez que vous êtes connecté : `gcloud auth list`
- Vérifiez le nom du projet : `gcloud projects list`
- Utilisez le Project ID complet, pas juste le nom

### "Permission denied"
- Vérifiez que vous êtes le propriétaire du projet
- Vérifiez que les APIs sont bien activées
- Attendez quelques minutes après la création du projet

---

## 🚀 Prochaine Étape

Une fois que tout est configuré, vous pouvez déployer votre backend :
```bash
cd backend
gcloud builds submit --tag gcr.io/[PROJECT-ID]/multidrive-backend
```

**Bon setup ! ☁️**

