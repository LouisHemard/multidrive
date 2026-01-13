# 🔧 Configuration Railway - Dossier Source

Si Railway ne détecte pas automatiquement le dossier `frontend`, voici comment le configurer :

## Option 1 : Via l'Interface Railway (Recommandé)

1. Dans votre projet Railway, cliquez sur votre **service** (l'application déployée)
2. Allez dans l'onglet **"Settings"**
3. Cherchez la section **"Root Directory"**
4. Entrez : `frontend`
5. Cliquez sur **"Save"**
6. Railway redéploiera automatiquement

## Option 2 : Utiliser nixpacks.toml (Déjà créé)

J'ai créé un fichier `nixpacks.toml` à la racine qui indique à Railway comment builder depuis le dossier `frontend`.

## Variable d'Environnement à Configurer

N'oubliez pas d'ajouter dans Railway → Variables :
- **Name** : `REACT_APP_API_URL`
- **Value** : `https://multidrive-backend-565974867635.europe-west1.run.app`

