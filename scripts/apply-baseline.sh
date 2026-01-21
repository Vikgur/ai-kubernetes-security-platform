#!/bin/bash
set -euo pipefail

# Apply cluster baseline manifests
echo "Applying cluster baseline..."
kubectl apply -k ../environments/base
kubectl apply -k ../environments/dev
echo "Baseline applied."
