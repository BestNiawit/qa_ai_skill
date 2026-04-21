# QA AI Skills

รวม Claude Code skills สำหรับทีม QA — ใช้ AI ช่วยลด effort ทุกขั้นตอนของ Testing Phase ตาม Ayodia SDP §5

**ครอบคลุม 12 AI-Assisted processes** ใน SDP §5.3.1 (Plan / Test Case / Review / Report / Perf) + skills เสริม (Bug Report, Matrix, E2E/Robot Automation)

> 🆕 **QA มาใหม่? เริ่มที่ [docs/qa-onboarding.md](docs/qa-onboarding.md)** — Quick Start 5 นาที + Decision Tree + End-to-End walkthrough
>
> 📊 **อยากเห็น Input/Process/Output ทุก skill + ไม่เปลือง AI?** → [docs/work-product-flow.md](docs/work-product-flow.md)

---

## Skills (10 ตัว)

### Testing Process Skills (ตาม SDP §5.3)

| # | Skill | SDP Process | Effort Saved |
|---|-------|-------------|:------------:|
| 1 | [test-plan-writer](skills/test-plan-writer/) | §5.3.1 P1/P5/P9 (SIT/UAT/Perf Plan) | ~40-50% |
| 2 | [test-case-writer](skills/test-case-writer/) | §5.3.1 P2/P6 (SIT/UAT TC) | ~50-60% |
| 3 | [test-case-reviewer](skills/test-case-reviewer/) | §5.3.1 P3/P7 (Peer Review) | ~40% |
| 4 | [test-report-writer](skills/test-report-writer/) | §5.3.1 P4/P8/P12 (SIT/UAT/Perf Report) | ~60-70% |
| 5 | [perf-test-generator](skills/perf-test-generator/) | §5.3.1 P10 (Perf Script) | ~50% |
| 6 | [perf-result-analyzer](skills/perf-result-analyzer/) | §5.3.1 P11 (Analyze Perf) | ~50% |

### Supporting Skills

| # | Skill | Use Case |
|---|-------|---------|
| 7 | [test-matrix-generator](skills/test-matrix-generator/) | Coverage / Pairwise / Platform matrix (quick coverage) |
| 8 | [bug-report-writer](skills/bug-report-writer/) | Jira/Linear/GitHub issue จาก defect ที่พบ |
| 9 | [robot-test-generator](skills/robot-test-generator/) | Robot Framework automation (athm_automation pattern) |
| 10 | [e2e-test-generator](skills/e2e-test-generator/) | Playwright/Cypress/WDIO/Selenium-Java automation |

---

## Testing Process → Skill Mapping

```
┌──── SDP §5 Testing Phase ────────────────────────────────────────┐
│                                                                   │
│  Plan → TC Design → Review → Execute → Report                    │
│   ↓         ↓          ↓         ↓         ↓                     │
│  #1        #2,#7      #3      (manual)    #4                     │
│                                  ↓                                │
│                           bug? → #8 (bug-report-writer)           │
│                           automate? → #9 / #10                    │
│                                                                   │
│  Performance: #1(perf) → #5 → Execute → #6 → #4(perf)            │
└───────────────────────────────────────────────────────────────────┘
```

ดูรายละเอียด: [references/sdp-mapping.md](references/sdp-mapping.md)

---

## Workflow แนะนำ (End-to-End)

### SIT Chain
```
SRS/PRD → test-plan-writer          → SIT Plan + Exit Criteria
         → test-matrix-generator     → Coverage matrix (optional, quick)
         → test-case-writer          → Full SIT Test Cases (23 cols)
              ↓
         test-case-reviewer          → Peer Review Report
              ↓
         robot/e2e-test-generator    → Automation scripts (TC.Automation=Yes)
              ↓
         [Execute SIT]
              ↓
         bug-report-writer           → Defects to Jira
         test-report-writer          → SIT Report (vs Exit Criteria)
```

### UAT Chain
```
SIT TC approved → test-case-writer (mode=uat)    → UAT TC (business view)
                → test-case-reviewer              → Peer Review
                → test-plan-writer (mode=uat)     → UAT Plan
                → [Execute by User]
                → test-report-writer (mode=uat)   → UAT Report + Sign-off
```

### Performance Chain
```
NFR + API Spec → test-plan-writer (mode=perf)   → Perf Test Plan
              → perf-test-generator              → k6 scripts
              → [Run Load/Stress/Soak/Spike]
              → perf-result-analyzer             → Bottleneck Analysis
              → test-report-writer (mode=perf)   → Perf Report
```

---

## Universal SKILL.md Structure (8 Sections)

ทุก skill ใช้ structure เดียวกัน — อ่านง่าย สลับใช้งานได้คล่อง:

1. **Purpose** — เป้าหมาย + Effort savings
2. **When to Use** — SDP mapping + เทียบกับ skills ที่เกี่ยวข้อง
3. **Inputs** — สิ่งที่ต้องเตรียม (+ `project-context.md`)
4. **Outputs** — format, templates, file naming
5. **Process** — ขั้นตอน step-by-step
6. **Quality Gate** — checklist ก่อนส่ง (derived จาก SDP §5.1)
7. **AI Guardrails** — ข้อควรระวัง (universal + skill-specific)
8. **Chain** — เชื่อมกับ skills อื่น (upstream/downstream)

ดูรายละเอียด + guidelines สำหรับ contributor: [SKILL-TEMPLATE.md](SKILL-TEMPLATE.md)

---

## มาตรฐานกลาง — `qa-standards.md`

> **New** — [references/qa-standards.md](references/qa-standards.md) กำหนด Severity / Priority / Sizing / Buffer / Velocity / KPI ที่ **บังคับใช้ทุก skill** เพื่อให้ข้อมูลไหลจาก TC → Plan → Report ได้ไม่ต้องแปลง scale

```
test-case-writer          test-plan-writer            test-report-writer
────────────────          ────────────────            ──────────────────
TC (Priority P0-P3,  →    Σ Sizing × Buffer Policy →  Estimate vs Actual
 Severity S1-S4,           = Schedule (Effort +        (feedback refine sizing)
 Sizing S/M/L/XL)            Calendar days)            AI Effort Savings KPI
                                                       (เป้าทีม ≥ 50%)
```

**บังคับ:**
- Severity 4 ระดับ (S1-S4) — ห้าม Blocker/Trivial
- Priority 4 ระดับ (P0-P3) — ห้าม High/Med/Low
- Schedule Formula ใน Test Plan = Σ Sizing + Buffer 20%
- Test Report ต้องมี Estimate vs Actual + AI Savings section

---

## การใช้ข้าม Project (Universal)

Skill แต่ละตัว **ไม่ hardcode** company-specific config — user ควรสร้าง `project-context.md` ใน working directory เพื่อ override:

```markdown
# project-context.md

## Environment
- SIT URL: https://sit.example.com
- UAT URL: https://uat.example.com
- DB: Oracle 19c — SIT_DB_v2.1

## NFR (สำหรับ Perf skills)
- p(95) ≤ 3s
- Throughput ≥ 100 TPS
- Error Rate ≤ 1%

## Glossary
- "AT" = Assessment Tax
- "PMS" = Property Management System

## Severity Scale
- S1 Critical, S2 Major, S3 Minor, S4 Cosmetic

## Business Rules
- Leave balance = 10 days/year, reset 1 Jan
```

Skill จะอ่านไฟล์นี้ก่อน apply ใน output — ย้าย project โดยไม่ต้องแก้ skill

---

## วิธี Install

### แบบที่ 1: User-level (ใช้กับทุก project)
```bash
# Symlink ทั้ง 10 skills
for skill in test-plan-writer test-case-writer test-case-reviewer test-report-writer \
             perf-test-generator perf-result-analyzer test-matrix-generator \
             bug-report-writer robot-test-generator e2e-test-generator; do
  ln -s "$(pwd)/skills/$skill" ~/.claude/skills/$skill
done
```

### แบบที่ 2: Project-level
```bash
mkdir -p /path/to/project/.claude/skills
cp -r skills/* /path/to/project/.claude/skills/
```

### ตรวจสอบ
เปิด Claude Code พิมพ์ `/help` หรือลองสั่ง เช่น "ช่วยเขียน SIT Plan จาก docs/srs.md"

---

## วิธีใช้ — ตัวอย่างคำสั่ง

### 1. test-plan-writer
```
เขียน SIT Plan จาก docs/srs-leave.md — scope: Leave Management, ภาษาไทย
```
```
draft UAT Plan จาก SIT Plan เดิม (sit_plan_leave_20260420.md) — business view
```
```
สร้าง Performance Test Plan สำหรับ 500 VUs, NFR p95 ≤ 3s, error ≤ 1%
```

### 2. test-case-writer
```
เขียน SIT test case จาก docs/srs-login.md ภาษาไทย CSV
เน้น negative case + boundary
```
```
convert SIT TC ในไฟล์ testcases_sit_login_20260420.md เป็น UAT TC (business view)
```

### 3. test-case-reviewer
```
review SIT test case ในไฟล์ testcases_sit_login_20260420.md
เทียบกับ SRS ที่ docs/srs-login.md — หา gap + ปัญหา
```

### 4. test-report-writer
```
สรุป SIT Report จาก Jira export ใน sit_execution.csv
เทียบ Exit Criteria ใน sit_plan_leave_20260420.md
```
```
เขียน UAT Report — User Sign-off: คุณสมศรี (2026-04-30, Approved)
```
```
สร้าง Perf Report จาก perf_analysis_leave_20260430.md
```

### 5. perf-test-generator
```
เขียน k6 load test สำหรับ /api/v1/orders
- endpoints: GET /orders, POST /orders
- SLO: p(95)<400ms, error <1%
- 200 req/s (RPS mode)
```

### 6. perf-result-analyzer
```
วิเคราะห์ผล k6 ในไฟล์ reports/results-load-20260430.json
NFR: p95 ≤ 3s, TPS ≥ 100, error ≤ 1%
หา bottleneck + แนะนำ tuning
```

### 7. test-matrix-generator
```
ทำ coverage matrix จาก docs/login-requirement.md
เช็ค scenario coverage
```

### 8. bug-report-writer
```
เขียน bug report:
- [Checkout] ยอดรวมผิดเมื่อใส่ coupon ซ้อน 2 ใบ
- Chrome 130 บน macOS, staging
- Severity: Major
```

### 9. robot-test-generator
```
สร้าง Robot test จาก testcases_sit_login_20260420.md
feature: login, prefix: AUTH, TC_IDs: AUTH_SC_001_TC_001..003
```

### 10. e2e-test-generator
```
สร้าง Playwright test จาก testcases_sit_login_20260420.md
feature: login, prefix: AUTH
```

---

## โครงสร้าง Repo

```
qa_ai_skill/
├── README.md                          ← คุณอยู่ตรงนี้
├── SKILL-TEMPLATE.md                  ← template สำหรับสร้าง skill ใหม่
├── docs/
│   ├── qa-onboarding.md               ← เริ่มต้นสำหรับ QA ใหม่
│   └── work-product-flow.md           ← NEW — IPO diagrams + token economy
├── references/                         ← Shared (linked by all skills)
│   ├── ai-guardrails.md                ← จาก SDP §5.3.3
│   ├── qa-standards.md                 ← Severity/Priority/Sizing/Buffer/KPI
│   └── sdp-mapping.md                  ← process → skill mapping
└── skills/
    ├── test-plan-writer/               ← NEW — SIT/UAT/Perf Plan
    ├── test-case-writer/               ← SIT + UAT mode
    ├── test-case-reviewer/             ← NEW — Peer Review
    ├── test-report-writer/             ← NEW — SIT/UAT/Perf Report
    ├── perf-test-generator/            ← k6
    ├── perf-result-analyzer/           ← NEW — Bottleneck Analysis
    ├── test-matrix-generator/          ← Coverage/Pairwise/Platform
    ├── bug-report-writer/              ← Jira/Linear/GitHub
    ├── robot-test-generator/           ← Robot Framework
    └── e2e-test-generator/             ← Playwright/Cypress/WDIO/Selenium
```

---

## AI Guardrails (Universal)

ทุก skill ยึด **5 หลักการ** จาก SDP §5.3.3 — อ่าน [references/ai-guardrails.md](references/ai-guardrails.md)

1. **AI = Draft & Assist, QC = Review & Approve**
2. **Cross-check กับ source เสมอ** — Traceability Matrix
3. **ห้าม commit Sensitive data** — `[REDACTED]` / env var
4. **Expected Result / Criteria ต้องวัดได้** — ไม่มี "ทำงานถูกต้อง"
5. **ไม่ make up number** — ถ้าไม่มีข้อมูลจริง ต้องถาม / ใช้ "TBD"

---

## Contribute เพิ่ม Skill

1. อ่าน [SKILL-TEMPLATE.md](SKILL-TEMPLATE.md) — universal 8-section structure
2. สร้าง `skills/<skill-name>/SKILL.md` ตาม template
3. เพิ่ม templates/references ที่จำเป็น
4. Update [references/sdp-mapping.md](references/sdp-mapping.md) (เพิ่มแถวในตาราง ถ้า map กับ SDP)
5. Update README.md skill table
6. เปิด PR

---

## References

- [Ayodia Software Development Process (SDP)](https://github.com/ayodia-organizational-process-assets.wiki/Guidelines/Process-Architecture/Software-Development-Process.md) — ต้นฉบับ process
- [IEEE 829](https://standards.ieee.org/ieee/829/3787/) — Test Documentation Standard
- [ISTQB Foundation Level Syllabus](https://www.istqb.org/) — Testing principles
- [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/) — AI security
