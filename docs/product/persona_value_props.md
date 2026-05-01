# Persona Value Propositions

**Status:** Complete — Gap #3 of 6
**Last Updated:** March 2026

---

## Overview

Nolapse serves five distinct personas. Each has a different relationship to test coverage, a different pain point, and a different definition of success. This document defines the value Nolapse delivers to each — and what that adoption signal means to each potential acquirer.

---

## Persona 1: Developer

**Value proposition:** Nolapse gives developers fast, fair, and predictable PR feedback on coverage — without arbitrary thresholds, without surprise failures, and without anyone moving the goalposts.

**Before Nolapse:**
The CI pipeline has a coverage threshold set at 80%. A developer refactors a module, shifting coverage from 83% to 79%. The PR fails. The developer didn't skip writing tests — they reorganized existing code. They ask the platform team to lower the threshold. This happens three times a month. Alternatively, the coverage check passes because the threshold was permissive and coverage has been quietly eroding for 18 months.

**After Nolapse:**
The developer's PR is compared to the baseline on `main` at the time they branched. If their changes introduce uncovered code, the delta is negative and the PR fails — with a clear diff showing exactly which lines are uncovered. A refactor that doesn't add uncovered code passes. The signal is fair because it only measures what the developer actually changed.

**Primary metric:** PR pass/fail confidence — developers trust the failure signal and fix coverage rather than disputing the threshold.

**Acquirer lens:** Developers already live in GitHub, GitLab, and Codecov. Nolapse's PR integration layer makes those platforms feel more trustworthy and opinionated. For GitHub and GitLab, this is a native platform enhancement. For Codecov, this is the enforcement step they have been missing.

---

## Persona 2: Platform Team

**Value proposition:** Nolapse gives the Platform Team a governed, versioned, org-wide coverage standard — without requiring them to build and maintain custom CI scripts for every team in the organization.

**Before Nolapse:**
The platform team owns coverage enforcement across 150+ repositories. Each repo has a slightly different coverage configuration, threshold, and CI step — most written by a different engineer years ago. Updating the standard requires changes in 150 places. Audit requests require manual data collection. New repos are onboarded inconsistently. The platform team spends 30% of its time on coverage-related tickets.

**After Nolapse:**
The platform team deploys Nolapse once. Repo discovery runs on a schedule, onboarding new repositories automatically. Baselines are generated and stored in each repo's Git history. Policy is defined centrally and enforced uniformly. Audit reports are exportable in minutes. The platform team goes from owning 150 bespoke configurations to owning one Nolapse deployment.

**Primary metric:** Hours saved per month on coverage-related support tickets and audit preparation.

**Acquirer lens:** The Platform Team is the operational buyer — the person who evaluates, deploys, and champions Nolapse internally. Winning this persona is the prerequisite to winning the account. For Codecov, this is the enterprise customer segment they have never fully served. For SonarSource, this is the persona that currently patches Sonar's enforcement gap with custom scripts. For GitHub and GitLab, this is the DevOps persona each platform is actively trying to win.

---

## Persona 3: Engineering Manager

**Value proposition:** Nolapse gives Engineering Managers a real-time, trustworthy view of coverage compliance across their portfolio — without requiring developers to change their workflow or report manually.

**Before Nolapse:**
The Engineering Manager gets a coverage dashboard showing numbers per repo — but the numbers are hard to interpret. Some repos measure line coverage, others branch coverage, thresholds vary. Is the org getting better or worse? Nobody knows. When the CTO asks "are we covered for the audit?", it takes two days of coordination to answer.

**After Nolapse:**
The Engineering Manager has a single, normalized view of coverage compliance across all repos — measured the same way, enforced the same way, auditable the same way. Every repo shows: current coverage, delta from last baseline, policy status (pass/warn/fail). The CTO's question is answered in under a minute.

**Primary metric:** Time to answer "are we coverage-compliant across the org?" — from days to under one minute.

**Acquirer lens:** Engineering Managers are the economic buyer in mid-market accounts and the internal sponsor in enterprise accounts. For SonarSource, this persona already uses SonarQube dashboards — Nolapse adds the enforcement and compliance layer that makes those dashboards actionable. For GitHub and GitLab, this persona bridges the developer-facing platform and executive-level governance.

---

## Persona 4: Security / Audit

**Value proposition:** Nolapse gives Security and Audit teams automated, immutable coverage compliance records — eliminating manual evidence collection for SOC 2, ISO 27001, and FedRAMP audits.

**Before Nolapse:**
Every SOC 2 cycle, the security team asks for evidence that the organization enforces test coverage standards. The platform team exports whatever they can from their SaaS coverage tools — often partial, inconsistent, or missing for repos that changed tools mid-year. An engineer spends several days pulling, normalizing, and formatting evidence into a spreadsheet. The coverage section is always the most painful part of the audit.

**After Nolapse:**
Coverage baselines are Git commits. Every baseline update has a timestamp, an author, and a cryptographic hash — verifiable and immutable by design. The audit export is a structured report generated in minutes: per-repo coverage over time, policy compliance status, baseline change history. The security team answers the auditor's coverage questions without involving the platform team.

**Primary metric:** Audit preparation time for coverage evidence — from days to under 30 minutes.

**Acquirer lens:** This persona is the compliance credibility unlock. Enterprise pricing in any SaaS product is partially justified by compliance features. For GitHub (GHAS), GitLab (compliance frameworks), and SonarSource (enterprise quality gates), Nolapse's audit-ready story validates the governance tier of their pricing model. Winning the Security/Audit persona is what makes Nolapse a line item in a compliance budget rather than a developer tool budget.

---

## Persona 5: Executive (VP Engineering / CTO)

**Value proposition:** Nolapse gives executives a provable, defensible answer to the question: *"Are our engineering quality standards actually enforced — not just aspirational?"*

**Before Nolapse:**
The VP Engineering has a coverage policy in writing. It says all repos should maintain 75% line coverage. In practice, the policy is inconsistently enforced, threshold exceptions have been granted dozens of times, and the actual average coverage across the org is unknown. The policy is aspirational, not operational. When the board asks about engineering quality governance, the VP Engineering can only say "we have a policy" — not "we can prove it."

**After Nolapse:**
The VP Engineering can state accurately: "Every repository in our org has a coverage baseline versioned in Git. Every PR is compared against it automatically. Coverage regressions cannot merge. Here is the org-wide compliance dashboard, and here is the audit export for any time range you want." That is governance, not aspiration — with a paper trail.

**Primary metric:** Ability to make a provable, auditable quality governance claim — to the board, to auditors, and to acquirers.

**Acquirer lens:** This persona is the acquisition signal. An executive at a 1,000-engineer regulated company choosing Nolapse as their quality governance layer is exactly the customer each acquirer's enterprise sales team is trying to reach. Nolapse with executive-level adoption demonstrates strategic platform value — it is no longer a developer tool, it is an enterprise quality standard. This is what justifies the acquisition premium.

---

## Persona Summary

| Persona | Primary Pain | Nolapse's Value | Key Metric |
| --- | --- | --- | --- |
| Developer | Unfair or unpredictable CI feedback | Baseline-aware enforcement — fair, fast, clear | PR signal trust |
| Platform Team | Maintaining 150 bespoke coverage configurations | One deployment governs the entire org | Support hours saved |
| Engineering Manager | No trustworthy org-wide compliance view | Normalized, real-time compliance dashboard | Time to answer "are we compliant?" |
| Security / Audit | Manual evidence collection for every audit cycle | Immutable Git-native audit trail, exportable in minutes | Audit prep time |
| Executive | Quality policy is aspirational, not provable | Auditable governance with a paper trail | Provable compliance claim |

---

See the [Baseline Concept Pitch](baseline_concept_pitch.md) for the narrative behind the core concept, and the [Competitive Landscape](../marketing/competitive_landscape.md) for how each persona maps to the acquirer ecosystem.
