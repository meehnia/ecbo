# Baseline Concept Pitch

**Status:** Complete — Gap #2 of 6
**Last Updated:** March 2026

---

## The 60-Second Explanation

> **"Nolapse stores your test coverage baseline as a file in your Git repository — right next to your code. Every pull request is automatically compared to that baseline. If coverage drops, the PR fails. If it improves or holds, it passes. No thresholds to argue about. No vendor dashboard to trust. The proof lives in your repo."**

That is the concept. Everything below is the story behind it.

---

## The Analogy That Makes It Click

Most teams already understand linting. A `.eslintrc` file sits in the repo, versions with the code, and fails CI when a developer introduces a style violation. Nobody argues about whether the linting rules are right or wrong — they were agreed on when the file was created, and every PR is judged against them automatically.

Nolapse does the same thing for test coverage.

The baseline file is the `.eslintrc` for coverage compliance. It lives in the repo, versions with every release, and makes every PR answer one binary question: *did you make coverage better, or did you make it worse?*

The difference from arbitrary threshold tools: **you are always compared to your own code, not to a number someone decided in a meeting three years ago.**

---

## Before Nolapse / After Nolapse

### Before Nolapse

A large engineering org has 200 repositories. Coverage is tracked in a third-party SaaS dashboard. The platform team has set threshold policies in CI — but thresholds were set repo by repo, inconsistently, two years ago. Some repos require 80%. Some require 50%. Several have thresholds that were lowered because a critical release was blocked.

When a developer opens a PR that drops coverage from 74% to 71%, one of three things happens:

1. The CI check passes because the threshold is 70% and both numbers are above it.
2. The CI check fails and the developer is confused — they didn't *add* uncovered code, they refactored a file and coverage shifted.
3. The platform team is asked to lower the threshold to unblock the release. They do. Again.

Six months later, the security team asks for a coverage compliance report for the SOC 2 audit. A platform engineer spends three days pulling data from the SaaS dashboard into a spreadsheet.

### After Nolapse

Each of the 200 repos has a `.audit/coverage/baseline.md` file committed to the main branch. This file was generated the first time Nolapse ran — it reflects the coverage at that moment in time, versioned in Git.

Every PR runs Nolapse as a CI step. Nolapse fetches the baseline from the repo, runs coverage on the PR branch, and computes the delta. If the delta is negative, the PR fails. If it is zero or positive, it passes.

There are no thresholds to argue about. The developer is compared to the state of the repo when they started working. A refactor that shifts coverage without adding new uncovered code will show a neutral or positive delta. A PR that adds new code without tests will fail.

When the SOC 2 auditor asks for coverage history, the platform engineer sends them a link to the `.audit/coverage/` directory in each repo. Every baseline update is a Git commit with a timestamp, an author, and a diff. Immutable. No vendor required.

---

## Pitch Language by Context

### Sales Deck (Single Slide)

**Headline:** Your coverage baseline should live in your codebase.

**Subhead:** Nolapse stores coverage baselines as versioned Git artifacts — automatically compared against every PR, auditable by design, owned by your team.

**Three bullets:**

- No arbitrary thresholds — PRs are compared to the baseline they branched from
- Baselines version with your code — no vendor lock-in, no data loss, no cloud dependency
- Every audit question answered with a Git log

---

### Landing Page Hero

> **"The coverage floor that never moves without your knowledge."**
>
> Nolapse commits a coverage baseline to every repository. Every pull request is automatically measured against it. Regressions fail CI before they merge. Audit evidence is a Git log.

---

### Cold Email (50 Words)

> Hi [Name],
>
> Most teams track coverage. Almost none enforce it consistently across 100+ repos.
>
> Nolapse stores coverage baselines in Git alongside your code. Every PR is compared to its own baseline automatically — regressions fail CI, improvements pass.
>
> 30-minute setup. No new infrastructure. Works with your existing CI.
>
> Worth a 20-minute look?

---

### Executive / Board Summary (2 Sentences)

> Nolapse treats test coverage as a versioned, auditable enterprise artifact — stored in your own Git repositories, enforced automatically in every CI pipeline, and exportable for SOC 2 and ISO compliance without manual preparation. This makes coverage regressions impossible to merge and coverage compliance trivial to prove.

---

## Why Git-Native Storage Is the Right Architecture

This is not an implementation detail. It is the core architectural decision that makes Nolapse defensible.

Every alternative — cloud-stored baselines, external databases, SaaS dashboards — introduces:

- **Vendor dependency**: if the vendor's service goes down, enforcement goes down
- **Data portability risk**: coverage history lives in someone else's system
- **Audit complexity**: evidence reconstruction requires vendor API calls, not a `git log`
- **Threshold drift**: externally stored baselines are easy to silently change without a PR review

Git-native baseline storage eliminates all four. The baseline is reviewed in PRs, versioned with releases, and never stored outside the team's own infrastructure. This is the architecture that makes Nolapse trustworthy to the Platform Team, auditable for the Security team, and self-sufficient for the air-gapped enterprise.

---

## Acquirer Lens

### Why this architecture is hard to replicate

For Codecov, SonarQube, and GitHub — all of whom store coverage data externally — replicating Git-native baseline storage means either:

1. Building a new Git write-back mechanism from scratch (non-trivial; requires safe service account management, branch handling, conflict resolution), or
2. Bolting a "save to Git" export onto their existing cloud model (which doesn't give you real-time enforcement or the audit properties — it's just a backup)

Nolapse owns this architecture today with a production implementation. That is the integration surface each acquirer is evaluating when they consider acquisition.

### What the pitch says to each acquirer

- **Codecov**: *"Your customers keep asking for Git-native baselines. Nolapse already built it."*
- **SonarSource**: *"Your enterprise customers build this themselves in custom scripts. Nolapse productizes it."*
- **GitHub**: *"Git is your platform. Coverage baselines belong in Git. Nolapse makes that native."*
- **GitLab**: *"Git-native artifacts are what your platform is built on. Nolapse extends that model to coverage governance."*

---

See the [Competitive Landscape](../marketing/competitive_landscape.md) and [Coverage Model](../marketing/coverage_model_summary.md) for supporting detail.
