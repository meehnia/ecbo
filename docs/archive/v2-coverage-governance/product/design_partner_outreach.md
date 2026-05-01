# Design Partner Outreach

**Status:** Active — Phase 1
**Last Updated:** March 2026

---

## Purpose

This document defines how Nolapse identifies, approaches, qualifies, and onboards design partners. Design partners are not early customers in the traditional sense — they are co-builders. They get hands-on access to founders, direct influence on the product, and preferential pricing in exchange for honest feedback, published case studies, and real-world validation.

Phase 1 requires 3–5 paying design partners to close. This is a go/no-go criterion. The outreach process described here is the mechanism for meeting it.

---

## Ideal Design Partner Profile (ICP)

Not every company that wants early access is a good design partner. A good design partner has:

**Organizational fit:**

- 200–2,000 engineers (large enough to have a Platform Team; small enough to move fast)
- 50–500 active repositories
- A dedicated Platform Engineering or DevOps team that owns CI/CD standards
- An existing test suite in at least one primary language (Node.js / Python for Phase 1)
- At least one of: SOC 2, ISO 27001, FedRAMP audit requirement active or upcoming

**Technical fit:**

- Already using GitHub Actions or GitLab CI as primary CI system
- Has at least one engineer who can evaluate and champion an internal tooling change
- Does not require air-gapped deployment for Phase 1 (air-gapped is Phase 2)

**Engagement fit:**

- Willing to meet biweekly with Nolapse founders during the first 90 days
- Has a specific pain point (inconsistent coverage enforcement, audit prep burden, or coverage threshold maintenance) they can articulate
- Willing to be quoted in a case study if the product delivers on the stated problem

**Disqualifying factors:**

- Pure OSS project with no commercial footprint (not a paying customer candidate)
- Already built a fully custom internal coverage governance tool they are satisfied with
- Has no CI/CD standardization (we cannot help if there is no CI)
- Requires procurement cycles longer than 30 days (incompatible with the design partner timeline)

---

## Target Ecosystems for Design Partner Selection

Design partners must be distributed across the four target acquirer ecosystems. This is not a nice-to-have — it is a Phase 1 acquisition signal requirement.

| Ecosystem | Target Count | What to Look For |
| --- | --- | --- |
| GitHub-native (primary CI: GitHub Actions) | 2 | Mid-size engineering orgs with 50+ repos on GitHub |
| GitLab-native (primary CI: GitLab CI) | 1 | GitLab self-managed or cloud customers with Platform Engineering ownership |
| Codecov co-use (already using Codecov for PR feedback) | 1 | Codecov Team or Enterprise customers who express frustration with enforcement gaps |
| SonarQube co-use (already using SonarQube for quality gates) | 1 | Regulated-industry Sonar customers with an active SOC 2 or ISO 27001 program |

A single design partner can satisfy multiple ecosystem slots (e.g., a company using GitHub Actions and Codecov satisfies both the GitHub-native and Codecov co-use slots).

---

## Outreach Sequence

### Step 1 — Identify

Sources for design partner candidates:

- Founder networks and ex-colleagues at target company profiles
- LinkedIn: "Platform Engineering" + "DevOps" at companies 200–2,000 engineers
- GitHub and GitLab public signals: organizations with large repo counts and active CI usage
- Conference attendee lists: PlatformCon, KubeCon, DevOpsDays
- Existing Codecov and SonarQube users who publicly discuss coverage enforcement frustrations (Twitter/X, Reddit r/devops, Hacker News)

Target list size: 30–50 qualified companies to generate 3–5 design partners.

### Step 2 — Research

Before any outreach, gather:

- Company size (employees, engineering headcount if available)
- Primary Git provider and CI system (visible from public repos or job postings)
- Evidence of coverage tooling (Codecov badge in README, SonarQube status check, or job postings mentioning coverage)
- Any public statement about SOC 2, compliance, or engineering quality standards
- A specific named person in a Platform Engineering or DevOps lead role

Research should take 15–20 minutes per company. Do not send generic outreach.

### Step 3 — First Contact

First contact is always personalized. Reference what you found in research. The goal of the first message is a 20-minute call — not a demo, not a pitch.

**Channel priority:**

1. Warm introduction (if one exists)
2. LinkedIn DM to the Platform Engineering lead
3. Email if a professional address is available

**Cold email template (adapt — do not copy verbatim):**

> Hi [Name],
>
> I noticed [Company] is running [GitHub Actions / GitLab CI] across a large number of repos — and you're using [Codecov / SonarQube] for coverage tracking.
>
> We're building Nolapse — a tool that stores coverage baselines in Git and enforces them automatically on every PR. The problem we keep hearing from Platform Teams is that coverage thresholds break down at scale: they're set inconsistently, lowered under release pressure, and impossible to audit for SOC 2.
>
> We're looking for 3–5 design partners to build this with us. You'd get hands-on access to the founders, direct influence on the product, and a preferential rate. In exchange, we ask for honest feedback and, if it works, a case study.
>
> Worth a 20-minute conversation?
>
> [Name]

### Step 4 — Qualification Call

The qualification call has one goal: determine if this is a real design partner or a browser.

Questions to answer:

1. What does coverage enforcement look like today? Who owns it?
2. What breaks when it does not work? (Audit risk, developer disputes, release pressure?)
3. Do they have a Platform Team with bandwidth to run a 90-day evaluation?
4. Is there budget authority in the room, or does this need to go to procurement?
5. What would "success" look like for them after 90 days?

If they cannot answer questions 1 and 2 with specific examples, they are not a good design partner.

### Step 5 — Design Partner Agreement

A design partner signs a lightweight agreement (not a full enterprise contract) that specifies:

- Discounted or pilot pricing (typically $0 for 90 days, then standard pricing if they continue)
- Biweekly check-in commitment with Nolapse founders
- Feedback on specific features and onboarding experience
- Option (not obligation) to be referenced in a case study
- No public announcement without mutual agreement

---

## Value Exchange

| What Nolapse Gets | What the Design Partner Gets |
| --- | --- |
| Real-world validation in a production CI environment | Direct access to founders for product feedback |
| Specific customer pain data to refine the product | Preferential pricing locked in for 12 months post-launch |
| A quoted case study (if they agree) | Influence over roadmap priorities |
| Ecosystem coverage (GitHub, GitLab, Codecov, Sonar) | First-mover advantage if Nolapse becomes a standard in their ecosystem |
| Phase 1 go/no-go metric (3 paying customers) | Audit-ready coverage governance with minimal setup cost |

---

## Design Partner Engagement Model

Once signed, each design partner follows this engagement rhythm:

**Week 1–2:** Onboarding. Platform Team connects Nolapse, runs first baseline on a pilot repo, validates the CI enforcement step. Nolapse founders are on Slack or email for any blockers.

**Weeks 3–8:** Production validation. Design partner expands to 5–10 repos. Nolapse collects feedback on the baseline model, the CI diff output, and the onboarding friction points.

**Weeks 9–12:** Org-wide pilot. If the pilot repos work, the Platform Team begins org-wide rollout with Nolapse's bulk baseline tooling. First audit export tested.

**Week 13:** Review call. Did Nolapse deliver on the stated problem? What needs to change? Is the design partner willing to continue as a paid customer and contribute to a case study?

---

## Case Study Requirements

A case study is a Phase 1 go/no-go criterion. It must include:

- A named company and a named spokesperson (cannot be anonymous)
- The specific problem they had before Nolapse (coverage enforcement inconsistency, audit prep burden, or threshold maintenance)
- Measurable outcome (time saved, repos governed, audit evidence generated)
- At least one quote suitable for use in sales and marketing materials

The case study does not need to be long. A 400-word customer story with a pull quote is sufficient.

---

See the [Roadmap](roadmap.md) for Phase 1 go/no-go criteria and the [Onboarding & Time-to-Value](onboarding.md) doc for the design partner onboarding flow.
