# QA Onboarding — เริ่มใช้ qa_ai_skill ยังไง

> **สำหรับ:** QA / Tester ที่เข้าทีมใหม่ หรือคนที่ยังไม่เคยใช้ Claude Code skills ชุดนี้
> **ใช้เวลาอ่าน:** 10 นาที + 30 นาที ทดลอง

---

## ✅ Day 1 Checklist — อ่านตามนี้ (~30 นาที)

- [ ] **1. [README.md](../README.md)** — 3 นาที
  รู้ว่า repo นี้คืออะไร, มี 11 skills อะไรบ้าง, install ยังไง

- [ ] **2. [docs/qa-onboarding.md](qa-onboarding.md)** (ไฟล์นี้) — 10 นาที
  คู่มือหลัก — Quick Start + Decision Tree + End-to-End walkthrough

- [ ] **3. [references/qa-standards.md](../references/qa-standards.md)** — 5 นาที
  มาตรฐานทีม: Severity Critical/Major/Minor/Trivial + Priority Critical/High/Medium/Low + Sizing S/M/L/XL + Buffer 20% + AI KPI 50%
  **อ้างอิง Ayodia TEST DEFINITION template เป็น source of truth**

- [ ] **4. [docs/work-product-flow.md](work-product-flow.md)** — 10 นาที (skim)
  IPO ของทุก skill: Input แบบไหน → AI ทำอะไร → ได้ work product อะไร + Token economy

**ถ้ามีเวลาแค่ 15 นาที:** อ่านแค่ไฟล์นี้ (qa-onboarding) — มี link ไปที่อื่นครบทุกจุดที่ต้องไป

---

## 🏃 Day 1 — ทำอะไรต่อหลังอ่านเสร็จ

1. **Install skills** → ทำตาม [Quick Start §Step 1](#step-1--install-skills) ด้านล่าง
2. **เตรียม `project-context.md`** ของโปรเจคที่ทำอยู่ → [Step 2](#step-2--เตรียม-project-context)
3. **ลองโมดูลเล็ก** (5-10 req) ตาม [End-to-End Timeline](#-end-to-end-timeline--1-week-sit-ภาพรวม) — 7 prompts, 1 สัปดาห์
4. **มีปัญหา?** → ดู [Common Scenarios](#-common-scenarios--ฉันเจอแบบนี้-ทำยังไง) (6 เคส)

---

## 🎯 Quick Start (5 นาที)

### Step 1 — Install skills
```bash
cd ~/Documents/GitHub/qa_ai_skill
for skill in skills/*/; do
  ln -sfn "$(pwd)/$skill" ~/.claude/skills/$(basename $skill)
done
```
เปิด Claude Code → `/help` ดูว่ามี skills โหลดขึ้นมามั้ย

### Step 2 — เตรียม project context
สร้าง `project-context.md` ใน working directory ของโปรเจคคุณ:
```markdown
## Environment
- SIT URL: https://sit.myproject.com
- DB: Oracle 19c (SIT_DB_v2.1)

## NFR (ถ้าเป็น Perf)
- p(95) ≤ 3s, Throughput ≥ 100 TPS, Error ≤ 1%

## Glossary
- "AT" = Assessment Tax (ใช้ย่อใน SRS)

## Team velocity (ถ้าต่างจาก default)
- 5 hr/tester/day (มี meeting เยอะ)
```

### Step 3 — อ่าน [qa-standards.md](../references/qa-standards.md) 3 นาที
ทั้งทีมใช้ scale เดียวกัน: **Severity Critical/Major/Minor/Trivial + Priority Critical/High/Medium/Low + Sizing S/M/L/XL** (Ayodia TEST DEFINITION template)

### Step 4 — เริ่มลุย!
ดู [Decision Tree ด้านล่าง](#-decision-tree-ฉันอยู่ตรงนี้--ทำอะไรต่อ) — หาว่า "ฉันอยู่ตรงนี้" ใช้ skill ไหน

---

## 🌲 Decision Tree — "ฉันอยู่ตรงนี้ → ทำอะไรต่อ"

```
┌─────────────────────────────────────────────────────────────────┐
│ Q1: คุณได้รับอะไรมา?                                            │
└─────────────────────────────────────────────────────────────────┘
                          ↓
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
   BRD/PRD/SRS      Test Case ที่มี       Test Execute เสร็จ
   (requirement)    อยู่แล้ว               (Jira/Excel)
        ↓                 ↓                 ↓
   ──────────────    ──────────────    ──────────────
   Pre-check +       Review / Convert    สรุป Report
   เริ่ม SIT
   ──────────────    ──────────────    ──────────────


┌─────────────────────────────────────────────────────────────────┐
│ Q2 (A0): BRD/PRD ชัดไหม? (requirement readiness check)          │
└─────────────────────────────────────────────────────────────────┘
                          ↓
          ┌───────────────┴───────────────┐
          ↓                               ↓
   ไม่แน่ใจ / PM เขียนสั้น /          ชัดมากแล้ว (มี FR ID +
   ขาด AC / ไม่ระบุ out-of-scope      AC วัดได้ + out-of-scope
                                      + data dictionary)
          ↓                               ↓
   1. requirement-analyzer          ข้ามไป Q2 (A) ได้เลย
      → Readiness Score + Normalized Req
      → PM Confirmation Doc
          ↓
   2. ส่งให้ PM/BA review 2-3 วัน
      (confirm Open Questions + Assumptions)
          ↓
   3. Update Normalized Req ตาม feedback
          ↓
   4. ไปต่อ Q2 (A) ด้วย Normalized Req
      (แทนที่ BRD ดิบ)


┌─────────────────────────────────────────────────────────────────┐
│ Q2 (A): เริ่ม SIT จาก SRS / Normalized Req — รีบมั้ย?           │
└─────────────────────────────────────────────────────────────────┘
                          ↓
          ┌───────────────┴───────────────┐
          ↓                               ↓
      ไม่รีบ                          รีบมาก! ต้อง coverage ก่อน
   (เวลาปกติ)                         (พรุ่งนี้ต้องส่ง)
          ↓                               ↓
   1. test-plan-writer              1. test-matrix-generator
      (SIT Plan placeholder)           (Coverage matrix เร็วๆ)
          ↓                               ↓
   2. test-case-writer               2. ทำ execute ตาม matrix
      (full SIT TC 23 cols)             (mark pass/fail)
          ↓                               ↓
   3. test-plan-writer (re-run)      3. ค่อยกลับมาขยายเป็น full TC
      (Schedule จาก Sizing Summary)     ตอนมีเวลา
          ↓
   4. test-case-reviewer
      (Peer review + gap check)
          ↓
   5. [TL/PM sign-off]
          ↓
   6. robot/e2e-test-generator
      (automate TC ที่ Automation=Yes)


┌─────────────────────────────────────────────────────────────────┐
│ Q2 (B): มี Test Case แล้ว ต้องทำอะไร?                          │
└─────────────────────────────────────────────────────────────────┘
                          ↓
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
   ตรวจ quality       แปลงเป็น UAT       Execute เลย
        ↓                 ↓                 ↓
   test-case-         test-case-writer   Run manual หรือ
   reviewer           (mode=uat)         robot/e2e script
                                               ↓
                                         เจอ bug?
                                        ↙        ↘
                                      ใช่         ไม่
                                       ↓          ↓
                                 bug-report-    test-report-
                                 writer         writer


┌─────────────────────────────────────────────────────────────────┐
│ Q2 (C): Execute เสร็จแล้ว — ต้องเขียน Report                    │
└─────────────────────────────────────────────────────────────────┘
                          ↓
          ┌───────────────┼───────────────┐
          ↓               ↓               ↓
      SIT             UAT             Performance
          ↓               ↓               ↓
   test-report-      test-report-    1. perf-result-analyzer
   writer            writer             (หา bottleneck ก่อน)
   (mode=sit)        (mode=uat)      2. test-report-writer
                      + User            (mode=perf)
                      Sign-off
          ↓               ↓               ↓
   [TL/PM approve] [User Sign-off]  [TL/Architect approve]
          ↓
   Go → UAT Phase
   No-Go → Dev fix → Re-test
```

---

## 🚶 End-to-End Timeline — 1 Week SIT (ภาพรวม)

> สมมติคุณได้ `docs/srs-login.md` (10 requirement) พรุ่งนี้ต้องเริ่ม SIT
> Total: 1 สัปดาห์ ≈ 7 prompts

| วัน | กิจกรรม | Skill | Prompt |
|-----|---------|-------|--------|
| Day 1 AM | Plan v1 (placeholder) | test-plan-writer | → [how-to-sit-uat Step 1](how-to-sit-uat.md#step-1--sit-plan-v1-placeholder-schedule) |
| Day 1 PM | Test Case | test-case-writer | → [Step 3](how-to-sit-uat.md#step-3--sit-test-case) |
| Day 2 AM | Plan v2 (Schedule จริง) | test-plan-writer | → [Step 5](how-to-sit-uat.md#step-5--sit-plan-v2-schedule-จริงจาก-sizing) |
| Day 2 PM | Peer Review | test-case-reviewer | → [Step 4](how-to-sit-uat.md#step-4--peer-review) |
| Day 3-5 | Execute + Bug report | bug-report-writer | ⬇ ตัวอย่างด้านล่าง |
| Day 5-6 | Automate (optional) | robot/e2e-test-generator | ⬇ ตัวอย่างด้านล่าง |
| Day 7 | Report | test-report-writer | → [Step 6](how-to-sit-uat.md#step-6--sit-report-หลัง-execute-เสร็จ) |

> 📖 **Prompt เต็ม + UAT chain ต่อ (Step 7-10)** → [docs/how-to-sit-uat.md](how-to-sit-uat.md)

### ตัวอย่าง Prompt เฉพาะ Onboarding

**เจอ bug ระหว่าง execute:**
```
เขียน bug report:
- [Login] กดปุ่มเข้าระบบแล้วหน้าค้าง เมื่อ password มี whitespace นำหน้า
- Chrome 130, macOS 14, SIT env
- Severity: Major, Priority: High
- Steps: ...
```
→ ได้ `bug_login_whitespace_20260423.md` → copy paste ลง Jira

**Automate TC ที่ `Automation=Yes`:**
```
สร้าง Playwright test จาก testcases_sit_LOG_20260421.md
feature: login, prefix: AUTH
เอาเฉพาะ TC ที่ Automation=Yes
```
→ ได้ `.spec.ts` files

---

## 👥 Role-Based Shortcut

### ถ้าคุณเป็น **QC Lead**
- Daily: [test-plan-writer](../skills/test-plan-writer/) → [test-report-writer](../skills/test-report-writer/) → [test-case-reviewer](../skills/test-case-reviewer/)
- Weekly: review sprint-tracking.csv + update qa-standards velocity ถ้า actual ต่างจาก plan เยอะ
- Monthly: รวบ AI Effort Savings KPI ต่อโปรเจค report ให้ management

### ถ้าคุณเป็น **Tester (Mid-level)**
- Main: [test-case-writer](../skills/test-case-writer/) → execute → [bug-report-writer](../skills/bug-report-writer/)
- Occasional: [test-matrix-generator](../skills/test-matrix-generator/) (เมื่อรีบ) / [robot-test-generator](../skills/robot-test-generator/) / [e2e-test-generator](../skills/e2e-test-generator/) (ถ้าโปรเจคมี automation)

### ถ้าคุณเป็น **BA ช่วย UAT**
- [test-case-writer](../skills/test-case-writer/) `mode=uat` — แปลง SIT TC → business language
- [test-report-writer](../skills/test-report-writer/) `mode=uat` — เก็บ User Sign-off

### ถ้าคุณเป็น **Perf Tester / TL**
- [test-plan-writer](../skills/test-plan-writer/) `mode=perf` → [perf-test-generator](../skills/perf-test-generator/) → k6 run → [perf-result-analyzer](../skills/perf-result-analyzer/) → [test-report-writer](../skills/test-report-writer/) `mode=perf`

---

## 🎬 Common Scenarios — "ฉันเจอแบบนี้ ทำยังไง"

### Scenario 1 — รีบมาก ไม่ทันเขียน Full TC
```
ใช้ test-matrix-generator สร้าง Coverage Matrix (CSV, 10-15 นาที)
→ execute ตาม matrix รอบแรกได้ coverage ก่อน
→ ค่อยกลับมาขยายเป็น Full TC ด้วย test-case-writer ตอนมีเวลา
```

### Scenario 2 — SIT ผ่านแล้ว เตรียม UAT
```
1. test-case-writer mode=uat format=tc (feed SIT TC file) → UAT TC (business view, 23 col)
   ── หรือ ──
   test-case-writer mode=uat format=checklist → UAT Checklist (multi-role workflow)
       ใช้เมื่อเป็น approval flow ข้าม role (เบิกสวัสดิการ, ลางาน, ขออนุมัติ)
2. test-case-reviewer mode=uat (check ว่าไม่ได้ copy SIT มาตรงๆ)
3. test-plan-writer mode=uat (feed SIT Plan + UAT TC/Checklist) → UAT Plan
4. [Confirm User Tester + Sign-off UAT TC]
5. [User execute] → test-report-writer mode=uat
```

> 📖 **อยากได้ prompt แบบ copy-paste ทุกขั้น (SIT→UAT 10 steps)?** → [docs/how-to-sit-uat.md](how-to-sit-uat.md)

### Scenario 3 — Perf Test ครั้งแรกในโปรเจค
```
1. รวบ NFR จาก Contract / Architect (p95, TPS, error rate)
2. test-plan-writer mode=perf → Workload Model + per-endpoint threshold
3. perf-test-generator → k6 script
4. Smoke test ก่อน (1 VU × 30s) — ตรวจว่า script ถูก
5. Load / Stress / Soak ตาม Plan
6. perf-result-analyzer → หา bottleneck
7. test-report-writer mode=perf → Perf Report + Tuning Recommendation
```

### Scenario 4 — เจอ bug ระหว่าง execute
```
1. bug-report-writer (ใช้ Severity Critical/Major/Minor/Trivial + Priority Critical/High/Medium/Low ตาม qa-standards)
2. paste ลง Jira
3. เมื่อ dev fix แล้ว → re-test TC นั้น
4. ถ้าผ่าน → update Test Result = Pass + กรอก Defect ID
```

### Scenario 5 — ต้องหยุด SIT กลางคัน (env down, dev slip)
```
1. Check Suspension Criteria ใน Plan (§13) — ผ่านเงื่อนไข suspend มั้ย?
2. ถ้าใช่ → suspend + record ใน sprint-tracking.csv Remark column
3. รอ Resume Criteria → กลับมารันต่อ
4. Report ต้องมี section "Suspension period" ระบุวันที่ + เหตุผล
```

### Scenario 6 — AI Savings ต่ำกว่าเป้า (< 50%)
```
1. เปิด Test Report → section "AI Effort Savings"
2. หา artifact ที่ savings < 50% (e.g., Peer Review)
3. ถามตัวเอง:
   - AI generate ครั้งแรกได้ใช้ได้จริงกี่ %?
   - ต้อง customize เยอะ → อัปเดต project-context.md (glossary, business rules)
   - Prompt ดี / แย่ → อัปเดต template
4. Sprint หน้าลองใหม่ เทียบตัวเลข
```

---

## 🚨 อย่าทำ!

- ❌ ใช้ legacy scale (S1-S4, P0-P3, Cosmetic) — **ต้องใช้ Critical/Major/Minor/Trivial + Critical/High/Medium/Low ตาม Ayodia TEST DEFINITION template**
- ❌ เขียน Test Plan Schedule เป็น `<days>` โดยไม่มี Effort Breakdown
- ❌ สรุป Test Report โดยไม่มี "Estimate vs Actual" + "AI Effort Savings" sections
- ❌ Copy SIT TC เป็น UAT โดยไม่ปรับเป็น business language
- ❌ Commit `[REDACTED]`, password จริง, PII ใน TC/Bug report
- ❌ Run skill โดยไม่อ่าน SRS/PRD ทั้งไฟล์ก่อน
- ❌ แก้ AI output โดยไม่ cross-check กับ source data (traceability)

---

## 📚 อ่านต่อ

| ถ้าคุณต้องการ... | ไปที่ |
|------------------|-------|
| ดูคำย่อ (SRS/FR/NFR/TC/SIT/UAT/BVA/...) | [§ Glossary](#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd) |
| เห็น Input/Process/Output ทุก skill + ไม่เปลือง AI | [docs/work-product-flow.md](work-product-flow.md) |
| เข้าใจ standard ของทีม | [references/qa-standards.md](../references/qa-standards.md) |
| เข้าใจ skill ↔ process mapping | [references/sdp-mapping.md](../references/sdp-mapping.md) |
| AI usage guardrails | [references/ai-guardrails.md](../references/ai-guardrails.md) |
| รายละเอียด skill ใดๆ | `skills/<skill-name>/SKILL.md` |
| Repo overview + install | [README.md](../README.md) |
| Contribute skill ใหม่ | [SKILL-TEMPLATE.md](../SKILL-TEMPLATE.md) |

---

## 📖 คำย่อ (Glossary) — เช็คก่อนอ่าน SKILL.md

> ย่อที่ใช้ทั้ง repo — **SKILL.md แต่ละไฟล์ expand ครั้งแรกแล้วใช้ย่อ** เพื่อไม่รก

### Requirement / Document
| ย่อ | คำเต็ม (EN) | ความหมาย |
|-----|------------|---------|
| **SRS** | Software Requirements Specification | เอกสารระบุ requirement ของระบบ (รวม FR + NFR) — input หลักของ test-plan/test-case |
| **PRD** | Product Requirements Document | เอกสาร requirement มุมธุรกิจ (what/why) |
| **BRD** | Business Requirements Document | เอกสาร requirement ฉบับธุรกิจ (ใครต้องการ/ทำไม/outcome) — มักเป็น input ก่อนแตกเป็น SRS/PRD |
| **AC** | Acceptance Criteria | เกณฑ์ยอมรับที่วัดได้ — ต้องมีใน BRD/SRS เพื่อให้ AI/QC เขียน expected result ได้ (ดู [brd-readiness-guide](../references/brd-readiness-guide.md)) |
| **US** | User Story | requirement รูปแบบ "As a ... I want ... so that ..." (INVEST criteria) |
| **FRS** | Functional Requirements Specification | technical breakdown ของ SRS |
| **FR** | Functional Requirement | requirement ด้าน function (feature ทำอะไรได้) — มักมี ID เช่น `FR_LOG_01` |
| **NFR** | Non-Functional Requirement | requirement ด้านคุณภาพ (performance, security, usability) |
| **SLA** | Service Level Agreement | ข้อตกลงระดับบริการ (เช่น fix Severity Critical ≤ 1 วัน) |
| **SDP** | Software Development Process | เอกสาร process มาตรฐานของทีม |

### Testing Type
| ย่อ | คำเต็ม (EN) | ความหมาย |
|-----|------------|---------|
| **TC** | Test Case | 1 เคสทดสอบ (มีทุก column ตาม 23-col template) |
| **SIT** | System Integration Testing | ทดสอบ integration ระหว่าง module โดย QC (technical view) |
| **UAT** | User Acceptance Testing | ทดสอบโดย User/BA ก่อนรับระบบ (business view) |
| **Perf** | Performance Testing | ทดสอบด้าน performance (Load / Stress / Soak / Spike) |
| **E2E** | End-to-End Testing | ทดสอบ flow ครบ cycle ข้าม module/role |
| **Smoke** | Smoke Testing | ทดสอบว่า build ใช้งานได้เบื้องต้น ก่อนเริ่ม SIT รอบเต็ม |
| **Regression** | Regression Testing | ทดสอบว่า feature เดิมยังใช้ได้หลัง fix |

### Testing Technique
| ย่อ | คำเต็ม (EN) | ความหมาย |
|-----|------------|---------|
| **BVA** | Boundary Value Analysis | ทดสอบค่าขอบเขต (min-1, min, max, max+1) |
| **ECP** | Equivalence Class Partitioning | แบ่งกลุ่ม input ที่น่าจะให้ผลลัพธ์เดียวกัน |
| **DT** | Decision Table | ตารางเงื่อนไขหลายตัวผสมกัน |
| **ST** | State Transition | ทดสอบการเปลี่ยน state ของ object |

### Role
| ย่อ | คำเต็ม (EN) | บทบาท |
|-----|------------|-------|
| **QC** | Quality Control | Tester / คนรัน SIT |
| **QA** | Quality Assurance | ทีม/กระบวนการประกันคุณภาพ (ครอบคลุมกว่า QC) |
| **BA** | Business Analyst | คน analyze business requirement + ช่วย UAT |
| **TL** | Team Leader / Tech Lead | หัวหน้าทีม — review + unblock |
| **PM** | Project Manager | อนุมัติ deferral + sign-off |

### Metric / Scale (ดู qa-standards.md ครบ)
| ย่อ | คำเต็ม (EN) | ความหมาย |
|-----|------------|---------|
| **Severity** | ความรุนแรงของปัญหา | Critical / Major / Minor / Trivial (Ayodia TEST DEFINITION template) |
| **Priority** | ความเร่งด่วนของการทดสอบ | Critical / High / Medium / Low (Ayodia TEST DEFINITION template) |
| **Action Label** | ผลลัพธ์ Severity × Priority Matrix | Blocker / Urgent / Standard High / Manageable / ... (qa-standards §2.1) |
| **S / M / L / XL** | Sizing — Small/Medium/Large/Extra-Large | TC execution time (<15min / 15-30min / 30-60min / >60min) |
| **KPI** | Key Performance Indicator | ตัววัดผล (เช่น AI Savings ≥ 50%) |
| **TPS / RPS** | Transactions / Requests Per Second | throughput (Perf) |
| **VU** | Virtual User | จำนวน user จำลองใน load test (k6) |
| **p95 / p99** | 95th / 99th percentile | response time ที่ 95%/99% ของ request ต่ำกว่าค่านี้ |

### Tool / Output
| ย่อ | คำเต็ม (EN) | ความหมาย |
|-----|------------|---------|
| **IPO** | Input-Process-Output | วิธี document ทุก skill (ดู work-product-flow.md) |
| **PII** | Personally Identifiable Information | ข้อมูลระบุตัวตน (ห้าม commit จริงลง repo) |
| **MD / CSV** | Markdown / Comma-Separated Values | format output ของ skill |

---

## 🆘 ถ้าติดปัญหา

1. **Skill ไม่โหลด:** check `~/.claude/skills/<skill-name>/SKILL.md` exist มั้ย
2. **AI สร้างผิด:** อ่าน section "AI Guardrails" ใน SKILL.md ของ skill นั้น + check cross-reference
3. **ไม่รู้ใช้ skill ไหน:** ดู Decision Tree ด้านบน หรือ [references/sdp-mapping.md](../references/sdp-mapping.md) ตาราง "12 AI-Assisted Processes"
4. **Scale/Standard ไม่ตรง:** qa-standards.md คือ source of truth — skill/template ใดๆ ที่ไม่ตรงถือเป็น bug → report
