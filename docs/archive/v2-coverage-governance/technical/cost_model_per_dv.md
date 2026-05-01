# Nolapse – Cost Model per Deployment Variant

## (Infrastructure Cost, Pricing Levers, and Margins)

This document defines a **clear cost model** for Nolapse across deployment variants. It is designed to support **tech stack decisions**, **pricing strategy**, and **SaaS margin planning**.

> Assumptions are conservative and intentionally simplified to enable early-stage planning. Numbers can be refined once usage telemetry exists.

---

## 1. Cost Model Dimensions

Nolapse costs scale primarily along four axes:

1. **Active repositories**
2. **Execution frequency** (CI + orchestrator runs)
3. **Runner compute time**
4. **Control-plane overhead**

We break costs into:

* **Fixed costs** (baseline infra)
* **Variable costs** (per execution / per repo)

---

## 2. Variant A – Single-Tenant (Enterprise-Hosted)

### 2.1 Cost Ownership

| Cost Area             | Owner    |
| --------------------- | -------- |
| Kubernetes / VM infra | Customer |
| Runner compute        | Customer |
| Storage               | Customer |
| Operations            | Customer |

From Nolapse’s perspective, this is primarily a **license + support business**.

---

### 2.2 Typical Infra Footprint (Customer)

| Component    | Typical Size           |
| ------------ | ---------------------- |
| Nolapse API     | 2 vCPU / 4 GB          |
| Orchestrator | 1 vCPU / 2 GB          |
| Runner pool  | Autoscaled (2–50 jobs) |
| Metadata DB  | Small Postgres         |

**Estimated monthly infra cost (customer):**

* Small enterprise: $300–700
* Large enterprise: $1,500–4,000

---

### 2.3 Nolapse Revenue & Margin

| Item           | Estimate   |
| -------------- | ---------- |
| Annual license | $40k–150k  |
| Support cost   | Low–medium |
| Gross margin   | 80–90%     |

**Why margins are high:**

* No compute burden on vendor
* Predictable enterprise contracts

---

## 3. Variant B – Multi-Tenant SaaS

### 3.1 Cost Ownership

| Cost Area      | Owner |
| -------------- | ----- |
| Control plane  | Nolapse  |
| Runner compute | Nolapse  |
| Storage        | Nolapse  |
| Operations     | Nolapse  |

This is a **usage-based SaaS cost model**.

---

### 3.2 Control Plane (Shared)

| Component          | Monthly Cost (Est.) |
| ------------------ | ------------------- |
| API + Orchestrator | $300–600            |
| DB (multi-tenant)  | $200–400            |
| Observability      | $150–300            |

**Fixed baseline:** ~$700–1,200 / month

---

### 3.3 Runner Cost Model (Primary Driver)

Assumptions:

* Avg execution: 5 minutes
* Avg runner: 2 vCPU
* Cost per vCPU-hour: ~$0.04 (cloud spot / committed)

**Cost per execution:**

```
2 vCPU × (5/60 hr) × $0.04 ≈ $0.0067
```

| Monthly Executions | Runner Cost |
| ------------------ | ----------- |
| 10k                | ~$67        |
| 50k                | ~$335       |
| 100k               | ~$670       |

---

### 3.4 Storage Cost

* Coverage reports stored in Git (external)
* Metadata retained for audits

**Estimated:** $50–150 / month (up to 1M records)

---

### 3.5 SaaS Pricing & Margins

| Plan       | Price   | Est. Cost | Gross Margin |
| ---------- | ------- | --------- | ------------ |
| Free       | $0      | $5–10     | Negative     |
| Team       | $99–299 | $20–40    | 70–85%       |
| Enterprise | $1k–5k  | $150–400  | 80%+         |

**Margin inflection point:** ~25–40 paying customers

---

## 4. Variant C – Hybrid SaaS (Recommended)

### 4.1 Cost Ownership

| Cost Area      | Owner             |
| -------------- | ----------------- |
| Control plane  | Nolapse              |
| Runner compute | Shared / customer |
| Storage        | Nolapse              |
| Operations     | Nolapse              |

---

### 4.2 Hybrid Cost Structure

| Component      | Cost                     |
| -------------- | ------------------------ |
| Shared API     | $300–600                 |
| Tenant runners | Passed-through or capped |
| Metadata DB    | $200–400                 |

**Key advantage:** compute-heavy workloads are isolated per tenant.

---

### 4.3 Pricing Levers

* Price per active repo
* Price per monthly executions
* Premium for dedicated runners

**Typical margin:** 75–85%

---

## 5. Cost Drivers That Influence Tech Stack

| Decision              | Cost Impact        |
| --------------------- | ------------------ |
| Docker vs Firecracker | Security vs cost   |
| Spot vs on-demand     | 2–3× cost delta    |
| Language image size   | Cold-start latency |
| DB choice             | Ops vs scale       |

These directly influence stack choices (Go vs Python, K8s vs VM).

---

## 6. CTO Guidance

* Start **single-tenant** for first enterprise deals
* Build **hybrid-ready architecture from day one**
* Track **execution cost per repo** as a first-class metric
* Do not optimize multi-tenancy prematurely

---

## 7. What This Enables Next

With this cost model, we can now:

* Finalize **tech stack choices**
* Design **rate limits & quotas**
* Define **pricing SKUs**
* Model **gross margin evolution**

---

**End of Cost Model**
