# Execution Lifecycle v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Execution Lifecycle](../archive/v2-coverage-governance/technical/execution_lifecycle_and_state_machine.md)

---

## Overview

An "execution" is a single Nolapse action run triggered by a GitHub Actions workflow. Each execution moves through distinct states, ultimately producing a pass/fail decision and audit log.

---

## State Diagram

```
                  ┌─────────────────────────────────┐
                  │    WORKFLOW_TRIGGERED           │
                  │  (GitHub Actions dispatched)    │
                  └────────────────┬────────────────┘
                                   ↓
                  ┌─────────────────────────────────┐
                  │    INPUT_VALIDATION             │
                  │  (Validate inputs, load token)  │
                  └────────────────┬────────────────┘
                                   ↓
                  ┌─────────────────────────────────┐
                  │    BASELINE_FETCH               │
                  │  (Fetch baseline from Git)      │
                  └────────────────┬────────────────┘
                                   ↓
                  ┌─────────────────────────────────┐
                  │    BASELINE_PARSE               │
                  │  (Parse JSON baseline)          │
                  └────────────────┬────────────────┘
                                   ↓
                  ┌─────────────────────────────────┐
                  │    COVERAGE_PARSE               │
                  │  (Parse lcov/jacoco/cobertura)  │
                  └────────────────┬────────────────┘
                                   ↓
                  ┌─────────────────────────────────┐
                  │    COMPARISON                   │
                  │  (Compare PR vs baseline)       │
                  └────────┬────────────────┬───────┘
                           │                │
                      PASS │                │ FAIL
                           ↓                ↓
            ┌─────────────────────────┐  ┌──────────────────────┐
            │  FEEDBACK_GENERATE      │  │  FEEDBACK_GENERATE   │
            │  (Success message)      │  │  (Failure feedback)  │
            └────────────────┬────────┘  └──────────────┬───────┘
                             │                          │
                             └──────────────┬───────────┘
                                            ↓
                             ┌──────────────────────────┐
                             │  PR_COMMENT_POST         │
                             │  (Post feedback comment) │
                             └──────────────┬───────────┘
                                            ↓
                             ┌──────────────────────────┐
                             │  GITHUB_CHECK_SET        │
                             │  (Set pass/fail status)  │
                             └──────────────┬───────────┘
                                            ↓
                             ┌──────────────────────────┐
                             │  AUDIT_LOG_CREATE        │
                             │  (Create exec log JSON)  │
                             └──────────────┬───────────┘
                                            ↓
                             ┌──────────────────────────┐
                             │  AUDIT_LOG_COMMIT        │
                             │  (Commit to Git)         │
                             └──────────────┬───────────┘
                                            ↓
                             ┌──────────────────────────┐
                             │  COMPLETE                │
                             │  (Execution finished)    │
                             └──────────────────────────┘
```

---

## State Descriptions

### 1. WORKFLOW_TRIGGERED

**When:** GitHub Actions workflow starts (on push, pull_request event)

**What Happens:**
- GitHub Actions dispatches Nolapse action
- Action environment prepared (GITHUB_TOKEN, etc.)
- Input parameters loaded

**Next State:** INPUT_VALIDATION

**Timeout:** N/A (GitHub Actions manages)

---

### 2. INPUT_VALIDATION

**When:** Action starts executing

**What Happens:**
- Validate required inputs present (coverage-report, baseline-path)
- Load GitHub token
- Parse agent-token from input or environment
- Initialize logging

**Possible Outcomes:**
- ✅ Success → BASELINE_FETCH
- ❌ Failure (missing input) → ERROR_EXIT

**Error Handling:**
```typescript
if (!inputs.coverageReport) {
  core.setFailed('Coverage report path required');
  process.exit(1);
}
```

---

### 3. BASELINE_FETCH

**When:** After inputs validated

**What Happens:**
- Clone/fetch repository (if needed)
- Locate baseline file (default: `.nolapse/baselines/baseline.json`)
- Read baseline from Git
- Verify baseline file exists

**Git Operation:**
```bash
git show HEAD:.nolapse/baselines/baseline.json
```

**Possible Outcomes:**
- ✅ Baseline found → BASELINE_PARSE
- ❌ Baseline not found → Use defaults → BASELINE_PARSE (fallback)
- ❌ Git error → ERROR_EXIT

---

### 4. BASELINE_PARSE

**When:** Baseline file fetched

**What Happens:**
- Validate JSON format
- Parse version, policy, thresholds
- Type-check baseline structure
- Cache baseline in memory

**Validation:**
```typescript
{
  version: string;  // required
  policy: {
    overall_threshold: number;  // required, 0-100
    agent_threshold?: number;   // optional
    max_delta_drop?: number;    // optional
  };
  by_file?: { [pattern]: number };  // optional
}
```

**Possible Outcomes:**
- ✅ Valid baseline → COVERAGE_PARSE
- ❌ Invalid JSON → ERROR_EXIT
- ❌ Missing required fields → ERROR_EXIT

---

### 5. COVERAGE_PARSE

**When:** Baseline parsed

**What Happens:**
- Locate coverage report file (input parameter)
- Detect format (lcov, jacoco, cobertura)
- Parse coverage metrics
- Extract file-by-file coverage
- Calculate overall coverage percentage

**Format Detection:**
```typescript
if (report.includes('SF:')) {
  format = 'lcov';  // lcov uses SF: prefix
} else if (report.includes('<coverage')) {
  format = 'cobertura';  // XML format
} else if (report.includes('classname')) {
  format = 'jacoco';  // Jacoco JSON/XML
}
```

**Possible Outcomes:**
- ✅ Coverage parsed → COMPARISON
- ❌ File not found → ERROR_EXIT
- ❌ Unparseable format → ERROR_EXIT

**Timeout:** 30 seconds (large repos)

---

### 6. COMPARISON

**When:** Coverage parsed

**What Happens:**
- Load previous coverage (from Git commit or baseline)
- Calculate deltas (file-by-file, overall)
- Apply policy rules (threshold, delta drop, agent vs human)
- Determine pass/fail status

**Decision Logic:**
```typescript
const isAgent = agentToken !== 'unknown';
const threshold = isAgent ? baseline.agent_threshold : baseline.overall_threshold;

if (newCoverage >= threshold) {
  status = 'PASS';
} else if (newCoverage < threshold - baseline.max_delta_drop) {
  status = 'FAIL';
} else {
  status = 'FAIL';  // Any regression is fail
}
```

**Possible Outcomes:**
- ✅ PASS → FEEDBACK_GENERATE
- ❌ FAIL → FEEDBACK_GENERATE (different feedback)

---

### 7. FEEDBACK_GENERATE

**When:** Comparison complete

**What Happens:**
- Generate JSON feedback
- Include pass/fail status
- If FAIL: include specific file failures, coverage gaps, suggestions
- If PASS: include congratulatory message

**Pass Feedback:**
```json
{
  "status": "pass",
  "message": "Coverage maintained at 85%"
}
```

**Fail Feedback:**
```json
{
  "status": "fail",
  "coverage": { "before": 80, "after": 72, "delta": -8 },
  "failed_files": [
    {
      "file": "src/auth.ts",
      "lines": "42-67",
      "required": 85,
      "actual": 60,
      "suggestion": "Add error path tests"
    }
  ]
}
```

**Possible Outcomes:**
- ✅ Feedback generated → PR_COMMENT_POST

---

### 8. PR_COMMENT_POST

**When:** Feedback generated

**What Happens:**
- Post feedback JSON as comment on PR
- Use GitHub API to create comment
- Mark comment with Nolapse header (for future edits)
- Include link to execution log

**GitHub API Call:**
```
POST /repos/{owner}/{repo}/issues/{issue_number}/comments
```

**Possible Outcomes:**
- ✅ Comment posted → GITHUB_CHECK_SET
- ❌ API error (rate limit, auth) → RETRY or ERROR_EXIT

**Timeout:** 10 seconds

---

### 9. GITHUB_CHECK_SET

**When:** PR comment posted

**What Happens:**
- Create GitHub Check Run with pass/fail status
- Check name: "Nolapse Coverage Enforcement"
- Include summary with coverage delta
- Set conclusion (success/failure)

**GitHub API Call:**
```
POST /repos/{owner}/{repo}/check-runs
```

**Check Details:**
```json
{
  "name": "Nolapse Coverage Enforcement",
  "head_sha": "{commit_hash}",
  "status": "completed",
  "conclusion": "success|failure",
  "output": {
    "title": "Coverage: 85%",
    "summary": "Coverage increased by 5%",
    "text": "..."
  }
}
```

**Possible Outcomes:**
- ✅ Check set → AUDIT_LOG_CREATE
- ❌ API error → RETRY or ERROR_EXIT

**Timeout:** 10 seconds

---

### 10. AUDIT_LOG_CREATE

**When:** GitHub check set

**What Happens:**
- Create execution log JSON object
- Include all metadata (timestamp, PR, commit, agent, coverage, baseline)
- Prepare for Git commit

**Log Object:**
```json
{
  "execution_id": "exec-abc123",
  "timestamp": "2026-03-15T14:23:45Z",
  "pr_number": 4821,
  "commit_hash": "a1b2c3d4e5f6",
  "agent_token": "claude-code-v1",
  "coverage": { ... },
  "status": "pass",
  "baseline_version": "v1.2.3"
}
```

**Possible Outcomes:**
- ✅ Log created → AUDIT_LOG_COMMIT

---

### 11. AUDIT_LOG_COMMIT

**When:** Audit log created

**What Happens:**
- Write log to file: `.nolapse/executions/pr-{pr}-exec-{id}.json`
- Commit file to Git
- Use workflow identity (GitHub Actions user)
- Include PR number in commit message

**Git Commands:**
```bash
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add .nolapse/executions/pr-4821-exec-abc123.json
git commit -m "nolapse: log execution for PR #4821"
git push
```

**Commit Message Format:**
```
nolapse: log execution for PR #4821

execution_id: exec-abc123
coverage: 85%
status: pass
```

**Possible Outcomes:**
- ✅ Committed → COMPLETE
- ❌ Git error (concurrent commit) → RETRY or ERROR_EXIT

**Timeout:** 30 seconds

---

### 12. COMPLETE

**When:** Audit log committed

**What Happens:**
- Action exits with success status
- All outputs populated (result, coverage-before, coverage-after, coverage-delta)
- Logs available in GitHub Actions console

**Output:** `result=pass`, `coverage-before=80`, `coverage-after=85`, `coverage-delta=+5`

---

## Error Handling

### Recoverable Errors (Retry)

- GitHub API rate limit (exponential backoff)
- Transient network errors (retry 3x)
- Git push conflict (rebase + retry)

### Unrecoverable Errors (Exit)

- Missing baseline file (cannot proceed)
- Invalid coverage report format (cannot parse)
- Missing GitHub token (cannot authenticate)
- Invalid JSON in baseline (cannot evaluate)

### Error State: ERROR_EXIT

**When:** Unrecoverable error occurs at any state

**What Happens:**
- Log error message to GitHub Actions console
- Set GitHub check to "failure"
- Call `core.setFailed()` to fail action
- Action exits with code 1

**Example:**
```typescript
try {
  const baseline = await parseBaseline(baselineFile);
} catch (error) {
  core.setFailed(`Failed to parse baseline: ${error.message}`);
  process.exit(1);
}
```

---

## Timeouts

| State | Timeout | Reason |
| --- | --- | --- |
| BASELINE_FETCH | 10s | Git operation |
| COVERAGE_PARSE | 30s | Large repos |
| COMPARISON | 5s | CPU-bound |
| PR_COMMENT_POST | 10s | GitHub API |
| GITHUB_CHECK_SET | 10s | GitHub API |
| AUDIT_LOG_COMMIT | 30s | Git push |
| **TOTAL** | **2 minutes** | GitHub Actions typical timeout |

---

## Concurrency Handling

### Concurrent PRs (Same Repo, Different Branches)

**Scenario:** Two PRs pushed simultaneously

**Behavior:**
- Both trigger Nolapse independently
- Both create separate execution logs in Git
- Logs committed to different files (keyed by exec_id)
- No conflicts

---

### Concurrent Commits (Same PR, Force Push)

**Scenario:** Agent force-pushes updated code to same PR

**Behavior:**
1. Old execution log remains for previous commit
2. New action run triggered
3. New execution log created for new commit
4. Old log remains in Git history (audit trail preserved)

---

## Idempotency

**Idempotent?** No (by design)

Each execution creates a unique log entry. If action runs twice on same commit:
- First run: creates execution log
- Second run: creates another execution log (same data, different exec_id)

This is intentional — audit trail shows "action ran twice" if it did.

---

## Related Documents

- **[Architecture v3.0](../product/architecture.md)** — Component design
- **[API Design v3.0](api-design.md)** — State data structures
- **[PRDs v3.0](../product/prds.md)** — Feature specifications

---

## Previous Version

**[View v2.0 Execution Lifecycle](../archive/v2-coverage-governance/technical/execution_lifecycle_and_state_machine.md)**

The v2 lifecycle focused on coverage calculation. v3.0 adds agent token tracking and audit logging stages.

---

*Execution Lifecycle v3.0 | March 2026*
