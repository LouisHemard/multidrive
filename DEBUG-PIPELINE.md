# 🐛 Débogage de la Pipeline CI/CD

Si la pipeline échoue, voici comment identifier et résoudre les problèmes.

---

## 🔍 Étape 1 : Voir les logs d'erreur

1. Allez sur : https://github.com/LouisHemard/multidrive/actions
2. Cliquez sur la dernière exécution (celle qui a échoué)
3. Cliquez sur le job qui a échoué (marqué d'une croix rouge)
4. Regardez les logs pour voir l'erreur exacte

---

## ❌ Erreurs courantes et solutions

### Erreur : "npm ci" failed

**Cause** : `package-lock.json` manquant

**Solution** :
```bash
cd frontend
npm install
git add package-lock.json
git commit -m "Ajouter package-lock.json"
git push
```

---

### Erreur : "GCP_SA_KEY not found" ou "Permission denied"

**Cause** : Secret GitHub manquant ou incorrect

**Solution** :
1. Vérifiez que le secret `GCP_SA_KEY` existe dans GitHub → Settings → Secrets
2. Vérifiez que le contenu JSON est complet (de `{` à `}`)
3. Vérifiez que le service account a les bonnes permissions

---

### Erreur : "DATABASE_URL not found"

**Cause** : Secret `DATABASE_URL` manquant

**Solution** :
1. Ajoutez le secret `DATABASE_URL` dans GitHub
2. Valeur : `postgresql://postgres.ozvjwsvbimjrwjycyxbr:mZjECcHQUJ3NdNZx@aws-1-eu-west-1.pooler.supabase.com:6543/postgres`

---

### Erreur : "CORS_ORIGINS not found"

**Cause** : Secret `CORS_ORIGINS` manquant

**Solution** :
1. Ajoutez le secret `CORS_ORIGINS` dans GitHub
2. Valeur : Votre URL Railway (ex: `https://votre-app.railway.app`)

---

### Erreur : "Module not found" ou "Import error"

**Cause** : Dépendances manquantes ou erreur dans le code

**Solution** :
1. Testez localement : `cd backend && pip install -r requirements.txt && python -c "from main import app"`
2. Vérifiez que tous les imports sont corrects
3. Vérifiez que `requirements.txt` contient toutes les dépendances

---

### Erreur : "Build failed" dans le frontend

**Cause** : Erreur de compilation React

**Solution** :
1. Testez localement : `cd frontend && npm install && npm run build`
2. Vérifiez les erreurs de compilation
3. Corrigez les erreurs et recommitez

---

## ✅ Checklist de vérification

Avant de déclencher la pipeline, vérifiez :

- [ ] Les 3 secrets sont configurés dans GitHub :
  - [ ] `GCP_SA_KEY`
  - [ ] `DATABASE_URL`
  - [ ] `CORS_ORIGINS`
- [ ] Le code fonctionne localement :
  - [ ] `cd backend && python -c "from main import app"` fonctionne
  - [ ] `cd frontend && npm run build` fonctionne
- [ ] `package-lock.json` existe dans `frontend/` (si vous utilisez `npm ci`)

---

## 🧪 Tester localement avant de pusher

```bash
# Test backend
cd backend
pip install -r requirements.txt
python -c "from main import app; print('✅ Backend OK')"

# Test frontend
cd ../frontend
npm install
npm run build
echo "✅ Frontend OK"
```

Si ces commandes fonctionnent localement, la pipeline devrait aussi fonctionner.

---

## 📝 Notes

- La première exécution peut prendre 5-10 minutes
- Les secrets sont nécessaires seulement pour le déploiement (pas pour les tests)
- Si les tests passent mais le déploiement échoue, c'est probablement un problème de secrets ou de permissions

