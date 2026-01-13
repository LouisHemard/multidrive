# 📤 Pousser le Code sur GitHub

## Étape 1 : Créer un Repository sur GitHub

1. Allez sur **https://github.com/new**
2. **Repository name** : `multidrive` (ou le nom que vous préférez)
3. **Description** : "MultiDrive - Application de gestion de véhicules"
4. Choisissez **Public** ou **Private** (pour un projet académique, Public est OK)
5. **NE COCHEZ PAS** "Initialize this repository with a README" (le code existe déjà)
6. Cliquez sur **"Create repository"**

## Étape 2 : Noter l'URL du Repository

GitHub affichera quelque chose comme :
```
https://github.com/VOTRE-USERNAME/multidrive.git
```

**📝 Notez cette URL !** (remplacez VOTRE-USERNAME par votre nom d'utilisateur GitHub)

## Étape 3 : Connecter et Pousser le Code

Une fois le repo créé, exécutez ces commandes dans votre terminal :

```bash
# Aller dans le dossier du projet
cd "/Users/louis/Documents/Projet_ynov/Projet Fil rouge Cloud"

# Faire le premier commit (si pas déjà fait)
git add .
git commit -m "Initial commit - MultiDrive project"

# Ajouter le remote GitHub (remplacez par votre URL)
git remote add origin https://github.com/VOTRE-USERNAME/multidrive.git

# Pousser le code
git branch -M main
git push -u origin main
```

**Remplacez `VOTRE-USERNAME` par votre nom d'utilisateur GitHub !**

## Authentification GitHub

Si GitHub vous demande de vous authentifier :
- **Option 1** : Utilisez un Personal Access Token (recommandé)
  - Allez sur GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
  - Créez un nouveau token avec les permissions `repo`
  - Utilisez ce token comme mot de passe

- **Option 2** : Utilisez GitHub CLI (`gh auth login`)
  - Plus simple si vous l'installez

## Vérification

Une fois le push réussi :
1. Allez sur votre repository GitHub
2. Vous devriez voir tous vos fichiers
3. Le code est maintenant sur GitHub ! 🎉

---

**Besoin d'aide ?** Dites-moi votre nom d'utilisateur GitHub et je vous donnerai les commandes exactes !

