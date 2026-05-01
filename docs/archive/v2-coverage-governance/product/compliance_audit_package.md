# Compliance Audit Package

**Status:** Active — Enterprise Tier Feature
**Last Updated:** March 2026

---

## Purpose

This document defines what Nolapse's compliance audit package contains, which specific controls it satisfies for SOC 2, ISO 27001, and FedRAMP audits, and how Platform Teams generate and deliver audit evidence.

This is an operational document. It is written for the Platform Team preparing evidence, the Security or Compliance team delivering it to an auditor, and any potential acquirer evaluating Nolapse's compliance posture and enterprise pricing rationale.

---

## What Problem This Solves

Coverage is a recurring pain point in SOC 2 audits. Auditors ask: *"Can you demonstrate that your organization enforces a defined software testing standard across all changes before they reach production?"*

Before Nolapse, the typical answer involves:

1. Exporting coverage data from a SaaS dashboard (partial, inconsistent, formatted for PR feedback not auditors)
2. Manually normalizing data across repos that use different coverage thresholds, different tools, or different measurement approaches
3. An engineer spending 2–3 days assembling a spreadsheet that auditors accept with reservations

After Nolapse, the audit package is a structured export generated in minutes from immutable Git-native records. Every baseline is a signed commit. Every enforcement decision has a timestamp, a committer, and a diff.

---

## SOC 2 Control Mapping

Nolapse's audit artifacts directly satisfy evidence requirements for the following Trust Services Criteria (TSC).

### CC8.1 — Change Management (Primary)

**Control:** The organization authorizes, designs, develops or acquires, configures, documents, tests, approves, and implements changes to infrastructure, data, software, and procedures to meet its change management objectives.

**What auditors ask for under CC8.1:**

- Evidence that a testing standard exists and is documented
- Evidence that changes are tested against that standard before merging
- Evidence that the standard is enforced (not aspirational)
- Evidence that the testing record is complete and tamper-resistant

**What Nolapse provides:**

| Auditor Requirement | Nolapse Evidence | Location |
| --- | --- | --- |
| Testing standard exists and is documented | Baseline file in `.audit/coverage/baseline.md` — versioned in Git with author and timestamp | Each governed repository |
| Changes are tested before merging | CI enforcement log: every PR evaluated by Nolapse, with pass/warn/fail outcome | Nolapse audit export |
| Standard is enforced, not optional | Policy configuration file (`nolapse.yaml`) committed to the repo; PRs cannot bypass without explicit override | Each governed repository |
| Record is complete and tamper-resistant | Git commit history — immutable, cryptographically hashed, author-attributed | Each governed repository |

**Auditor-ready statement:** *"Our organization enforces a coverage baseline standard on all pull requests across [N] repositories. The standard is defined as a versioned artifact in each repository's Git history. Every proposed change is evaluated against the baseline before merge. The enforcement record is the repository's Git log — immutable and complete."*

---

### CC7.2 — System Monitoring (Secondary)

**Control:** The entity monitors system components and the operation of those components for anomalies that are indicative of malicious acts, natural disasters, and errors affecting the entity's ability to meet its objectives.

**What Nolapse contributes:** The org-wide coverage compliance dashboard provides a real-time signal when any repository's coverage drops below its established baseline. Coverage regression is a monitoring signal for code quality anomalies introduced by changes.

**What Nolapse provides:**

- Org-wide compliance status: count of repos in pass/warn/fail state at any point in time
- Coverage trend data per repository: change in baseline over time, surfacing regressions before they compound
- Alert configuration: notify the Platform Team when a repo enters a failing state

---

### Additional Criteria (Phase 2 and Beyond)

| TSC | Applicability | Phase |
| --- | --- | --- |
| CC6.1 — Logical access controls | Indirect: Nolapse SSO (SAML/OIDC) provides access-controlled enforcement | Phase 2 |
| CC6.8 — Malware prevention | Indirect: Nolapse's ephemeral runner isolation prevents code persistence | Phase 1 |
| A1.2 — Environmental protections (Availability) | Nolapse's 99.9% uptime SLA is an availability control | Phase 2 SLA |

---

## ISO 27001 Control Mapping

ISO 27001 Annex A controls relevant to Nolapse's coverage governance artifacts:

| Annex A Control | Description | Nolapse Coverage |
| --- | --- | --- |
| A.12.1.2 — Change management | Changes to the organization and information processing facilities shall be controlled | Nolapse's PR enforcement and baseline versioning are the change control evidence |
| A.14.2.3 — Technical review of applications after operating platform changes | Applications shall be reviewed after changes to operating platforms | Nolapse's bulk baseline regeneration provides a re-baseline trigger after platform changes |
| A.14.2.8 — System security testing | Testing of security functionality shall be carried out during development | Nolapse CI enforcement demonstrates that testing is structurally enforced, not ad-hoc |
| A.14.3.1 — Protection of test data | Test data shall be selected carefully, protected, and controlled | Nolapse's ephemeral runner isolation — no code or test data persists post-execution |

**ISO 27001 auditor-ready statement:** *"Our organization implements and enforces software change testing controls under A.12.1.2 and A.14.2.8 through Nolapse. Coverage baselines for all production repositories are version-controlled in Git. Every change is automatically evaluated against the established baseline before merge. Evidence is available as a structured audit export covering any requested time range."*

---

## FedRAMP Control Mapping

For organizations pursuing FedRAMP authorization, Nolapse contributes evidence for:

| NIST SP 800-53 Control | Description | Nolapse Coverage |
| --- | --- | --- |
| SA-11 — Developer Security Testing and Evaluation | Require the developer of the system, system component, or system service to implement a security assessment plan | Nolapse's CI enforcement demonstrates systematic testing coverage evaluation on every change |
| SA-11(1) — Static Code Analysis | Employ static code analysis tools to identify common flaws | Nolapse complements static analysis (SonarQube) by adding enforcement; both together satisfy SA-11 and SA-11(1) |
| CM-3 — Configuration Change Control | Determine the types of changes that are configuration-controlled | Baseline changes in Nolapse require a commit to the `.audit/coverage/` directory — each baseline update is a configuration change event with full attribution |
| CM-3(2) — Test, Validate, and Document Changes | Test, validate, and document changes before finalizing the implementation | Nolapse's PR enforcement is the automated test-and-validate gate for coverage standards before merge |

**Note on FedRAMP:** FedRAMP requires a third-party assessment organization (3PAO) to evaluate controls. Nolapse's audit exports are designed to be 3PAO-readable — structured, time-stamped, and cross-referenced to repository and PR identifiers.

---

## The Audit Package: What It Contains

When a Platform Team generates an Nolapse compliance audit package, the export contains:

### 1. Coverage Baseline Registry

A per-repository listing of:

- Current baseline version (commit SHA, timestamp, author)
- Baseline at the start of the audit period
- All baseline changes during the audit period (each as a separate record: who changed it, when, what changed, and the associated PR if applicable)

### 2. Enforcement Activity Log

For the requested audit period, a complete log of every Nolapse enforcement evaluation:

| Field | Description |
| --- | --- |
| Repository | Full repository path |
| PR identifier | Pull request number or CI job ID |
| Evaluation timestamp | ISO 8601 timestamp |
| Baseline coverage | Coverage percentage at time of evaluation |
| PR coverage | Coverage percentage after PR changes |
| Delta | PR coverage minus baseline coverage |
| Policy outcome | PASS / WARN / FAIL |
| Override | If FAIL was overridden, the override author and reason |

### 3. Policy Configuration Snapshot

The `nolapse.yaml` policy configuration in effect for each repository during the audit period, with change history.

### 4. Compliance Summary

An aggregated compliance statement covering the audit period:

- Total repositories governed
- Total PR evaluations performed
- Pass rate, warn rate, fail rate
- Number of policy overrides (any manual bypass of a FAIL outcome)
- Repositories with no enforcement activity (alert: potential coverage gap)

### 5. Export Formats

| Format | Use Case |
| --- | --- |
| JSON | Machine-readable; import into GRC platforms (Vanta, Drata, Secureframe) |
| CSV | Spreadsheet review by auditors or security teams |
| PDF | Formatted evidence package for physical or digital submission |
| Git archive | The `.audit/coverage/` directory history, packaged as a signed archive |

---

## How to Generate the Audit Package

### For SOC 2 Type II

SOC 2 Type II covers a period (typically 6 or 12 months). Generate the package as follows:

1. In the Nolapse dashboard, navigate to **Audit** → **Export**
2. Set the date range to match your SOC 2 audit period
3. Select the repositories in scope (all production repositories by default)
4. Choose export format: JSON + PDF for most auditors
5. Download the package and deliver to your auditor or GRC platform

**Time to generate:** Under 5 minutes for up to 500 repositories.

### For ISO 27001 Surveillance Audit

ISO 27001 surveillance audits occur annually. The same export flow applies, with the date range set to the 12 months since the last audit.

### For FedRAMP Continuous Monitoring

FedRAMP requires monthly continuous monitoring reports. Configure Nolapse to auto-generate a monthly export on the 1st of each month and deliver it to the designated FedRAMP POA&M repository.

---

## Scope and Limitations

Nolapse's compliance audit package covers coverage enforcement controls. It does not cover:

| Out of Scope | What Covers It Instead |
| --- | --- |
| Static code analysis (SAST) | SonarQube, Snyk, Semgrep |
| Dynamic application security testing (DAST) | Burp Suite, OWASP ZAP |
| Dependency vulnerability scanning | Dependabot, Snyk |
| Infrastructure security controls | Cloud provider compliance, Terraform |
| Access control and identity management | SSO provider, IAM policies |
| Penetration testing | Third-party pentesting firm |

A complete SOC 2 or ISO 27001 audit requires evidence across all applicable controls. Nolapse handles the change management and testing evidence for coverage — it is one component of a complete compliance posture.

---

## GRC Platform Integration

Nolapse's JSON export is designed for import into common GRC (Governance, Risk, and Compliance) platforms:

| Platform | Integration | Status |
| --- | --- | --- |
| Vanta | Manual JSON import; auto-import via API (Phase 2) | Phase 1: Manual |
| Drata | Manual JSON import; auto-import via API (Phase 2) | Phase 1: Manual |
| Secureframe | Manual JSON import | Phase 1: Manual |
| Tugboat Logic | Manual CSV import | Phase 1: Manual |

Automated GRC integrations are a Phase 2 roadmap item. Phase 1 supports manual import for all major platforms.

---

## Acquirer Lens

The compliance audit package is the primary justification for Nolapse's Enterprise pricing tier ($24,000–$120,000/year). It is also the feature that unlocks the regulated-industry enterprise buyer segment — the highest-ACV segment in the roadmap.

**For GitHub (Advanced Security):** GHAS already provides dependency and secret scanning compliance evidence. Nolapse adds the coverage change management evidence layer — completing the picture for SOC 2 CC8.1 without GitHub needing to build it.

**For GitLab:** GitLab's compliance frameworks include pipeline evidence collection. Nolapse's structured audit export is designed to be pipeline-native — it can be committed as a pipeline artifact, making it natively GitLab-compatible post-acquisition.

**For SonarSource:** Sonar's enterprise customers already use SonarQube for code quality evidence. Nolapse's coverage audit package is the enforcement and audit layer that converts Sonar's quality metrics into auditable change control evidence — closing the compliance sale that Sonar's enterprise team cannot currently close alone.

**For Codecov:** Codecov has no compliance export feature. Every Codecov enterprise customer with a SOC 2 requirement is a latent Nolapse customer. The compliance audit package is what converts Codecov's largest accounts into Nolapse enterprise accounts before or after acquisition.

---

See the [Monetization Model](monetization_model.md) for how the compliance audit package maps to Enterprise tier pricing, and the [Data Room Index](data_room_index.md) for the SOC 2 Type II report status in the acquisition data room.
