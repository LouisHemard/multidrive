# 🔑 Guide : Créer la clé GCP_SA_KEY pour GitHub Actions

Ce guide vous explique étape par étape comment créer un service account Google Cloud et obtenir la clé JSON pour GitHub Actions.

---

## 📋 Prérequis

- Avoir `gcloud` CLI installé et configuré
- Être connecté à votre projet Google Cloud : `multidrive-484209`

---

## 🚀 Étapes

### Étape 1 : Vérifier que vous êtes connecté

```bash
# Vérifier le projet actuel
gcloud config get-value project

# Si ce n'est pas le bon projet, le définir
gcloud config set project multidrive-484209

# Vérifier que vous êtes connecté
gcloud auth list
```

---

### Étape 2 : Créer le Service Account

```bash
# Créer le service account (si pas déjà créé)
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions Service Account" \
  --description="Service account pour déployer depuis GitHub Actions" \
  --project=multidrive-484209
```

**Note** : Si vous obtenez une erreur "already exists", c'est normal, le service account existe déjà. Passez à l'étape suivante.

---

### Étape 3 : Donner les permissions nécessaires

Le service account a besoin de ces rôles pour déployer sur Cloud Run :

```bash
# Rôle 1 : Admin de Cloud Run (pour déployer)
gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/run.admin"

# Rôle 2 : Admin de Storage (pour push les images Docker)
gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# Rôle 3 : Utilisateur de Service Account (pour utiliser le service account)
gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Rôle 4 : Service Account User (pour Cloud Build)
gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

---

### Étape 4 : Créer la clé JSON

```bash
# Créer la clé JSON
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=github-actions@multidrive-484209.iam.gserviceaccount.com \
  --project=multidrive-484209
```

Cette commande crée un fichier `github-actions-key.json` dans le répertoire actuel.

---

### Étape 5 : Afficher le contenu de la clé

```bash
# Afficher le contenu du fichier JSON
cat github-actions-key.json
```

**⚠️ IMPORTANT** : Copiez TOUT le contenu de ce fichier (il commence par `{` et finit par `}`).

---

### Étape 6 : Ajouter le secret dans GitHub

1. Allez sur votre repository GitHub : `https://github.com/LouisHemard/multidrive`
2. Cliquez sur **Settings** (en haut à droite)
3. Dans le menu de gauche, cliquez sur **Secrets and variables** → **Actions**
4. Cliquez sur **New repository secret**
5. Remplissez :
   - **Name** : `GCP_SA_KEY`
   - **Value** : Collez TOUT le contenu du fichier JSON (le `{...}` complet)
6. Cliquez sur **Add secret**

---

### Étape 7 : Sécuriser le fichier (optionnel mais recommandé)

```bash
# Supprimer le fichier de clé de votre machine (après l'avoir ajouté à GitHub)
rm github-actions-key.json

# Ou le déplacer dans un endroit sécurisé
# Ne le commitez JAMAIS dans Git !
```

---

## ✅ Vérification

Pour vérifier que tout fonctionne :

1. Faites un petit changement dans votre code
2. Commitez et pushez :
   ```bash
   git add .
   git commit -m "Test CI/CD avec GCP_SA_KEY"
   git push origin main
   ```
3. Allez sur GitHub → **Actions**
4. Vérifiez que la pipeline s'exécute sans erreur

---

## 🆘 Dépannage

### Erreur : "Permission denied" lors du déploiement

→ Vérifiez que tous les rôles ont été ajoutés (étape 3)

### Erreur : "Service account not found"

→ Vérifiez que le service account existe :
```bash
gcloud iam service-accounts list --project=multidrive-484209
```

### Erreur : "Invalid JSON" dans GitHub

→ Assurez-vous d'avoir copié TOUT le contenu du fichier JSON, y compris les accolades `{` et `}`

---

## 📝 Notes importantes

- 🔒 **NE COMMITEZ JAMAIS** le fichier `github-actions-key.json` dans Git
- 🔐 La clé JSON donne accès à votre projet Google Cloud, gardez-la secrète
- 🔄 Si vous perdez la clé, vous pouvez en créer une nouvelle (les anciennes restent valides jusqu'à suppression)
- 📊 Vous pouvez voir les clés actives avec :
  ```bash
  gcloud iam service-accounts keys list \
    --iam-account=github-actions@multidrive-484209.iam.gserviceaccount.com
  ```

---

## 🎯 Résumé rapide

```bash
# 1. Créer le service account
gcloud iam service-accounts create github-actions --display-name="GitHub Actions Service Account" --project=multidrive-484209

# 2. Donner les permissions
gcloud projects add-iam-policy-binding multidrive-484209 --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" --role="roles/run.admin"
gcloud projects add-iam-policy-binding multidrive-484209 --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" --role="roles/storage.admin"
gcloud projects add-iam-policy-binding multidrive-484209 --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" --role="roles/iam.serviceAccountUser"

# 3. Créer la clé JSON
gcloud iam service-accounts keys create github-actions-key.json --iam-account=github-actions@multidrive-484209.iam.gserviceaccount.com --project=multidrive-484209

# 4. Afficher la clé
cat github-actions-key.json

# 5. Copier le contenu et l'ajouter dans GitHub → Settings → Secrets → GCP_SA_KEY
```

