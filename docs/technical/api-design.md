# API Design v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - API Design](../archive/v2-coverage-governance/technical/api_contracts_and_versioning_strategy.md)

---

## Overview

Nolapse v3.0 has three main API surfaces:

1. **GitHub Action Input/Output** — How customers invoke Nolapse
2. **Internal Component APIs** — How Nolapse components communicate
3. **Query/CLI APIs** — How users query execution logs

---

## 1. GitHub Action Interface (Public API)

### Inputs

```yaml
name: 'Nolapse Coverage Enforcement'
inputs:
  token:
    description: 'GitHub token (GITHUB_TOKEN)'
    required: true
  
  baseline-path:
    description: 'Path to baseline files (.nolapse/baselines/)'
    required: false
    default: '.nolapse/baselines/'
  
  coverage-report:
    description: 'Path to coverage report (lcov.info, coverage.xml, etc)'
    required: true
  
  agent-token:
    description: 'Token identifying the agent (claude-code, cursor, etc)'
    required: false
    default: 'unknown'
  
  fail-on-regression:
    description: 'Fail PR if coverage regresses'
    required: false
    default: 'true'
  
  comment-on-failure:
    description: 'Post feedback comment on failure'
    required: false
    default: 'true'

runs:
  using: 'node20'
  main: 'dist/index.js'
```

### Outputs

```yaml
outputs:
  result:
    description: 'pass|fail'
  
  coverage-before:
    description: 'Coverage % before'
  
  coverage-after:
    description: 'Coverage % after'
  
  coverage-delta:
    description: 'Delta (e.g., +5%, -2%)'
  
  execution-id:
    description: 'Unique execution ID (for audit logs)'
```

### Example Usage

```yaml
- uses: nolapse-dev/nolapse-action@v3
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    baseline-path: .nolapse/baselines/
    coverage-report: coverage/lcov.info
    agent-token: ${{ env.AGENT_TOKEN || 'unknown' }}
    fail-on-regression: true
    comment-on-failure: true
```

---

## 2. Internal Component APIs

### BaselineManager API

```typescript
interface Baseline {
  version: string;
  overall_threshold: number;  // e.g., 80
  agent_threshold: number;    // e.g., 85 (optional)
  by_file: {
    [glob: string]: number;   // e.g., "src/critical/**": 95
  };
  policy: {
    max_delta_drop: number;   // e.g., 5 (%)
    require_improvement: boolean;
  };
}

class BaselineManager {
  async fetchBaseline(repo: Repo, ref: string): Promise<Baseline>;
  async getBaselineVersion(repo: Repo, ref: string): Promise<string>;
  async validateBaseline(baseline: Baseline): Promise<void>;
}
```

### CoverageParser API

```typescript
interface CoverageFile {
  path: string;
  lines_covered: number;
  lines_total: number;
  coverage: number;  // e.g., 0.85 for 85%
  line_coverage: {
    [lineNumber: number]: 'covered' | 'uncovered' | 'not-executable';
  };
}

interface CoverageReport {
  files: CoverageFile[];
  overall_coverage: number;  // e.g., 0.82 for 82%
  timestamp: string;
}

class CoverageParser {
  async parseLcov(file: string): Promise<CoverageReport>;
  async parseJacoco(file: string): Promise<CoverageReport>;
  async parseCobertura(file: string): Promise<CoverageReport>;
}
```

### Comparison Engine API

```typescript
interface ComparisonResult {
  status: 'pass' | 'fail';
  overall_delta: number;      // e.g., +5 for +5%
  baseline_used: Baseline;
  files_with_regression: File[];
  reason: string;
}

class ComparisonEngine {
  async compare(
    coverage: CoverageReport,
    baseline: Baseline,
    agentToken?: string
  ): Promise<ComparisonResult>;
  
  evaluatePolicy(coverage: CoverageReport, baseline: Baseline): boolean;
}
```

### Feedback Generator API

```typescript
interface Feedback {
  status: 'pass' | 'fail';
  reason: string;
  details?: {
    current_coverage: number;
    required_coverage: number;
    delta: number;
    failed_coverage_for: {
      file: string;
      lines: string;  // e.g., "42-67"
      current: number;
      required: number;
      suggestion: string;
    }[];
  };
}

class FeedbackGenerator {
  generateJSON(result: ComparisonResult): Feedback;
  generateMarkdown(result: ComparisonResult): string;
}
```

### Audit Logger API

```typescript
interface ExecutionLog {
  execution_id: string;
  timestamp: string;
  pr_number: number;
  commit_hash: string;
  agent_token: string;
  coverage_before: number;
  coverage_after: number;
  coverage_delta: number;
  status: 'pass' | 'fail';
  baseline_version: string;
  files_affected: string[];
}

class AuditLogger {
  async createLog(log: ExecutionLog, repo: Repo): Promise<void>;
  async commitLog(log: ExecutionLog, repo: Repo): Promise<string>;  // returns commit hash
}
```

---

## 3. Query/CLI APIs

### Execution Query API

```typescript
interface QueryOptions {
  pr?: number;
  agent?: string;
  since?: Date;
  until?: Date;
  commit?: string;
  status?: 'pass' | 'fail';
}

class ExecutionQuery {
  async query(options: QueryOptions): Promise<ExecutionLog[]>;
  async getByPR(prNumber: number): Promise<ExecutionLog>;
  async getByAgent(agentToken: string): Promise<ExecutionLog[]>;
  async getByCommit(commitHash: string): Promise<ExecutionLog>;
}
```

### CLI Interface

```bash
# Query by PR
nolapse query --pr 4821

# Query by agent
nolapse query --agent "claude-code" --since "2026-03-01"

# Query by commit
nolapse query --commit abc1234

# Query recent failures
nolapse query --status fail --since "2026-03-01"

# Export audit trail
nolapse export --agent "claude-code" --since "2026-03-01" --format csv
```

---

## 4. Data Structures

### Baseline File Format

```json
{
  "version": "1.2.3",
  "created_at": "2026-03-01T00:00:00Z",
  "policy": {
    "overall_threshold": 80,
    "agent_threshold": 85,
    "max_delta_drop": 5,
    "require_improvement": false
  },
  "by_file": {
    "src/critical/**": 95,
    "src/api/**": 85,
    "src/utils/**": 80,
    "tests/**": 0
  }
}
```

### Execution Log File Format

```json
{
  "execution_id": "exec-abc123",
  "timestamp": "2026-03-15T14:23:45Z",
  "pr_number": 4821,
  "commit_hash": "a1b2c3d4e5f6",
  "agent_token": "claude-code-v1",
  "coverage": {
    "before": "78%",
    "after": "82%",
    "delta": "+4%"
  },
  "status": "pass",
  "baseline_version": "v1.2.3",
  "files_affected": ["src/api/handler.ts", "src/utils/validation.ts"],
  "feedback": {
    "status": "pass",
    "message": "Coverage increased"
  }
}
```

### PR Comment Feedback Format

```json
{
  "nolapse": {
    "version": "3.0.0",
    "execution_id": "exec-abc123"
  },
  "result": {
    "status": "fail",
    "reason": "coverage_regression",
    "summary": "Coverage dropped 8% (from 80% to 72%)"
  },
  "details": {
    "coverage": {
      "before": 80,
      "after": 72,
      "delta": -8
    },
    "baseline_policy": {
      "overall_threshold": 80,
      "required_for_agent": 85
    },
    "failed_files": [
      {
        "file": "src/handlers/auth.ts",
        "lines": "42-67",
        "coverage": 60,
        "required": 85,
        "gap": 25,
        "missing_paths": ["error handling", "token expiration"]
      }
    ]
  },
  "actions": {
    "agent": "Add tests for error handling in src/handlers/auth.ts:42-67",
    "reviewer": "Approve once coverage is restored"
  }
}
```

---

## 5. API Versioning

### Compatibility Policy

- **Major version changes** (v3 → v4): Breaking changes to inputs/outputs
- **Minor version changes** (v3.1 → v3.2): New inputs (backwards compatible)
- **Patch version changes** (v3.0.1 → v3.0.2): Bug fixes only

### Example

```yaml
# v3.0 - Requires baseline-path input
- uses: nolapse-dev/nolapse-action@v3
  with:
    baseline-path: .nolapse/baselines/

# v3.1 - Adds optional agent-token input (still compatible with v3.0)
- uses: nolapse-dev/nolapse-action@v3
  with:
    baseline-path: .nolapse/baselines/
    agent-token: "claude-code"  # NEW input added

# v4.0 - Could require different input structure (breaking)
- uses: nolapse-dev/nolapse-action@v4
  with:
    config-file: .nolapse/config.yaml  # Different signature
```

---

## Related Documents

- **[Architecture v3.0](../product/architecture.md)** — Component interactions
- **[PRDs v3.0](../product/prds.md)** — Feature specifications
- **[Execution Lifecycle v3.0](execution_lifecycle.md)** — State machine

---

## Previous Version

**[View v2.0 API Design](../archive/v2-coverage-governance/technical/api_contracts_and_versioning_strategy.md)**

The v2 API focused on baseline management. v3.0 API adds agent token handling and audit logs.

---

*API Design v3.0 | March 2026*
