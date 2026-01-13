# ⚠️ Problème d'Authentification Supabase

## Problème

Le circuit breaker de Supabase est ouvert à cause de trop d'erreurs d'authentification. Cela signifie que le mot de passe utilisé n'est pas correct.

## Solutions

### Option 1 : Vérifier le mot de passe dans Supabase

1. Allez sur https://app.supabase.com
2. Sélectionnez votre projet "Multidrive"
3. Allez dans **Settings** → **Database**
4. En bas de la page, cliquez sur **"Reset your database password"**
5. Réinitialisez le mot de passe (vous pouvez utiliser le même : `multidrive123$`)
6. **Important** : Notez le nouveau mot de passe exactement

### Option 2 : Utiliser un mot de passe plus simple (temporaire)

Pour éviter les problèmes d'encodage avec le caractère `$`, vous pourriez :
1. Réinitialiser le mot de passe dans Supabase
2. Utiliser un mot de passe sans caractères spéciaux, par exemple : `multidrive123`
3. Mettre à jour la connection string dans `docker-compose.yml`

### Option 3 : Attendre que le circuit breaker se réinitialise

Le circuit breaker se réinitialise généralement après 5-10 minutes. Ensuite, réessayez avec le bon mot de passe.

## Format de la Connection String

Une fois que vous avez le bon mot de passe :

```yaml
DATABASE_URL: "postgresql://postgres.ozvjwsvbimjrwjycyxbr:[MOT_DE_PASSE_ENCODE]@aws-1-eu-west-1.pooler.supabase.com:6543/postgres"
```

**Encodage URL des caractères spéciaux :**
- `$` → `%24`
- `@` → `%40`
- `#` → `%23`
- etc.

## Test de la Connexion

Après avoir corrigé le mot de passe, testez :

```bash
docker compose up -d backend
docker compose logs -f backend
```

Vous devriez voir :
- ✅ Connexion réussie
- ✅ Tables créées
- ✅ Données initiales ajoutées

