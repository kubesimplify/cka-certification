# Add the repository (if not already added)
helm repo add argo https://argoproj.github.io/argo-helm

# Update the repository
helm repo update
helm show values argo/argo-cd --version 5.5.0 > /tmp/values.yaml

# Generate the template without CRDs
helm template argocd argo/argo-cd \
  --version 5.5.0 \
  --namespace argocd \
  --set crds.install=false \
  > /tmp/argocd-template.yaml

# Verify no CRDs are present
cat /tmp/argocd-template.yaml | grep -i "CustomResourceDefinition"