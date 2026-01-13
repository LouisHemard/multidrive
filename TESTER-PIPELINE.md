# 🧪 Tester la Pipeline CI/CD

Une fois les secrets ajoutés dans GitHub, voici comment tester et vérifier que tout fonctionne.

---

## ✅ Étape 1 : Vérifier que les secrets sont bien configurés

1. Allez sur : https://github.com/LouisHemard/multidrive/settings/secrets/actions
2. Vérifiez que vous voyez bien 3 secrets :
   - ✅ `GCP_SA_KEY`
   - ✅ `DATABASE_URL`
   - ✅ `CORS_ORIGINS`

---

## 🚀 Étape 2 : Déclencher la pipeline

### Option A : Faire un petit changement (recommandé)

```bash
# Faire un petit changement (ex: ajouter un commentaire)
echo "# Test CI/CD" >> README.md

# Commiter et pusher
git add README.md
git commit -m "Test: déclencher la pipeline CI/CD"
git push origin main
```

### Option B : La pipeline se déclenche automatiquement

La pipeline se déclenche automatiquement à chaque push sur `main`, donc si vous avez déjà fait un push récemment, elle devrait déjà s'exécuter.

---

## 📊 Étape 3 : Vérifier l'exécution de la pipeline

1. Allez sur : https://github.com/LouisHemard/multidrive/actions
2. Vous devriez voir une nouvelle exécution en cours ou terminée
3. Cliquez dessus pour voir les détails

### Ce que vous devriez voir :

- ✅ **test-backend** : Tests du backend (vert = succès)
- ✅ **test-frontend** : Tests du frontend (vert = succès)
- ✅ **build-backend** : Build de l'image Docker backend
- ✅ **deploy-backend** : Déploiement sur Cloud Run
- ✅ **build-frontend** : Build du frontend
- ✅ **summary** : Résumé de la pipeline

---

## 🔍 Étape 4 : Vérifier les logs

Si une étape échoue (rouge) :

1. Cliquez sur le job qui a échoué
2. Cliquez sur l'étape qui a échoué
3. Regardez les logs pour voir l'erreur

### Erreurs communes :

#### ❌ "Permission denied" dans deploy-backend
→ Vérifiez que `GCP_SA_KEY` est bien configuré et que le service account a les bonnes permissions

#### ❌ "DATABASE_URL not found"
→ Vérifiez que le secret `DATABASE_URL` est bien créé

#### ❌ "Build failed"
→ Regardez les logs pour voir quelle étape a échoué (install, build, etc.)

---

## ✅ Étape 5 : Vérifier le déploiement

Une fois la pipeline terminée avec succès :

### Backend sur Cloud Run

1. Vérifiez que le backend est déployé :
   ```bash
   curl https://multidrive-backend-565974867635.europe-west1.run.app/
   ```
   Devrait retourner : `{"message":"MultiDrive API"}`

2. Vérifiez les garages :
   ```bash
   curl https://multidrive-backend-565974867635.europe-west1.run.app/garages
   ```

### Frontend sur Railway

- Railway se charge automatiquement du déploiement via l'intégration GitHub
- Vérifiez votre application Railway pour voir si elle a été mise à jour

---

## 🎯 Résultat attendu

Si tout fonctionne, vous devriez voir :

```
✅ test-backend: SUCCESS
✅ test-frontend: SUCCESS
✅ build-backend: SUCCESS
✅ deploy-backend: SUCCESS
✅ build-frontend: SUCCESS
✅ summary: SUCCESS
```

---

## 🔄 Prochaines étapes

Une fois que la pipeline fonctionne :

1. **Chaque push sur `main`** déclenchera automatiquement :
   - Les tests
   - Le build
   - Le déploiement du backend sur Cloud Run

2. **Le frontend** sera automatiquement déployé par Railway (via leur intégration GitHub)

3. **Vous pouvez voir l'historique** de tous les déploiements dans :
   - GitHub → Actions
   - Google Cloud Console → Cloud Run
   - Railway → Deployments

---

## 🆘 Si ça ne fonctionne pas

1. Vérifiez que tous les secrets sont bien configurés
2. Regardez les logs dans GitHub Actions
3. Vérifiez que le service account Google Cloud a les bonnes permissions
4. Vérifiez que votre projet Google Cloud est bien `multidrive-484209`

---

## 📝 Notes

- La première exécution peut prendre 5-10 minutes
- Les exécutions suivantes seront plus rapides (cache)
- Vous recevrez une notification par email si la pipeline échoue (si configuré dans GitHub)
