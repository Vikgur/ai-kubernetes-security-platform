# Оглавление

- [Назначение Security Boundary](#назначение-security-boundary)  
- [Базовый принцип](#базовый-принцип)  
- [Trust Boundaries](#trust-boundaries)  
- [Kubernetes vs Underlying Infrastructure](#kubernetes-vs-underlying-infrastructure)  
  - [Trusted](#trusted)  
  - [Untrusted](#untrusted)  
- [Control Plane Boundary](#control-plane-boundary)  
  - [Trusted](#trusted-1)  
  - [Security Properties](#security-properties)  
- [Data Plane Boundary](#data-plane-boundary)  
  - [Untrusted](#untrusted-1)  
  - [Mitigations](#mitigations)  
- [Human Identities vs Workload Identities](#human-identities-vs-workload-identities)  
  - [Human Identities](#human-identities)  
  - [Workload Identities](#workload-identities)  
- [Namespace Boundary](#namespace-boundary)  
- [CI/CD Boundary](#cicd-boundary)  
- [Admission Boundary](#admission-boundary)  
- [Runtime Boundary](#runtime-boundary)  
- [Связь с моделью угроз](#связь-с-моделью-угроз)  
- [Связь с policy-стратегией](#связь-с-policy-стратегией)  
- [Инварианты security boundary](#инварианты-security-boundary)  
- [Не-цели документа](#не-цели-документа)  
- [Итог](#итог)

---

# Назначение Security Boundary

`security-boundary.md` формализует **границы доверия и ответственности** в Kubernetes-платформе Sovereign AI.

Документ отвечает на вопросы:
- чему можно доверять и при каких условиях;
- где проходят trust boundaries;
- какие субъекты считаются hostile;
- где заканчивается ответственность Kubernetes.

README описывает платформу.  
Этот документ фиксирует **модель доверия**.

---

# Базовый принцип

По умолчанию **ничему не доверяется**.

Доверие:
- явно задано;
- минимально;
- проверяемо;
- отзываемо.

Отсутствие формализованных границ считается архитектурной ошибкой.

---

# Trust Boundaries

В платформе выделяются следующие trust boundaries:

1. Kubernetes ↔ underlying infrastructure  
2. Control plane ↔ data plane  
3. Human identities ↔ workload identities  
4. Namespace ↔ namespace  
5. CI/CD ↔ runtime cluster  

Каждая граница:
- контролируется;
- логируется;
- защищается политиками.

---

# Kubernetes vs Underlying Infrastructure

## Trusted

- физическая и виртуальная инфраструктура;
- hardened OS и container runtime;
- bootstrap-скрипты и Ansible-hardening;
- cloud primitives (VPC, firewall, IAM).

## Untrusted

- всё, что выполняется внутри Kubernetes как workload;
- любой pod;
- любой контейнер;
- любой namespace, кроме system.

Kubernetes **не расширяет доверие инфраструктуры**.  
Он изолирует её от workload’ов.

---

# Control Plane Boundary

## Trusted

- API server;
- scheduler;
- controller-manager;
- etcd (при корректном hardening).

## Security Properties

- строгий RBAC;
- audit logging;
- admission enforcement;
- минимальный доступ администраторов.

Компрометация control plane:
- рассматривается как критическая;
- требует incident response;
- не должна происходить silently.

---

# Data Plane Boundary

Data plane считается **hostile-by-default**.

## Untrusted

- все пользовательские workload’ы;
- AI training и inference контейнеры;
- сторонние образы;
- transient jobs.

## Mitigations

- namespace isolation;
- network policies;
- runtime enforcement;
- resource limits;
- behavior detection.

Data plane никогда не получает implicit trust.

---

# Human Identities vs Workload Identities

## Human Identities

- SRE;
- DevSecOps;
- platform operators;
- auditors.

Свойства:
- минимальный RBAC;
- короткоживущие креды;
- полный аудит;
- break-glass как исключение.

## Workload Identities

- ServiceAccounts;
- pod-bound identities;
- автоматические токены.

Свойства:
- строго namespace-scoped;
- без кросс-доступа;
- без cluster-admin;
- подчинены admission и policy engines.

Human ≠ workload.  
Их права никогда не пересекаются.

---

# Namespace Boundary

Namespace — базовая unit изоляции, но **не security perimeter**.

Свойства:
- логическая изоляция;
- enforcement через policies;
- network isolation обязательна.

Без NetworkPolicy namespace считается небезопасным.

---

# CI/CD Boundary

CI/CD:
- считается внешним по отношению к кластеру;
- не имеет постоянного доступа;
- взаимодействует через декларативные интерфейсы.

Git — единственный источник истины.  
Кластер — пассивный consumer.

---

# Admission Boundary

Admission — ключевая точка контроля.

Здесь:
- недоверенный ввод;
- формализация требований;
- окончательное решение о допуске.

Все объекты:
- считаются потенциально вредоносными;
- проверяются политиками;
- либо допускаются, либо отклоняются.

---

# Runtime Boundary

Runtime:
- не доверяет admission;
- не доверяет образу;
- не доверяет процессу.

Любое поведение вне модели:
- фиксируется;
- алертится;
- может быть заблокировано.

---

# Связь с моделью угроз

Границы доверия используются как основа:
- STRIDE-модели;
- attack scenarios;
- mitigations.

Подробно: `docs/kubernetes-threat-model.md`

---

# Связь с policy-стратегией

Все границы:
- выражаются в policy-as-code;
- enforce’ятся автоматически;
- проверяются в CI.

Подробно: `docs/policy-strategy.md`

---

# Инварианты security boundary

Никогда не нарушаются:
- workload’ам нельзя доверять;
- humans ограничены RBAC;
- контроль всегда централизован;
- ручные исключения запрещены;
- audit обязателен.

---

# Не-цели документа

Документ не описывает:
- конкретные YAML-манифесты;
- tool-specific конфигурации;
- operational runbooks.

Он фиксирует **модель доверия**, а не реализацию.

---

# Итог

Security boundary:
- определяет архитектуру безопасности;
- задаёт основу threat modeling;
- исключает implicit trust;
- делает Kubernetes управляемой security-системой.

В Sovereign AI доверие — это ресурс.  
И он распределяется крайне экономно.
