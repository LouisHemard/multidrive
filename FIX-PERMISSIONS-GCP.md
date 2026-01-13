# 🔧 Corriger les permissions Google Cloud

L'erreur indique que le service account n'a pas les permissions pour push vers Artifact Registry (GCR utilise maintenant Artifact Registry).

---

## ✅ Permissions ajoutées

J'ai ajouté les permissions suivantes au service account `github-actions` :

- `roles/artifactregistry.writer` : Permet d'écrire dans Artifact Registry
- `roles/artifactregistry.admin` : Permet de gérer Artifact Registry

---

## 🔄 Vérification

Pour vérifier que les permissions sont bien configurées :

```bash
gcloud projects get-iam-policy multidrive-484209 \
  --flatten="bindings[].members" \
  --filter="bindings.members:github-actions@multidrive-484209.iam.gserviceaccount.com" \
  --format="table(bindings.role)"
```

---

## 🚀 Prochaine étape

Une fois les permissions ajoutées, relancez la pipeline :

1. Allez sur GitHub Actions
2. Cliquez sur "Re-run jobs" → "Re-run failed jobs"

La pipeline devrait maintenant pouvoir push l'image Docker vers GCR.

---

## 📝 Note

GCR (Google Container Registry) utilise maintenant Artifact Registry en backend, c'est pourquoi il faut les permissions Artifact Registry même si vous utilisez l'URL `gcr.io`.

