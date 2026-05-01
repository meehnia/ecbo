# Acquisition Data Room Index

**Status:** Phase 3 Preparation — In Progress
**Last Updated:** March 2026
**Target Completion:** Month 21 (Phase 3 entry)

---

## Purpose

This document is the master index for Nolapse's acquisition data room. The data room is the structured package of materials provided to potential acquirers during due diligence. It is the difference between a competitive acquisition process Nolapse controls and a chaotic one that an acquirer controls.

The data room is prepared in Phase 3 but the index is maintained from Phase 1 onward. Every section that is "needs creation" today has a clear owner and a target date. Nothing in Phase 3 should be assembled from scratch.

---

## Status Key

| Status | Meaning |
| --- | --- |
| Complete | Document exists and is current |
| In Progress | Document being drafted or actively maintained |
| Needs Creation | Does not yet exist; must be built during Phase 2 or 3 |
| Needs Legal Review | Draft exists; requires counsel review before data room inclusion |
| Not Applicable | Section not relevant to Nolapse's structure |

---

## Section 1 — Company Overview

| Document | Status | Notes |
| --- | --- | --- |
| Company overview (2-page summary) | Needs Creation | Summary of Nolapse's history, product, market, and exit rationale |
| Organizational structure | Needs Creation | Cap table, entity structure, founder equity |
| Board and advisor roster | Needs Creation | Names, roles, relevant background |
| Mission, vision, and strategy | Complete | See [Strategic Decisions Log](strategic_decisions.md) |

---

## Section 2 — Financial Statements

| Document | Status | Notes |
| --- | --- | --- |
| Historical P&L (all operating periods) | Needs Creation | Prepared by accountant; formatted for M&A review |
| ARR bridge (month-by-month) | In Progress | Maintained in internal financial model |
| Customer-level ARR breakdown | Needs Creation | Anonymizable for initial diligence; named for final stage |
| Cash position and runway | Needs Creation | Updated monthly |
| Unit economics (CAC, LTV, payback) | Needs Creation | Built from customer cohort data |
| Financial projections (3-year) | Needs Creation | Conservative, base, and optimistic scenarios |

---

## Section 3 — Customer and Revenue

| Document | Status | Notes |
| --- | --- | --- |
| Customer list with ARR and tenure | Needs Creation | Full list for final diligence; anonymized for early stage |
| Design partner case studies | In Progress | Requirement: 3+ published by Phase 2 close |
| Customer reference contacts (4 minimum) | Needs Creation | One per acquirer ecosystem |
| Net Revenue Retention (NRR) by cohort | Needs Creation | Built from billing data; target ≥ 120% |
| Churn log with reasons | Needs Creation | Every churned customer with root cause |
| Pipeline and bookings forecast | Needs Creation | 6–12 month forward view |

---

## Section 4 — Product and Technical

| Document | Status | Notes |
| --- | --- | --- |
| Product overview and demo recording | Needs Creation | 10–15 minute walkthrough for acquirer technical teams |
| Architecture documentation | Complete | See [System Architecture](../product/architecture.md) |
| API contracts and versioning strategy | Complete | See [API Design](../technical/api_contracts_and_versioning_strategy.md) |
| SRS (Software Requirements Specification) | Complete | See [SRS](srs.md) |
| Security threat model | Complete | See [Threat Modeling](../security/c4-stride.md) |
| Deployment variants | Complete | See [Deployment Variants](../technical/deployment_variants.md) |
| Known technical debt inventory | Needs Creation | Honest list of architectural shortcuts and their remediation paths |
| Third-party dependency audit | Needs Creation | License review; no copyleft licenses in the enforcement path |
| API-first architecture confirmation | Needs Creation | Engineering sign-off that Nolapse's API surface is integrable post-acquisition |

---

## Section 5 — Intellectual Property

| Document | Status | Notes |
| --- | --- | --- |
| IP ownership confirmation | Needs Legal Review | All code owned by the entity, not individuals |
| Open source license audit | Needs Legal Review | Nothing in the core product that creates GPL contamination |
| Patent search (defensive only) | Needs Creation | Git-native baseline storage is the primary differentiation to protect |
| Trademark status | Needs Creation | "Nolapse" name and logo in relevant jurisdictions |
| Employment IP assignment agreements | Needs Legal Review | All contractors and employees have signed |

---

## Section 6 — Go-to-Market and Ecosystem

| Document | Status | Notes |
| --- | --- | --- |
| GTM strategy | Complete | See [Go-to-Market Strategy](../marketing/gtm_pps.md) |
| Competitive landscape | Complete | See [Competitive Landscape](../marketing/competitive_landscape.md) |
| Ecosystem marketplace listings | In Progress | GitHub Actions Marketplace (Phase 1), GitLab CI catalog (Phase 1) |
| Partnership agreements | Needs Creation | Any co-marketing or referral agreements with ecosystem partners |
| Acquirer ecosystem signal documentation | In Progress | Per-acquirer: which customers use Nolapse in their ecosystem |

---

## Section 7 — Legal and Compliance

| Document | Status | Notes |
| --- | --- | --- |
| Customer contracts (template + signed) | Needs Legal Review | SaaS subscription agreement, data processing addendum |
| Privacy policy and terms of service | Needs Legal Review | Current and compliant with GDPR, CCPA |
| SOC 2 Type II report | Needs Creation | Target: Phase 2 close; required for regulated-industry design partners |
| Pending or threatened litigation | Not Applicable | None expected; disclose immediately if this changes |
| Regulatory filings | Not Applicable | No regulated-industry licenses required for Nolapse's current product |

---

## Section 8 — Team

| Document | Status | Notes |
| --- | --- | --- |
| Founder bios and LinkedIn profiles | Needs Creation | 1-page each; acquisition narrative included |
| Full team roster with roles and tenure | Needs Creation | Including contractors |
| Key person dependency analysis | Needs Creation | Which roles are single points of failure; retention plan |
| Compensation and equity summary | Needs Legal Review | Anonymized by band; individual-level for final diligence |
| Employment agreements | Needs Legal Review | For founders and key engineers; confirm IP assignment |

---

## Section 9 — Acquisition Mechanics

| Document | Status | Notes |
| --- | --- | --- |
| Acquirer-specific integration narrative | Needs Creation | One 2-page document per acquirer: what changes post-close, integration timeline, value unlocked |
| Post-acquisition retention plan | Needs Creation | What it takes to retain founders and key engineers for 12–24 months |
| Data room NDA template | Needs Legal Review | Sent before data room access is granted |
| Process timeline | Needs Creation | LOI → due diligence → close target timeline; Nolapse controls this |

---

## Per-Acquirer Emphasis Map

Different acquirers will weight different sections of the data room. Prepare accordingly.

| Acquirer | Highest Priority Sections | What They Will Scrutinize |
| --- | --- | --- |
| Sentry / Codecov | Customers (Codecov co-use), Technical (API surface), GTM | Which Codecov customers use Nolapse; how Nolapse's API integrates with Codecov's data pipeline |
| SonarSource | Customers (Sonar co-use), Technical (baseline model), Legal (IP) | Whether Nolapse's Git write-back conflicts with any SonarQube patent or architecture claim |
| GitHub (Microsoft) | Technical (GitHub Actions integration depth), Customers (GitHub-native), Financial | Scale of GitHub Actions Marketplace installs; enterprise customer concentration |
| GitLab | Customers (cross-platform footprint), GTM (ecosystem neutrality), Technical | Whether Nolapse's GitHub-native design partners would survive transition to GitLab's platform |

---

## Data Room Access Protocol

1. All access is gated behind a mutual NDA
2. Data room is hosted in a purpose-built virtual data room (not Google Drive)
3. Document-level access logging is enabled — Nolapse can see what each acquirer reviews
4. Initial access: Sections 1, 4 (overview only), 6 — no financial or legal detail
5. Full access: granted after signed term sheet or formal LOI
6. Access is revoked immediately if a party exits the process

---

See the [Roadmap](roadmap.md) for Phase 3 acquisition process timing and the [Strategic Decisions Log](strategic_decisions.md) for the competitive acquisition process strategy.
