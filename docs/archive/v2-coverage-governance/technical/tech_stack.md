# Nolapse – Technology Stack Decisions

## CTO-Level Evaluation & Recommendation

This document finalizes **technology stack decisions** for Nolapse, based on:

* Architecture (C4)
* Threat model (STRIDE)
* Trust boundaries
* Deployment variants
* Cost model

Each layer presents **2–3 viable stacks**, scores them objectively, and ends with a **clear recommendation**.

Scoring scale: **1 (poor) → 5 (excellent)**

---

# 1. Control Plane Stack

## Responsibilities

* API & auth
* Job orchestration
* Policy evaluation
* Git & CI adapters

---

## Option A: Go + Gin + gRPC

**Stack**

* Language: Go
* API: Gin (REST) + gRPC internal
* Auth: OIDC / JWT
* Deployment: Kubernetes

**Evaluation**

| Dimension     | Score | Rationale                               |
| ------------- | ----- | --------------------------------------- |
| Cost          | 5     | Low memory footprint, fewer nodes       |
| Security      | 5     | Small attack surface, static binaries   |
| Scale         | 5     | Concurrency-native, predictable latency |
| Team Velocity | 3     | Slower iteration, fewer devs            |

---

## Option B: Python + FastAPI

**Stack**

* Language: Python
* API: FastAPI
* Auth: OIDC / JWT
* Deployment: Kubernetes

**Evaluation**

| Dimension     | Score | Rationale                             |
| ------------- | ----- | ------------------------------------- |
| Cost          | 3     | Higher memory & CPU usage             |
| Security      | 4     | Mature ecosystem, but dynamic runtime |
| Scale         | 3     | Async helps, but limits at high QPS   |
| Team Velocity | 5     | Fast iteration, large talent pool     |

---

## Option C: Java + Spring Boot

**Evaluation Summary**

* Cost: 2
* Security: 4
* Scale: 4
* Velocity: 2

**Verdict:** Overkill, slow startup, higher infra cost

---

### ✅ Control Plane Recommendation

> **Go + Gin (+ gRPC internally)**

Reason:

* Control plane must be **cheap, predictable, and secure**
* Nolapse is orchestration-heavy, not CRUD-heavy
* Go aligns best with long-term SaaS margins

---

# 2. Execution Plane Stack

## Responsibilities

* Clone repos
* Run tests & coverage
* Generate reports

---

## Option A: Kubernetes Jobs + Docker (Rootless)

| Dimension | Score | Notes                     |
| --------- | ----- | ------------------------- |
| Cost      | 4     | Good density, autoscaling |
| Security  | 4     | Needs hardening (seccomp) |
| Scale     | 5     | Battle-tested             |
| Velocity  | 5     | Simple, familiar          |

---

## Option B: Firecracker / MicroVMs

| Dimension | Score | Notes                        |
| --------- | ----- | ---------------------------- |
| Cost      | 3     | Higher infra complexity      |
| Security  | 5     | Strong isolation             |
| Scale     | 4     | Slightly slower provisioning |
| Velocity  | 2     | Operationally complex        |

---

### ✅ Execution Plane Recommendation

> **Kubernetes Jobs + Rootless Docker (Phase 1)**

Upgrade path:

* Introduce Firecracker **only for high-risk tenants**

---

# 3. Persistence & Telemetry

## Responsibilities

* Audit metadata
* Execution logs
* Metrics

---

## Option A: Postgres + Prometheus + Loki

| Dimension | Score | Notes              |
| --------- | ----- | ------------------ |
| Cost      | 4     | OSS-friendly       |
| Security  | 4     | Mature controls    |
| Scale     | 4     | Scales to millions |
| Velocity  | 5     | Widely known       |

---

## Option B: Managed Cloud Stack

* DB: Aurora / Cloud SQL
* Logs: Cloud-native
* Metrics: Managed Prometheus

| Cost | 3 | Higher spend |
| Security | 5 | Cloud IAM |
| Scale | 5 | Near infinite |
| Velocity | 4 | Vendor lock-in |

---

### ✅ Persistence Recommendation

> **Postgres + Prometheus + Loki (OSS-first)**

Reason:

* Aligns with single-tenant & hybrid models
* Easy SaaS evolution later

---

# 4. CI Integration Model

## Responsibilities

* Developer entry point
* Low-friction adoption

---

## Option A: CLI-first (`nolapse run`)

| Cost | 5 |
| Security | 4 |
| Scale | 4 |
| Velocity | 5 |

---

## Option B: Native CI Plugins Only

| Cost | 3 |
| Security | 4 |
| Scale | 4 |
| Velocity | 2 |

---

## Option C: Hybrid (CLI + Thin Wrappers)

| Cost | 4 |
| Security | 5 |
| Scale | 5 |
| Velocity | 5 |

---

### ✅ CI Integration Recommendation

> **Hybrid: CLI Core + CI-specific wrappers**

Reason:

* Single execution engine
* Best DX
* Lowest maintenance

---

# 5. Final CTO Stack Summary

| Layer           | Chosen Stack                 |
| --------------- | ---------------------------- |
| Control Plane   | Go + Gin + gRPC              |
| Execution Plane | K8s Jobs + Rootless Docker   |
| Persistence     | Postgres + Prometheus + Loki |
| CI Integration  | CLI core + thin CI wrappers  |

---

## CTO Final Guidance

> **Optimize first for isolation, then for margins, then for speed.**

This stack:

* Scales safely
* Keeps SaaS margins healthy
* Allows enterprise flexibility
* Avoids premature complexity

---

**End of Tech Stack Decision Document**
