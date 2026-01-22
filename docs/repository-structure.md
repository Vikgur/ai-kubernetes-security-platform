# Оглавление

- [Назначение Repository Structure](#назначение-repository-structure)  
- [Ключевая идея](#ключевая-идея)  
- [Как читать репозиторий](#как-читать-репозиторий)  
- [Где enforcement, а где описание](#где-enforcement-а-где-описание)  
- [Роль корневых файлов](#роль-корневых-файлов)  
  - [README.md](#readmemd)  
  - [Linters и policy config](#linters-и-policy-config)  
- [Роль ключевых директорий](#роль-ключевых-директорий)  
  - [`cluster/`](#cluster)  
  - [`rbac/`](#rbac)  
  - [`network-security/`](#network-security)  
  - [`runtime-security/`](#runtime-security)  
  - [`supply-chain-security/`](#supply-chain-security)  
  - [`policy-engine/`](#policy-engine)  
  - [`observability-security/`](#observability-security)  
  - [`multi-tenancy/`](#multi-tenancy)  
  - [`compliance/`](#compliance)  
  - [`threat-model/`](#threat-model)  
  - [`environments/`](#environments)  
  - [`ci/`](#ci)  
  - [`scripts/`](#scripts)  
  - [`docs/`](#docs)
- [Назначение директорий и файлов](#назначение-директорий-и-файлов)  
  - [README.md](#readmemd-1)  
  - [.gitignore](#gitignore)  
  - [.editorconfig](#editorconfig)  
  - [.yamllint](#yamllint)  
  - [.kube-linter.yaml](#kube-linteryaml)  
  - [.opa.yaml](#opa-yaml)  
  - [.trivyignore](#trivyignore)  
  - [.checkov.yaml](#checkovyaml)  
  - [cluster/](#cluster)  
    - [bootstrap/](#bootstrap)  
    - [baseline/](#baseline)  
    - [hardening/](#hardening)  
    - [README.md](#readmemd-2)  
  - [rbac/](#rbac)  
    - [base/](#base)  
    - [break-glass/](#break-glass)  
    - [README.md](#readmemd-3)  
  - [network-security/](#network-security)  
    - [cni/](#cni)  
    - [network-policies/](#network-policies)  
    - [dns-security.yaml](#dns-securityyaml)  
    - [README.md](#readmemd-4)
  - [runtime-security/](#runtime-security)  
    - [admission/](#admission)  
    - [pod-security/](#pod-security)  
    - [seccomp/](#seccomp)  
    - [apparmor/](#apparmor)  
    - [README.md](#readmemd-5)  
  - [supply-chain-security/](#supply-chain-security)  
    - [image-policy/](#image-policy)  
    - [sbom/](#sbom)  
    - [provenance/](#provenance)  
    - [README.md](#readmemd-6)  
  - [policy-engine/](#policy-engine)  
    - [opa-gatekeeper/](#opa-gatekeeper)  
      - [constraints/](#constraints)  
      - [templates/](#templates)  
    - [kyverno/](#kyverno)  
    - [rego/](#rego)  
    - [README.md](#readmemd-7)  
  - [observability-security/](#observability-security)  
    - [audit-logs/](#audit-logs)  
    - [falco/](#falco)  
    - [prometheus-rules/](#prometheus-rules)  
    - [README.md](#readmemd-8)
  - [multi-tenancy/](#multi-tenancy)  
  - [compliance/](#compliance)  
    - [cis/](#cis)  
    - [nist/](#nist)  
    - [iso27001/](#iso27001)  
    - [reports/](#reports)  
    - [README.md](#readmemd-9)  
  - [threat-model/](#threat-model)  
    - [STRIDE.md](#stride-md)  
    - [attack-scenarios.md](#attack-scenarios-md)  
    - [mitigations.md](#mitigations-md)  
    - [README.md](#readmemd-10)  
  - [environments/](#environments)  
    - [dev/](#dev)  
    - [stage/](#stage)  
    - [prod/](#prod)  
    - [base/](#base-1)  
    - [kustomization.yaml](#kustomization-yaml)  
    - [README.md](#readmemd-11)
  - [ci/](#ci)  
    - [kube-linter.yml](#kube-linteryml)  
    - [opa-policy-check.yml](#opa-policy-checkyml)  
    - [trivy-k8s.yml](#trivy-k8syml)  
    - [manifest-validate.yml](#manifest-validateyml)  
    - [compliance-report.yml](#compliance-reportyml)  
    - [README.md](#readmemd-12)  
  - [scripts/](#scripts)  
    - [apply-baseline.sh](#apply-baselinesh)  
    - [verify-cluster.sh](#verify-clustersh)  
    - [audit-dump.sh](#audit-dumpsh)  
    - [architecture_bootstrap.sh](#architecture_bootstrapsh)  
    - [README.md](#readmemd-13)  
  - [docs/](#docs)  
    - [architecture.md](#architecture-md)  
    - [security-boundary.md](#security-boundary-md)  
    - [kubernetes-threat-model.md](#kubernetes-threat-model-md)  
    - [policy-strategy.md](#policy-strategy-md)  
    - [admission-control.md](#admission-control-md)  
    - [runtime-security.md](#runtime-security-md)  
    - [supply-chain-security.md](#supply-chain-security-md)  
    - [compliance-overview.md](#compliance-overview-md)  
    - [repository-structure.md](#repository-structure-md)

---

# Назначение Repository Structure

`repository-structure.md` объясняет, **как читать, понимать и использовать репозиторий** платформенной безопасности Kubernetes.

Репозиторий:
- не набор YAML;
- не коллекция best practices;
- не демо.

Это **operational security platform**, реализованная как минимально необходимая codebase.

Репозиторий:
- читается как архитектура;
- применяется как платформа;
- проверяется как продукт.

---

# Ключевая идея

Репозиторий отражает архитектуру, а не окружение.

Принципы:
- immutable infrastructure;
- policy as code;
- deny by default;
- separation of concerns;
- enforcement > documentation.

Если чего-то нет в репозитории — этого не существует в платформе.

---

# Как читать репозиторий

Чтение идёт **сверху вниз по уровням контроля**:

1. Архитектура и границы доверия (`docs/`)
2. Platform-level controls (`cluster/`, `rbac/`, `network-security/`)
3. Enforcement и policy engines (`policy-engine/`, `runtime-security/`)
4. Supply chain (`supply-chain-security/`)
5. Observability и detection (`observability-security/`)
6. Compliance как производная (`compliance/`)
7. Environment overlays (`environments/`)
8. Автоматизация (`ci/`, `scripts/`)

---

# Где enforcement, а где описание

- **Enforcement**: всё, что применяется к кластеру
  - YAML, политики, webhooks, профили, quotas
- **Documentation**: объясняет *почему*, а не *как*
  - `docs/`, `README.md` в каталогах

Документация не дублирует enforcement.  
Enforcement не объясняет себя.

---

# Роль корневых файлов

## README.md

Точка входа.
Фиксирует:
- философию;
- границы;
- целевую модель безопасности.

Читается первым.

---

## Linters и policy config

Файлы вида:
- `.yamllint`
- `.kube-linter.yaml`
- `.opa.yaml`
- `.checkov.yaml`
- `.trivyignore`

Определяют **gate’ы качества**.
Ни один манифест не считается допустимым без прохождения этих проверок.

---

# Роль ключевых директорий

## `cluster/`

Базовая безопасность control plane и core namespace’ов.

Решает:
- baseline hardening;
- Pod Security Standards;
- resource isolation;
- API-level hardening.

DevSecOps-смысл:  
защита кластера как платформы, а не как среды для приложений.

---

## `rbac/`

Модель доступа.

Решает:
- least privilege;
- separation of duties;
- break-glass сценарии.

DevSecOps-смысл:  
доступ — это attack surface.

---

## `network-security/`

Сетевые границы.

Решает:
- namespace isolation;
- default deny;
- DNS security.

DevSecOps-смысл:  
каждый pod изолирован, пока не доказано обратное.

---

## `runtime-security/`

Контроль после admission.

Решает:
- admission enforcement;
- pod security context;
- seccomp / AppArmor.

DevSecOps-смысл:  
даже допустимый workload не считается безопасным по умолчанию.

---

## `supply-chain-security/`

Доверие к артефактам.

Решает:
- image trust;
- SBOM;
- provenance;
- связь CI → cluster.

DevSecOps-смысл:  
атака начинается задолго до деплоя.

---

## `policy-engine/`

Центр политик.

Решает:
- validation;
- mutation;
- enforcement.

Использует:
- OPA Gatekeeper;
- Kyverno.

DevSecOps-смысл:  
политика — это код, а не договорённость.

---

## `observability-security/`

Видимость и detection.

Решает:
- audit logs;
- runtime detection;
- security alerts.

DevSecOps-смысл:  
невидимая атака считается успешной.

---

## `multi-tenancy/`

Изоляция команд и арендаторов.

Решает:
- tenant boundaries;
- quota enforcement;
- blast radius reduction.

DevSecOps-смысл:  
ошибка одной команды не должна быть инцидентом платформы.

---

## `compliance/`

Compliance как следствие.

Решает:
- mapping к CIS / NIST / ISO;
- evidence;
- audit readiness.

DevSecOps-смысл:  
compliance не добавляется — он вытекает.

---

## `threat-model/`

Модель угроз.

Решает:
- формализацию атак;
- привязку mitigations;
- архитектурное мышление.

DevSecOps-смысл:  
без threat model безопасность декларативна.

---

## `environments/`

Environment overlays.

Решает:
- dev / stage / prod отличия;
- controlled drift;
- reproducibility.

DevSecOps-смысл:  
окружения отличаются конфигурацией, не архитектурой.

---

## `ci/`

Security gates.

Решает:
- policy validation;
- static analysis;
- compliance reporting.

DevSecOps-смысл:  
security не опционален и не ручной.

---

## `scripts/`

Операционные действия.

Решает:
- bootstrap;
- verification;
- audit dump.

DevSecOps-смысл:  
ручные действия формализуются или запрещаются.

---

## `docs/`

Архитектурное описание.

Решает:
- объяснение решений;
- связи между слоями;
- onboarding senior-level инженеров.

DevSecOps-смысл:  
без архитектуры контроль не масштабируется.

---

# Назначение директорий и файлов

## README.md
Главная точка входа репозитория.  
Содержит позиционирование, scope, non-goals и ссылки на docs/.  
DevSecOps-смысл: быстрое понимание архитектуры и политики безопасности.

## .gitignore
Файл исключений Git.  
Определяет, какие временные, локальные или чувствительные файлы не попадут в репозиторий.  
DevSecOps-смысл: предотвращение утечек секретов и мусора в кодовую базу.

## .editorconfig
Конфигурация редактора кода.  
Устанавливает единый стиль форматирования YAML и других файлов.  
DevSecOps-смысл: стандартизированная кодовая база для команды и CI.

## .yamllint
Конфигурация линтера YAML.  
Проверяет корректность синтаксиса и стиль манифестов.  
DevSecOps-смысл: предотвращение ошибок деплоя из-за некорректных YAML.

## .kube-linter.yaml
Конфигурация kube-linter.  
Выполняет статическую проверку Kubernetes манифестов на best practices и безопасность.  
DevSecOps-смысл: выявление misconfig и security anti-patterns до деплоя.

## .opa.yaml
Конфигурация OPA (Gatekeeper) для локальных проверок.  
Позволяет валидировать policies как код ещё на этапе CI.  
DevSecOps-смысл: enforcement policy-as-code до попадания в кластер.

## .trivyignore
Файл исключений для Trivy.  
Определяет пакеты и уязвимости, которые игнорируются при сканировании контейнеров.  
DevSecOps-смысл: фокус на критических уязвимостях, минимизация false positives.

## .checkov.yaml
Конфигурация Checkov для IaC и Kubernetes.  
Автоматически проверяет security и compliance правил в манифестах.  
DevSecOps-смысл: раннее обнаружение нарушений инфраструктурной безопасности.

## cluster/
Основная директория для **hardening и baseline безопасности кластера**.  
DevSecOps-смысл: централизованное управление security-контролями платформы.

### bootstrap/
Начальный этап конфигурации кластера.  
Файл `placeholder.yaml` используется как шаблон для future bootstrap manifests.  
DevSecOps-смысл: формализует порядок инициализации кластера и минимизирует ручные действия.

### baseline/
Базовые политики и настройки для всех namespace’ов и pod’ов.  
- `pod-security-standards.yaml` — базовые Pod Security Standards для cluster-wide enforcement.  
- `namespaces.yaml` — предопределённые namespace’ы с назначенными labels и annotations.  
- `resource-quotas.yaml` — ограничение ресурсов по namespace, предотвращение DoS через потребление CPU/Memory.  
DevSecOps-смысл: гарантия консистентности и безопасности на старте, enforceable baseline.

### hardening/
Hardening control plane компонентов.  
- `api-server.yaml` — настройки безопасности API Server (RBAC, auditing, TLS).  
- `controller-manager.yaml` — ограничение привилегий и secure flags для controller-manager.  
- `scheduler.yaml` — безопасная конфигурация scheduler (priority, binding restrictions).  
- `etcd.yaml` — шифрование, доступ и аудит хранилища.  
DevSecOps-смысл: минимизация attack surface control plane и обеспечение immutable security.

### README.md
Документация к директории cluster/.  
Объясняет порядок применения bootstrap, baseline и hardening manifests.  
DevSecOps-смысл: быстрое понимание уровня контроля кластера и его enforcement.

## rbac/
Директория для **управления доступом и правами в кластере**.  
DevSecOps-смысл: централизованное управление attack surface через least privilege и separation of duties.

### base/
Базовые роли и привязки для всех namespace’ов.  
- `roles.yaml` — определяет роли с ограниченными правами.  
- `rolebindings.yaml` — привязка ролей к пользователям или группам.  
- `serviceaccounts.yaml` — настройка сервисных аккаунтов для workloads.  
DevSecOps-смысл: enforceable least privilege для всей платформы.

### break-glass/
Сценарии экстренного доступа.  
- `break-glass-admin.yaml` — временный доступ с повышенными правами для аварийных операций.  
DevSecOps-смысл: минимизация риска misusage, контроль через audit и ограниченное время действия.

### README.md
Документация к директории rbac/.  
Объясняет структуру ролей, привязок и break-glass сценариев.  
DevSecOps-смысл: быстрый обзор политики доступа и их enforcement.

## network-security/
Директория для **сетевой изоляции и безопасности кластера**.  
DevSecOps-смысл: контроль трафика между pod’ами, namespace’ами и внешними сервисами.

### cni/
Конфигурация сетевого плагина (CNI).  
- `placeholder.yaml` — шаблон для будущих CNI manifests.  
DevSecOps-смысл: стандартизация network layer и подготовка к интеграции с enforcement.

### network-policies/
Policy manifests для сетевой сегрегации.  
- `default-deny.yaml` — блокирует весь неразрешённый трафик по умолчанию.  
- `namespace-isolation.yaml` — изоляция namespace, предотвращение lateral movement.  
DevSecOps-смысл: enforceable deny-by-default сетевой контур, минимизация blast radius.

### dns-security.yaml
Политики и настройки для безопасного разрешения DNS внутри кластера.  
DevSecOps-смысл: предотвращение атак через подмену DNS и exfiltration.

### README.md
Документация к директории network-security/.  
Объясняет, какие политики применяются и как они взаимодействуют с другими security layers.  
DevSecOps-смысл: понимание сетевой модели и enforceable isolation.

## runtime-security/
Директория для **runtime защиты workloads после деплоя**.  
DevSecOps-смысл: enforcement security на уровне Pod и контейнера, минимизация риска post-deploy атак.

### admission/
Admission webhooks для контроля входящих объектов.  
- `validating-webhook.yaml` — проверяет compliance объектов с policy до создания.  
- `mutating-webhook.yaml` — автоматически добавляет обязательные security контексты и annotations.  
DevSecOps-смысл: предотвратить нарушение политик до запуска workload.

### pod-security/
Pod Security Standards enforcement.  
- `restricted.yaml` — строгие ограничения для критических namespace’ов.  
- `baseline.yaml` — базовые ограничения для остальных workloads.  
DevSecOps-смысл: immutable security context для pod’ов, enforceable через code.

### seccomp/
Seccomp profiles для контейнеров.  
- `default.json` — блокировка небезопасных системных вызовов.  
DevSecOps-смысл: минимизация kernel-level attack surface.

### apparmor/
AppArmor профили для контейнеров.  
- `.gitkeep` — placeholder, структура готова для будущих профилей.  
DevSecOps-смысл: предотвращение unauthorized actions внутри контейнера.

### README.md
Документация к runtime-security/.  
Объясняет порядок применения admission, Pod Security и профилей ядра.  
DevSecOps-смысл: понимание runtime enforcement и его роли в общей платформенной безопасности.

## supply-chain-security/
Директория для **обеспечения доверия к артефактам** перед деплоем в кластер.  
DevSecOps-смысл: гарантировать, что все образы и зависимости проверены, подписаны и имеют provenance.

### image-policy/
Политики допуска контейнерных образов.  
- `allowed-registries.yaml` — список доверенных registry.  
- `signed-images-only.yaml` — enforcement использования только подписанных образов.  
DevSecOps-смысл: prevent poisoned images и enforce immutable supply chain.

### sbom/
Хранение SBOM (Software Bill of Materials).  
- `.gitkeep` — placeholder, структура для автоматической генерации и хранения SBOM.  
DevSecOps-смысл: traceability компонентов и vulnerability management.

### provenance/
Хранение информации о происхождении артефактов.  
- `.gitkeep` — placeholder для future provenance metadata.  
DevSecOps-смысл: подтверждение источника и CI pipeline для каждого артефакта.

### README.md
Документация к supply-chain-security/.  
Объясняет модель доверия, применение политики образов, SBOM и provenance.  
DevSecOps-смысл: понимание и enforceable цепочки доверия CI → Deployment.

## policy-engine/
Директория для **централизованного управления политиками Kubernetes**.  
DevSecOps-смысл: все enforcement механизмы собраны как code, versioned и auditable.

### opa-gatekeeper/
OPA Gatekeeper для валидации ресурсов.  

#### constraints/
- `required-labels.yaml` — проверка обязательных label’ов на ресурсах.  
- `deny-privileged.yaml` — запрет запуска привилегированных контейнеров.  
DevSecOps-смысл: enforceable security policies на уровне cluster-wide admission.

#### templates/
- `required-labels.yaml` — шаблон constraint для новых namespace/teams.  
- `deny-privileged.yaml` — шаблон constraint для future workloads.  
DevSecOps-смысл: ускоряет rollout новых правил без ручного копирования.

### kyverno/
Kyverno для mutation и дополнительной валидации.  
- `enforce-security-context.yaml` — добавляет обязательные security context к pod’ам.  
- `mutate-seccomp.yaml` — автоматически назначает seccomp профили.  
DevSecOps-смысл: автоматизация и стандартизация security context, enforcement на этапе deploy.

### rego/
Папка для дополнительных Rego policy.  
- `.gitkeep` — placeholder для future custom rules.  
DevSecOps-смысл: возможность расширения OPA enforcement без изменения основного pipeline.

### README.md
Документация к policy-engine/.  
Объясняет, как применять, версионировать и комбинировать политики OPA и Kyverno.  
DevSecOps-смысл: единый источник истины по policy-as-code.

## observability-security/
Директория для **видимости и мониторинга безопасности кластера**.  
DevSecOps-смысл: обнаружение инцидентов и контроль compliance в реальном времени.

### audit-logs/
Настройка audit логирования Kubernetes.  
- `audit-policy.yaml` — определяет, какие события логируются и как.  
DevSecOps-смысл: полный audit trail для forensic и compliance целей.

### falco/
Runtime detection через Falco-подобные правила.  
- `placeholder.yaml` — шаблон для будущих security detection правил.  
DevSecOps-смысл: обнаружение подозрительных действий на уровне pod/host.

### prometheus-rules/
Alerting и метрики для безопасности.  
- `security-alerts.yaml` — правила Prometheus для оповещений о нарушениях security.  
DevSecOps-смысл: оперативное оповещение и интеграция с SIEM/incident response.

### README.md
Документация к observability-security/.  
Объясняет порядок настройки audit, detection и alerting.  
DevSecOps-смысл: быстрый обзор системы runtime visibility.

---

## multi-tenancy/
Директория для **изоляции арендаторов и команд внутри кластера**.  
DevSecOps-смысл: ограничение blast radius и защита ресурсов разных tenants.

- `tenant-isolation.yaml` — сетевые и namespace boundary политики для отдельных арендаторов.  
- `quota-enforcement.yaml` — ограничения ресурсов для каждого tenant.  
- `README.md` — документация по multi-tenancy.  
DevSecOps-смысл: enforceable tenant separation и ресурсные лимиты как код.

## compliance/
Директория для **встроенного соответствия стандартам безопасности и регуляторным требованиям**.  
DevSecOps-смысл: интегрированное compliance как архитектурное свойство, а не отдельная «бумажка».

### cis/
CIS Kubernetes Benchmark.  
- `mapping.md` — сопоставление controls с кластерной архитектурой.  
- `controls.yaml` — enforceable CIS controls manifests.  
DevSecOps-смысл: автоматизированная проверка и enforcement стандартов CIS.

### nist/
NIST controls для Kubernetes.  
- `mapping.md` — отображение NIST controls на реализацию в кластере.  
- `controls.yaml` — manifests для автоматического соответствия.  
DevSecOps-смысл: поддержка государственных и enterprise compliance требований.

### iso27001/
ISO/IEC 27001 mapping.  
- `mapping.md` — связь стандартов ISO с существующими security controls.  
DevSecOps-смысл: доказательство соответствия и интеграция в audit pipeline.

### reports/
Хранение результатов compliance сканирования.  
- `.gitkeep` — placeholder для future automated reports.  
DevSecOps-смысл: traceable evidence для auditors и CI/CD pipeline.

### README.md
Документация к compliance/.  
Объясняет, какие стандарты покрыты и как применять controls.  
DevSecOps-смысл: единый источник информации по встроенному compliance.

## threat-model/
Директория для **формализации угроз и mitigation стратегии на уровне платформы**.  
DevSecOps-смысл: понимание attack surface, приоритизация mitigations и интеграция с policy enforcement.

### STRIDE.md
Описание угроз по модели STRIDE (Spoofing, Tampering, Repudiation, Information disclosure, Denial of Service, Elevation of privilege).  
DevSecOps-смысл: систематизация возможных атак для последующего контроля и автоматизации защит.

### attack-scenarios.md
Конкретные сценарии атак на кластер и workloads.  
DevSecOps-смысл: тестирование и validation security controls против реальных угроз.

### mitigations.md
Рекомендации и controls для снижения рисков из attack scenarios и STRIDE.  
DevSecOps-смысл: roadmap для enforcement через policy-as-code и runtime-security.

### README.md
Документация к threat-model/.  
Объясняет как использовать threat model для планирования политик и runtime защит.  
DevSecOps-смысл: единый reference по угрозам и их mitigation для всей платформы.

## environments/
Директория для **environment-specific конфигураций Kubernetes**.  
DevSecOps-смысл: управление различными стадиями жизненного цикла кластера через declarative manifests и kustomize.

### dev/
Development окружение.  
- `kustomization.yaml` — overlay для dev namespace, настройки ресурсов, debug flags.  
DevSecOps-смысл: безопасное тестирование и validation политик перед stage/prod.

### stage/
Staging окружение.  
- `kustomization.yaml` — overlay для stage с production-like настройками.  
DevSecOps-смысл: pre-prod проверка и финальный контроль policy enforcement.

### prod/
Production окружение.  
- `kustomization.yaml` — overlay для prod с строгими security и resource constraints.  
DevSecOps-смысл: immutable, enforceable и auditable production deployment.

### base/
Базовые manifests для всех окружений.  
- `kustomization.yaml` — общие ресурсы, namespace, configmaps, secrets placeholders.  
DevSecOps-смысл: single source of truth для всех environments.

### kustomization.yaml
Главный kustomization файл, объединяющий base и overlays.  
DevSecOps-смысл: централизованный control over all environments, reproducible deployments.

### README.md
Документация к environments/.  
Объясняет структуру overlay, overlay inheritance и принципы управления конфигурациями.  
DevSecOps-смысл: быстрое понимание как environment-aware deployments интегрируются с security.

## ci/
Директория для **CI/CD пайплайнов безопасности Kubernetes**.  
DevSecOps-смысл: автоматизация проверки, enforcement и compliance на этапе CI, до деплоя.

### kube-linter.yml
Конфигурация для проверки Kubernetes manifests через kube-linter.  
DevSecOps-смысл: выявление misconfigurations и enforceable best practices на раннем этапе.

### opa-policy-check.yml
CI job для проверки ресурсов на соответствие OPA/Gatekeeper policy.  
DevSecOps-смысл: гарантирует, что все manifests соответствуют централизованным политикам.

### trivy-k8s.yml
Сканирование container images и Kubernetes manifests на уязвимости через Trivy.  
DevSecOps-смысл: раннее обнаружение vulnerabilities и compliance violations.

### manifest-validate.yml
Validation pipeline для всех Kubernetes manifests (schema, duplication, best practices).  
DevSecOps-смысл: prevent misconfig и enforce consistent manifests across environments.

### compliance-report.yml
Автоматическая генерация отчетов по соответствию CIS/NIST/ISO стандартам.  
DevSecOps-смысл: traceable evidence для auditors и CI/CD reporting.

### README.md
Документация к ci/.  
Объясняет порядок работы всех CI jobs, их цели и интеграцию с GitOps.  
DevSecOps-смысл: единый reference для всех automated security checks.

## scripts/
Директория для **утилитарных скриптов управления и проверки кластера**.  
DevSecOps-смысл: автоматизация рутинных операций, enforceable baseline и проверка security posture.

### apply-baseline.sh
Применяет baseline manifests (namespaces, pod-security, resource quotas) в кластер.  
DevSecOps-смысл: reproducible baseline deployment для всех окружений.

### verify-cluster.sh
Скрипт для проверки состояния security controls и compliance после деплоя.  
DevSecOps-смысл: быстрый аудит и validation enforcement.

### audit-dump.sh
Сохраняет audit logs и cluster events для анализа.  
DevSecOps-смысл: traceable evidence и forensic-ready данные для compliance и incident response.

### architecture_bootstrap.sh
Инициализация структуры cluster, overlay environments и policy-engine.  
DevSecOps-смысл: reproducible cluster setup с enforceable security layers.

### README.md
Документация к scripts/.  
Объясняет назначение каждого скрипта и порядок их применения.  
DevSecOps-смысл: единый reference для автоматизации cluster management и security enforcement.

## docs/
Директория для **документации и описания архитектуры безопасности платформы**.  
DevSecOps-смысл: единый источник знаний для разработчиков, DevOps и аудиторов, обеспечивающий понимание, enforcement и traceability.

### architecture.md
Описание security-архитектуры Kubernetes платформы.  
DevSecOps-смысл: понимание слоёв защиты, control plane vs data plane и места runtime enforcement.

### security-boundary.md
Формализация trust boundaries и границ ответственности.  
DevSecOps-смысл: clear definition trusted vs untrusted, human vs workload identities.

### kubernetes-threat-model.md
Threat model уровня платформы.  
DevSecOps-смысл: систематизация attack surfaces, control plane и workload угроз.

### policy-strategy.md
Документ по стратегии применения политик.  
DevSecOps-смысл: lifecycle, versioning, OPA vs Kyverno, enforceable policy-as-code.

### admission-control.md
Enforcement на входе в кластер.  
DevSecOps-смысл: validating/mutating admission webhooks, Pod Security Standards enforcement.

### runtime-security.md
Защита после деплоя.  
DevSecOps-смысл: runtime detection, seccomp/AppArmor, alerting и response.

### supply-chain-security.md
Доверие к артефактам и образам.  
DevSecOps-смысл: image trust, SBOM, provenance, CI → Deployment traceability.

### compliance-overview.md
Встроенный compliance как свойство платформы.  
DevSecOps-смысл: CIS/NIST/ISO coverage, mapping, evidence generation.

### repository-structure.md
Руководство по структуре репозитория.  
DevSecOps-смысл: быстрое понимание назначения директорий, enforceable anti-pattern avoidance и принципы immutable infra & policy-as-code.

