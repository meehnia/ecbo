# Case Study Template

**Status:** Active — Phase 1
**Last Updated:** March 2026

---

## Purpose

This document has two parts:

1. **Interview Guide** — questions to ask the design partner spokesperson to gather raw material
2. **Published Case Study Template** — the formatted output ready for sales, website, and data room use

A case study is a Phase 1 go/no-go criterion. At least one must be published before Phase 2 begins. It must be named (no anonymized logos), include measurable outcomes, and contain at least one pull quote usable in sales materials.

---

## Minimum Viable Case Study

A case study is publishable when it has all of the following:

- Named company and named spokesperson (title + first name minimum)
- One specific problem they had before Nolapse (not generic — specific)
- One measurable outcome (time, repos, coverage delta, audit prep reduction)
- One pull quote approved by the spokesperson for public use
- Company permission to use their logo in sales materials

If any of these are missing, it is a testimonial, not a case study. Testimonials are valuable but do not satisfy the Phase 1 go/no-go criterion.

---

## Part 1 — Interview Guide

The case study interview takes 30–45 minutes. Conduct it at the end of the 90-day design partner engagement, after the Platform Team has used Nolapse in production.

### Before the Interview

Send the spokesperson these three questions 24 hours in advance so they can think:

1. What was the specific coverage enforcement problem you were trying to solve when you started with Nolapse?
2. What has changed — what can you do now that you could not do before?
3. Is there a number that captures the improvement? (Time saved, repos governed, audit prep reduction, developer dispute rate)

### During the Interview

**Opening — Understand the before state (10 minutes)**

- Walk me through what coverage enforcement looked like before Nolapse. Who owned it? How was it enforced? What broke?
- How many repositories were you managing coverage across? Were they consistent?
- Did you have any audit or compliance requirements around coverage? How were you handling them?
- What was the worst version of this problem? Can you give me a specific example?

**Decision — Why Nolapse (5 minutes)**

- What made you want to try Nolapse specifically?
- What other options did you consider? Why didn't those work?
- What was the thing that made you say "this could actually work" early in the evaluation?

**Implementation — The onboarding experience (5 minutes)**

- How long did it take to get the first baseline generated for your pilot repo?
- What was the hardest part of the rollout? What surprised you?
- How did developers react when they first saw Nolapse fail a PR? What happened?

**Results — The after state (10 minutes)**

- How many repositories are now governed by Nolapse?
- Has anyone disputed a coverage failure signal since deployment? What happened?
- If you had a SOC 2 auditor ask for coverage evidence today, how long would it take to generate?
- What has the Platform Team been able to stop doing because Nolapse handles it?
- If you had to put a number on the time savings — per month, per audit cycle, per incident — what would it be?

**Closing — Quote and permissions (5 minutes)**

- Is there a sentence that captures how you'd describe Nolapse to a peer who asked about it?
- Are you comfortable being named in a case study? Can we use your company logo?
- Would you be willing to take a call from a prospective customer who asks for a reference?

---

## Part 2 — Published Case Study Template

**Format:** 400–600 words. One page when formatted for print or PDF. Suitable for a website case study page, a sales deck slide, or a data room attachment.

---

### [COMPANY NAME] — [ONE-LINE OUTCOME HEADLINE]

*Example headline: "Acme Corp governs 300+ repositories with a single Nolapse deployment — audit prep dropped from 3 days to under an hour."*

---

**Company**

[Company name], [brief description: industry, size, engineering team scale]. [Optional: one sentence on what they build or who they serve.]

---

**The Challenge**

[2–3 sentences describing the specific problem. Use the before state from the interview. Name the pain precisely — not "coverage enforcement was hard" but "the Platform Team was managing 47 different coverage threshold configurations across 200 repos, each set by a different engineer 2–3 years ago."]

> The specific failure mode: [1 sentence on what actually broke or what risk they were carrying — developer disputes, audit exposure, release pressure causing threshold reductions, etc.]

---

**Why Nolapse**

[1–2 sentences on why they chose Nolapse over alternatives or over building it themselves. What was the deciding factor?]

---

**Implementation**

[2–3 sentences on the onboarding experience. How long did the pilot take? Did they hit the 30-minute baseline target? What surprised them?]

Key implementation facts:

- Time to first baseline: [X minutes]
- Pilot repos before org-wide rollout: [X]
- Total rollout time (pilot to all repos): [X days / weeks]

---

**Results**

[2–3 sentences on the measurable outcome. Lead with the number.]

| Metric | Before Nolapse | After Nolapse |
| --- | --- | --- |
| Repositories governed | [X] bespoke configs | [X] under one Nolapse deployment |
| Developer signal dispute rate | [X%] or unknown | [< 10% / specific number] |
| Audit prep time for coverage evidence | [X days] | [X hours / minutes] |
| Platform Team time on coverage tickets | [X hours/month] | [X hours/month] |

*[Include only rows with real data. Do not include rows with estimated or unknown values.]*

---

**In Their Words**

> "[Pull quote from spokesperson — 1–3 sentences. Should be specific and honest. Avoid marketing language. A quote that says "Nolapse solved a real problem we were tired of working around" is more credible than "Nolapse is a game-changing platform."]"
>
> — [First name, Title], [Company name]

---

**What's Next**

[1–2 sentences on their plans. Expanding to more repos? Adding the compliance audit package? Using Nolapse as part of their SOC 2 evidence package? This signals product stickiness and expansion revenue potential.]

---

*[Company logo] | Nolapse Design Partner | [Month Year]*

---

## Ecosystem Tagging

Before publishing, tag each case study with the ecosystem signals it satisfies. This determines which acquirer conversations it supports.

| Signal | Satisfied? | Notes |
| --- | --- | --- |
| GitHub-native customer | Yes / No | Primary CI: GitHub Actions |
| GitLab-native customer | Yes / No | Primary CI: GitLab CI |
| Codecov co-use | Yes / No | Codecov running alongside Nolapse |
| SonarQube co-use | Yes / No | SonarQube running in the same org |
| Regulated-industry SOC 2 use case | Yes / No | Active SOC 2 program documented |

Each published case study should satisfy at least one ecosystem signal. The first three case studies should collectively satisfy all four ecosystem signals — this is the Phase 2 go/no-go criterion.

---

See the [Design Partner Outreach](design_partner_outreach.md) doc for the engagement model that produces case study candidates, and the [Roadmap](roadmap.md) for where case studies appear in Phase 1 and Phase 2 go/no-go criteria.
