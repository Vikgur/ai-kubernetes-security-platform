docs/architecture.md

Назначение
Единая security-архитектура Kubernetes платформы.

Тезисы:
– Security layers: bootstrap → baseline → enforcement → runtime → audit
– Control plane vs data plane
– Где применяются policy engines
– Где работает runtime detection

Связи:
– README → architecture.md
– architecture.md → admission-control.md
– architecture.md → runtime-security.md