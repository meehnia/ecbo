# Onboarding & Time-to-Value

**Status:** Complete — Gap #4 of 6
**Last Updated:** March 2026

---

## The First Value Moment

> **A developer's PR fails because coverage dropped — the developer sees exactly which lines are uncovered, understands why, trusts the signal, and writes the missing test.**

Everything before this moment is onboarding cost. Everything after it is retention.

The onboarding design goal: **a Platform Team goes from zero to their first enforced PR in under one working day**, on the CI system they already use, without changing how developers write code.

---

## Target Time-to-Value

| Milestone | Target |
| --- | --- |
| First baseline generated for a pilot repo | Under 30 minutes |
| First CI enforcement step live | Under 2 hours |
| First developer PR evaluated by Nolapse | Under 1 day |
| Org-wide rollout (100+ repos) | Under 2 weeks |

The 30-minute-to-first-baseline target is the critical number. It defines whether Nolapse is a "try it today" tool or a "schedule a POC" tool. It must be the former.

---

## Onboarding Flow

### Step 1 — Connect (5 minutes)

The Platform Team authenticates Nolapse with their Git provider using a service account PAT or OIDC. Nolapse needs read access to repo metadata and write access to create baseline commits.

- GitHub: Organization-level PAT or GitHub App installation
- GitLab: Group-level access token
- Azure DevOps / Bitbucket: Service account PAT

No infrastructure deployment required at this step.

---

### Step 2 — Discover (5 minutes)

Nolapse scans the connected org and returns a list of discovered repositories with detected languages and coverage readiness.

The Platform Team reviews the list and selects a pilot repo — ideally a mid-size repo with an existing test suite and a CI pipeline already in place.

Friction point eliminated: Nolapse auto-detects the language and framework. The Platform Team does not need to configure per-repo settings for pilot.

---

### Step 3 — Generate First Baseline (10 minutes)

Nolapse runs coverage collection on the pilot repo's default branch (`main` or `master`). It normalizes the output into its canonical line-coverage schema and commits a baseline file to `.audit/coverage/baseline.md` in the repo.

The Platform Team sees the baseline committed — a readable Markdown file showing per-file and overall line coverage percentages.

This is the "it works" moment. The baseline is now in Git.

---

### Step 4 — Add CI Enforcement (10 minutes)

The Platform Team adds the Nolapse CI step to the pilot repo's pipeline. This is a single snippet:

**GitHub Actions:**

```yaml
- uses: nolapse-dev/coverage-action@v1
  with:
    policy: strict
```

**GitLab CI:**

```yaml
include:
  - component: $CI_SERVER_FQDN/nolapse-dev/coverage-component@v1
    inputs:
      policy: strict
```

**Other CI systems:** a one-line CLI invocation: `nolapse run --policy strict`

The CI step runs on every PR. It fetches the baseline from the repo, runs coverage on the PR branch, and returns pass/warn/fail with a delta summary.

---

### Step 5 — Validate (10 minutes)

The Platform Team opens a test PR that intentionally drops coverage. Nolapse fails it with a clear diff. They open a second PR that adds a test. Nolapse passes it.

The signal is trusted. The pilot is done.

---

### Step 6 — Org-Wide Rollout

With the pilot validated, the Platform Team runs Nolapse's bulk baseline generation across all remaining repos. Nolapse queues jobs, handles concurrency, retries failures, and reports on completion.

The rollout produces a baseline in every repo without requiring a single change from individual development teams.

CI enforcement is then deployed org-wide via the Platform Team's standard CI template propagation process — the same snippet added once to the org-level CI template.

---

## Friction Points and How We Eliminate Them

| Friction Point | Risk | Elimination |
| --- | --- | --- |
| Per-repo CI configuration | Slows rollout at scale | Org-level CI template with one snippet handles all repos |
| Language/framework detection | Requires per-repo setup knowledge | Nolapse auto-detects; manual override available |
| Baseline generation for repos with no tests | Fails silently | Nolapse marks repos as "no test suite detected" and skips — not a blocker |
| Developer trust in the failure signal | Adoption rejection if signal feels unfair | Baseline-aware enforcement means developers are only compared to their own code; clear diff output |
| Air-gapped / self-hosted requirements | Enterprise procurement blocker | Nolapse supports self-hosted deployment; no external network calls required |
| Service account permissions | Security team friction | Nolapse requires minimum permissions; PAT or OIDC; no persistent credentials on runners |

---

## Onboarding by Integration Partner

Each of Nolapse's four ecosystem partners has a slightly different onboarding surface. Nolapse's onboarding is designed to feel native to each.

**Codecov users:** Nolapse's CI snippet is additive to Codecov's existing upload step. A team already using Codecov adds Nolapse as a second CI step — no change to their Codecov configuration. Nolapse and Codecov run in parallel.

**SonarQube users:** SonarQube's onboarding is often weeks-long due to scanner configuration. Nolapse's 30-minute onboarding creates a favorable contrast. The two tools run independently — SonarQube for code quality analysis, Nolapse for coverage baseline enforcement.

**GitHub Actions users:** Nolapse's GitHub Action follows GitHub Marketplace conventions. Authentication is via OIDC (no PAT required for GitHub-hosted repos). The action is composable and works alongside existing GitHub Actions workflows without modification.

**GitLab CI users:** Nolapse's GitLab CI component follows GitLab's component catalog conventions. A single `include:` block activates Nolapse. No pipeline restructuring required.

---

## Kill Criteria

Onboarding is failing if any of the following are true:

- First baseline takes longer than 30 minutes for a repo with an existing test suite
- Developers dispute more than 10% of Nolapse's CI failure signals in the first month
- Platform Team spends more than 2 hours per repo on configuration during rollout
- Any repo requires manual coverage tool configuration that Nolapse doesn't auto-detect

These are signals that Nolapse's setup friction is too high, not signals that the product concept is wrong.

---

See the [MVP Definition](mvp_definition.md) for the Phase 1 delivery scope that supports this onboarding flow, and the [Persona Value Props](persona_value_props.md) for how each persona experiences the first value moment.
