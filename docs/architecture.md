# Оглавление

- [Назначение Kubernetes Security Architecture](#назначение-kubernetes-security-architecture)  
- [Архитектурный принцип](#архитектурный-принцип)  
- [Security Layers](#security-layers)  
- [Bootstrap Layer](#bootstrap-layer)  
- [Baseline Layer](#baseline-layer)  
- [Enforcement Layer](#enforcement-layer)  
- [Runtime Layer](#runtime-layer)  
- [Audit Layer](#audit-layer)  
- [Control Plane vs Data Plane](#control-plane-vs-data-plane)  
  - [Control Plane](#control-plane)  
  - [Data Plane](#data-plane)  
- [Policy Engines в архитектуре](#policy-engines-в-архитектуре)  
- [Runtime Detection в архитектуре](#runtime-detection-в-архитектуре)  
- [Связь с другими документами](#связь-с-другими-документами)  
- [Архитектурные инварианты](#архитектурные-инварианты)  
- [Не-цели архитектуры](#не-цели-архитектуры)  
- [Итог](#итог)

---

# Назначение Kubernetes Security Architecture

`architecture.md` описывает **целостную security-архитектуру Kubernetes-платформы** в составе Sovereign AI.

Документ отвечает на вопросы:
- как устроена безопасность кластера как системы;
- где проходят security boundaries;
- какие контуры за что отвечают;
- как enforcement и runtime дополняют друг друга.

README описывает *что* реализовано.  
Этот документ описывает *как и почему*.

---

# Архитектурный принцип

Kubernetes рассматривается как **единая система безопасности**, а не набор компонентов.

Безопасность:
- не добавляется поверх;
- не зависит от приложений;
- не ослабляется средой.

Все контуры работают совместно и перекрывают друг друга.

---

# Security Layers

Архитектура построена по многоуровневой модели:

**bootstrap → baseline → enforcement → runtime → audit**

Каждый слой:
- имеет чёткую зону ответственности;
- не заменяет предыдущий;
- рассчитан на отказ нижележащего слоя.

---

# Bootstrap Layer

Назначение:
- минимально безопасный старт кластера.

Свойства:
- задание базовых инвариантов;
- подготовка namespaces и системных контуров;
- отсутствие доверия к workload’ам.

Bootstrap не содержит бизнес-логики.  
Он задаёт точку, ниже которой кластер опуститься не может.

---

# Baseline Layer

Назначение:
- зафиксировать **минимально допустимый уровень безопасности**.

Содержит:
- Pod Security Standards;
- resource quotas;
- namespace boundaries;
- базовые RBAC ограничения.

Baseline — это **security floor**, одинаковый для всех сред.

---

# Enforcement Layer

Назначение:
- жёстко принуждать архитектурные и security-инварианты.

Реализуется через:
- OPA Gatekeeper;
- Kyverno;
- admission webhooks.

Задачи:
- deny небезопасных конфигураций;
- автоматическая мутация допустимых;
- блокировка drift’а.

Enforcement работает **до создания объекта**.

Подробно: `docs/admission-control.md`

---

# Runtime Layer

Назначение:
- контроль поведения уже запущенных workload’ов.

Реализуется через:
- seccomp;
- AppArmor;
- runtime detection (Falco-подобный подход);
- security alerts.

Runtime:
- не доверяет admission’у;
- рассчитан на компрометацию pod’а;
- фиксирует попытки выхода за модель.

Подробно: `docs/runtime-security.md`

---

# Audit Layer

Назначение:
- полная наблюдаемость security-событий.

Содержит:
- audit logs API-сервера;
- security-метрики;
- compliance evidence;
- входные данные для расследований.

Audit не предотвращает атаки.  
Он делает их **невозможными для сокрытия**.

---

# Control Plane vs Data Plane

## Control Plane

Защищается через:
- hardening компонентов;
- строгие RBAC;
- audit logging;
- admission policies.

Control plane — главный объект защиты.  
Компрометация CP считается критическим инцидентом.

## Data Plane

Защищается через:
- namespace isolation;
- network policies;
- runtime enforcement;
- resource ограничения.

Data plane считается **hostile-by-default**.

---

# Policy Engines в архитектуре

Policy engines применяются:
- на входе в кластер (admission);
- при эволюции конфигураций;
- для compliance enforcement.

Роль:
- формализовать требования безопасности;
- исключить человеческий фактор;
- сделать безопасность проверяемой.

Policy engines — не advisory.  
Они всегда enforce.

---

# Runtime Detection в архитектуре

Runtime detection:
- дополняет policy enforcement;
- покрывает поведение, а не конфигурацию;
- реагирует на неизвестные сценарии атак.

Он не заменяет политики.  
Он закрывает gap между design-time и execution-time.

---

# Связь с другими документами

- `README.md` — обзор платформы и scope  
- `architecture.md` — системная модель безопасности  
- `admission-control.md` — enforcement и policy engines  
- `runtime-security.md` — защита исполнения и detection  

Документы читаются **сверху вниз**, от абстракции к деталям.

---

# Архитектурные инварианты

Никогда не нарушаются:
- security-first, не app-first;
- deny-by-default;
- immutable environments;
- auditability как обязательство;
- GitOps как единственный источник истины.

---

# Не-цели архитектуры

Архитектура сознательно не решает:
- удобство локальной разработки;
- permissive onboarding;
- ручное администрирование;
- обход политик “временно”.

Безопасность не торгуется удобством.

---

# Итог

Эта архитектура:
- масштабируется под regulated AI;
- устойчива к ошибкам и компрометациям;
- совместима с sovereign требованиями;
- рассчитана на Senior / Principal уровень эксплуатации.

Kubernetes здесь — не оркестратор.  
Это **security platform для Sovereign AI**.
