# 🔧 Corriger le secret GCP_SA_KEY

Le secret `GCP_SA_KEY` dans GitHub n'est pas un JSON valide. Voici comment le corriger.

---

## ❌ Problème

L'erreur indique : `failed to parse service account key JSON credentials: unexpected token`

Cela signifie que le JSON copié dans GitHub n'est pas valide.

---

## ✅ Solution : Re-copier le JSON correctement

### Étape 1 : Vérifier le fichier local

Le fichier `github-actions-key.json` doit être dans votre dossier projet.

### Étape 2 : Afficher le contenu complet

```bash
cat github-actions-key.json
```

### Étape 3 : Copier TOUT le contenu

⚠️ **IMPORTANT** : Vous devez copier :
- **DE** : le premier `{`
- **JUSQU'À** : le dernier `}`
- **SANS** espaces avant ou après
- **SANS** sauts de ligne avant ou après

Le JSON doit ressembler à ça (exemple) :
```json
{
  "type": "service_account",
  "project_id": "multidrive-484209",
  ...
}
```

### Étape 4 : Dans GitHub

1. Allez sur : https://github.com/LouisHemard/multidrive/settings/secrets/actions
2. Cliquez sur le secret `GCP_SA_KEY`
3. Cliquez sur "Update"
4. **SUPPRIMEZ TOUT** le contenu actuel
5. Collez le nouveau JSON (celui du fichier `github-actions-key.json`)
6. Cliquez sur "Update secret"

---

## 🧪 Vérification

Pour vérifier que le JSON est valide avant de le copier :

```bash
# Vérifier que le JSON est valide
cat github-actions-key.json | python3 -m json.tool > /dev/null && echo "✅ JSON valide" || echo "❌ JSON invalide"
```

Si ça affiche "✅ JSON valide", vous pouvez le copier.

---

## ⚠️ Points importants

- Le JSON doit commencer par `{` et finir par `}`
- Pas d'espaces ou de caractères avant le `{`
- Pas d'espaces ou de caractères après le `}`
- Pas de sauts de ligne avant ou après
- Copiez EXACTEMENT ce qui est dans le fichier

---

## 🔄 Si le fichier n'existe plus

Si vous avez supprimé le fichier `github-actions-key.json`, vous pouvez le recréer :

```bash
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=github-actions@multidrive-484209.iam.gserviceaccount.com \
  --project=multidrive-484209
```

Puis suivez les étapes ci-dessus pour copier le contenu.

