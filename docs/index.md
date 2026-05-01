# Nolapse

**Version:** 1.2 (Gold Standard) | **Status:** Board / Enterprise Ready | **Date:** March 2026

---

## Welcome to Nolapse Documentation

This comprehensive documentation site covers all aspects of Nolapse — from business strategy to technical implementation and operations.

---

## How to Read This Docs Site

This site is written for two audiences simultaneously. The same documents serve both, but each audience has a different starting point and a different question they are trying to answer.

**If you are an enterprise buyer evaluating Nolapse:**

Start with the [Baseline Concept Pitch](product/baseline_concept_pitch.md) to understand the core idea in 60 seconds. Then read [Persona Value Props](product/persona_value_props.md) to see how Nolapse delivers value to your specific role. Follow with [Onboarding & Time-to-Value](product/onboarding.md) to understand what deployment looks like, and [Monetization Model](product/monetization_model.md) for pricing. The [Competitive Landscape](marketing/competitive_landscape.md) answers "how does this relate to tools I already use?"

**If you are a potential acquirer evaluating strategic fit:**

Start with the [Strategic Decisions Log](product/strategic_decisions.md) — it documents the acquisition-first build rationale directly. Then read the [Go-to-Market Strategy](marketing/gtm_pps.md) Section 12, the [Competitive Landscape](marketing/competitive_landscape.md) Acquisition Rationale section, and the [Roadmap](product/roadmap.md) acquisition timeline alignment table. The [Data Room Index](product/data_room_index.md) documents what due diligence materials are available and their current status.

---

### Quick Navigation

#### Business & Product

Understand the business case, market positioning, and product requirements.

- [Strategic Decisions](product/strategic_decisions.md) - Acquisition strategy and key product decisions
- [Software Requirements Spec](product/srs.md) - Complete SRS v1.2
- [Go-to-Market Strategy](marketing/gtm_pps.md) - Market positioning and competitive landscape
- [Competitive Landscape](marketing/competitive_landscape.md) - Competitive analysis and ecosystem partners
- [Product Requirements](product/prds.md) - Complete PRD specification
- [MVP Definition](product/mvp_definition.md) - Phase 1 minimum viable product
- [Coverage Model](marketing/coverage_model_summary.md) - How we measure and track coverage
- [Baseline Concept Pitch](product/baseline_concept_pitch.md) - The 60-second explanation and pitch formats
- [Persona Value Props](product/persona_value_props.md) - Value proposition for each buyer persona
- [Onboarding & Time-to-Value](product/onboarding.md) - From zero to first enforced PR in one day
- [Monetization Model](product/monetization_model.md) - Pricing tiers, ARR model, acquirer packaging
- [Roadmap](product/roadmap.md) - Phase timelines, success metrics, and acquisition alignment
- [Design Partner Outreach](product/design_partner_outreach.md) - ICP, outreach sequence, and engagement model
- [Case Study Template](product/case_study_template.md) - Interview guide and published case study format
- [Compliance Audit Package](product/compliance_audit_package.md) - SOC 2, ISO 27001, and FedRAMP control mapping and export guide
- [Data Room Index](product/data_room_index.md) - Acquisition due diligence materials and status

#### Architecture & Design

Deep dive into system design, architecture decisions, and technical foundations.

- [System Architecture](product/architecture.md) - Overall system design and components
- [Architecture Decision Records](technical/architecture_decision_records.md) - Key design decisions and rationale
- [Repository Model](technical/hybrid_repository_model_using_git_submodules.md) - Git repository organization strategy
- [API Design](technical/api_contracts_and_versioning_strategy.md) - API contracts and versioning approach

#### Security & Compliance

Security threat modeling, trust boundaries, and compliance frameworks.

- [Threat Modeling (C4 & STRIDE)](security/c4-stride.md) - Security analysis and threat identification
- [Trust Boundaries](security/trust_boundary_diagram.md) - System security boundaries and isolation

#### Technical Implementation

Technology stack, runner implementation, and CI/CD integration details.

- [Technology Stack](technical/tech_stack.md) - Languages, frameworks, and libraries
- [Runner Blueprint](technical/runner_implementation_blueprint.md) - Coverage runner implementation guide
- [CI/CD Integrations](technical/ci_integrations.md) - Integration with GitHub, GitLab, Azure DevOps

#### Operations

Deployment, scaling, cost models, and execution lifecycle.

- [Deployment Variants](technical/deployment_variants.md) - Different deployment options and configurations
- [Cost Model](technical/cost_model_per_dv.md) - Economics and pricing for each deployment variant
- [Execution Lifecycle](technical/execution_lifecycle_and_state_machine.md) - Coverage job lifecycle and state management
- [Scheduling Algorithm](technical/orchestrator_scheduling_algorithm.md) - Orchestration and scheduling logic

---

## What is Nolapse?

Nolapse is a platform that makes **test coverage a governed, versioned, and enforceable enterprise artifact**.

### The Problem

Large organizations operate hundreds or thousands of repositories with:

- Inconsistent coverage practices across teams
- No single source of truth for coverage baselines
- Manual audits and ad-hoc reporting
- Coverage gains lost over time with tooling changes

### The Solution

Nolapse provides:

- **Git-native** - Coverage baselines versioned with code
- **CI/CD-first** - Enforcement within existing pipelines
- **Policy-driven** - Enterprise-wide coverage policies
- **Audit-ready** - Compliance and audit reporting built-in
- **Cloud-agnostic** - Deploy anywhere: on-prem, cloud, hybrid

---

## Key Features

| Feature | Benefit |
| --- | --- |
| **Repository Discovery** | Automatically find and onboard repositories |
| **Language Detection** | Support 10+ languages and frameworks |
| **Coverage Execution** | Run tests and collect coverage metrics |
| **Baseline Management** | Version and track coverage over time |
| **CI/CD Enforcement** | Block PRs that violate coverage policies |
| **Policy Engine** | Define and enforce enterprise coverage rules |
| **Audit Reporting** | Generate compliance and audit reports |

---

## For Your Role

**👨‍💼 Engineering Managers**  
→ Start with [Business & Product](marketing/gtm_pps.md) to understand strategy and vision

**👨‍💻 Developers**  
→ Review [CI/CD Integrations](technical/ci_integrations.md) to see how Nolapse impacts your workflow

**🏗️ Architects**  
→ Deep-dive into [Architecture & Design](product/architecture.md) for system design details

**🔒 Security & Compliance**  
→ Review [Security & Compliance](security/c4-stride.md) for threat models and trust boundaries

**🚀 DevOps / Platform Engineers**  
→ Focus on [Operations](technical/deployment_variants.md) and [Technical Implementation](technical/tech_stack.md)

---

## Document Status

This documentation is maintained as a **living document** and reflects the current state of Nolapse development. Changes are tracked and versioned with the codebase.

**Last Updated:** March 2026
**Maintained by:** Vipul Meehnia
