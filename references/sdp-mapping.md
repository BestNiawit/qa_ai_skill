# SDP Mapping — Skill ↔ Software Development Process

> Map ระหว่าง skills ใน repo นี้ กับ Ayodia Software Development Process (SDP) §5 Testing
> ช่วยทีม QA เห็นภาพว่าแต่ละ skill ช่วยในขั้นตอนไหนของ process, effort ที่ลดได้
> **See also:** [`qa-standards.md`](qa-standards.md) — Severity/Priority/Sizing/Buffer/KPI standards (บังคับใช้ทุก skill)

---

## Process Flow + AI Coverage

```
[Project Planning] → [Requirement] → [Design] → [Programming]
                                                      │
                                                      ▼
                              ┌─────────── 5. TESTING ───────────┐
                              │                                   │
                              │  SIT      UAT      Performance    │
                              │   │        │           │          │
                              └───┼────────┼───────────┼──────────┘
                                  ▼        ▼           ▼
                              [AI-Assisted 12 จุด — ดูตารางล่าง]
                                  │
                                  ▼
                         [Deployment] → [Maintenance]
```

---

## 12 AI-Assisted Processes (SDP §5.3.1)

| # | SDP Process | Responsible | Skill ใน repo นี้ | Effort ลด |
|---|------------|-------------|-------------------|:---------:|
| 1 | เขียน SIT Plan | QC | [test-plan-writer](../skills/test-plan-writer/) | ~50% |
| 2 | เขียน SIT Test Case | QC | [test-case-writer](../skills/test-case-writer/) | ~60% |
| 3 | Peer Review SIT TC | QC/TL/BA | [test-case-reviewer](../skills/test-case-reviewer/) | ~40% |
| 4 | เขียน SIT Report | QC | [test-report-writer](../skills/test-report-writer/) | ~70% |
| 5 | เขียน UAT Plan | QC/BA | [test-plan-writer](../skills/test-plan-writer/) (mode=uat) | ~50% |
| 6 | เขียน UAT Test Case | QC/BA | [test-case-writer](../skills/test-case-writer/) (mode=uat) | ~50% |
| 7 | Peer Review UAT TC | QC/BA/TL | [test-case-reviewer](../skills/test-case-reviewer/) | ~40% |
| 8 | เขียน UAT Report | QC/BA | [test-report-writer](../skills/test-report-writer/) (mode=uat) | ~60% |
| 9 | เขียน Perf Test Plan | QC/TL | [test-plan-writer](../skills/test-plan-writer/) (mode=perf) | ~40% |
| 10 | เตรียม Perf Script | QC/Dev | [perf-test-generator](../skills/perf-test-generator/) | ~50% |
| 11 | วิเคราะห์ผล Perf | Dev/TL | [perf-result-analyzer](../skills/perf-result-analyzer/) | ~50% |
| 12 | เขียน Perf Report | QC/TL | [test-report-writer](../skills/test-report-writer/) (mode=perf) + [perf-result-analyzer](../skills/perf-result-analyzer/) | ~60% |

---

## Skills เสริม (นอกตาราง SDP แต่เสริม Testing phase)

| Skill | ใช้เมื่อ | เชื่อมกับ SDP |
|-------|---------|-------------|
| [test-matrix-generator](../skills/test-matrix-generator/) | เขียน TC ไม่ทัน, ต้องการ coverage เร็ว | ก่อน SIT Test Case (ขั้น 2) |
| [bug-report-writer](../skills/bug-report-writer/) | เจอ defect ระหว่าง SIT/UAT | ระหว่าง "ทดสอบ SIT/UAT" → Jira Card |
| [robot-test-generator](../skills/robot-test-generator/) | Automation Robot Framework | ขยาย "ทดสอบ SIT" → automate |
| [e2e-test-generator](../skills/e2e-test-generator/) | Automation Playwright/Cypress/WDIO/Selenium | ขยาย "ทดสอบ SIT" → automate |

---

## Chain — ลำดับการใช้ Skills

### SIT Chain
```
SRS/PRD
  ├→ test-plan-writer           → SIT Plan
  ├→ test-matrix-generator       → Coverage/Pairwise/Platform matrix (optional, quick)
  └→ test-case-writer            → SIT Test Cases (full)
        └→ test-case-reviewer     → Peer Review report
        └→ robot/e2e-test-generator → Automation script (TC.Automation=Yes)
              └→ [Execute SIT]
                    └→ bug-report-writer → Defects
                    └→ test-report-writer → SIT Report
```

### UAT Chain
```
SIT Test Cases (approved)
  ├→ test-case-writer (mode=uat)   → UAT Test Cases (business language)
  │       └→ test-case-reviewer     → Peer Review
  ├→ test-plan-writer (mode=uat)    → UAT Plan
  └→ [Execute UAT by User]
        └→ bug-report-writer  → Defects
        └→ test-report-writer (mode=uat) → UAT Report + User Sign-off
```

### Performance Chain
```
NFR + API Spec
  ├→ test-plan-writer (mode=perf)    → Perf Test Plan (workload model)
  ├→ perf-test-generator              → k6 scripts + config
  └→ [Run Load/Stress/Soak/Spike]
        └→ perf-result-analyzer       → Bottleneck + NFR evaluation
              └→ test-report-writer (mode=perf) → Perf Report
```

---

## Quality Gate Reference (SDP §5.1)

Skill ทุกตัวมี **Quality Gate checklist** ใน section "Quality Gate" ของ SKILL.md ซึ่ง derived จาก SDP §5.1 — ไม่ต้อง open ไฟล์ SDP เวลาทำงาน

| Work Product | Quality Gate อยู่ที่ |
|-------------|----------------------|
| SIT Plan / UAT Plan / Perf Test Plan | `test-plan-writer/SKILL.md` §6 |
| SIT Test Case / UAT Test Case | `test-case-writer/SKILL.md` §6 |
| Peer Review Record | `test-case-reviewer/SKILL.md` §6 |
| SIT Report / UAT Report / Perf Report | `test-report-writer/SKILL.md` §6 |
| Perf Analysis | `perf-result-analyzer/SKILL.md` §6 |

---

## Data Flow — Priority/Severity/Sizing Pipeline

> 3 skill เชื่อมกันผ่าน `qa-standards.md` (บังคับใช้ scale เดียวทุก artifact)

```
test-case-writer              test-plan-writer                test-report-writer
──────────────                ────────────────                ──────────────────
TC Table (23 col)        →    Read "Sizing Summary"      →    Compare Est vs Actual
 ├ Priority P0-P3                 Σ sizing × Buffer Policy       (qa-standards §4)
 ├ Severity S1-S4                 = Schedule (hrs + days)
 └ Test Sizing S/M/L/XL           (qa-standards §4)         →    AI Effort Savings KPI
                                                                 (qa-standards §6)
Sizing Summary Block     →    Schedule Effort Breakdown
(auto-generated at         →    sprint-tracking.csv         →    Feedback: refine
 bottom of TC file)              (Est Hours per task)            sizing scale if
                                                                 variance > 30%

bug-report-writer
─────────────────
Severity S1-S4             ←→  Defect Management (Plan)   →    Defect Summary by S1-S4
Priority P0-P3                  SLA by severity                 (Report)
(qa-standards §1-§2)
```

---

## References
- [`qa-standards.md`](qa-standards.md) — มาตรฐานกลาง (Severity/Priority/Sizing/Buffer/KPI)
- [`ai-guardrails.md`](ai-guardrails.md) — AI usage guardrails
- Ayodia SDP §5 Testing (`ayodia-organizational-process-assets.wiki/Guidelines/Process-Architecture/Software-Development-Process.md`)
- IEEE 829 — Test Documentation Standard
- ISTQB Foundation Level Syllabus
