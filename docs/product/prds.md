# Product Requirements Document v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Coverage Governance PRD](../archive/v2-coverage-governance/product/prds.md)

---

## Overview

Nolapse v3.0 is a quality infrastructure platform specifically designed for AI agent governance. It solves three growth blockers by automating quality gates, providing audit trails, and enabling agent self-correction.

---

## Core Requirement Categories

### 1. Agent-Readable Feedback Loops ⭐ MVP-CRITICAL

**Requirement:** Agent PRs that fail coverage baseline must receive structured, machine-readable feedback that agents can parse and act on.

#### 1.1 Structured PR Comments

**Requirement:** Failed PRs receive JSON-formatted feedback in GitHub PR comments.

```json
{
  "status": "fail",
  "reason": "coverage_regression",
  "details": {
    "current_coverage": "72%",
    "required_coverage": "80%",
    "delta": "-8%",
    "failed_coverage_for": [
      {
        "file": "src/handlers/auth.ts",
        "lines": "42-67",
        "current_coverage": "60%",
        "required_coverage": "85%",
        "missing_coverage": ["error path handling", "edge cases in token validation"],
        "suggestion": "Add tests for error paths in lines 42-67, specifically token expiration handling"
      },
      {
        "file": "src/utils/logger.ts",
        "lines": "15-22",
        "current_coverage": "50%",
        "required_coverage": "80%",
        "missing_coverage": ["debug mode tests"],
        "suggestion": "Add tests for debug mode in lines 15-22"
      }
    ]
  }
}
```

**Acceptance Criteria:**
- ✅ Failed PRs receive JSON comment within 30 seconds of test run completion
- ✅ JSON is parseable by standard JSON libraries
- ✅ Includes file, line numbers, and specific suggestions
- ✅ Agents can extract and understand the feedback programmatically

#### 1.2 Pass/Fail Status Checks

**Requirement:** GitHub PR checks show pass/fail status with link to detailed feedback.

**Acceptance Criteria:**
- ✅ GitHub check created on PR with status (pass/fail/pending)
- ✅ Check failure blocks merge if required
- ✅ Check success allows auto-merge
- ✅ Details link to full feedback in PR comment

---

### 2. Agent Token Attribution & Tracking

**Requirement:** Every executed PR must be tagged with the agent/token that created it for audit and analysis purposes.

#### 2.1 Token Detection

**Requirement:** Automatically detect and record which AI tool/token generated the PR.

**Sources:**
- GitHub Actions environment variable: `AGENT_TOKEN` or `GITHUB_ACTOR`
- CI context: Detect Cursor, Claude Code, Devin, Copilot from commit metadata
- Manual override: Allow explicit token assignment via config

**Acceptance Criteria:**
- ✅ Token detected from GitHub Actions context
- ✅ Token stored immutably in execution log
- ✅ Token can be filtered in audit exports
- ✅ Unknown/missing token handled gracefully (logged as "unknown-agent")

#### 2.2 Audit Log Entry Structure

**Requirement:** Each execution log entry includes agent token attribution.

```json
{
  "execution_id": "exec-12345",
  "timestamp": "2026-03-15T14:23:45Z",
  "pr_number": 4821,
  "commit_hash": "abc1234def5678",
  "agent_token": "claude-code-v1",
  "coverage_delta": {
    "before": "78%",
    "after": "82%",
    "change": "+4%"
  },
  "status": "pass",
  "files_affected": ["src/api/handler.ts", "src/utils/validation.ts"],
  "baseline_version": "v1.2.3"
}
```

**Acceptance Criteria:**
- ✅ Log entry created for each PR execution
- ✅ Agent token immutably stored
- ✅ Timestamp accurate to second
- ✅ Coverage delta calculated and stored
- ✅ Files affected tracked

---

### 3. Enterprise Audit Trail & Compliance

**Requirement:** Complete, immutable, Git-native audit trail keyed by agent token for enterprise procurement.

#### 3.1 Git-Native Audit Logs

**Requirement:** All execution logs stored in Git, not in vendor cloud, to ensure immutability and auditability.

**Storage Model:**
- Logs stored in `.nolapse/executions/` directory in Git
- One file per PR execution: `executions/pr-4821-exec-12345.json`
- Logs are versioned with the code
- Git commit hash proves log authenticity

**Acceptance Criteria:**
- ✅ Logs stored in Git repository
- ✅ Logs committed with reproducible hash
- ✅ Logs cannot be edited retroactively without changing Git history
- ✅ Logs survive repository clones and backups

#### 3.2 Audit Export

**Requirement:** Generate audit-ready exports filtered by agent token type for enterprise security reviews.

**Export Format:** CSV or JSON with columns:
- timestamp
- pr_number
- commit_hash
- agent_token
- coverage_before
- coverage_after
- coverage_delta
- pass_fail_status
- files_affected

**Acceptance Criteria:**
- ✅ Export generated in <5 seconds for 100+ PRs
- ✅ Filterable by agent_token (e.g., "claude-code", "copilot")
- ✅ Filterable by date range
- ✅ Export includes complete history (no sampling)
- ✅ Export verifiable by Git hash

---

### 4. Coverage Baseline Management

**Requirement:** Versioned, enforceable coverage baselines stored in Git alongside code.

#### 4.1 Baseline Storage & Versioning

**Requirement:** Coverage baselines stored in `.nolapse/baselines/` directory, versioned with code.

**Structure:**
```
.nolapse/baselines/
├── baseline.json       # Current baseline for human-written code
├── agent-baseline.json # Baseline for agent-written code (may be stricter)
└── history/
    ├── baseline-v1.0.0.json
    └── agent-baseline-v1.0.0.json
```

**Acceptance Criteria:**
- ✅ Baselines stored in Git
- ✅ Agent and human baselines configurable separately
- ✅ Baselines versioned with code
- ✅ Baseline history queryable
- ✅ Baseline updates tracked in Git commit history

#### 4.2 Baseline Comparison

**Requirement:** PR coverage compared against baseline at time of branch creation.

**Logic:**
1. Agent PR branches off from commit `ABC123`
2. Baseline at `ABC123` is fetched
3. PR coverage is calculated
4. Coverage is compared against baseline
5. Pass/fail determined

**Acceptance Criteria:**
- ✅ Baseline retrieved from commit where branch started
- ✅ File-level comparison (which files dropped coverage)
- ✅ Line-level coverage tracked
- ✅ Comparison result logged with timestamp
- ✅ False positives prevented (no blame for pre-existing gaps)

---

### 5. Incident Root Cause Clarity

**Requirement:** When incidents occur, root cause is identified in minutes via execution logs.

#### 5.1 Execution Query Interface

**Requirement:** CLI tool to query execution logs by PR, commit, agent, or date range.

```bash
nolapse query --pr 4821
nolapse query --agent "claude-code" --since "2026-03-01"
nolapse query --commit abc1234def5678
nolapse query --coverage-drop --threshold 5%
```

**Acceptance Criteria:**
- ✅ Query returns execution record in <1 second
- ✅ Query includes full context (agent, coverage delta, files)
- ✅ Query supports multiple filters (AND logic)
- ✅ Query results include baseline version at time

#### 5.2 Incident Attribution

**Requirement:** When a bug is traced to a specific commit, determine if agent wrote it and what coverage was.

**Output:**
```
Commit abc1234def5678:
  PR: #4821
  Agent: claude-code-v1
  Coverage before: 78%
  Coverage after: 82%
  Coverage delta: +4%
  Failed coverage areas: [...]
  Baseline version: v1.2.3
  Conclusion: Agent did not introduce coverage regression; baseline is being met
```

**Acceptance Criteria:**
- ✅ Attribution determined from execution logs
- ✅ Coverage baseline at time of execution shown
- ✅ Clear statement of whether regression occurred
- ✅ Distinguishes "gap was pre-existing" vs "agent introduced it"

---

### 6. CI/CD Integration

**Requirement:** Seamless integration with existing CI/CD pipelines for GitHub, GitLab, Jenkins, Azure.

#### 6.1 GitHub Actions (v1.0)

**Requirement:** GitHub Action that runs coverage, compares baseline, and posts feedback.

```yaml
- uses: nolapse-dev/nolapse-action@v1
  with:
    token: ${{ secrets.NOLAPSE_TOKEN }}
    baseline-path: .nolapse/baselines/
    coverage-format: lcov
    agent-token: ${{ env.AGENT_TOKEN || 'unknown' }}
```

**Acceptance Criteria:**
- ✅ Action runs in <2 minutes for typical repos
- ✅ Integrates with existing test runners
- ✅ Posts PR comment with feedback
- ✅ Sets GitHub check status
- ✅ Logs execution to Git

#### 6.2 GitLab CI / Jenkins (Phase 2)

**Requirement:** Support for GitLab CI and Jenkins pipelines.

**Acceptance Criteria:**
- ✅ Equivalent to GitHub Action
- ✅ Posts feedback to MR/PR comments
- ✅ Sets pipeline status

---

### 7. Policy Engine

**Requirement:** Configurable threshold rules for pass/fail determination.

#### 7.1 Threshold Configuration

**Requirement:** Support multiple threshold types (absolute, delta, file-specific).

```json
{
  "coverage_policy": {
    "overall": {
      "minimum": "80%",
      "type": "absolute"
    },
    "agent": {
      "minimum": "85%",
      "type": "absolute"
    },
    "by_file": {
      "src/critical/**": "95%",
      "src/utils/**": "80%",
      "tests/**": "0%"
    },
    "delta": {
      "max_drop": "5%",
      "require_improvement": false
    }
  }
}
```

**Acceptance Criteria:**
- ✅ Policies stored in `.nolapse/config.json` (in repo)
- ✅ Policies versioned with code
- ✅ Absolute thresholds work
- ✅ Delta thresholds work (no drops >X%)
- ✅ File-specific thresholds override global

---

## Non-Functional Requirements

### Performance

- Coverage calculation: <30 seconds for typical repo
- Baseline comparison: <5 seconds
- PR feedback posted: <1 minute after test completion
- Audit export: <5 seconds for 1000+ executions

### Reliability

- 99.5% uptime for GitHub Action execution
- Zero data loss (all logs in Git)
- Graceful degradation if external services unavailable

### Security

- No plaintext storage of tokens
- All audit logs immutable (in Git)
- Audit logs do not contain source code
- Enterprise audit export support

### Scalability

- Support 50+ agents per repository
- Support 10K+ executions in history
- Query performance constant (indexed by commit hash)

---

## Success Metrics

| Metric | Target |
| --- | --- |
| Agent self-correction rate | >60% (agents fix feedback and re-run) |
| Time to incident RCA | <10 minutes (from bug discovery to PR identification) |
| Enterprise deal close time | <14 days (from security review start) |
| False positive rate | <2% (baseline falsely fails PR) |

---

## Related Documents

- **[MVP Definition v3.0](mvp-definition.md)** — What ships in Phase 1
- **[Architecture v3.0](architecture.md)** — System design
- **[Roadmap v3.0](roadmap.md)** — Implementation phases

---

## Previous Version

**[View v2.0 PRD](../archive/v2-coverage-governance/product/prds.md)**

The v2 PRD focused on general coverage governance. v3.0 PRD focuses on agent-specific features and growth blocker removal.

---

*PRD v3.0 | March 2026*
