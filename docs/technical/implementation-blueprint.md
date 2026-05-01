# Implementation Blueprint v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Runner Blueprint](../archive/v2-coverage-governance/technical/runner_implementation_blueprint.md)

---

## Overview

This blueprint guides the implementation of Nolapse v3.0, the GitHub Action that runs in customer workflows to enforce coverage baselines and provide agent feedback.

---

## Technology Stack

| Layer | Technology | Justification |
| --- | --- | --- |
| **Language** | TypeScript | Type safety, GitHub Action standard |
| **Runtime** | Node.js 20+ | GitHub Actions native |
| **Testing** | Jest + ts-jest | Modern testing, TypeScript support |
| **Coverage** | c8 | Accurate coverage reporting |
| **Build** | tsc + @vercel/ncc | Compile + bundle into single file |
| **Git** | simple-git | Pure JS, no native dependencies |
| **CI/CD** | GitHub Actions | Self-hosted testing |

---

## Project Structure

```
nolapse-action/
├── src/
│   ├── index.ts                  # Entry point, orchestration
│   ├── inputs.ts                 # Parse GitHub Action inputs
│   ├── outputs.ts                # Set GitHub Action outputs
│   ├── baseline/
│   │   ├── fetcher.ts            # Fetch baseline from Git
│   │   ├── parser.ts             # Parse JSON baseline
│   │   ├── validator.ts          # Validate baseline structure
│   │   └── types.ts              # TypeScript interfaces
│   ├── coverage/
│   │   ├── parser.ts             # Factory for format-specific parsers
│   │   ├── parsers/
│   │   │   ├── lcov.ts           # LCOV format parser
│   │   │   ├── jacoco.ts         # Jacoco XML parser
│   │   │   ├── cobertura.ts      # Cobertura XML parser
│   │   │   └── opencover.ts      # OpenCover XML parser
│   │   ├── calculator.ts         # Coverage delta calculation
│   │   └── types.ts              # Coverage interfaces
│   ├── comparison/
│   │   ├── engine.ts             # Main comparison logic
│   │   ├── policy.ts             # Policy evaluation
│   │   └── types.ts              # Comparison result interfaces
│   ├── feedback/
│   │   ├── generator.ts          # Generate feedback from results
│   │   ├── formatter.ts          # Format as JSON for agents
│   │   └── types.ts              # Feedback interfaces
│   ├── github/
│   │   ├── api.ts                # GitHub API interactions
│   │   ├── check-runs.ts         # Create check runs
│   │   ├── pull-requests.ts      # PR comment operations
│   │   └── types.ts              # GitHub API types
│   ├── audit/
│   │   ├── logger.ts             # Create execution logs
│   │   ├── committer.ts          # Commit logs to Git
│   │   └── types.ts              # Audit log interfaces
│   ├── utils/
│   │   ├── logger.ts             # Console + file logging
│   │   ├── config.ts             # Load config from action inputs
│   │   ├── git.ts                # Git operations wrapper
│   │   ├── errors.ts             # Custom error classes
│   │   └── constants.ts          # Constants + enums
│   └── main.ts                   # Main function, error handling
├── __tests__/
│   ├── baseline.test.ts
│   ├── coverage.test.ts
│   ├── comparison.test.ts
│   ├── feedback.test.ts
│   ├── github.test.ts
│   ├── audit.test.ts
│   ├── fixtures/                 # Test data (sample coverage reports, baselines)
│   └── integration.test.ts       # End-to-end tests
├── action.yml                    # GitHub Action definition
├── dist/                         # Bundled output (committed to repo)
│   ├── index.js                  # Compiled + bundled
│   └── index.js.map              # Source map
├── package.json
├── tsconfig.json
├── jest.config.js
├── .npmignore
├── .gitignore
└── README.md
```

---

## Key Modules

### 1. Baseline Module (`src/baseline/`)

**Responsibility:** Fetch, parse, and validate coverage baselines

**Key Functions:**

```typescript
// src/baseline/fetcher.ts
export async function fetchBaseline(
  repoPath: string,
  baselineDir: string = '.nolapse/baselines'
): Promise<string> {
  const git = simpleGit(repoPath);
  const content = await git.show([`HEAD:${baselineDir}/baseline.json`]);
  return content;
}

// src/baseline/parser.ts
export function parseBaseline(content: string): Baseline {
  const json = JSON.parse(content);
  validateBaselineSchema(json);
  return {
    version: json.version,
    policy: json.policy || {},
    by_file: json.by_file || {}
  };
}

// src/baseline/validator.ts
export function validateBaselineSchema(obj: any): void {
  if (!obj.version) throw new Error('Baseline missing version');
  if (typeof obj.policy?.overall_threshold !== 'number') {
    throw new Error('Invalid overall_threshold');
  }
}
```

**Test Coverage:** >90%
- Parse valid baselines
- Handle missing baselines (fallback)
- Reject invalid JSON
- Validate schema

---

### 2. Coverage Module (`src/coverage/`)

**Responsibility:** Parse coverage reports, calculate deltas

**Key Functions:**

```typescript
// src/coverage/parser.ts
export async function parseCoverageReport(
  reportPath: string
): Promise<CoverageReport> {
  const content = await fs.promises.readFile(reportPath, 'utf-8');
  const format = detectFormat(content);
  
  switch (format) {
    case 'lcov': return parseLcov(content);
    case 'jacoco': return parseJacoco(content);
    case 'cobertura': return parseCobertura(content);
    default: throw new Error(`Unsupported format: ${format}`);
  }
}

// src/coverage/calculator.ts
export function calculateDelta(before: number, after: number): {
  delta: number,
  percentage: string
} {
  const delta = after - before;
  const percentage = `${delta >= 0 ? '+' : ''}${delta.toFixed(1)}%`;
  return { delta, percentage };
}
```

**Supported Formats:**
- LCOV (default for Node, Python)
- Jacoco (Java)
- Cobertura (multi-language)
- OpenCover (.NET)

**Test Coverage:** >95%
- Parse each format type
- Handle malformed reports
- Extract file-level coverage
- Calculate overall coverage

---

### 3. Comparison Engine (`src/comparison/`)

**Responsibility:** Compare coverage vs baseline, apply policies

**Key Functions:**

```typescript
// src/comparison/engine.ts
export function compareWithBaseline(
  coverage: CoverageReport,
  baseline: Baseline,
  agentToken?: string
): ComparisonResult {
  const isAgent = agentToken !== 'unknown';
  const threshold = isAgent 
    ? baseline.policy.agent_threshold || baseline.policy.overall_threshold
    : baseline.policy.overall_threshold;
  
  const status = evaluatePolicy(coverage, baseline, threshold);
  
  return {
    status,
    overall_delta: coverage.overall_coverage - baseline.policy.overall_threshold,
    files_with_regression: findRegressions(coverage, baseline),
    baseline_used: baseline
  };
}

// src/comparison/policy.ts
export function evaluatePolicy(
  coverage: CoverageReport,
  baseline: Baseline,
  threshold: number
): 'pass' | 'fail' {
  // Check overall threshold
  if (coverage.overall_coverage < threshold) return 'fail';
  
  // Check per-file thresholds
  for (const file of coverage.files) {
    const fileThreshold = getFileThreshold(file.path, baseline);
    if (file.coverage < fileThreshold) return 'fail';
  }
  
  // Check delta rules
  if (baseline.policy.max_delta_drop) {
    const drop = baseline.policy.overall_threshold - coverage.overall_coverage;
    if (drop > baseline.policy.max_delta_drop) return 'fail';
  }
  
  return 'pass';
}
```

**Test Coverage:** >90%
- Evaluate absolute thresholds
- Evaluate delta thresholds
- Evaluate file-specific thresholds
- Handle edge cases (missing files, new files)

---

### 4. Feedback Module (`src/feedback/`)

**Responsibility:** Generate agent-readable JSON feedback

**Key Functions:**

```typescript
// src/feedback/generator.ts
export function generateFeedback(
  result: ComparisonResult
): Feedback {
  if (result.status === 'pass') {
    return {
      status: 'pass',
      message: 'Coverage maintained'
    };
  }
  
  return {
    status: 'fail',
    reason: 'coverage_regression',
    details: {
      current_coverage: result.coverage_after,
      required_coverage: result.baseline_used.policy.overall_threshold,
      delta: result.overall_delta,
      failed_coverage_for: result.files_with_regression.map(file => ({
        file: file.path,
        lines: formatLineRange(file.uncovered_lines),
        current_coverage: file.coverage,
        required_coverage: getFileThreshold(file.path, result.baseline_used),
        suggestion: generateSuggestion(file)
      }))
    }
  };
}

// src/feedback/formatter.ts
export function formatAsJson(feedback: Feedback): string {
  return JSON.stringify(feedback, null, 2);
}

export function formatAsMarkdown(feedback: Feedback): string {
  // Format for human readability in PR comments
}
```

**Test Coverage:** >85%
- Generate pass feedback
- Generate fail feedback with specifics
- Format JSON correctly
- Generate helpful suggestions

---

### 5. GitHub Module (`src/github/`)

**Responsibility:** Interact with GitHub API (comments, checks)

**Key Functions:**

```typescript
// src/github/api.ts
export async function postPRComment(
  octokit: InstanceType<typeof GitHub>,
  repo: { owner: string; repo: string },
  prNumber: number,
  feedback: Feedback
): Promise<void> {
  const comment = formatCommentBody(feedback);
  await octokit.rest.issues.createComment({
    owner: repo.owner,
    repo: repo.repo,
    issue_number: prNumber,
    body: comment
  });
}

// src/github/check-runs.ts
export async function createCheckRun(
  octokit: InstanceType<typeof GitHub>,
  repo: { owner: string; repo: string },
  commitSha: string,
  result: ComparisonResult
): Promise<void> {
  const conclusion = result.status === 'pass' ? 'success' : 'failure';
  
  await octokit.rest.checks.create({
    owner: repo.owner,
    repo: repo.repo,
    name: 'Nolapse Coverage Enforcement',
    head_sha: commitSha,
    status: 'completed',
    conclusion,
    output: {
      title: 'Coverage Analysis',
      summary: `Coverage: ${result.coverage_after.toFixed(1)}%`,
      text: generateCheckDetails(result)
    }
  });
}
```

**Test Coverage:** >85%
- Post PR comments
- Create check runs
- Set status checks
- Handle API errors

---

### 6. Audit Module (`src/audit/`)

**Responsibility:** Create and commit execution logs

**Key Functions:**

```typescript
// src/audit/logger.ts
export function createExecutionLog(
  result: ComparisonResult,
  pr: { number: number; commitSha: string },
  agentToken: string,
  baselineVersion: string
): ExecutionLog {
  return {
    execution_id: generateId(),
    timestamp: new Date().toISOString(),
    pr_number: pr.number,
    commit_hash: pr.commitSha,
    agent_token: agentToken,
    coverage_before: result.coverage_before,
    coverage_after: result.coverage_after,
    coverage_delta: result.overall_delta,
    status: result.status,
    baseline_version: baselineVersion,
    files_affected: result.files_changed
  };
}

// src/audit/committer.ts
export async function commitExecutionLog(
  git: SimpleGit,
  log: ExecutionLog
): Promise<string> {
  const path = `.nolapse/executions/pr-${log.pr_number}-exec-${log.execution_id}.json`;
  
  await fs.promises.mkdir(path.split('/').slice(0, -1).join('/'), { 
    recursive: true 
  });
  
  await fs.promises.writeFile(
    path,
    JSON.stringify(log, null, 2)
  );
  
  await git.add(path);
  
  const commitHash = await git.commit(
    `nolapse: log execution for PR #${log.pr_number}`,
    [path],
    { '--author': 'github-actions[bot] <github-actions[bot]@users.noreply.github.com>' }
  );
  
  await git.push();
  
  return commitHash;
}
```

**Test Coverage:** >90%
- Create valid logs
- Format JSON correctly
- Commit to Git
- Handle push failures

---

## Build & Distribution

### Build Process

```bash
# Compile TypeScript
npm run build

# Bundle with @vercel/ncc
npm run package

# Commit dist/ to Git
git add dist/
git commit -m "chore: rebuild"
```

### Single File Distribution

All code bundled into `dist/index.js` using @vercel/ncc:
- No external dependencies at runtime
- Includes all source code
- Minified
- Single file deployed to action consumers

---

## Testing Strategy

### Unit Tests (Jest)

```typescript
describe('Baseline Parser', () => {
  it('parses valid baseline', () => {
    const baseline = parseBaseline(validBaseline);
    expect(baseline.version).toBe('1.0.0');
  });
  
  it('rejects missing version', () => {
    expect(() => parseBaseline(invalidBaseline)).toThrow();
  });
});
```

### Integration Tests

- End-to-end: coverage report → feedback → PR comment
- Real Git operations (in temp repo)
- Mock GitHub API calls

### Test Coverage Target

- **Statements:** >85%
- **Branches:** >80%
- **Functions:** >85%
- **Lines:** >85%

---

## Performance Targets

| Operation | Target | Actual |
| --- | --- | --- |
| Input validation | <1s | TBD |
| Baseline fetch | <3s | TBD |
| Baseline parse | <1s | TBD |
| Coverage parse | <30s | TBD |
| Comparison | <5s | TBD |
| Feedback generation | <1s | TBD |
| GitHub API calls | <20s | TBD |
| Audit commit | <10s | TBD |
| **Total** | **<2 min** | TBD |

---

## Related Documents

- **[Architecture v3.0](../product/architecture.md)** — System design
- **[Execution Lifecycle v3.0](execution_lifecycle.md)** — State machine
- **[API Design v3.0](api-design.md)** — External interfaces

---

## Previous Version

**[View v2.0 Runner Blueprint](../archive/v2-coverage-governance/technical/runner_implementation_blueprint.md)**

The v2 blueprint focused on basic coverage calculation. v3.0 adds agent feedback and audit logging modules.

---

*Implementation Blueprint v3.0 | March 2026*
