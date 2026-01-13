# 🔥 Configuration Supabase pour MultiDrive

## Informations du Projet

- **Nom du projet** : Multidrive
- **Mot de passe** : `multidrive123$`

## Étape 1 : Récupérer la Connection String

1. Allez sur https://app.supabase.com
2. Sélectionnez votre projet "Multidrive"
3. Allez dans **Settings** → **Database**
4. Dans la section **Connection string**, sélectionnez l'onglet **URI**
5. Vous verrez une connection string comme :
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
   ```
6. Remplacez `[YOUR-PASSWORD]` par votre mot de passe : `multidrive123$`

La connection string finale devrait ressembler à :
```
postgresql://postgres:multidrive123$@db.xxxxx.supabase.co:5432/postgres
```

## Étape 2 : Configuration Locale (Docker)

Pour tester en local avec Docker, vous avez deux options :

### Option A : Utiliser Supabase directement (recommandé)

1. Créez un fichier `.env` dans le dossier `backend/`
2. Ajoutez la connection string :
   ```env
   DATABASE_URL=postgresql://postgres:multidrive123$@db.xxxxx.supabase.co:5432/postgres
   ```
3. Modifiez `docker-compose.yml` pour utiliser cette variable d'environnement

### Option B : Continuer avec la DB locale pour le développement

Garder la base de données locale pour le développement et utiliser Supabase pour la production.

## Étape 3 : Création des Tables

Les tables seront créées automatiquement au démarrage du backend grâce à la fonction `init_db()` dans `main.py`.

## Étape 4 : Tester la Connexion

Une fois configuré, testez la connexion :
```bash
docker compose up -d backend
docker compose logs backend
```

Vous devriez voir :
- ✅ Connexion réussie
- ✅ Tables créées
- ✅ Données initiales ajoutées

## Notes Importantes

- ⚠️ Le caractère `$` dans le mot de passe peut nécessiter un échappement dans certains contextes
- ⚠️ Supabase a des limites sur le plan gratuit (500 MB de base de données)
- ✅ Supabase utilise PostgreSQL, donc 100% compatible avec votre code existant
- ✅ Les tables sont créées automatiquement au premier démarrage

