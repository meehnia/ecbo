# Roadmap Timelines & Metrics

**Status:** Complete — Gap #6 of 6
**Last Updated:** March 2026

---

## Roadmap Philosophy

The roadmap has two audiences and two timelines running in parallel:

- **Product timeline** — what gets built, in what order, validated against enterprise customer needs
- **Acquisition timeline** — what traction gets established, in what order, visible to each of the four target acquirers

Phase boundaries are defined by customer outcomes and market signals, not feature completeness. A phase ends when the go/no-go criteria are met — not when the feature list is exhausted.

---

## Phase 1 — Core Platform (Months 0–12)

**Theme:** Build a narrow, trustworthy product and prove it works in real CI pipelines at real companies.

**Scope:**

- Coverage execution (Node.js / Jest initially; Python and Go added before Phase 1 close)
- Git-native baseline generation and write-back
- Policy engine (strict mode only)
- GitHub Actions integration (first-class)
- GitLab CI component (published by Month 6)
- CLI (`nolapse run`) for manual and non-standard CI use
- Audit export (CSV / JSON)
- Self-hosted deployment (Docker / Kubernetes)

**Target Customer:** 3–5 enterprise design partners. Hands-on onboarding. Direct Slack access to founders.

**Success Metrics:**

| Metric | Target |
| --- | --- |
| Design partner orgs live on Nolapse | 3–5 |
| Repos governed across all design partners | 200+ |
| PR enforcement uptime | ≥ 99% |
| Developer CI signal dispute rate | < 10% |
| Time to first baseline (new repo) | < 30 minutes |

**Go/No-Go Criteria to enter Phase 2:**

- At least 3 paying design partner customers
- At least one case study published (customer quoted, metrics documented)
- GitHub Actions Marketplace listing live
- GitLab CI component catalog listing live
- Developer signal dispute rate below 10% (the enforcement is trusted)
- Zero critical security incidents

**Acquisition signal at Phase 1 close:**
Each of the four acquirers can see Nolapse running in their ecosystem. The GitHub Marketplace listing is visible to GitHub. The GitLab component is visible to GitLab. The Codecov co-use pattern is documented in at least one case study. Sentry/Codecov and SonarSource are watching.

---

## Phase 2 — Governance & Enterprise Traction (Months 9–24)

**Theme:** Add the enterprise governance features that turn design partners into a full customer base and make Nolapse visible as a strategic asset to potential acquirers.

**Scope:**

- Org-wide coverage compliance dashboard
- Multi-repo orchestration at scale (500+ repos in a single scheduled run)
- Advanced policy engine (branch-aware policies, file-level thresholds, warn mode)
- SSO (SAML / OIDC)
- Compliance audit packages (SOC 2, ISO 27001 templates)
- Full polyglot support (Java, .NET, Ruby added)
- Multi-tenant SaaS deployment
- Expanded CI support (Jenkins, CircleCI, Azure DevOps, Argo/Tekton)
- Codecov and SonarQube data import integrations

**Note:** Phase 2 starts at Month 9 — overlapping with Phase 1's final quarter. The overlap is intentional: design partner feedback in Phase 1 directly informs Phase 2 scope.

**Target Customer:** 10–25 enterprise accounts. Self-serve Team tier open. Inbound from marketplace listings.

**Success Metrics:**

| Metric | Target |
| --- | --- |
| Total paying enterprise accounts | 10–25 |
| ARR | $500K–$1.2M |
| Repos governed across all customers | 5,000+ |
| Case studies published | 3+ |
| NPS from Platform Team personas | ≥ 50 |
| Ecosystem integration listings (all four partners) | 4 / 4 |

**Go/No-Go Criteria to enter Phase 3:**

- ARR exceeds $1M
- At least one customer in each of the four acquirer ecosystems (a GitHub-native customer, a GitLab-native customer, a Codecov co-use customer, a SonarQube co-use customer)
- At least one regulated-industry SOC 2 use case documented
- All four ecosystem marketplace listings live and actively driving inbound
- No single acquirer relationship has been exclusively favored (Switzerland Model intact)

**Acquisition signal at Phase 2 close:**
This is the competitive urgency trigger. Nolapse has enterprise logos in every acquirer's ecosystem. Each acquirer can see that their customers need Nolapse — and that a competitor could acquire it first. The asymmetry is deliberate. Phase 2 ends when acquisition urgency is real, not manufactured.

---

## Phase 3 — Intelligence, Insights, and Acquisition Process (Months 21–36)

**Theme:** Add the product capabilities that make Nolapse an intelligence layer, not just a compliance enforcer — while running the acquisition process in parallel.

**Scope:**

- Coverage trend analytics and regression prediction
- AI-assisted coverage gap identification (which files are highest risk given recent change velocity)
- Cross-org benchmarking (anonymized coverage percentiles by industry / language)
- API-first architecture for acquirer integration surface
- Acquisition data room preparation (clean financials, customer references, technical documentation)

**Note:** Phase 3 product work is partly acquisition-preparation work. The API-first refactor makes Nolapse easier to integrate into an acquirer's product post-close. The analytics features increase the acquisition multiple by demonstrating intelligence-layer potential beyond compliance.

**Target Customer:** 50+ enterprise accounts. Expansion within existing accounts. Inbound-driven growth.

**Success Metrics:**

| Metric | Target |
| --- | --- |
| ARR | $2.5M–$3.5M |
| Enterprise accounts | 40–60 |
| Gross margin | ≥ 80% |
| NRR (Net Revenue Retention) | ≥ 120% |
| Acquirers in active conversation | 2–4 |

**Go/No-Go Criteria to run acquisition process:**

- ARR ≥ $2.5M with ≥ 80% gross margin
- NRR ≥ 120% (existing customers are expanding, not churning)
- At least 2 acquirers have conducted technical due diligence
- Data room is complete and reviewed by legal/financial advisors
- Founder-led customer references available for all four acquirer conversations

**Acquisition process:**
Run a competitive process with all interested parties simultaneously. Nolapse controls the timeline. The acquirer who moves fastest and offers the best integration narrative wins. The others lose their path to coverage governance permanently.

---

## Phase Summary

| Phase | Theme | Duration | ARR Target | Key Go/No-Go |
| --- | --- | --- | --- | --- |
| Phase 1 | Core platform | Months 0–12 | First revenue | 3 paying design partners, trusted signal |
| Phase 2 | Governance & traction | Months 9–24 | $500K–$1.2M | $1M ARR, all 4 ecosystem listings live |
| Phase 3 | Intelligence & acquisition | Months 21–36 | $2.5M–$3.5M | $2.5M ARR, 2+ acquirers in diligence |

---

## Acquisition Timeline Alignment

| Roadmap Phase | Acquisition Strategy Phase | Signal to Acquirers |
| --- | --- | --- |
| Phase 1 complete | Phase 1 (0–18 months): Be Everyone's Best Friend | Integrations live in all four ecosystems; product is trustworthy |
| Phase 2 complete | Phase 2 (12–24 months): Create Competitive Anxiety | Enterprise logos in every ecosystem; each acquirer sees their customers using Nolapse |
| Phase 3 entry | Phase 3 (24–36 months): Run Acquisition Process | $2.5M ARR, strong NRR, multiple acquirers in conversation; Nolapse controls the outcome |

---

See the [Strategic Decisions Log](strategic_decisions.md) for the full acquisition strategy, the [Monetization Model](monetization_model.md) for ARR assumptions, and the [MVP Definition](mvp_definition.md) for Phase 1 delivery scope.
