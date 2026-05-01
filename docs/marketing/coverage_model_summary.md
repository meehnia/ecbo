# Nolapse Coverage Model – Executive & Product Summary

This document is a **concise, authoritative summary** of Nolapse’s coverage philosophy, calculation model, enforcement logic, and how it differs from existing tools like SonarQube and Codecov.

It is intended for:

* Product & engineering alignment
* Public documentation foundations
* Sales, GTM, and positioning clarity
* Potential acquirers evaluating Nolapse's technical differentiation and integration surface

---

## 1. First Principles (Non‑Negotiable)

Nolapse’s coverage system is built on the following immutable principles:

* Coverage must be **enforceable**, not just visible
* Comparisons must be **relative to the codebase itself**, not an arbitrary standard
* The signal must be **predictable, explainable, and fair**
* Developers should never lose by improving code
* The model must work consistently across languages

What Nolapse explicitly avoids:

* Global hard thresholds (e.g. “80% or fail”)
* Repo‑to‑repo comparisons
* Tool‑specific or composite metrics
* Coverage used as a vanity score

---

## 2. The Nolapse Coverage Model (Core Concept)

> **A pull request must not reduce test coverage compared to its baseline branch.**

Everything in Nolapse flows from this single rule.

Definitions:

* **Baseline** → coverage of the target branch (usually `main`)
* **PR Coverage** → coverage after applying PR changes
* **Delta** → PR coverage − baseline coverage

Decision rule:

* `delta ≥ 0` → PASS
* `delta < 0` → FAIL

---

## 3. Nolapse’s Precise Definition of “Coverage”

> **Coverage is the percentage of executable source code lines that are executed at least once by the test suite.**

This definition is intentionally narrow and unambiguous.

---

## 4. Breaking Down the Definition (Word by Word)

* **Executable lines**: lines that can actually run (comments and blanks excluded)
* **Executed**: run at least once by any test
* **At least once**: frequency does not matter
* **Percentage**: covered executable lines ÷ total executable lines × 100

---

## 5. What Exactly Do We Measure?

### Primary metric (MVP and beyond):

* **Line coverage only**

Why:

* Universally supported
* Least ambiguous
* Most stable across tools
* Best suited for enforcement

Branch, function, and statement coverage are explicitly **out of scope** for MVP.

---

## 6. What Nolapse Explicitly Does NOT Include in “Coverage”

Nolapse coverage does **not** include:

* Branch coverage
* Function coverage
* Statement coverage
* Test quality or effectiveness
* Static analysis or code smells

Coverage ≠ code quality. Nolapse is explicit and honest about this.

---

## 7. The Exact Calculation (Canonical)

1. Compute baseline coverage on target branch
2. Compute PR coverage with changes applied
3. Normalize both into Nolapse’s canonical schema
4. Calculate delta:

```
delta = PR_line_coverage − baseline_line_coverage
```

5. Apply policy:

* Pass if delta ≥ 0
* Fail if delta < 0

No weighting. No smoothing. No hidden logic.

---

## 8. File‑Level Nuance (Fairness, Not Gaming)

Problem:

* PRs touching a few files should not be punished by legacy low‑coverage code

Nolapse’s direction:

* Global coverage delta remains the primary signal
* Changed‑files coverage becomes a secondary guardrail

Outcome:

* Developers are accountable for what they change
* Large refactors are not unfairly penalized

---

## 9. Handling Edge Cases (Explicitly)

* **New files**: must meet 100% coverage expectation
* **Deleted uncovered code**: improves coverage
* **Deleted covered code**: neutral
* **Flaky coverage**: treated as user failure, not auto‑smoothed

Explicit handling prevents trust erosion.

---

## 10. Why Nolapse Chooses Line Coverage (Product Reasoning)

Line coverage is chosen because:

* It is consistent across ecosystems
* Developers intuitively understand it
* It produces the least noise
* Enforcement requires predictability, not sophistication

Nolapse prioritizes **trust and clarity over metric richness**.

---

## 11. How Nolapse Uses Coverage (Key Differentiation)

Nolapse does not use coverage as:

* A target
* A score
* A goal in itself

Nolapse uses coverage as:

> **A regression‑detection signal enforced automatically in CI.**

Coverage is a guardrail, not a KPI.

---

## 12. Nolapse’s Operational Definition (Canonical)

Internally, Nolapse treats coverage as:

```
coverage = executed_executable_lines / total_executable_lines
```

Nothing more. Nothing less.

---

## 13. Why This Definition Is Fair

This model is fair because:

* Developers are compared only to their own code
* There are no arbitrary thresholds
* Improvements are never penalized
* Behavior is predictable and repeatable

The only way to fail is to make coverage worse.

---

## 14. How We Explain This Publicly (CMO Lens)

Public explanation:

> **“Coverage means the percentage of your executable code that your tests actually run. Nolapse doesn’t chase a magic number — it only blocks regressions compared to your baseline.”**

Messaging pillars:

* Enforcement over reporting
* Baseline over thresholds
* Trust over dashboards

---

## 15. Nolapse vs Sonar vs Codecov (Explicit Comparison)

Nolapse complements SonarQube and Codecov — it does not replace them. Each tool occupies a distinct layer of the coverage stack.

| Dimension | Nolapse | SonarQube | Codecov |
| --- | --- | --- | --- |
| Metric | Line coverage only | Multiple metrics | Multiple metrics |
| Baseline | Mandatory (Git-native) | Indirect (New Code) | Optional |
| Thresholds | None | Static | Optional |
| Enforcement | Always | Config-dependent | Rare |
| Primary Role | Governance & enforcement | Code quality analysis | Coverage reporting |
| Nolapse Integration | — | Nolapse enforces; Sonar measures | Nolapse governs; Codecov reports |

One-line distinction:

* **SonarQube:** How healthy is my code?
* **Codecov:** What does my coverage look like?
* **Nolapse:** Did this PR make things worse — and can I prove it to an auditor?

The practical deployment: teams keep SonarQube for quality gates and Codecov for PR feedback. They add Nolapse for org-wide governance, baseline versioning, and audit-ready compliance. The three tools run in parallel and do not conflict.

---

## 16. Final Product Truth

> **Nolapse does not try to make coverage perfect.
> Nolapse makes regressions impossible.**

This principle anchors product, engineering, and go-to-market alignment.

---

## 17. Why This Model Makes Nolapse Acquirable

The coverage model is not just a product decision — it is the technical argument for why each of the four target acquirers would want to own Nolapse.

**Sentry / Codecov:** Codecov tracks coverage. Nolapse enforces it. The delta-based model is the enforcement layer Codecov has never shipped. Acquiring Nolapse gives Codecov the enterprise governance tier their largest customers are asking for.

**SonarSource:** SonarQube's "New Code" concept is conceptually similar to Nolapse's baseline model — but Sonar stores the baseline in their cloud, not in the customer's Git repo. Nolapse's Git-native model is the audit-ready, air-gapped-compatible version of what Sonar's enterprise customers need. Acquiring Nolapse fills that gap without rebuilding Sonar's baseline architecture.

**GitHub (Microsoft):** The coverage model's Git-native storage is architecturally native to GitHub. Coverage baselines as Git artifacts, enforced by GitHub Actions, visible in pull request checks — this is a natural extension of GitHub's platform story. The model was designed with this integration surface in mind.

**GitLab:** GitLab's compliance frameworks and DevSecOps narrative are strengthened by a coverage governance layer that stores its artifacts in Git and exposes them through the CI pipeline. Nolapse's model maps directly onto GitLab's artifact and pipeline architecture.

See the [Competitive Landscape](competitive_landscape.md) for the full acquisition rationale per acquirer.

---

**End of Nolapse Coverage Model Summary**
