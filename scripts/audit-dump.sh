#!/bin/bash
set -euo pipefail

# Dump audit logs for inspection
OUTPUT_DIR="./audit-dump"
mkdir -p "$OUTPUT_DIR"
echo "Dumping audit logs..."
kubectl logs -n kube-system -l component=kube-apiserver > "$OUTPUT_DIR/kube-apiserver.log"
echo "Audit dump completed."
