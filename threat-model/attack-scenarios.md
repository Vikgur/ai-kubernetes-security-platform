# Attack Scenarios

## Compromised kube-apiserver credentials
Initial access via leaked kubeconfig → cluster-admin → full takeover.

## Admission controller bypass
Malicious pod deployed with privileged=true and hostPath mounts.

## Poisoned container image
Signed image replaced in registry without enforcement.

## RBAC privilege escalation
Wildcard verbs/resources bound to workload service account.

## DNS-based data exfiltration
Sensitive data encoded in DNS queries.

## etcd data extraction
Direct access to etcd endpoint without TLS/auth.
