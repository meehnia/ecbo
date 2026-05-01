# Nolapse – API Contracts

## REST & gRPC Definitions with Versioning Strategy

This document defines the **formal API contracts for Nolapse**, covering:

* External **REST APIs** (CI systems, CLI, UI)
* Internal **gRPC APIs** (control-plane ↔ orchestrator)
* A strict **versioning and compatibility strategy**

These contracts are **hard boundaries** and enable parallel development across teams.

---

## 1. API Design Principles

1. **Contracts first, implementation second**
2. **Backward compatibility by default**
3. **Versioning is explicit and boring**
4. **gRPC internally, REST externally**
5. **Idempotency everywhere**

---

## 2. API Surface Overview

| Consumer       | API Type | Purpose                |
| -------------- | -------- | ---------------------- |
| CI/CD systems  | REST     | Trigger executions     |
| CLI            | REST     | User-facing operations |
| UI / Dashboard | REST     | Read-only views        |
| Orchestrator   | gRPC     | Scheduling & execution |

---

## 3. REST API (External)

### 3.1 Base Conventions

* Base URL: `/api/v1`
* JSON only
* Auth: OIDC Bearer token
* Idempotency via `Idempotency-Key` header

---

### 3.2 Execution APIs

#### POST /api/v1/executions

Trigger a new coverage execution.

**Request**

```json
{
  "repoUrl": "https://git/org/repo",
  "ref": "refs/pull/123/head",
  "trigger": "ci",
  "policyMode": "strict"
}
```

**Response**

```json
{
  "executionId": "uuid",
  "status": "QUEUED"
}
```

---

#### GET /api/v1/executions/{id}

Fetch execution status.

**Response**

```json
{
  "executionId": "uuid",
  "state": "RUNNING",
  "startedAt": "2026-01-01T10:00:00Z",
  "cost": {
    "cpuSeconds": 120,
    "memorySeconds": 480
  }
}
```

---

### 3.3 Baseline APIs

#### GET /api/v1/baselines

List baselines for a repo.

#### POST /api/v1/baselines

Create or update baseline (admin only).

---

### 3.4 Audit & Reporting APIs

#### GET /api/v1/audit/export

Export audit data.

Query params:

* `from`
* `to`
* `format=csv|json`

---

### 3.5 Error Model (Standardized)

```json
{
  "error": {
    "code": "QUOTA_EXCEEDED",
    "message": "Monthly execution limit reached",
    "retryable": false
  }
}
```

---

## 4. gRPC API (Internal)

### 4.1 Why gRPC

* Strong typing
* Low latency
* Contract-driven development
* Safer refactoring

---

### 4.2 Orchestrator Service

```proto
syntax = "proto3";

package nolapse.orchestrator.v1;

service OrchestratorService {
  rpc EnqueueJob (EnqueueJobRequest) returns (EnqueueJobResponse);
  rpc GetJobStatus (GetJobStatusRequest) returns (GetJobStatusResponse);
}
```

---

### 4.3 Messages

```proto
message EnqueueJobRequest {
  string execution_id = 1;
  string repo_url = 2;
  string ref = 3;
  Policy policy = 4;
  ResourceLimits limits = 5;
}

message EnqueueJobResponse {
  string job_id = 1;
}

message ResourceLimits {
  int32 cpu_cores = 1;
  int32 memory_mb = 2;
}
```

---

## 5. REST ↔ gRPC Mapping

| REST Endpoint        | gRPC Call    |
| -------------------- | ------------ |
| POST /executions     | EnqueueJob   |
| GET /executions/{id} | GetJobStatus |

REST is a thin translation layer over gRPC.

---

## 6. Versioning Strategy

### 6.1 REST Versioning

* Version in URL (`/api/v1`)
* Breaking changes → new major version
* Minor changes are additive only

---

### 6.2 gRPC Versioning

* Versioned protobuf packages

```proto
package nolapse.orchestrator.v1;
package nolapse.orchestrator.v2;
```

No breaking changes inside a version.

---

### 6.3 Compatibility Rules

| Change Type      | Allowed? |
| ---------------- | -------- |
| Add field        | ✅        |
| Remove field     | ❌        |
| Rename field     | ❌        |
| Add enum value   | ✅        |
| Change semantics | ❌        |

---

## 7. Deprecation Policy

* Old versions supported for **12 months**
* Deprecation warnings via headers

Example:

```
X-Nolapse-Deprecated: true
X-Nolapse-Sunset: 2027-01-01
```

---

## 8. Contract Testing

* REST: OpenAPI contract tests
* gRPC: Protobuf compatibility checks
* CI blocks breaking changes

---

## 9. Security Considerations

* All APIs authenticated
* Authorization enforced at API layer
* Idempotency required for mutating calls

---

## 10. CTO Summary

> **API contracts are a product, not an implementation detail.**

This design:

* Enables parallel teams
* Prevents breaking changes
* Supports enterprise stability
* Scales cleanly to SaaS

---

**End of API Contracts Document**
