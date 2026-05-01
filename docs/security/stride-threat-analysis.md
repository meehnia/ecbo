# STRIDE Threat Analysis v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Coverage Governance STRIDE](../archive/v2-coverage-governance/security/c4-stride.md)

---

## Executive Summary

Nolapse v3.0 runs in customer's GitHub Actions pipeline and stores all state in customer's Git repository. This architecture significantly reduces vendor-side security risk compared to traditional SaaS tools.

**Key Security Properties:**
- ✅ No vendor database = no vendor breach impacts coverage data
- ✅ Audit logs in Git = immutable, customer-owned, Git-verifiable
- ✅ No customer secrets sent to vendor = no secret exfiltration risk
- ✅ All computation in customer's GitHub = vendor has no visibility into code

---

## STRIDE Threat Analysis

### S — Spoofing

#### Threat 1.1: Agent Token Spoofing

**Description:** Attacker spoofs agent token to make human-written code appear agent-written.

**Example:** Malicious insider sets `AGENT_TOKEN=claude-code-v1` on human PR to hide it in agent audit logs.

**Risk Level:** 🟡 Medium (requires GitHub Actions access)

**Mitigation:**
- Agent token sourced from trusted GitHub Action environment (`GITHUB_ACTOR`, `GITHUB_ACTIONS_RUN_ID`)
- Cannot override via env var if running in official action
- All token sources logged and auditable
- Enterprise can require manual token assignment for high-risk repos

**Implementation:**
```typescript
function getAgentToken(): string {
  // Prioritize environment, but only if GITHUB_ACTIONS is set
  if (process.env.GITHUB_ACTIONS === 'true') {
    const env = process.env.AGENT_TOKEN;
    if (env) return env;
  }
  // Fallback: unknown
  return 'unknown-agent';
}
```

---

#### Threat 1.2: Baseline Spoofing

**Description:** Attacker modifies baseline.json in Git to make failing PR appear to pass.

**Example:** Insider commits modified baseline.json with lowered thresholds before pushing code.

**Risk Level:** 🔴 High (but fully auditable)

**Mitigation:**
- Baselines in Git = full Git history auditable
- Baseline changes appear in Git log with author + timestamp
- Git commit signing can enforce authorized changes
- Audit export includes baseline version used at time of PR

**Implementation:**
- Require baseline changes in separate commit from coverage changes
- Policy: "Baseline changes require code review"
- Audit log: "Baseline version used at time of execution"

---

### T — Tampering

#### Threat 2.1: Execution Log Tampering

**Description:** Attacker modifies execution log after PR merged to hide coverage regression.

**Example:** After incident, insider commits modified `pr-4821-exec-abc123.json` to change `status: fail` → `status: pass`.

**Risk Level:** 🟡 Medium (but detectable)

**Mitigation:**
- Execution logs in Git = can only be "modified" by rewriting history
- Git history is immutable (GitHub prevents force-push by default)
- Tampered log creates new commit hash that differs from original
- Auditor can detect tampering by comparing stored hash vs new hash

**Implementation:**
- Log commit hash in PR comment: "Execution logged in commit abc123"
- Auditor can verify: `git log --oneline` and check for abc123
- If commit hash changed, history was rewritten (tampering detected)

---

#### Threat 2.2: Coverage Report Tampering

**Description:** Attacker modifies coverage report before Nolapse action runs.

**Example:** Script modifies lcov.info to report higher coverage than actual tests achieved.

**Risk Level:** 🟡 Medium (test failure would be obvious)

**Mitigation:**
- Test suite must pass for PR to reach Nolapse action
- Nolapse only processes coverage reports from passed test runs
- Tampering would require test suite to still pass (defeating the purpose)
- Enterprise can use GitHub Actions branch protection to prevent modification

---

#### Threat 2.3: PR Comment Tampering

**Description:** Attacker edits JSON feedback comment after Nolapse posts it.

**Example:** After Nolapse posts `{"status": "fail"}`, insider edits to `{"status": "pass"}`.

**Risk Level:** 🟡 Medium (but comment history visible)

**Mitigation:**
- GitHub comment editing is auditable (shows edit history)
- Audit export captures original timestamp, not edit time
- Policy: "Comments should not be edited" (enforced via branch rules)
- Original comment version preserved in Git commit

---

### R — Repudiation

#### Threat 3.1: Agent Denies Responsibility

**Description:** Agent claims it didn't write a particular PR, even though logs show its token.

**Example:** "I didn't write that PR!" (But token = claude-code-v1 in audit log)

**Risk Level:** 🟢 Low (audit log is proof)

**Mitigation:**
- Agent token in execution log is immutable proof
- Enterprise can audit which tokens wrote which code
- Can cross-reference with agent license tracking
- Incident investigation can prove "this token was responsible"

---

#### Threat 3.2: Nolapse Denies Processing Result

**Description:** Nolapse claims it didn't process a particular PR.

**Example:** "We never saw that PR!" (But execution log exists in customer's repo)

**Risk Level:** 🟢 Low (logs are customer-owned)

**Mitigation:**
- Execution logs stored in customer's Git = Nolapse has no access to delete them
- If Nolapse claims PR wasn't processed, customer can show Git log as proof
- Customer owns all evidence

---

### I — Information Disclosure

#### Threat 4.1: Code Disclosure via Feedback Comments

**Description:** Nolapse accidentally includes source code in feedback comment, revealing to all PR reviewers.

**Example:** Feedback includes full code snippet from failing coverage area.

**Risk Level:** 🟡 Medium (but content is already in PR)

**Mitigation:**
- Feedback includes only file paths + line numbers, never code content
- Code is already visible in PR (Nolapse only references it)
- No sensitive information in feedback
- Feedback format strictly enforced via schema validation

---

#### Threat 4.2: Coverage Data Disclosure to Unauthorized Parties

**Description:** Attacker accesses Git repository, reads baseline/execution logs, learns about code architecture.

**Example:** External attacker with repo access reads baselines, infers architecture.

**Risk Level:** 🟡 Medium (but requires repo access)

**Mitigation:**
- GitHub already controls repo access (standard GitHub permission model)
- Nolapse doesn't add new disclosure risk (same risk as code itself)
- Baselines only contain coverage thresholds, not code
- Execution logs contain only coverage data + file names (already in PR)

---

#### Threat 4.3: Agent Token Disclosure

**Description:** Attacker obtains list of which agents are writing code.

**Example:** Attacker reads execution logs, learns company uses "claude-code" + "cursor".

**Risk Level:** 🟢 Low (not sensitive information)

**Mitigation:**
- Agent tokens are not secrets (they're part of audit trail)
- Tool versions are not sensitive (already visible in PRs)
- No disclosure of API keys, credentials, or source code

---

### D — Denial of Service

#### Threat 5.1: Action Timeout / Infinite Loops

**Description:** Nolapse action hangs indefinitely or times out, blocking PRs.

**Example:** Coverage parser enters infinite loop, GitHub Actions timeout = PR blocked.

**Risk Level:** 🟡 Medium (affects development velocity)

**Mitigation:**
- Strict timeouts on all operations (<2 minutes total)
- Coverage parser tested with pathological inputs
- GitHub Actions has built-in timeout (5-6 hours, action timeout <30m)
- Fallback: if action times out, check remains "pending" (doesn't block merge)

**Implementation:**
```typescript
const timeout = 2 * 60 * 1000; // 2 minutes
const timer = setTimeout(() => {
  throw new Error('Action timeout');
}, timeout);
```

---

#### Threat 5.2: Resource Exhaustion

**Description:** Massive repository (10K+ files) causes action to exhaust memory.

**Example:** Customer with huge monorepo's coverage report causes OOM.

**Risk Level:** 🟡 Medium (affects large repos)

**Mitigation:**
- Stream-based coverage parsing (process line-by-line, not all in memory)
- Parallel parsing limited to CPU count
- Memory limits enforced (abort if >1GB)
- Test with pathological repos (10K files, 100MB coverage report)

---

#### Threat 5.3: GitHub API Rate Limiting

**Description:** Many repos using Nolapse simultaneously hit GitHub API limits.

**Example:** 1000 repos run Nolapse at same time, GitHub rate limit hit.

**Risk Level:** 🟢 Low (GitHub has generous limits for Actions)

**Mitigation:**
- Use GitHub App authentication (5000 req/hr vs 60 for user token)
- Batch API calls where possible
- Exponential backoff on rate limit
- Enterprise: request higher limits from GitHub

---

### E — Elevation of Privilege

#### Threat 6.1: Unauthorized Baseline Modification

**Description:** User without permission commits modified baseline.

**Example:** Junior developer lowers baseline thresholds without review approval.

**Risk Level:** 🟡 Medium (but standard Git access control)

**Mitigation:**
- GitHub branch protection: require PR review for baseline changes
- CODEOWNERS: assign baseline to security/arch team only
- Audit: all baseline changes appear in Git log with author
- Policy: "Baseline changes require +2 approvals"

**Implementation:**
```yaml
# CODEOWNERS
.nolapse/baselines/ @security-team @arch-team
```

---

#### Threat 6.2: Unauthorized Execution Log Modification

**Description:** User commits retroactive changes to execution logs.

**Example:** After incident, user rewrites Git history to hide bad PR.

**Risk Level:** 🟢 Low (GitHub prevents by default)

**Mitigation:**
- GitHub Admin Protection: prevent force-push to main
- GitHub has "push protection" that warns on committed secrets
- Audit: force-push attempts are logged and visible
- Default: "Dismiss stale pull request approvals when new commits are pushed"

---

#### Threat 6.3: Agent Token Escalation

**Description:** Attacker gains ability to use high-privilege agent token.

**Example:** Attacker obtains Claude API key used in GitHub Actions secret.

**Risk Level:** 🔴 High (but standard secret management issue)

**Mitigation:**
- Nolapse never stores or sees agent credentials/API keys
- Agent tokens in execution logs are identifiers, not credentials
- GitHub Secrets management standard security (encrypted)
- Policy: rotate agent API keys regularly
- This is a customer credential management issue, not Nolapse issue

---

## Trust Model

### What Nolapse TRUSTS

✅ GitHub (authentication, repo access control, API)  
✅ Customer's Git repository (immutability, audit logs)  
✅ Customer's test suite (coverage reports)  
✅ GitHub Actions secrets (agent API keys)  

### What Nolapse DOES NOT TRUST

❌ Pull request author (could be automated, could be attacker)  
❌ Baseline thresholds (customer owns policy)  
❌ Coverage reports (verified by passing test suite)  
❌ Agent tokens (customer provides, can be spoofed)  

---

## Audit Trail

### What Gets Logged (Immutably)

✅ Execution timestamp  
✅ PR number + commit hash  
✅ Agent token used  
✅ Coverage before + after  
✅ Pass/fail status  
✅ Baseline version at time of execution  
✅ Files affected  

### What is NOT Logged

❌ Source code  
❌ Test details  
❌ Agent credentials  
❌ Customer infrastructure details  

---

## Compliance Implications

### SOC 2 / ISO 27001

- ✅ Audit trail: immutable, customer-owned, Git-verifiable
- ✅ Access control: GitHub standard (no vendor involvement)
- ✅ Data isolation: customer's repo only
- ✅ Encryption: GitHub HTTPS standard

### FedRAMP

- ⚠️ Nolapse runs in customer's environment (GitHub Actions)
- ⚠️ No vendor systems involved
- ⚠️ Customer responsible for GitHub's FedRAMP compliance

---

## Threat Prioritization

| Threat | Severity | Likelihood | Mitigation Status |
| --- | --- | --- | --- |
| Code disclosure via comments | Medium | Low | Requires policy + schema validation |
| Baseline spoofing | High | Medium | Requires branch protection |
| Execution log tampering | Medium | Low | Requires GitHub push protection |
| Agent token spoofing | Medium | Medium | Requires environment-based token source |
| DoS via action timeout | Medium | Low | Requires timeout + resource limits |
| Secret exposure in API keys | High | Medium | Standard GitHub Secrets management |

---

## Related Documents

- **[Trust Boundaries v3.0](trust_boundary_diagram.md)** — System boundaries and isolation
- **[Architecture v3.0](../product/architecture.md)** — System design
- **[PRDs v3.0](../product/prds.md)** — Security requirements

---

## Previous Version

**[View v2.0 STRIDE Analysis](../archive/v2-coverage-governance/security/c4-stride.md)**

The v2 analysis focused on general coverage governance threats. v3.0 analysis adds threats specific to agent token attribution and audit trails.

---

*STRIDE Threat Analysis v3.0 | March 2026*
