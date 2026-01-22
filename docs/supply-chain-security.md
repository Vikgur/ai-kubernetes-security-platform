# Оглавление

- [Назначение Supply Chain Security](#назначение-supply-chain-security)  
- [Базовый принцип](#базовый-принцип)  
- [Image Trust Model](#image-trust-model)  
  - [Разрешённые источники](#разрешённые-источники)  
  - [Подпись образов](#подпись-образов)  
  - [Enforcement на уровне Kubernetes](#enforcement-на-уровне-kubernetes)  
- [SBOM Lifecycle](#sbom-lifecycle)  
  - [Назначение SBOM](#назначение-sbom)  
  - [Генерация](#генерация)  
  - [Использование](#использование)  
- [Provenance](#provenance)  
  - [Назначение](#назначение)  
  - [Provenance и CI](#provenance-и-ci)  
- [Связь CI → Deployment](#связь-ci--deployment)  
- [Supply Chain и Threat Model](#supply-chain-и-threat-model)  
- [Supply Chain и Compliance](#supply-chain-и-compliance)  
- [Инварианты supply chain](#инварианты-supply-chain)  
- [Не-цели supply chain security](#не-цели-supply-chain-security)  
- [Итог](#итог)

---

# Назначение Supply Chain Security

`supply-chain-security.md` описывает **модель доверия к артефактам**, которые попадают в Kubernetes-платформу Sovereign AI.

Документ отвечает на вопросы:
- каким образам можно доверять;
- как формируется и проверяется SBOM;
- как подтверждается происхождение артефактов;
- где проходит граница между CI и deployment.

Supply chain — один из главных векторов атак.  
Здесь доверие **никогда не подразумевается**.

---

# Базовый принцип

Артефакт по умолчанию **недоверенный**.

Доверие возникает только если:
- известен источник;
- подтверждена целостность;
- проверено происхождение;
- выполнены политики допуска.

Отсутствие сигнала ≠ доверие.

---

# Image Trust Model

## Разрешённые источники

В кластер допускаются только образы:
- из allowlist registry;
- с известным владельцем;
- с неизменяемыми тегами или digest.

Public registry не считается доверенным по умолчанию.

---

## Подпись образов

Образ считается допустимым, если:
- он подписан доверенным ключом;
- подпись проверяема автоматически;
- ключи управляются централизованно.

Неподписанный образ не деплоится.

---

## Enforcement на уровне Kubernetes

Проверка доверия:
- выполняется на admission этапе;
- блокирует деплой до runtime;
- не зависит от команды разработки.

Deployment без trust-check невозможен.

---

# SBOM Lifecycle

## Назначение SBOM

SBOM:
- фиксирует состав артефакта;
- используется для vulnerability management;
- является частью compliance evidence.

SBOM — не отчёт, а актив.

---

## Генерация

SBOM:
- создаётся в CI;
- привязывается к конкретному образу;
- версионируется вместе с артефактом.

Ручная генерация недопустима.

---

## Использование

SBOM применяется:
- при admission проверках;
- при incident response;
- при регуляторных аудитах.

Отсутствие SBOM считается нарушением.

---

# Provenance

## Назначение

Provenance подтверждает:
- где и как был собран артефакт;
- каким pipeline’ом;
- из какого исходного кода.

Это защита от подмены и replay атак.

---

## Provenance и CI

Provenance:
- генерируется CI;
- подписывается;
- передаётся вместе с образом.

CI без provenance не считается доверенным.

---

# Связь CI → Deployment

Контур доверия:

Source  
→ CI build  
→ SBOM  
→ Provenance  
→ Image signing  
→ Admission validation  
→ Runtime

Разрыв в цепочке = отказ в деплое.

---

# Supply Chain и Threat Model

Основные угрозы:
- poisoned images;
- dependency substitution;
- compromised CI;
- replay артефактов.

Митигируются через:
- trust model;
- SBOM;
- provenance;
- admission enforcement.

Подробно: `docs/kubernetes-threat-model.md`

---

# Supply Chain и Compliance

Supply chain:
- поставляет доказательства происхождения;
- снижает scope аудита;
- повышает доверие регуляторов.

SBOM и provenance — формальные evidence.

Подробно: `docs/compliance-overview.md`

---

# Инварианты supply chain

Никогда не нарушаются:
- нет доверия без подписи;
- нет деплоя без provenance;
- нет артефактов без SBOM;
- нет ручных исключений.

---

# Не-цели supply chain security

Платформа не предназначена для:
- доверия по тегу latest;
- ручной валидации образов;
- implicit trust CI;
- обхода enforcement ради скорости.

---

# Итог

Supply chain security:
- делает атаки на артефакты видимыми;
- исключает silent compromise;
- связывает CI и Kubernetes в единый контур;
- является основой доверия в Sovereign AI.

Если неизвестно, откуда артефакт — он не запускается.
