# 🔐 Configuration des Secrets GitHub Actions

Pour que la pipeline CI/CD fonctionne, vous devez configurer les secrets suivants dans GitHub.

## 📍 Comment ajouter des secrets dans GitHub

1. Allez sur votre repository GitHub : `https://github.com/LouisHemard/multidrive`
2. Cliquez sur **Settings** (en haut à droite)
3. Dans le menu de gauche, cliquez sur **Secrets and variables** → **Actions**
4. Cliquez sur **New repository secret**
5. Ajoutez chaque secret un par un

## 🔑 Secrets nécessaires

### 1. GCP_SA_KEY (Google Cloud Service Account Key)

**Description** : Clé JSON du compte de service Google Cloud pour déployer sur Cloud Run.

**Comment l'obtenir** :
```bash
# 1. Créer un compte de service (si pas déjà fait)
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions Service Account"

# 2. Donner les permissions nécessaires
gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding multidrive-484209 \
  --member="serviceAccount:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# 3. Créer la clé JSON
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=github-actions@multidrive-484209.iam.gserviceaccount.com

# 4. Copier le contenu du fichier github-actions-key.json
cat github-actions-key.json
```

**Dans GitHub** :
- **Name** : `GCP_SA_KEY`
- **Value** : Collez tout le contenu du fichier JSON (commence par `{` et finit par `}`)

---

### 2. DATABASE_URL (URL de connexion Supabase)

**Description** : URL de connexion à la base de données PostgreSQL sur Supabase.

**Valeur** :
```
postgresql://postgres.ozvjwsvbimjrwjycyxbr:mZjECcHQUJ3NdNZx@aws-1-eu-west-1.pooler.supabase.com:6543/postgres
```

**Dans GitHub** :
- **Name** : `DATABASE_URL`
- **Value** : `postgresql://postgres.ozvjwsvbimjrwjycyxbr:mZjECcHQUJ3NdNZx@aws-1-eu-west-1.pooler.supabase.com:6543/postgres`

---

### 3. CORS_ORIGINS (Origines autorisées pour CORS)

**Description** : URLs autorisées pour les requêtes CORS (votre frontend Railway).

**Valeur** :
```
https://votre-app.railway.app
```

**Comment obtenir l'URL Railway** :
1. Allez sur Railway → Votre projet
2. Onglet **Settings** → **Domains**
3. Copiez l'URL (ex: `https://multidrive-production.up.railway.app`)

**Dans GitHub** :
- **Name** : `CORS_ORIGINS`
- **Value** : `https://votre-url-railway.app` (remplacez par votre vraie URL)

---

## ✅ Checklist de configuration

- [ ] Secret `GCP_SA_KEY` créé avec la clé JSON du service account
- [ ] Secret `DATABASE_URL` créé avec l'URL Supabase
- [ ] Secret `CORS_ORIGINS` créé avec l'URL Railway
- [ ] Service account Google Cloud a les permissions nécessaires
- [ ] Pipeline testée avec un push sur `main`

---

## 🧪 Tester la pipeline

Une fois les secrets configurés :

1. Faites un petit changement dans le code (ex: commentaire)
2. Commitez et pushez sur `main` :
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
3. Allez sur GitHub → **Actions** (onglet en haut)
4. Vous devriez voir la pipeline s'exécuter

---

## 📝 Notes importantes

- ⚠️ **Ne partagez JAMAIS les secrets publiquement**
- 🔒 Les secrets sont cryptés par GitHub
- 🔄 Si vous changez les secrets, la pipeline utilisera les nouvelles valeurs au prochain run
- 📊 Vous pouvez voir l'historique des runs dans l'onglet **Actions**

---

## 🆘 Dépannage

### Erreur : "Permission denied" dans Cloud Run
→ Vérifiez que le service account a les rôles `roles/run.admin` et `roles/iam.serviceAccountUser`

### Erreur : "DATABASE_URL not found"
→ Vérifiez que le secret `DATABASE_URL` est bien créé dans GitHub

### Erreur : "CORS_ORIGINS invalid"
→ Vérifiez que l'URL Railway est correcte et commence par `https://`

