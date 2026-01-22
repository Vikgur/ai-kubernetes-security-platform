# Оглавление

- [Назначение Admission Control](#назначение-admission-control)  
- [Роль admission в архитектуре](#роль-admission-в-архитектуре)  
- [Типы admission контролей](#типы-admission-контролей)  
- [Validating Admission](#validating-admission)  
  - [Назначение](#назначение)  
  - [Характеристики](#характеристики)  
  - [Примеры блокировок](#примеры-блокировок)  
- [Mutating Admission](#mutating-admission)  
  - [Назначение](#назначение-1)  
  - [Характеристики](#характеристики-1)  
  - [Примеры мутаций](#примеры-мутаций)  
- [Что блокируется всегда](#что-блокируется-всегда)  
- [Что допускается условно](#что-допускается-условно)  
- [Связь с Pod Security Standards](#связь-с-pod-security-standards)  
- [Admission и policy engines](#admission-и-policy-engines)  
  - [OPA Gatekeeper](#opa-gatekeeper)  
  - [Kyverno](#kyverno)  
- [Admission и среды](#admission-и-среды)  
- [Связь с runtime security](#связь-с-runtime-security)  
- [Инварианты admission control](#инварианты-admission-control)  
- [Не-цели admission](#не-цели-admission)  
- [Итог](#итог)

---

# Назначение Admission Control

`admission-control.md` описывает **контур enforcement на входе в Kubernetes-кластер**.

Документ отвечает на вопросы:
- какие объекты допускаются в кластер;
- какие отклоняются безусловно;
- какие могут быть модифицированы;
- где проходит граница между admission и runtime защитой.

Admission — **первая и обязательная линия обороны**.

---

# Роль admission в архитектуре

Admission находится между:
- запросом к API;
- фактическим созданием объекта.

Здесь:
- вход считается недоверенным;
- политики исполняются принудительно;
- решения принимаются детерминированно.

Admission не логирует намерения.  
Он либо разрешает, либо запрещает.

---

# Типы admission контролей

Используются два класса:

- Validating Admission  
- Mutating Admission  

Они дополняют друг друга и не пересекаются по ответственности.

---

# Validating Admission

## Назначение

- строгая проверка соответствия требованиям;
- блокировка небезопасных объектов;
- защита архитектурных инвариантов.

## Характеристики

- не изменяет объект;
- возвращает allow или deny;
- используется для non-negotiable правил.

## Примеры блокировок

Блокируется всегда:
- privileged containers;
- hostPath и hostNetwork без явного разрешения;
- запуск от root;
- отсутствие обязательных labels;
- отсутствие resource limits;
- попытки обхода baseline.

Validating admission — точка **жёсткого отказа**.

---

# Mutating Admission

## Назначение

- автоматическое приведение объекта к допустимому виду;
- снижение вероятности human error;
- стандартизация конфигураций.

## Характеристики

- изменяет объект до валидации;
- работает в рамках допустимого;
- не ослабляет безопасность.

## Примеры мутаций

Допускается условно:
- добавление seccomp профиля;
- установка readOnlyRootFilesystem;
- нормализация securityContext;
- добавление стандартных labels.

Mutating admission **никогда не превращает deny в allow**.

---

# Что блокируется всегда

Без исключений:
- privileged pods;
- host PID / IPC / Network;
- cluster-admin для workload’ов;
- обход Pod Security Standards;
- образы из неразрешённых registry;
- неподписанные образы.

Эти правила не имеют override’ов.

---

# Что допускается условно

Допускается при выполнении условий:
- non-root при наличии user override;
- дополнительные capabilities при explicit allow;
- network egress при наличии политики;
- elevated permissions в system namespaces.

Условие всегда выражено в коде.

---

# Связь с Pod Security Standards

Pod Security Standards используются как:
- минимальный baseline;
- входной фильтр;
- совместимый с upstream механизм.

Admission:
- расширяет PSS;
- закрывает gaps;
- enforce’ит stricter правила.

PSS — необходимое, но недостаточное условие.

---

# Admission и policy engines

## OPA Gatekeeper

Используется для:
- строгого validation;
- compliance-критичных запретов;
- cluster-wide правил.

## Kyverno

Используется для:
- mutation;
- guardrails;
- developer-facing defaults.

Роли чётко разделены.

---

# Admission и среды

Admission:
- одинаков во всех средах;
- не имеет dev-mode;
- не ослабляется в stage.

Если объект не проходит admission в dev — он не готов к prod.

---

# Связь с runtime security

Admission:
- предотвращает известные риски;
- не контролирует поведение.

Runtime:
- покрывает execution-time угрозы;
- реагирует на post-deploy атаки.

Подробно: `docs/runtime-security.md`

---

# Инварианты admission control

Никогда не нарушаются:
- deny-by-default;
- отсутствие ручных override’ов;
- детерминированные решения;
- audit каждого отказа;
- Git как источник политик.

---

# Не-цели admission

Admission не решает:
- runtime эксплойты;
- zero-day в ядре;
- поведенческие аномалии;
- incident response.

Он закрывает **вход**, а не исполнение.

---

# Итог

Admission control:
- превращает архитектуру в принудимые правила;
- исключает небезопасные деплои;
- стандартизирует конфигурации;
- является фундаментом platform security.

В Sovereign AI ничего не попадает в кластер  
без прохождения admission.
