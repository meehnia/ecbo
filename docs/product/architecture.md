# System Architecture v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Coverage Governance Architecture](../archive/v2-coverage-governance/product/architecture.md)

---

## Architecture Overview

Nolapse v3.0 is a distributed system for agent-aware quality governance. It runs in customer CI/CD pipelines, stores audit logs in Git, and provides feedback to agents via PR comments.

### Key Architectural Principles

1. **Git-Native** — All state in customer's Git repo, not vendor cloud
2. **Distributed Execution** — Runs in customer CI/CD (GitHub Actions, GitLab CI, Jenkins)
3. **Immutable Logs** — Execution logs committed to Git for audit compliance
4. **Agent-Aware** — Token attribution and agent-readable feedback as core features
5. **Stateless** — No vendor database required (Git is the source of truth)

---

## C4 Model

### Level 1: System Context

```
┌──────────────────────────────────────────────────────┐
│                    Nolapse System                     │
│                                                        │
│  Coverage baseline enforcement + agent governance    │
└──────────────────────────────────────────────────────┘
           ↑                           ↓
        reads from              posts feedback to
           ↓                           ↑
┌──────────────────────────────────────────────────────┐
│                   GitHub / GitLab                     │
│  (Repos, PRs, Actions, Auth, Notifications)         │
└──────────────────────────────────────────────────────┘
           ↑                           ↓
      Enterprise            [Covered above]
      Auditor
           ↓
    Reviews audit export
```

**External Systems:**
- **GitHub/GitLab:** Source repos, PR context, authentication
- **Enterprise Auditor:** Queries audit trail for procurement

---

### Level 2: Container Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      GitHub Repository                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │          Source Code + Baselines + Execution Logs        │  │
│  │  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │  │
│  │  │ src/        │  │ .nolapse/    │  │ .nolapse/    │   │  │
│  │  │ (main code) │  │ baselines/   │  │ executions/  │   │  │
│  │  │             │  │ (versioned)  │  │ (immutable)  │   │  │
│  │  └─────────────┘  └──────────────┘  └──────────────┘   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                            ↑ ↓
│  ┌──────────────────────────────────────────────────────────┐  │
│  │         GitHub Actions (CI/CD Pipeline)                  │  │
│  │  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │  │
│  │  │ Checkout    │→ │ Run Tests    │→ │ Nolapse      │   │  │
│  │  │             │  │ (collect     │  │ Action       │   │  │
│  │  │             │  │  coverage)   │  │ (enforcement)│   │  │
│  │  └─────────────┘  └──────────────┘  └──────────────┘   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                            ↓
│  ┌──────────────────────────────────────────────────────────┐  │
│  │         PR Feedback & GitHub Checks                       │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │  │
│  │  │ JSON Comment │  │ Status Check │  │ Execution    │   │  │
│  │  │ (agent-      │  │ (pass/fail)  │  │ Log Commit   │   │  │
│  │  │  readable)   │  │              │  │              │   │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Containers:**
1. **GitHub Repository** — Source code + baselines + execution logs
2. **GitHub Actions** — Test execution + coverage collection + Nolapse enforcement
3. **PR Feedback** — JSON comments, status checks, log commits

---

### Level 3: Component Diagram (Inside Nolapse Action)

```
┌────────────────────────────────────────────────────┐
│             Nolapse Action (GitHub)                │
│                                                     │
│  ┌──────────────┐                                 │
│  │   Input      │  • PR context (number, branch)  │
│  │   Handler    │  • Coverage report (lcov, xml)  │
│  │              │  • Agent token (env var)        │
│  └──────┬───────┘                                 │
│         ↓                                         │
│  ┌──────────────────────────────────────────┐   │
│  │   Baseline Manager                        │   │
│  │  ┌────────────────┐  ┌────────────────┐ │   │
│  │  │ Fetch Baseline │  │ Parse Baseline │ │   │
│  │  │ from Git       │→ │ (JSON format)  │ │   │
│  │  │ (.nolapse/)   │  │                │ │   │
│  │  └────────────────┘  └────────────────┘ │   │
│  └──────────────────────────────────────────┘   │
│         ↓                                       │
│  ┌──────────────────────────────────────────┐   │
│  │   Coverage Parser                         │   │
│  │  ┌────────────────┐  ┌────────────────┐ │   │
│  │  │ Parse Coverage │→ │ Extract File   │ │   │
│  │  │ Report (lcov)  │  │ + Line Level   │ │   │
│  │  │                │  │ Coverage       │ │   │
│  │  └────────────────┘  └────────────────┘ │   │
│  └──────────────────────────────────────────┘   │
│         ↓                                       │
│  ┌──────────────────────────────────────────┐   │
│  │   Comparison Engine                       │   │
│  │  ┌────────────────────────────────────┐ │   │
│  │  │ Compare PR Coverage vs Baseline    │ │   │
│  │  │ - File-level comparison            │ │   │
│  │  │ - Delta calculation                │ │   │
│  │  │ - Policy evaluation                │ │   │
│  │  │ - Pass/fail determination          │ │   │
│  │  └────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────┘   │
│         ↓                                       │
│  ┌──────────────────────────────────────────┐   │
│  │   Feedback Generator                      │   │
│  │  ┌────────────────────────────────────┐ │   │
│  │  │ Generate JSON feedback for agents  │ │   │
│  │  │ - Failed files                     │ │   │
│  │  │ - Specific line ranges             │ │   │
│  │  │ - Coverage gaps                    │ │   │
│  │  │ - Test suggestions                 │ │   │
│  │  └────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────┘   │
│         ↓                                       │
│  ┌──────────────────────────────────────────┐   │
│  │   Output Handler                         │   │
│  │  ┌──────────────┐  ┌──────────────────┐│   │
│  │  │ Post PR      │→ │ Create GitHub    ││   │
│  │  │ Comment      │  │ Check Status     ││   │
│  │  │ (JSON)       │  │                  ││   │
│  │  └──────────────┘  └──────────────────┘│   │
│  └────────┬──────────────────────────────────┘   │
│           ↓                                      │
│  ┌──────────────────────────────────────────┐   │
│  │   Audit Logger                            │   │
│  │  ┌────────────────────────────────────┐ │   │
│  │  │ Create execution log:               │ │   │
│  │  │ - timestamp, PR #, commit hash      │ │   │
│  │  │ - agent token, coverage deltas      │ │   │
│  │  │ - pass/fail status                  │ │   │
│  │  │ Commit to .nolapse/executions/      │ │   │
│  │  └────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────┘   │
└────────────────────────────────────────────────────┘
```

**Components:**
1. **Input Handler** — Receives PR context and coverage data
2. **Baseline Manager** — Fetches and parses baselines from Git
3. **Coverage Parser** — Parses coverage reports (lcov, jacoco, etc.)
4. **Comparison Engine** — Compares PR coverage vs baseline, evaluates policy
5. **Feedback Generator** — Creates agent-readable JSON feedback
6. **Output Handler** — Posts PR comment, sets GitHub check
7. **Audit Logger** — Creates execution log, commits to Git

---

### Level 4: Code Structure

```
nolapse-action/
├── src/
│   ├── index.ts              # Entry point (GitHub Action)
│   ├── baseline/
│   │   ├── fetcher.ts        # Fetch baseline from Git
│   │   ├── parser.ts         # Parse JSON baseline
│   │   └── types.ts          # Baseline interfaces
│   ├── coverage/
│   │   ├── parser.ts         # Parse lcov/jacoco/etc
│   │   ├── calculator.ts     # Coverage delta calculation
│   │   └── types.ts          # Coverage interfaces
│   ├── comparison/
│   │   ├── engine.ts         # Compare vs baseline
│   │   ├── policy.ts         # Policy evaluation
│   │   └── types.ts          # Comparison result interfaces
│   ├── feedback/
│   │   ├── generator.ts      # Generate JSON feedback
│   │   ├── formatter.ts      # Format for agents
│   │   └── templates.ts      # Feedback templates
│   ├── output/
│   │   ├── github.ts         # Post to GitHub PR
│   │   ├── auditor.ts        # Create audit log
│   │   └── types.ts          # Output interfaces
│   └── utils/
│       ├── logger.ts         # Logging
│       ├── config.ts         # Config loading
│       └── git.ts            # Git operations
├── tests/                     # Unit tests
├── action.yml                 # GitHub Action definition
├── package.json
└── README.md
```

---

## Data Flow

### Happy Path (PR Passes)

```
1. Agent writes code → pushes PR
   ↓
2. GitHub Actions triggered
   ↓
3. Tests run → coverage report generated (lcov)
   ↓
4. Nolapse Action started
   ├─ Fetches baseline from .nolapse/baselines/baseline.json
   ├─ Parses coverage report
   ├─ Compares PR coverage vs baseline
   ├─ Coverage ≥ baseline? YES
   ↓
5. Generate feedback
   ├─ Status: PASS
   ├─ Message: "Coverage maintained"
   ↓
6. Post outputs
   ├─ GitHub check: ✅ pass
   ├─ Create execution log
   ├─ Commit log to .nolapse/executions/pr-4821-exec-abc123.json
   ↓
7. Agent sees ✅ check → PR can be merged
```

### Error Path (PR Fails, Agent Self-Corrects)

```
1. Agent writes code → pushes PR
   ↓
2. GitHub Actions triggered
   ↓
3. Tests run → coverage drops to 72% (baseline: 80%)
   ↓
4. Nolapse Action
   ├─ Comparison: 72% < 80%? YES → FAIL
   ↓
5. Generate feedback JSON
   ├─ Status: FAIL
   ├─ Coverage gap: src/auth.ts:42-67 (60% coverage, needs 85%)
   ├─ Suggestion: "Add tests for error handling paths"
   ↓
6. Post outputs
   ├─ GitHub check: ❌ fail (blocks merge)
   ├─ PR comment: JSON feedback with specific files + lines
   ├─ Create execution log
   ├─ Commit log to .nolapse/executions/
   ↓
7. Agent reads feedback → understands what to fix
   ↓
8. Agent self-corrects → adds tests for auth.ts:42-67
   ↓
9. Agent pushes new commit → GitHub Actions triggered again
   ↓
10. Tests run → coverage now 82% (≥ 80%)
    ↓
11. Nolapse: PASS ✅
    ↓
12. Agent sees ✅ check → PR ready to merge
```

---

## Enterprise Audit Trail

### Execution Log Structure

```
.nolapse/executions/
├── pr-4821-exec-abc123.json  # Execution for PR #4821
├── pr-4820-exec-def456.json
└── pr-4819-exec-ghi789.json

Content of pr-4821-exec-abc123.json:
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
  "files_affected": ["src/api.ts", "src/utils.ts"]
}
```

**Immutability:**
- Logs committed to Git immediately after execution
- Git commit hash proves authenticity
- Cannot be edited without changing Git history
- Auditor can verify by checking Git

---

## Technology Stack

| Layer | Technology | Notes |
| --- | --- | --- |
| **Language** | TypeScript | Type safety for complex logic |
| **Runtime** | Node.js 18+ | GitHub Action standard |
| **Testing** | Jest + Coverage | Unit + integration tests |
| **Git Operations** | simple-git | Fetch baselines, commit logs |
| **Coverage Parsing** | Custom parsers | Support lcov, jacoco, cobertura |
| **JSON Formatting** | TypeScript types | Type-safe JSON generation |

---

## Deployment Model

### For Customers

1. **Add GitHub Action to workflow:**
   ```yaml
   - uses: nolapse-dev/nolapse-action@v3
   ```

2. **Configure baselines in repo:**
   ```
   .nolapse/baselines/baseline.json
   .nolapse/baselines/agent-baseline.json  (optional)
   ```

3. **Commit baseline + action:**
   ```bash
   git add .nolapse/ .github/workflows/
   git commit -m "Add Nolapse coverage enforcement"
   git push
   ```

4. **Next PR triggers Nolapse enforcement automatically**

---

## Scalability Considerations

**Single Repository:**
- Supports 50+ agents
- Supports 10K+ execution logs
- Baseline comparison: <5 seconds

**Performance Bottlenecks:**
- Coverage parsing: O(files) — typically <30s
- Baseline fetch: O(1) — <1s (Git local)
- Comparison: O(files) — <5s
- GitHub API calls: Batch when possible

**Future Optimization:**
- Cache parsed baselines
- Parallel coverage parsing (multi-language)
- Incremental coverage analysis

---

## Security Architecture

See [STRIDE Threat Analysis v3.0](../security/stride-threat-analysis.md) for security model.

**Key Principles:**
- No plaintext secrets stored
- Audit logs immutable (in Git)
- All operations in customer's GitHub context
- No vendor-side state or data storage

---

## Related Documents

- **[STRIDE Threat Analysis v3.0](../security/stride-threat-analysis.md)** — Security model and mitigations
- **[PRDs v3.0](prds.md)** — Feature specifications
- **[Execution Lifecycle v3.0](../technical/execution_lifecycle.md)** — Detailed state machine

---

## Previous Version

**[View v2.0 Architecture](../archive/v2-coverage-governance/product/architecture.md)**

The v2 architecture focused on general coverage governance. v3.0 architecture adds agent token attribution and audit logging.

---

*Architecture v3.0 | March 2026*
