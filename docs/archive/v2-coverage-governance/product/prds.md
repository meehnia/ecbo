> **ARCHIVED** — This is v2.0 (Coverage Governance framing)
> **Current version:** [v3.0 - AI Agent Governance](../../product/prds.md)

---

# Nolapse – Product Requirement Documents (PRDs)

This document decomposes the **Nolapse Gold Standard SRS v1.2** into **execution-ready PRDs** that product, engineering, and design teams can directly build against.

Each PRD follows a consistent structure used in mature product organizations.

**Strategic framing:** PRDs 3 (Baseline Management & Git Write-Back) and 4 (Policy Engine & CI Enforcement) are Nolapse's acquisition-differentiated capabilities — the two things none of the four target acquirers have built and cannot easily replicate. All other PRDs are table-stakes infrastructure. Build PRDs 3 and 4 first, with production quality. They are the reason Nolapse is acquirable.

See the [Roadmap](roadmap.md) for phase sequencing and the [Strategic Decisions Log](strategic_decisions.md) for the acquisition rationale behind each prioritization decision.

---

# PRD 1: Repository Discovery & Inventory Management

## 1. Problem Statement

Large enterprises lack a real-time, authoritative inventory of repositories, their tech stacks, and test coverage readiness.

## 2. Objective

Provide an automated, continuously updated repository inventory across Git providers.

## 3. Success Metrics

* ≥ 99% repository discovery accuracy
* Inventory refresh < 15 minutes for 1,000 repos

## 4. Users

* Platform Engineers
* DevOps Teams

## 5. Functional Requirements

* Authenticate with Git providers (OAuth / PAT)
* Discover repositories by org, project, or workspace
* Regex-based include/exclude filters
* Detect primary language & framework

## 6. Non-Functional Requirements

* Stateless execution
* Rate-limit aware
* Idempotent scans

## 7. User Flow

1. Admin configures Git connection
2. Nolapse scans org/project
3. Inventory stored & exposed via API

## 8. Out of Scope

* Repo content analysis beyond metadata

---

# PRD 2: Coverage Execution Engine

## 1. Problem Statement

Coverage execution across polyglot repos is inconsistent and environment-dependent.

## 2. Objective

Execute coverage in isolated, reproducible environments across languages.

## 3. Success Metrics

* ≥ 95% successful execution rate
* Deterministic results across runs

## 4. Users

* Developers
* CI/CD Pipelines

## 5. Functional Requirements

* Auto-detect language & framework
* Pull correct runner image
* Execute tests with coverage
* Enforce execution timeouts

## 6. Non-Functional Requirements

* Ephemeral execution
* No code persistence
* Horizontal scalability

## 7. User Flow

1. CI invokes Nolapse
2. Runner spins up
3. Coverage executed
4. Result returned

---

# PRD 3: Baseline Management & Git Write-Back

## 1. Problem Statement

Coverage history is often externalized and lost over time.

## 2. Objective

Store coverage baselines alongside code in Git.

## 3. Success Metrics

* 100% repos with baseline
* Zero baseline corruption

## 4. Users

* Developers
* Audit Teams

## 5. Functional Requirements

* Normalize coverage outputs
* Generate Markdown reports
* Commit to `.audit/coverage/`
* Support PR or direct merge

## 6. Non-Functional Requirements

* Deterministic diffs
* Minimal Git noise

## 7. User Flow

1. Coverage executed
2. Baseline generated
3. Commit created via service account

---

# PRD 4: Policy Engine & CI Enforcement

## 1. Problem Statement

Coverage thresholds are inconsistently enforced.

## 2. Objective

Provide centralized, configurable policy enforcement.

## 3. Success Metrics

* Policy evaluation < 1s
* Clear pass/warn/fail outcomes

## 4. Users

* Platform Teams
* Engineering Managers

## 5. Functional Requirements

* Define policies (strict, warn, advisory)
* Compare against baseline
* Fail or warn CI pipeline

## 6. Non-Functional Requirements

* Deterministic evaluation
* Configurable per org/project

## 7. User Flow

1. Policy defined
2. CI invokes Nolapse
3. Policy evaluated
4. Result returned to CI

---

# PRD 5: Central Orchestrator & Bulk Operations

## 1. Problem Statement

Large-scale baseline creation cannot rely solely on CI.

## 2. Objective

Enable scheduled and bulk coverage operations.

## 3. Success Metrics

* 500+ repos per run
* Partial success tolerance

## 4. Users

* Platform Teams

## 5. Functional Requirements

* Scheduled scans
* Job queueing
* Concurrency control
* Retry handling

## 6. Non-Functional Requirements

* Horizontal scaling
* Failure isolation

## 7. User Flow

1. Schedule triggered
2. Jobs queued
3. Workers execute
4. Results aggregated

---

# PRD 6: Observability, Audit & Reporting

## 1. Problem Statement

Coverage data is hard to audit and report centrally.

## 2. Objective

Provide enterprise-grade observability and audit exports.

## 3. Success Metrics

* Complete audit export in < 5 min
* 100% traceability

## 4. Users

* Security Teams
* Audit Teams
* Leadership

## 5. Functional Requirements

* Execution logs
* Coverage trends
* CSV / JSON export

## 6. Non-Functional Requirements

* Immutable records
* Access controlled

## 7. User Flow

1. Audit requested
2. Data aggregated
3. Export generated

---

# PRD 7: Configuration & Developer Experience

## 1. Problem Statement

Inconsistent configuration leads to adoption friction.

## 2. Objective

Deliver a simple, powerful configuration experience.

## 3. Success Metrics

* < 10 min setup time
* Low config error rate

## 4. Users

* Developers
* Platform Teams

## 5. Functional Requirements

* `nolapse.yaml` DSL
* Sensible defaults
* Overrides at repo/project/org level

## 6. Non-Functional Requirements

* Backward compatibility
* Schema validation

## 7. User Flow

1. Add config file
2. CI invokes Nolapse
3. Config applied

---

# PRD 8: Enterprise Features (Paid)

## 1. Problem Statement

Enterprises require governance beyond OSS tooling.

## 2. Objective

Deliver monetizable enterprise capabilities.

## 3. Success Metrics

* Enterprise adoption
* Contract renewals

## 4. Users

* Enterprises

## 5. Functional Requirements

* SSO (SAML/OIDC)
* Org-level policies
* Dashboards
* SLA support

## 6. Non-Functional Requirements

* High availability
* Enterprise security standards

## 7. User Flow

1. Enterprise onboarding
2. SSO configured
3. Org-wide policies applied

---

## PRD Governance Notes

* Each PRD maps directly to SRS sections
* PRDs can be converted to epics
* PRDs are independently buildable

---

**End of PRDs**