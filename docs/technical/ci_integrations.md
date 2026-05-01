# Nolapse – CI Integration Templates

## GitHub Actions, GitLab CI, Jenkins

This document provides **production-ready CI integration templates** for Nolapse. These templates are intentionally **thin wrappers** around the Nolapse CLI, following the earlier architectural decision:

> **CLI core + CI-specific wrappers**

This ensures:

* Consistent behavior across CI systems
* Minimal maintenance
* Fast onboarding for developers

---

## 1. Common Integration Principles

All CI integrations follow these rules:

1. CI systems **never talk directly to runners**
2. CI systems invoke the **Nolapse CLI only**
3. Authentication is short-lived and scoped
4. Failures map cleanly to CI pass/fail states

---

## 2. GitHub Actions Integration

### 2.1 Usage Model

* Distributed as a **composite GitHub Action**
* Wraps the `nolapse` CLI
* Zero configuration for basic usage

---

### 2.2 Example Workflow

```yaml
name: Nolapse Coverage Check

on:
  pull_request:

jobs:
  coverage:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run Nolapse
        uses: nolapse-dev/coverage-action@v1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          policy-mode: strict
```

---

### 2.3 Failure Mapping

| Nolapse Result    | GitHub Status     |
| -------------- | ----------------- |
| SUCCEEDED      | ✅ Pass            |
| POLICY FAILED  | ❌ Fail            |
| SYSTEM ERROR   | ❌ Fail            |
| QUOTA EXCEEDED | ❌ Fail (explicit) |

---

## 3. GitLab CI Integration

### 3.1 Usage Model

* Provided as a **Docker image + script**
* Runs as a standard GitLab job

---

### 3.2 Example `.gitlab-ci.yml`

```yaml
nolapse_coverage:
  image: nolapse/cli:latest
  stage: test

  script:
    - nolapse run \
        --repo-url "$CI_REPOSITORY_URL" \
        --ref "$CI_COMMIT_REF_NAME" \
        --policy strict

  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

---

### 3.3 Failure Mapping

| Exit Code | GitLab Result  |
| --------- | -------------- |
| 0         | Pass           |
| 20        | Fail (policy)  |
| 30        | Fail (timeout) |
| 40+       | Fail (system)  |

---

## 4. Jenkins Integration

### 4.1 Usage Model

* Jenkins shared library or shell step
* Uses Nolapse CLI directly

---

### 4.2 Example Jenkinsfile

```groovy
pipeline {
  agent any

  stages {
    stage('Nolapse Coverage') {
      steps {
        sh '''
          nolapse run \
            --repo-url ${GIT_URL} \
            --ref ${BRANCH_NAME} \
            --policy strict
        '''
      }
    }
  }
}
```

---

### 4.3 Jenkins Result Mapping

| Nolapse Outcome | Jenkins |
| ------------ | ------- |
| Success      | SUCCESS |
| Policy fail  | FAILURE |
| Infra/System | FAILURE |

---

## 5. Authentication Patterns

### 5.1 GitHub Actions

* Uses GitHub OIDC
* No stored secrets

---

### 5.2 GitLab CI

* Uses project access token
* Scoped to repo only

---

### 5.3 Jenkins

* Short-lived Nolapse token
* Stored in Jenkins credentials store

---

## 6. Output & Developer Feedback

All CI systems:

* Receive structured console output
* Link to Nolapse execution URL
* Show coverage delta summary

Example output:

```
Coverage: 82.3% → 84.1% (+1.8%)
Policy: PASSED
Execution ID: abc-123
```

---

## 7. Failure UX Principles

* Policy failures are explicit and actionable
* Infra failures include retry guidance
* Quota failures explain limits

No silent or ambiguous failures.

---

## 8. Versioning & Compatibility

* CI integrations versioned independently
* Compatible with Nolapse API versions via CLI

| Integration   | Versioning |
| ------------- | ---------- |
| GitHub Action | v1, v2     |
| GitLab Image  | semver     |
| Jenkins Lib   | semver     |

---

## 9. Security Guarantees

* CI never sees coverage internals
* No secrets in logs
* Tokens scoped per execution

---

## 10. CTO Summary

> **CI integrations should feel boring, predictable, and invisible.**

These templates:

* Maximize adoption
* Minimize maintenance
* Preserve architectural integrity

They are ready for **enterprise and SaaS usage**.

---

**End of CI Integration Templates**
