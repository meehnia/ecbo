# Nolapse Gap Analysis Tracker
**Living document — updated after each session | March 2026**

---

## Gap Closure Progress

| # | Gap | Status | Output File |
|---|---|---|---|
| 1 | Competitive Landscape | ✅ Complete | `docs/marketing/competitive_landscape.md` (v3.0) |
| 2 | Baseline Concept Pitch | ✅ Complete | `docs/product/baseline_concept_pitch.md` |
| 3 | Persona Value Props | ✅ Complete | `docs/product/persona_value_props.md` |
| 4 | Onboarding / Time-to-Value | ✅ Complete | `docs/product/onboarding.md` |
| 5 | Monetization Model | ✅ Complete | `docs/product/monetization_model.md` |
| 6 | Roadmap Timelines & Metrics | ✅ Complete | `docs/product/roadmap.md` |

---

## Gap #1 — Competitive Landscape ✅

**Problem:** No analysis of who Nolapse competes with, how it differentiates, or why buyers should choose it over existing tools.

**Output:** Two versions produced and merged:
- `competitive_landscape_v1.md` — Initial analysis (4 competitor categories, differentiation matrix, white space map)
- `competitive_landscape_v2_merged.md` — Merged with second source document; added market sizing, GitHub Advanced Security column, GTM motions, risk table

**Key Finding:** No competitor owns Nolapse's niche. Biggest real-world competitor is DIY scripts. Codecov (Sentry) is the most likely future competitive threat.

**Strategic Update Applied:** Competitive framing shifted from "Nolapse vs. competitors" to "Nolapse as neutral governance layer above competitors" — reflecting the acquisition-first exit strategy decided in session.

---

## Gap #2 — Baseline Concept Pitch ✅

**Problem:** The concept of "versioned coverage baselines stored in Git" is technically elegant but not immediately intuitive to a VP Engineering or budget holder. There's no 60-second non-technical explanation.

**Output:** `docs/product/baseline_concept_pitch.md`

**Key Decisions:**

- Core analogy: baselines are the `.eslintrc` for coverage — agreed-on rules that version with code and judge every PR automatically
- Four pitch formats produced: sales deck slide, landing page hero, cold email (50 words), executive 2-sentence summary
- Before/after story centered on a 200-repo org with and without Nolapse
- Acquirer lens added: per-acquirer pitch line showing what the Git-native architecture means to each of the four

**Key Finding:** "The coverage floor that never moves without your knowledge" is the landing page hero line. The `.eslintrc` analogy is the sales conversation opener.

---

## Gap #3 — Persona Value Props ✅

**Problem:** SRS Section 5 lists five personas but doesn't describe what Nolapse *gives* each one. The ROI story is missing for every persona, especially the executive and security/audit buyers who hold budget.

**Output:** `docs/product/persona_value_props.md`

**Key Decisions:**

- All five personas covered with full before/after narrative and a single primary metric each
- Each persona section includes an **Acquirer Lens** — what that persona's adoption signals to each of the four target acquirers
- Bold text labels used instead of `###` subheadings to avoid duplicate heading lint errors across five identical sub-sections

**Primary Metrics by Persona:**

- Developer: PR signal trust (dispute rate < 10%)
- Platform Team: Support hours saved on coverage tickets
- Engineering Manager: Time to answer "are we compliant?" (days → under 1 minute)
- Security / Audit: Audit prep time for coverage evidence (days → under 30 minutes)
- Executive: Ability to make a provable, auditable quality governance claim

---

## Gap #4 — Onboarding / Time-to-Value ✅

**Problem:** No description of how a new customer gets from signup to first value. High setup friction kills SaaS conversion and drives early churn.

**Output:** `docs/product/onboarding.md`

**Key Decisions:**

- First value moment defined precisely: "A developer's PR fails because coverage dropped — the developer sees exactly which lines are uncovered, understands why, trusts the signal, and writes the missing test."
- 30-minute-to-first-baseline is the critical number; determines if Nolapse is a "try it today" or "schedule a POC" tool
- Six-step onboarding flow: Connect → Discover → Generate Baseline → Add CI Enforcement → Validate → Org-Wide Rollout
- Kill criteria defined (4 failure signals that indicate onboarding friction, not product concept failure)

**Time Targets:**

- First baseline: < 30 minutes
- First CI enforcement: < 2 hours
- First developer PR evaluated: < 1 day
- Org-wide rollout (100+ repos): < 2 weeks

---

## Gap #5 — Monetization Model ✅

**Problem:** SRS Section 30 lists three tiers and three billing dimensions with no pricing, no ARR targets, and no conversion funnel logic.

**Output:** `docs/product/monetization_model.md`

**Key Decisions:**

- **Freemium** (not time-limited trial) — the Free tier is a distribution channel and acquisition signal, not a revenue vehicle
- Org-level pricing — not per-seat or per-repo — to reflect the org-wide value unit and avoid scaling friction
- Pricing: Free ($0, 10 repos), Team ($5,000/year, 100 repos), Enterprise ($24,000–$120,000/year, unlimited repos)
- ARR targets: $250K (Year 1), $1.2M (Year 2), $3.25M (Year 3 — acquisition-ready threshold)
- Each acquirer's billing model mapped to show Nolapse packaging compatibility post-acquisition

---

## Gap #6 — Roadmap Timelines & Metrics ✅

**Problem:** SRS Phases 1–3 are named but have no timelines, no success metrics, and no go/no-go criteria between phases.

**Output:** `docs/product/roadmap.md`

**Key Decisions:**

- Roadmap has two parallel timelines: product timeline and acquisition timeline
- Phase boundaries defined by customer outcomes and market signals, not feature completeness
- Phases overlap intentionally (Phase 2 starts at Month 9 during Phase 1's final quarter)
- Each phase includes explicit go/no-go criteria and an acquirer signal statement

**Phase Summary:**

- Phase 1 (0–12 months): Core platform, 3–5 design partners, 200+ repos governed
- Phase 2 (9–24 months): Governance + enterprise traction, $500K–$1.2M ARR, all 4 ecosystem listings live
- Phase 3 (21–36 months): Intelligence + acquisition process, $2.5M–$3.5M ARR, 2+ acquirers in due diligence

---

*Nolapse Gap Tracker | Version 1.0 | March 2026*
