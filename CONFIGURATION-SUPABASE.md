# 🔥 Configuration Supabase pour MultiDrive

## 📋 Informations du Projet

- **Projet Supabase** : Multidrive
- **Mot de passe** : `multidrive123$`

## 🔍 Étape 1 : Récupérer la Connection String

1. Allez sur https://app.supabase.com
2. Sélectionnez votre projet **"Multidrive"**
3. Allez dans **Settings** → **Database**
4. Dans la section **Connection string**, sélectionnez l'onglet **URI**
5. Vous verrez une connection string comme :
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
   ```
6. **Important** : Remplacez `[YOUR-PASSWORD]` par votre mot de passe : `multidrive123$`
   - ⚠️ Dans l'URL, le caractère `$` doit être encodé en `%24`
   - Donc `multidrive123$` devient `multidrive123%24`

**Exemple de connection string finale :**
```
postgresql://postgres:multidrive123%24@db.abcdefghijklmnop.supabase.co:5432/postgres
```

Notez la partie `db.xxxxx.supabase.co` - c'est votre identifiant de projet (à garder secret).

## ⚙️ Étape 2 : Utiliser le Session Pooler (RECOMMANDÉ)

⚠️ **Important** : Supabase utilise IPv6 par défaut, ce qui peut causer des problèmes avec Docker.
Utilisez le **Session Pooler** à la place (compatible IPv4) :

1. Dans Supabase, allez dans **Settings** → **Database**
2. Section **Connection string** → **URI**
3. Changez **"Method"** de "Direct connection" à **"Session mode"** ou **"Transaction mode"**
4. Utilisez la connection string du pooler (port **6543** au lieu de 5432)

La connection string du Session Pooler ressemble à :
```
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
```

## ⚙️ Étape 3 : Configuration

Une fois que vous avez la connection string complète (avec le pooler), deux options :

### Option A : Utiliser Supabase avec Docker (recommandé pour tester)

1. Modifiez le fichier `docker-compose.yml` ligne 20 :
   ```yaml
   DATABASE_URL: postgresql://postgres:multidrive123%24@db.[VOTRE-ID].supabase.co:5432/postgres
   ```
   
2. Redémarrez le backend :
   ```bash
   docker compose up -d --build backend
   ```

3. **Important** : Désactivez ou commentez le service `db` local dans docker-compose.yml si vous utilisez Supabase

### Option B : Tester directement en local (sans Docker)

1. Créez un fichier `.env` dans le dossier `backend/` (vous pouvez copier `env.example`)
2. Ajoutez votre connection string :
   ```env
   DATABASE_URL=postgresql://postgres:multidrive123%24@db.[VOTRE-ID].supabase.co:5432/postgres
   ```
3. Testez la connexion :
   ```bash
   cd backend
   python -c "from sqlalchemy import create_engine; import os; engine = create_engine(os.getenv('DATABASE_URL')); engine.connect(); print('✅ Connexion réussie!')"
   ```

## 🚀 Étape 3 : Création des Tables

Les tables seront créées **automatiquement** au démarrage du backend grâce à la fonction `init_db()` dans `main.py`.

Les tables créées :
- `garages` (id, name, address)
- `vehicles` (id, brand, model, year, license_plate, garage_id)

Les données initiales (2 garages) seront également ajoutées automatiquement.

## ✅ Étape 4 : Tester la Connexion

Une fois configuré, testez :

```bash
# Voir les logs du backend
docker compose logs -f backend

# Tester l'API
curl http://localhost:8000/garages

# Vérifier dans Supabase
# Allez dans Table Editor → vous devriez voir les tables "garages" et "vehicles"
```

## 🔐 Notes Importantes

- ✅ Supabase utilise PostgreSQL, donc 100% compatible avec votre code
- ✅ Le mot de passe `$` doit être encodé en `%24` dans l'URL
- ⚠️ Supabase a des limites sur le plan gratuit (500 MB de base de données, 2 GB de bande passante)
- ✅ Les tables sont créées automatiquement au premier démarrage
- 🔒 Gardez votre connection string secrète (ne la commitez pas dans Git)

## 📝 Exemple Complet

Si votre identifiant Supabase est `abcdefghijklmnop`, votre connection string sera :

```
postgresql://postgres:multidrive123%24@db.abcdefghijklmnop.supabase.co:5432/postgres
```

Et dans `docker-compose.yml` :
```yaml
environment:
  DATABASE_URL: postgresql://postgres:multidrive123%24@db.abcdefghijklmnop.supabase.co:5432/postgres
```

## 🆘 Dépannage

**Erreur de connexion :**
- Vérifiez que le mot de passe est bien encodé (`%24` au lieu de `$`)
- Vérifiez que l'identifiant du projet est correct
- Vérifiez que votre IP est autorisée dans Supabase (Settings → Database → Connection pooling)

**Tables non créées :**
- Vérifiez les logs : `docker compose logs backend`
- Les tables sont créées au démarrage, redémarrez le backend

**Mot de passe incorrect :**
- Le mot de passe est : `multidrive123$` (avec le $)
- Dans l'URL : `multidrive123%24`

