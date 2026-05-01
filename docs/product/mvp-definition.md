# MVP Definition v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Coverage Governance](../archive/v2-coverage-governance/product/mvp_definition.md)

---

## What Has Changed From v2

**v2.0 MVP:** General coverage baseline enforcement for human-written code

**v3.0 MVP:** Coverage baseline enforcement specifically designed for AI agent feedback loops

The core difference: **Agent-readable PR comments are now MVP-critical, not Phase 2.**

Without structured feedback, agents cannot self-correct. With it, the self-correction loop is complete and demonstrable.

---

## MVP Scope: v1.0 (Datum)

The minimum viable product that solves **all three growth blockers**.

### Core Features

#### 1. Agent-Specific Baseline Management ✨ NEW

- Store coverage baselines in Git (versioned with code)
- Support agent-specific baselines (separate from human-written code)
- Allow teams to lock baselines to prevent accidental regressions
- Enable per-repository baseline configuration

**Why this matters:** Enterprise compliance requires Git-native, immutable baseline records.

#### 2. Coverage Execution & Measurement

- Run tests and collect coverage metrics (10+ languages)
- Parse coverage reports (OpenCov, LCOV, Jacoco, etc.)
- Calculate delta against baseline
- Track coverage by file and by code path

**Why this matters:** Baseline comparison is the foundation of enforcement.

#### 3. Agent Token Attribution ✨ NEW

- Track which AI tool/token wrote each PR (agent ID from GitHub Actions context or CI environment)
- Log agent token in every execution record
- Enable audit filtering by token type
- Store immutable execution logs in Git

**Why this matters:** Enterprise auditors need to trace code back to its origin (human vs agent).

#### 4. Automated Quality Gates

- Block PRs with coverage regressions
- Allow PRs that pass baseline comparison
- Support configurable threshold rules (absolute, delta-based, file-specific)
- Integrate with GitHub PR checks (status checks, blocking required review)

**Why this matters:** Removes manual review bottleneck (solves Blocker 1).

#### 5. Agent-Readable PR Feedback ✨ **MVP-CRITICAL**

- Generate structured JSON feedback on PR comments
- Include specific file/line information where coverage dropped
- Provide actionable suggestions (which tests to add, which code paths lack coverage)
- Format for machine parsing (agents can read and act on it)

**Example feedback:**
```json
{
  "status": "fail",
  "reason": "coverage_regression",
  "details": {
    "failed_coverage_for": [
      {
        "file": "src/handler.ts",
        "lines": "42-50",
        "current_coverage": "60%",
        "required_coverage": "80%",
        "suggestion": "Add tests for error handling paths in lines 42-50"
      }
    ]
  }
}
```

Agent receives this, understands exactly what to fix, and can self-correct.

**Why this matters:** Closes the self-correction loop (demonstrates Blocker 1 solution).

#### 6. Enterprise Audit Trail

- Log every execution: timestamp, agent token, PR hash, coverage delta, pass/fail
- Store logs in Git (not vendor cloud) for immutability
- Enable filtering/export by agent token type
- Generate audit exports for enterprise procurement

**Why this matters:** Enables enterprise security reviews to pass (solves Blocker 2).

#### 7. Incident Root Cause Clarity

- Query execution logs by PR/commit
- Identify which agent (token) wrote problematic PR
- Show coverage state at time of merge
- Distinguish between "agent wrote bad code" vs "coverage gap was present"

**Why this matters:** Enables rapid incident resolution and prevents "all AI code is risky" narrative (solves Blocker 3).

---

## What's NOT in MVP

❌ **Dashboard UI** — Logs live in Git. CLI for query is sufficient for v1.

❌ **Advanced visualization** — Coverage graphs, historical trends can come later

❌ **Policy engine** — Simple threshold rules only. Complex policies come in Phase 2.

❌ **Multi-org/SAAS UI** — Designed for teams, not SaaS at launch

❌ **Integration with other tools** — GitHub only for v1.0. GitLab/Azure/Jenkins follow.

---

## Success Criteria for MVP

The MVP is successful if:

1. ✅ **Blocker 1 is demonstrable:** A 3-minute demo shows an agent PR failing, receiving feedback, self-correcting, and passing
2. ✅ **Blocker 2 is solvable:** Enterprise auditor can access complete, Git-native log of every agent PR with coverage data
3. ✅ **Blocker 3 is preventable:** Root cause of a coverage regression is identified in <10 minutes (previously took weeks)
4. ✅ **Agents can scale:** A team can run 10+ agents with zero manual review overhead

---

## Technical Requirements

### Language Support (v1.0)

- Go
- Python
- Node.js / TypeScript
- Java
- C# / .NET
- Rust (if time)

### CI/CD Integration (v1.0)

- GitHub Actions (primary)
- GitHub API for PR comment posting and status checks
- Git for log storage and baseline versioning

### Data Storage

- Git repository (immutable audit logs)
- Local file system (coverage artifacts)
- GitHub checks/comments (PR feedback)

---

## Related Documents

- **[Strategic Positioning v3.0](strategic-positioning.md)** — Why these features solve growth blockers
- **[The Three Blockers](ai-agent-governance/)** — Deep dive on what each blocker requires
- **[Product Requirements](prds.md)** — Detailed feature specifications
- **[Roadmap](roadmap.md)** — Phase timeline and Phase 2 features

---

## Previous Version

**[View v2.0 MVP Definition](../archive/v2-coverage-governance/product/mvp_definition.md)**

The v2 MVP was designed for general code quality. v3.0 MVP is specifically designed for agent feedback loops and enterprise audit trails.

---

*MVP Definition v3.0 | March 2026*
