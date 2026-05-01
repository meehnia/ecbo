# Monetization Model

**Status:** Complete — Gap #5 of 6
**Last Updated:** March 2026

---

## Pricing Philosophy

Two non-negotiable constraints shaped this model:

1. **Org-level value, org-level pricing.** Nolapse governs an entire organization's coverage standards. Per-repo or per-seat pricing misrepresents the value unit and creates friction at the exact moment a customer tries to scale.
2. **Acquisition-compatible packaging.** Every tier and billing dimension is designed so it can be absorbed cleanly into each of the four target acquirers' existing billing models without restructuring.

---

## Tier Structure

### Free (OSS / Community)

**Target:** Individual developers, open-source projects, small teams evaluating Nolapse.

**Limits:**

- Up to 10 repositories
- Single Git provider
- Community-supported (GitHub Issues, Discord)
- Self-hosted only

**Price:** Free, always.

**Purpose:** Community adoption, ecosystem presence, and design partner pipeline. The Free tier is not a revenue vehicle — it is a distribution channel and an acquisition signal. Every enterprise customer starts here.

---

### Team

**Target:** Engineering teams of 10–200 engineers with 10–100 active repositories.

**Price:** $500/month flat (billed annually: $5,000/year)

**Includes:**

- Up to 100 repositories
- All Git providers (GitHub, GitLab, Bitbucket, Azure DevOps)
- Email + chat support (business hours)
- Audit export (CSV/JSON)
- Basic org-level policy enforcement

**Expansion trigger:** A Team customer outgrows 100 repos or needs SSO, advanced policy, or SLA support. At that point, the conversation moves to Enterprise.

**ACV:** $5,000

---

### Enterprise

**Target:** Organizations with 200+ engineers, 100+ repositories, regulated industry, active compliance requirements.

**Price:** Starting at $24,000/year (custom ACV based on repo count and compliance features)

**Includes everything in Team, plus:**

- Unlimited repositories
- SSO (SAML / OIDC)
- Advanced policy engine (branch-aware, file-level, custom thresholds)
- Dedicated compliance audit package (SOC 2, ISO 27001, FedRAMP templates)
- SLA: 99.9% uptime, 4-hour response
- Dedicated customer success
- Self-hosted deployment option with Helm chart support
- Air-gapped / offline mode

**ACV range:** $24,000–$120,000 depending on repo scale and compliance tier.

---

## Billing Dimensions

| Dimension | Free | Team | Enterprise |
| --- | --- | --- | --- |
| Active repositories | Up to 10 | Up to 100 | Unlimited |
| Executions/month | 500 | 10,000 | Unlimited |
| Policy definitions | 1 (org-level) | 10 | Unlimited |
| Audit exports | No | Yes (CSV/JSON) | Yes (compliance templates) |
| SSO | No | No | Yes |
| Self-hosted | Yes | Optional | Yes |
| Air-gapped | No | No | Yes |

---

## Freemium vs. Free Trial Decision

**Decision: Freemium (permanent free tier), not time-limited trial.**

Rationale:

- Nolapse's primary distribution channel is organic adoption by Platform Teams who discover it through the developer community or a marketplace listing. A time-limited trial creates friction in that motion.
- The Free tier functions as a permanent proof-of-concept environment. Design partner conversations are always easier when the prospect has already run Nolapse in their environment, even at small scale.
- The Free tier creates acquisition signals: every GitHub Marketplace installation, every GitLab component pull, every OSS community member is visible to each potential acquirer as evidence of ecosystem traction.

The risk of a permanent free tier (revenue delay) is outweighed by the distribution and acquisition signaling value in the 0–24 month window.

---

## Expansion Revenue Story

The expansion path is deliberate and low-friction:

**Free → Team:** Triggered automatically when a customer exceeds 10 repos or needs multi-provider support. The upgrade prompt is surfaced in the Nolapse dashboard. No sales call required for self-serve Team upgrades.

**Team → Enterprise:** Triggered by one of three signals:

1. The customer exceeds 100 repos
2. Their security team asks for SSO or audit compliance templates
3. A compliance audit requires the SOC 2 / ISO 27001 evidence package

Enterprise upgrades require a brief sales conversation — the goal is to understand the compliance requirements and configure the right audit package. Target close: 2–4 weeks from first Enterprise inquiry.

**Enterprise expansion:** Within Enterprise accounts, expansion is driven by:

- Repo growth (more repos → higher ACV)
- Acquiring additional business units that need Nolapse governance
- Upgrading to the compliance tier for additional frameworks (adding FedRAMP to an existing SOC 2 customer)

---

## ARR Model: Year 1–3

These are targets, not projections. All figures assume the 3-phase acquisition strategy timeline.

### Year 1 — Design Partners and Early Traction

| Customer Type | Count | ACV | ARR |
| --- | --- | --- | --- |
| Enterprise (design partners) | 5 | $30,000 | $150,000 |
| Team | 20 | $5,000 | $100,000 |
| **Total** | **25** | | **$250,000** |

Year 1 focus: prove the product and collect case studies. Revenue validates the model; logos validate the enterprise narrative.

---

### Year 2 — Ecosystem Traction and Inbound

| Customer Type | Count | ACV | ARR |
| --- | --- | --- | --- |
| Enterprise | 20 | $40,000 | $800,000 |
| Team | 80 | $5,000 | $400,000 |
| **Total** | **100** | | **$1,200,000** |

Year 2 focus: ecosystem partner referrals and inbound from marketplace listings. Enterprise ACV growth as more compliance features are activated.

---

### Year 3 — Acquisition-Ready ARR

| Customer Type | Count | ACV | ARR |
| --- | --- | --- | --- |
| Enterprise | 50 | $50,000 | $2,500,000 |
| Team | 150 | $5,000 | $750,000 |
| **Total** | **200** | | **$3,250,000** |

Year 3 target ARR of ~$3M at 80%+ gross margin is the acquisition-ready threshold. At this scale, Nolapse represents a meaningful enterprise revenue line for any of the four acquirers.

---

## Acquirer Packaging Compatibility

Each acquirer has a distinct billing model. Nolapse's pricing is designed to map cleanly into all four without restructuring.

**Sentry / Codecov** — Codecov bills per-repo. Nolapse's org-level pricing is additive rather than competing. Post-acquisition, Nolapse becomes "Codecov Enterprise" — a tier above Codecov's existing per-repo plans.

**SonarSource** — Sonar bills per seat / instance. Nolapse's repo-based pricing is a distinct billing dimension that adds an enforcement layer on top of Sonar's quality metrics. Post-acquisition, Nolapse maps as a Sonar add-on or a dedicated compliance tier.

**GitHub (Microsoft)** — GitHub bills per seat with feature unlocks by tier. Nolapse as a native GitHub feature most naturally maps to GitHub Enterprise (Advanced Security model) — a per-seat bundle where Nolapse is a governance feature rather than a standalone product.

**GitLab** — GitLab bills per seat with Free / Premium / Ultimate tiers. Nolapse maps cleanly as an Ultimate-tier feature or a standalone compliance add-on for Premium customers.

---

See the [Persona Value Props](persona_value_props.md) for how each tier maps to specific buyer personas, and the [Strategic Decisions Log](strategic_decisions.md) for the acquisition-first build rationale that shapes this model.
