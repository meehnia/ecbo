# Nolapse – Threat Model (STRIDE) per C4 Container

This section provides a **formal threat model using the STRIDE methodology**, mapped explicitly to **C4 containers**. It is intended for security architecture reviews, compliance sign-off, and enterprise risk assessments.

---

## STRIDE Overview

| Category | Description            |
| -------- | ---------------------- |
| S        | Spoofing identity      |
| T        | Tampering with data    |
| R        | Repudiation            |
| I        | Information disclosure |
| D        | Denial of service      |
| E        | Elevation of privilege |

---

## Container 1: Nolapse API

### Description

Central control-plane entry point for CI/CD systems, users, and administrators.

### Threat Analysis

| STRIDE | Threat                   | Mitigation                                   |
| ------ | ------------------------ | -------------------------------------------- |
| S      | Forged CI identity       | OIDC, signed tokens, short-lived credentials |
| T      | API payload manipulation | Schema validation, TLS, request signing      |
| R      | Action denial            | Immutable audit logs, request IDs            |
| I      | Metadata leakage         | RBAC, response filtering                     |
| D      | API flooding             | Rate limiting, WAF                           |
| E      | Privilege escalation     | Fine-grained roles, policy checks            |

---

## Container 2: Orchestrator

### Description

Schedules and coordinates bulk and scheduled coverage execution.

### Threat Analysis

| STRIDE | Threat                   | Mitigation                 |
| ------ | ------------------------ | -------------------------- |
| S      | Fake job injection       | Authenticated job queue    |
| T      | Job definition tampering | Signed job specs           |
| R      | Execution denial         | Job execution logs         |
| I      | Repo metadata exposure   | Scoped access, encryption  |
| D      | Job starvation           | Quotas, concurrency limits |
| E      | Cross-tenant execution   | Tenant isolation           |

---

## Container 3: Runner (Ephemeral Execution Plane)

### Description

Executes coverage inside isolated Docker/Kubernetes jobs.

### Threat Analysis

| STRIDE | Threat                     | Mitigation                            |
| ------ | -------------------------- | ------------------------------------- |
| S      | Runner impersonation       | Mutual TLS, short-lived tokens        |
| T      | Code / result manipulation | Read-only mounts, checksum validation |
| R      | Execution disputes         | Immutable logs, artifact hashes       |
| I      | Source code leakage        | Ephemeral storage, no persistence     |
| D      | Resource exhaustion        | CPU/memory limits, timeouts           |
| E      | Container escape           | Seccomp, rootless containers          |

---

## Container 4: Policy Engine

### Description

Evaluates coverage deltas against configured policies.

### Threat Analysis

| STRIDE | Threat               | Mitigation                 |
| ------ | -------------------- | -------------------------- |
| S      | Policy spoofing      | Signed policy definitions  |
| T      | Policy modification  | Git-based versioning       |
| R      | Decision repudiation | Policy decision logs       |
| I      | Policy leakage       | Access control             |
| D      | Evaluation abuse     | Cached results             |
| E      | Policy bypass        | Mandatory evaluation hooks |

---

## Container 5: Git Provider Integration

### Description

Reads repositories and writes coverage baselines.

### Threat Analysis

| STRIDE | Threat                 | Mitigation                         |
| ------ | ---------------------- | ---------------------------------- |
| S      | Token theft            | Rotating tokens, scoped access     |
| T      | Baseline tampering     | Protected branches, signed commits |
| R      | Commit denial          | Service account identity           |
| I      | Repo data exposure     | Least-privilege scopes             |
| D      | API rate exhaustion    | Adaptive throttling                |
| E      | Privileged repo access | Repo-level ACLs                    |

---

## Container 6: Metadata Store (Enterprise)

### Description

Stores execution metadata and audit information.

### Threat Analysis

| STRIDE | Threat                 | Mitigation         |
| ------ | ---------------------- | ------------------ |
| S      | DB credential spoofing | IAM-based auth     |
| T      | Data corruption        | Checksums, backups |
| R      | Audit record deletion  | Append-only logs   |
| I      | Sensitive data leak    | Encryption at rest |
| D      | Query overload         | Read replicas      |
| E      | Privilege escalation   | DB role separation |

---

## Cross-Cutting Threats

| Area          | Threat                 | Mitigation                      |
| ------------- | ---------------------- | ------------------------------- |
| Supply Chain  | Malicious runner image | Signed images, trusted registry |
| Secrets       | Leakage in CI          | Masking, secret scanning        |
| Multi-Tenancy | Tenant data bleed      | Strong isolation                |

---

## Security Posture Summary

* Control-plane hardened via identity & RBAC
* Execution-plane isolated and ephemeral
* Git is immutable source of truth
* All decisions are auditable

---

**End of STRIDE Threat Model**
