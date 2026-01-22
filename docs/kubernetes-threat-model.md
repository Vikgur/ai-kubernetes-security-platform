# Оглавление

- [Назначение Kubernetes Threat Model](#назначение-kubernetes-threat-model)  
- [Подход к моделированию угроз](#подход-к-моделированию-угроз)  
- [Threat Actors](#threat-actors)  
  - [External Adversary](#external-adversary)  
  - [Malicious Workload](#malicious-workload)  
  - [Insider](#insider)  
  - [Supply Chain Attacker](#supply-chain-attacker)  
- [Attack Surfaces](#attack-surfaces)  
- [Control Plane Threats](#control-plane-threats)  
  - [API Server Abuse](#api-server-abuse)  
  - [etcd Compromise](#etcd-compromise)  
  - [Admission Bypass](#admission-bypass)  
- [Node и Workload Threats](#node-и-workload-threats)  
  - [Container Escape](#container-escape)  
  - [Privilege Escalation внутри кластера](#privilege-escalation-внутри-кластера)  
  - [Lateral Movement](#lateral-movement)  
- [Supply Chain Threats](#supply-chain-threats)  
  - [Malicious Images](#malicious-images)  
  - [Dependency Poisoning](#dependency-poisoning)  
- [CI/CD Threats](#cicd-threats)  
- [Runtime Threats](#runtime-threats)  
  - [Post-Deployment Abuse](#post-deployment-abuse)  
- [Cross-Cutting Threats](#cross-cutting-threats)  
  - [Misconfiguration](#misconfiguration)  
- [Связь с архитектурой](#связь-с-архитектурой)  
- [Связь с другими документами](#связь-с-другими-документами)  
- [Не-цели threat model](#не-цели-threat-model)  
- [Итог](#итог)

---

# Назначение Kubernetes Threat Model

`kubernetes-threat-model.md` описывает **модель угроз Kubernetes-платформы уровня Sovereign AI**.

Документ отвечает на вопросы:
- кто является потенциальным атакующим;
- какие поверхности атак существуют;
- какие угрозы считаются системными;
- какими контурами они покрываются.

Это threat model **платформы**, а не отдельного приложения.

---

# Подход к моделированию угроз

Используется архитектурно-ориентированный подход:
- от trust boundaries;
- от системных ролей;
- от жизненного цикла workload’ов.

STRIDE применяется как вспомогательная модель,  
но ключевым является **platform-level мышление**.

---

# Threat Actors

## External Adversary

- внешний атакующий;
- доступ через exposed сервисы;
- эксплуатация уязвимостей приложений.

## Malicious Workload

- скомпрометированный контейнер;
- вредоносный образ;
- poisoned AI workload.

## Insider

- разработчик;
- оператор;
- CI/CD actor.

## Supply Chain Attacker

- компрометированный registry;
- подменённый образ;
- poisoned dependency.

---

# Attack Surfaces

Основные поверхности атак:
- Kubernetes API;
- admission pipeline;
- container runtime;
- сеть между pod’ами;
- CI/CD интеграции;
- image registry и metadata.

Каждая поверхность рассматривается как потенциально враждебная.

---

# Control Plane Threats

## API Server Abuse

Угрозы:
- эскалация RBAC;
- несанкционированные изменения;
- обход admission.

Митигируется:
- строгим RBAC;
- audit logging;
- admission policies;
- минимальным admin-доступом.

---

## etcd Compromise

Угрозы:
- утечка секретов;
- модификация состояния;
- полный контроль кластера.

Митигируется:
- hardening;
- ограничением доступа;
- шифрованием;
- отсутствием прямого доступа из data plane.

---

## Admission Bypass

Угрозы:
- деплой небезопасных объектов;
- обход policy engines.

Митигируется:
- deny-by-default;
- обязательными admission controllers;
- запретом direct-to-node deploy.

Связь: `docs/admission-control.md`

---

# Node и Workload Threats

## Container Escape

Угрозы:
- выход из контейнера;
- доступ к host OS;
- lateral movement.

Митигируется:
- seccomp;
- AppArmor;
- drop capabilities;
- non-root execution.

---

## Privilege Escalation внутри кластера

Угрозы:
- misuse ServiceAccount;
- токен-эксфильтрация;
- кросс-namespace доступ.

Митигируется:
- namespace isolation;
- minimal RBAC;
- admission validation;
- runtime detection.

---

## Lateral Movement

Угрозы:
- перемещение между pod’ами;
- атаки через DNS или сервисы.

Митигируется:
- default deny NetworkPolicy;
- namespace isolation;
- egress control.

---

# Supply Chain Threats

## Malicious Images

Угрозы:
- backdoored контейнеры;
- poisoned ML frameworks;
- скрытые miner’ы.

Митигируется:
- allowlist registry;
- signed images only;
- provenance checks.

Связь: `docs/supply-chain-security.md`

---

## Dependency Poisoning

Угрозы:
- вредоносные зависимости;
- подмена build-артефактов.

Митигируется:
- SBOM;
- provenance;
- immutable images.

---

# CI/CD Threats

Угрозы:
- компрометация pipeline;
- внедрение вредоносных манифестов;
- подмена политик.

Митигируется:
- policy validation в CI;
- separation of duties;
- GitOps-модель.

---

# Runtime Threats

## Post-Deployment Abuse

Угрозы:
- выполнение неожиданных процессов;
- криптомайнинг;
- data exfiltration.

Митигируется:
- runtime detection;
- behavior-based alerts;
- audit trails.

Связь: `docs/runtime-security.md`

---

# Cross-Cutting Threats

## Misconfiguration

Угрозы:
- permissive policies;
- открытые namespaces;
- отсутствие ограничений.

Митигируется:
- deny-by-default;
- automated validation;
- compliance enforcement.

---

# Связь с архитектурой

Все угрозы:
- маппятся на security layers;
- покрываются policy и runtime контурами;
- проверяются в CI.

Архитектура определяет mitigation,  
а не наоборот.

---

# Связь с другими документами

- `README.md` — scope и позиционирование  
- `security-boundary.md` — trust model  
- `admission-control.md` — enforcement  
- `runtime-security.md` — execution-time защита  
- `supply-chain-security.md` — цепочка поставки  

---

# Не-цели threat model

Модель не описывает:
- конкретные CVE;
- tool-specific эксплойты;
- pentest-отчёты.

Это **структурная модель угроз**, а не чеклист.

---

# Итог

Threat model:
- определяет архитектурные решения;
- формирует policy-стратегию;
- задаёт требования к runtime защите;
- исключает слепые зоны.

В Sovereign AI атака рассматривается как неизбежная.  
Архитектура строится так, чтобы она была контролируемой.
