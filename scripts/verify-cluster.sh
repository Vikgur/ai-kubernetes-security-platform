#!/bin/bash
set -euo pipefail

# Verify cluster security settings
echo "Verifying RBAC..."
kubectl get roles,rolebindings -A
echo "Verifying Network Policies..."
kubectl get networkpolicies -A
echo "Verifying Pod Security Standards..."
kubectl get ns -o json | jq '.items[].metadata.labels'
