# Roadmap v3.0 — AI Agent Governance

**Version:** 3.0  
**Date:** March 2026  
**Previous Version:** [v2.0 - Coverage Governance Roadmap](../archive/v2-coverage-governance/product/roadmap.md)

---

## Overview

Nolapse roadmap is organized around removing the three growth blockers:

1. **Agent Scaling Wall** — Requires agent feedback loops
2. **Enterprise Deal Stall** — Requires audit trails and compliance
3. **Production Incident Risk** — Requires execution logging and root cause clarity

Each phase is designed to progressively unlock the ability to sell into these problems.

---

## Phase 1: Datum (v1.0) — Core Blocker Removal

**Timeline:** Q2 2026  
**Goal:** MVP is ready. All three blockers are solvable (though not fully optimized).

### What Ships

**Agent-Readable Feedback Loop** ✨
- Structured JSON PR comments
- Specific file/line information
- Agent can parse and self-correct

**Enterprise Audit Trail**
- Execution logs in Git (immutable)
- Agent token tracking
- Audit export for procurement

**Coverage Baseline Enforcement**
- Pass/fail on agent PRs
- Block regressions before merge
- Support agent-specific baselines

**Incident Clarity**
- Query logs by PR/commit
- Identify which agent wrote code
- Coverage delta tracking

### Blocker Impact

| Blocker | Status | Impact |
| --- | --- | --- |
| Agent Scaling Wall | **Solvable** | Automated gates + feedback loops enable agents to self-correct |
| Enterprise Deal Stall | **Solvable** | Audit export answers procurement questions |
| Incident Risk | **Preventable** | Root cause identified in minutes, not weeks |

### Success Metrics

- ✅ Demo: Agent PR fails → gets feedback → self-corrects → passes (3 minutes)
- ✅ Audit export: Complete log of 100+ agent PRs generated in seconds
- ✅ Root cause query: Identify problematic PR in <5 minutes
- ✅ Sales: Able to close deals with teams running 5+ agents

---

## Phase 2: Hephaestus (v1.1) — Optimization & Scale

**Timeline:** Q3 2026  
**Goal:** Optimize for 50+ agents. Add dashboard and visualization.

### What Ships

**Dashboard UI**
- Coverage trends over time
- Agent performance comparison
- Incident timeline and trends
- Quick query interface for logs

**Advanced Policy Engine**
- File-specific thresholds
- Trend-based enforcement (no sudden drops)
- Team-specific policies
- Compliance rule templates

**CI/CD Expansion**
- GitLab CI integration
- Jenkins integration
- Azure DevOps integration
- Webhook-based execution model

**Performance Optimizations**
- Coverage calculation caching
- Baseline comparison speedup (sub-second)
- Log query optimization (>10K PRs)

### Blocker Impact

| Blocker | Status | Impact |
| --- | --- | --- |
| Agent Scaling Wall | **Optimized** | Can run 50+ agents with <5% overhead |
| Enterprise Deal Stall | **Streamlined** | Dashboard accelerates audit reviews |
| Incident Risk | **Minimized** | Trend detection catches regression patterns early |

---

## Phase 3: Prometheus (v2.0) — Intelligence & Automation

**Timeline:** Q4 2026  
**Goal:** Intelligent baseline management. Multi-org support.

### What Ships

**Intelligent Baseline Evolution**
- ML-based baseline recommendation (when to update)
- Anomaly detection (unusual coverage patterns)
- Baseline drift alerts
- Historical baseline versions

**Team & Org Multi-Tenancy**
- SAAS-ready architecture
- Team-level policies and baselines
- Cross-team reporting
- Org-wide compliance dashboard

**Advanced Feedback**
- Test suggestion engine
- Code path analysis
- Risk-based feedback (high-risk areas get stricter thresholds)

**Integration Ecosystem**
- Datadog / New Relic export
- Slack notifications
- Custom webhooks
- OpenTelemetry instrumentation

### Blocker Impact

| Blocker | Status | Impact |
| --- | --- | --- |
| Agent Scaling Wall | **Mature** | Autonomous baseline management reduces operational overhead |
| Enterprise Deal Stall | **Enterprise-Ready** | Multi-org compliance, audit retention, role-based access |
| Incident Risk | **Predictive** | Anomaly detection prevents incidents before they happen |

---

## Success Metrics by Phase

### Phase 1 (Datum)

- [ ] Blocker 1: Agent can self-correct in feedback loop
- [ ] Blocker 2: Enterprise audit export is complete and trustworthy
- [ ] Blocker 3: Incident root cause identified in <10 minutes
- [ ] 5+ design partners using and validating
- [ ] First enterprise deal closes

### Phase 2 (Hephaestus)

- [ ] Can scale to 50+ agents without incident
- [ ] Dashboard accelerates enterprise security reviews
- [ ] 20+ customers
- [ ] Expanded CI/CD coverage (GitLab, Jenkins)
- [ ] Net new enterprise logos from improved UX

### Phase 3 (Prometheus)

- [ ] 50+ customers
- [ ] Multi-org SAAS-ready
- [ ] Predictive incident prevention demonstrated
- [ ] Integration marketplace live

---

## Key Decision: Agent Feedback in v1.0

**Decision:** Agent-readable PR feedback is **Phase 1**, not Phase 2.

**Rationale:**
- Without feedback, agents cannot self-correct
- With feedback, Blocker 1 is demonstrably solved in a 3-minute demo
- This is the difference between "80% complete solution" and "100% complete solution"
- Sales impact is immediate and measurable

---

## Competitive Timing

The window to own agent governance is **Q2–Q3 2026**. By Q4:

- GitHub Copilot may have governance features
- Devin may integrate baseline checks
- Enterprise tooling vendors will build this

**Being first with a complete solution (v1.0 Datum) is critical.**

---

## Related Documents

- **[MVP Definition v3.0](mvp-definition.md)** — What Phase 1 includes
- **[Strategic Positioning v3.0](strategic-positioning.md)** — Why these features solve blockers
- **[Product Requirements](prds.md)** — Detailed specs for Phase 1

---

## Previous Version

**[View v2.0 Roadmap](../archive/v2-coverage-governance/product/roadmap.md)**

The v2 roadmap was designed around progressive coverage governance features. v3.0 roadmap is organized around blocker removal and competitive timing.

---

*Roadmap v3.0 | March 2026*
