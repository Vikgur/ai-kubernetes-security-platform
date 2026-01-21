#!/usr/bin/env bash
set -euo pipefail

# --- directories ---

dirs=(
cluster/{bootstrap,baseline,hardening}
rbac/{base,break-glass}
network-security/{cni,network-policies}
runtime-security/{admission,pod-security,seccomp,apparmor}
supply-chain-security/{image-policy,sbom,provenance}
policy-engine/{opa-gatekeeper/{constraints,templates},kyverno/policies,rego}
observability-security/{audit-logs,falco,prometheus-rules}
multi-tenancy
compliance/{cis,nist,iso27001,reports}
threat-model
environments/{base,dev,stage,prod}
ci
scripts
docs
)

mkdir -p "${dirs[@]}"

# --- files ---

files=(
README.md
.gitignore
.editorconfig
.yamllint
.kube-linter.yaml
.opa.yaml
.trivyignore
.checkov.yaml

cluster/README.md
cluster/bootstrap/{placeholder.yaml}
cluster/baseline/{pod-security-standards.yaml,namespaces.yaml,resource-quotas.yaml}
cluster/hardening/{api-server.yaml,controller-manager.yaml,scheduler.yaml,etcd.yaml}

rbac/README.md
rbac/base/{roles.yaml,rolebindings.yaml,serviceaccounts.yaml}
rbac/break-glass/{README.md,break-glass-admin.yaml}

network-security/README.md
network-security/cni/placeholder.yaml
network-security/network-policies/{default-deny.yaml,namespace-isolation.yaml}
network-security/dns-security.yaml

runtime-security/README.md
runtime-security/admission/{validating-webhook.yaml,mutating-webhook.yaml}
runtime-security/pod-security/{restricted.yaml,baseline.yaml}
runtime-security/seccomp/{default.json}

supply-chain-security/image-policy/{allowed-registries.yaml,signed-images-only.yaml}
supply-chain-security/README.md

policy-engine/README.md
policy-engine/opa-gatekeeper/{constraints,templates}/{required-labels.yaml,deny-privileged.yaml}
policy-engine/kyverno/policies/{enforce-security-context.yaml,mutate-seccomp.yaml}

observability-security/README.md
observability-security/audit-logs/audit-policy.yaml
observability-security/falco/placeholder.yaml
observability-security/prometheus-rules/security-alerts.yaml

multi-tenancy/{tenant-isolation.yaml,quota-enforcement.yaml,README.md}

compliance/README.md
compliance/cis/{mapping.md,controls.yaml}
compliance/nist/{mapping.md,controls.yaml}
compliance/iso27001/mapping.md

threat-model/{STRIDE.md,attack-scenarios.md,mitigations.md,README.md}

environments/{kustomization.yaml,README.md}
environments/base/kustomization.yaml
environments/dev/kustomization.yaml
environments/stage/kustomization.yaml
environments/prod/kustomization.yaml

ci/{kube-linter.yml,opa-policy-check.yml,trivy-k8s.yml,manifest-validate.yml,compliance-report.yml}

scripts/{apply-baseline.sh,verify-cluster.sh,audit-dump.sh,README.md}

docs/{architecture.md,security-boundary.md,kubernetes-threat-model.md,policy-strategy.md,admission-control.md,runtime-security.md,supply-chain-security.md,compliance-overview.md,repository-structure.md}
)

touch "${files[@]}"

# --- gitkeep ---

gitkeep_dirs=(
policy-engine/rego
supply-chain-security/{sbom,provenance}
compliance/reports
runtime-security/apparmor
)

for d in "${gitkeep_dirs[@]}"; do
touch "$d/.gitkeep"
done

echo "ai-kubernetes-security-platform architecture bootstrap completed."