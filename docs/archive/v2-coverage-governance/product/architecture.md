# Nolapse – Overall Architecture (C4 Model)

This section defines the **overall system architecture of Nolapse using the C4 model**, progressing from high-level context to deployable components. These diagrams are intended for architects, senior engineers, and review boards.

---

## C4 – Level 1: System Context Diagram

### Purpose

Shows Nolapse as a system in its environment and how external actors interact with it.

```mermaid
C4Context
  title Nolapse – System Context

  Person(dev, "Developer", "Writes code and opens pull requests")
  Person(platform, "Platform Team", "Operates Nolapse")
  Person(auditor, "Security / Audit", "Reviews coverage compliance")

  System(nolapse, "Nolapse Platform", "Enterprise test coverage governance system")

  System_Ext(git, "Git Providers", "GitHub, GitLab, Bitbucket, Azure DevOps")
  System_Ext(ci, "CI/CD Systems", "GitHub Actions, Jenkins, GitLab CI, Argo")
  System_Ext(idp, "Identity Provider", "SSO / OIDC / SAML")

  Rel(dev, git, "Pushes code / opens PRs")
  Rel(git, ci, "Triggers pipelines")
  Rel(ci, nolapse, "Invokes coverage checks")
  Rel(nolapse, git, "Reads & writes baselines")
  Rel(platform, nolapse, "Configures & operates")
  Rel(auditor, nolapse, "Exports audit reports")
  Rel(nolapse, idp, "Authenticates users")
```

---

## C4 – Level 2: Container Diagram

### Purpose

Breaks Nolapse into major deployable/runtime containers.

```mermaid
C4Container
  title Nolapse – Container Diagram

  Person(dev, "Developer")
  Person(platform, "Platform Team")

  System_Ext(ci, "CI/CD")
  System_Ext(git, "Git Provider")

  Container_Boundary(nolapse, "Nolapse Platform") {
    Container(api, "Nolapse API", "Go / Python", "Auth, orchestration, policy evaluation")
    Container(orchestrator, "Orchestrator", "Go / Python", "Bulk & scheduled execution")
    Container(policy, "Policy Engine", "Embedded", "Evaluates coverage deltas")
    Container(runner, "Runner", "Docker / K8s Job", "Executes coverage")
    Container(db, "Metadata Store", "Postgres / Cloud DB", "Execution metadata")
  }

  Rel(dev, git, "Push / PR")
  Rel(ci, api, "Invoke Nolapse")
  Rel(api, orchestrator, "Schedule jobs")
  Rel(orchestrator, runner, "Dispatch work")
  Rel(runner, git, "Read/write baselines")
  Rel(api, db, "Store metadata")
```

---

## C4 – Level 3: Component Diagram (Nolapse API)

### Purpose

Explains internal structure of the most critical container.

```mermaid
C4Component
  title Nolapse API – Component Diagram

  Container_Boundary(api, "Nolapse API") {
    Component(auth, "Auth Module", "OIDC / Token", "Authenticates users & CI")
    Component(adapter, "Git & CI Adapters", "REST", "Integrates external systems")
    Component(policy, "Policy Evaluator", "Rules Engine", "Evaluates thresholds")
    Component(job, "Job Controller", "Scheduler", "Manages executions")
    Component(report, "Report Generator", "Markdown", "Creates baseline reports")
  }

  Rel(auth, adapter, "Secures calls")
  Rel(job, policy, "Requests evaluation")
  Rel(job, report, "Generates output")
```

---

## C4 – Level 4: Deployment Diagram (Kubernetes)

### Purpose

Shows how Nolapse is deployed in a production cloud environment.

```mermaid
C4Deployment
  title Nolapse – Kubernetes Deployment

  Deployment_Node(cluster, "Kubernetes Cluster") {
    Deployment_Node(ns, "Namespace: nolapse") {
      Container(api, "Nolapse API Pod")
      Container(orchestrator, "Orchestrator CronJob")
      Deployment_Node(runners, "Runner Jobs") {
        Container(runner, "Ephemeral Runner Pod")
      }
    }
  }

  Deployment_Node(ext, "External Systems") {
    System_Ext(ci, "CI/CD")
    System_Ext(git, "Git Provider")
    System_Ext(idp, "Identity Provider")
  }

  Rel(ci, api, "Invoke")
  Rel(api, git, "Git API")
  Rel(api, idp, "Auth")
```

---

## Architecture Notes

* Nolapse follows **control-plane vs execution-plane separation**
* Runners are fully ephemeral and stateless
* Git is the system of record for baselines
* Metadata DB is optional for OSS, mandatory for Enterprise

---

**End of C4 Architecture**
