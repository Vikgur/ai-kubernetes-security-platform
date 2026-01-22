# Оглавление

- [Назначение Runtime Security](#назначение-runtime-security)  
- [Базовый принцип](#базовый-принцип)  
- [Классы runtime-угроз](#классы-runtime-угроз)  
  - [Unexpected Process Execution](#unexpected-process-execution)  
  - [Privilege Escalation](#privilege-escalation)  
  - [Container Escape](#container-escape)  
  - [Network Abuse](#network-abuse)  
  - [Resource Abuse](#resource-abuse)  
- [Роль seccomp](#роль-seccomp)  
  - [Назначение](#назначение)  
  - [Рациональность](#рациональность)  
- [Роль AppArmor](#роль-apparmor)  
  - [Назначение](#назначение-1)  
  - [Рациональность](#рациональность-1)  
- [Falco-подобная модель detection](#falco-подобная-модель-detection)  
  - [Подход](#подход)  
  - [Детектируемые события](#детектируемые-события)  
- [Alert vs Response](#alert-vs-response)  
  - [Alerting](#alerting)  
  - [Response](#response)  
- [Runtime и audit](#runtime-и-audit)  
- [Связь с моделью угроз](#связь-с-моделью-угроз)  
- [Связь с observability-security](#связь-с-observability-security)  
- [Инварианты runtime-защиты](#инварианты-runtime-защиты)  
- [Не-цели runtime security](#не-цели-runtime-security)  
- [Итог](#итог)

---

# Назначение Runtime Security

`runtime-security.md` описывает **контур защиты Kubernetes после деплоя workload’ов**.

Документ отвечает на вопросы:
- какие угрозы существуют на этапе исполнения;
- почему admission недостаточен;
- как ограничивается поведение процессов;
- как обнаруживаются атаки и аномалии.

Runtime security — **последняя линия обороны**.

---

# Базовый принцип

После деплоя:
- объект считается потенциально скомпрометированным;
- конфигурация больше не гарантирует безопасность;
- контроль должен быть поведенческим.

Runtime защита не доверяет:
- admission;
- образу;
- разработчику;
- прошлым проверкам.

---

# Классы runtime-угроз

## Unexpected Process Execution

- запуск shell’ов;
- отладочные инструменты;
- сторонние бинарники.

---

## Privilege Escalation

- попытки получения root;
- изменение capabilities;
- взаимодействие с host.

---

## Container Escape

- системные вызовы ядра;
- доступ к host filesystem;
- взаимодействие с container runtime.

---

## Network Abuse

- неожиданные исходящие соединения;
- lateral movement;
- data exfiltration.

---

## Resource Abuse

- криптомайнинг;
- fork bombs;
- DoS через ресурсы.

---

# Роль seccomp

## Назначение

seccomp:
- ограничивает системные вызовы;
- уменьшает kernel attack surface;
- применяется до запуска процесса.

## Рациональность

- большинство приложений используют малый поднабор syscalls;
- запрет по умолчанию снижает impact эксплойтов;
- отказоустойчив к misconfiguration.

seccomp — **предиктивная защита**, а не детекция.

---

# Роль AppArmor

## Назначение

AppArmor:
- ограничивает доступ к файловой системе;
- контролирует сетевые операции;
- задаёт модель допустимого поведения.

## Рациональность

- syscall-фильтрации недостаточно;
- нужен контроль ресурсов и путей;
- профили могут быть workload-specific.

AppArmor — **policy enforcement на уровне ядра**.

---

# Falco-подобная модель detection

## Подход

Используется модель:
- наблюдение за системными событиями;
- сопоставление с ожидаемым поведением;
- генерация сигналов при отклонении.

## Детектируемые события

- exec внутри контейнера;
- модификация бинарников;
- доступ к sensitive путям;
- сетевые аномалии.

Detection ориентирован на **behavior**, а не сигнатуры.

---

# Alert vs Response

## Alerting

- сигнализирует о нарушении;
- не останавливает систему;
- используется для расследований.

Применяется для:
- раннего обнаружения;
- обучения модели поведения;
- forensic анализа.

---

## Response

- активное вмешательство;
- ограничение или завершение workload’а;
- изоляция namespace.

Используется только:
- при высоком уровне уверенности;
- при строгих runbooks;
- без ложных срабатываний.

Response всегда вторичен по отношению к alerting.

---

# Runtime и audit

Все runtime-события:
- логируются;
- коррелируются;
- доступны для compliance evidence.

Runtime без audit не считается защитой.

---

# Связь с моделью угроз

Runtime закрывает угрозы:
- post-deploy abuse;
- unknown attack vectors;
- zero-day behavior.

Подробно: `docs/kubernetes-threat-model.md`

---

# Связь с observability-security

Runtime security:
- поставляет сигналы;
- использует метрики и логи;
- интегрируется с alerting.

Observability — транспорт.  
Runtime security — смысл.

---

# Инварианты runtime-защиты

Никогда не нарушаются:
- workload не доверяется;
- поведение ограничено;
- события фиксируются;
- ручное вмешательство минимально.

---

# Не-цели runtime security

Runtime не решает:
- архитектурные ошибки;
- слабые политики;
- отсутствие admission;
- плохой дизайн приложений.

Он компенсирует, но не заменяет.

---

# Итог

Runtime security:
- принимает факт компрометации;
- минимизирует impact;
- обеспечивает обнаружение;
- замыкает security lifecycle.

В Sovereign AI безопасность продолжается  
после деплоя.
