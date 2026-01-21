# STRIDE Threat Model — Sovereign AI Kubernetes Platform

## Control Plane

S — Spoofing  
- Compromised kubeconfig
- Stolen service account tokens

T — Tampering  
- API request modification
- etcd data manipulation

R — Repudiation  
- Disabled or incomplete audit logs

I — Information Disclosure  
- Secrets via API / etcd
- Metrics leaking sensitive data

D — Denial of Service  
- API flooding
- Controller exhaustion

E — Elevation of Privilege  
- RBAC misconfiguration
- Admission bypass

## Node Layer

S  
- Rogue node join

T  
- Kubelet config tampering

R  
- Missing node-level logs

I  
- HostPath abuse
- Kernel info leakage

D  
- Resource exhaustion

E  
- Privileged pods → host

## Workloads

S  
- Impersonation via shared SA

T  
- Image replacement

R  
- No workload-level audit

I  
- Secret mounts leakage

D  
- Fork bombs / memory abuse

E  
- Privileged / CAP_SYS_ADMIN

## Supply Chain

S  
- Fake registry / mirror

T  
- Image mutation post-build

R  
- No provenance records

I  
- SBOM exposure

D  
- CI poisoning

E  
- Malicious base image

## Identity

S  
- Token reuse

T  
- Identity claim modification

R  
- Missing auth logs

I  
- Token exfiltration

D  
- Auth system overload

E  
- Privilege escalation via RBAC
