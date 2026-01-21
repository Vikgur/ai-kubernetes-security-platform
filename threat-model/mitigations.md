# Threat Mitigations Mapping

## kube-apiserver compromise
- RBAC least privilege (rbac/base)
- Audit logging (observability-security/audit-logs)
- Break-glass only (rbac/break-glass)

## Admission bypass
- ValidatingWebhookConfiguration (runtime-security/admission)
- Pod Security Standards: restricted (runtime-security/pod-security)

## Poisoned images
- Signed images only (supply-chain-security/image-policy)
- Allowed registries enforcement

## RBAC escalation
- No wildcards in roles
- Separation human/workload identities

## DNS exfiltration
- DNS egress restrictions (network-security/dns-security.yaml)
- Default deny network policies

## etcd exposure
- TLS + auth hardening (cluster/hardening/etcd.yaml)
- No direct network access
