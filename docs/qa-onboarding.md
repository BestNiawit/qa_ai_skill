# QA Onboarding — เริ่มใช้ qa_ai_skill ยังไง

> **สำหรับ:** QA / Tester ที่เข้าทีมใหม่ หรือคนที่ยังไม่เคยใช้ Claude Code skills ชุดนี้
> **ใช้เวลาอ่าน:** 10 นาที + 30 นาที ทดลอง

---

## ✅ Day 1 Checklist — อ่านตามนี้ (~30 นาที)

- [ ] **1. [README.md](../README.md)** — 3 นาที
  รู้ว่า repo นี้คืออะไร, มี 10 skills อะไรบ้าง, install ยังไง

- [ ] **2. [docs/qa-onboarding.md](qa-onboarding.md)** (ไฟล์นี้) — 10 นาที
  คู่มือหลัก — Quick Start + Decision Tree + End-to-End walkthrough

- [ ] **3. [references/qa-standards.md](../references/qa-standards.md)** — 5 นาที
  มาตรฐานทีม: Severity S1-S4 / Priority P0-P3 / Sizing S/M/L/XL / Buffer 20% / AI KPI 50%
  **ห้ามใช้ scale อื่น** (ห้าม Blocker/Trivial, ห้าม High/Med/Low)

- [ ] **4. [docs/work-product-flow.md](work-product-flow.md)** — 10 นาที (skim)
  IPO ของทุก skill: Input แบบไหน → AI ทำอะไร → ได้ work product อะไร + Token economy

**ถ้ามีเวลาแค่ 15 นาที:** อ่านแค่ไฟล์นี้ (qa-onboarding) — มี link ไปที่อื่นครบทุกจุดที่ต้องไป

---

## 🏃 Day 1 — ทำอะไรต่อหลังอ่านเสร็จ

1. **Install skills** → ทำตาม [Quick Start §Step 1](#step-1--install-skills) ด้านล่าง
2. **เตรียม `project-context.md`** ของโปรเจคที่ทำอยู่ → [Step 2](#step-2--เตรียม-project-context)
3. **ลองโมดูลเล็ก** (5-10 req) ตาม [End-to-End Walkthrough](#-end-to-end-walkthrough--login-module-ตัวอย่างจริง) — 7 prompts, 1 สัปดาห์
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
ทั้งทีมใช้ scale เดียวกัน: **S1-S4 / P0-P3 / Sizing S/M/L/XL** — ห้ามใช้คำอื่น

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
   SRS / PRD        Test Case ที่มี       Test Execute เสร็จ
   (requirement)    อยู่แล้ว               (Jira/Excel)
        ↓                 ↓                 ↓
   ──────────────    ──────────────    ──────────────
   เริ่ม SIT          Review / Convert    สรุป Report
   ──────────────    ──────────────    ──────────────


┌─────────────────────────────────────────────────────────────────┐
│ Q2 (A): เริ่ม SIT จาก SRS — รีบมั้ย?                            │
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

## 🚶 End-to-End Walkthrough — Login Module (ตัวอย่างจริง)

> สมมติคุณได้ `docs/srs-login.md` (10 requirement) พรุ่งนี้ต้องเริ่ม SIT
> Total: 1 สัปดาห์ = 7 prompts พอ

### Day 1 — Plan + TC Design

**Prompt 1:** Draft Plan ก่อน (placeholder schedule)
```
เขียน SIT Plan จาก docs/srs-login.md
- scope: Login Module (FR_LOG_01..10)
- ภาษาไทย
- 1 tester
```
→ ได้ `sit_plan_login_20260421.md` (Schedule = TBD เพราะยังไม่มี TC)

**Prompt 2:** เขียน Test Case
```
เขียน SIT test case จาก docs/srs-login.md ภาษาไทย CSV
module ID: LOG, prefix TC_LOG
เน้น Positive + Negative + Boundary + Edge cases
```
→ ได้ `testcases_sit_LOG_20260421.md` พร้อม **Sizing Summary Block** ท้ายไฟล์

### Day 2 — Plan Final + Peer Review

**Prompt 3:** Re-run Plan ให้อ่าน Sizing Summary
```
update sit_plan_login_20260421.md
ให้คำนวณ Schedule จาก testcases_sit_LOG_20260421.md
(อ่าน Sizing Summary Block แล้วใช้ Buffer Policy ใน qa-standards.md §4)
```
→ ได้ Effort Breakdown + Calendar days จริง

**Prompt 4:** Peer Review
```
review test case ใน testcases_sit_LOG_20260421.md
เทียบกับ docs/srs-login.md — หา coverage gap + quality issue
```
→ ได้ `peer_review_LOG_20260421.md` — fix Must Fix issues ก่อนไป execute

### Day 3-5 — Execute

- Tester รัน TC ตามไฟล์ กรอก Actual Result / Test Result / Tested By / Date ใน template
- เจอ bug → **Prompt 5:**
```
เขียน bug report:
- [Login] กดปุ่มเข้าระบบแล้วหน้าค้าง เมื่อ password มี whitespace นำหน้า
- Chrome 130, macOS 14, SIT env
- Severity: S2 Major
- Priority: P1
- Steps: ...
```
→ ได้ `bug_login_whitespace_20260423.md` → copy paste ลง Jira

### Day 5-6 — Automate (optional)

**Prompt 6:** Automate TC ที่ `Automation=Yes`
```
สร้าง Playwright test จาก testcases_sit_LOG_20260421.md
feature: login, prefix: AUTH
เอาเฉพาะ TC ที่ Automation=Yes
```
→ ได้ `.spec.ts` files

### Day 7 — Report

**Prompt 7:** สรุป Report
```
สรุป SIT Report จาก testcases_sit_LOG_20260421.md (กรอก actual แล้ว)
+ bug list ใน ./bugs/
เทียบ Exit Criteria ใน sit_plan_login_20260421.md
บันทึก AI effort savings:
- Plan: draft 30min + review 3.5hr
- TC: draft 1hr + review 11hr
- Report (this): draft 15min + review 1.25hr
```
→ ได้ `sit_report_login_20260428.md` — มี **Estimate vs Actual** + **AI Savings KPI** ครบ → ส่ง TL/PM

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
1. bug-report-writer (ใช้ Severity S1-S4, Priority P0-P3 ตาม qa-standards)
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

- ❌ ใช้ Severity "Blocker/Trivial" หรือ Priority "High/Med/Low" — **ต้องใช้ S1-S4 / P0-P3 เท่านั้น**
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
| เห็น Input/Process/Output ทุก skill + ไม่เปลือง AI | [docs/work-product-flow.md](work-product-flow.md) |
| เข้าใจ standard ของทีม | [references/qa-standards.md](../references/qa-standards.md) |
| เข้าใจ skill ↔ process mapping | [references/sdp-mapping.md](../references/sdp-mapping.md) |
| AI usage guardrails | [references/ai-guardrails.md](../references/ai-guardrails.md) |
| รายละเอียด skill ใดๆ | `skills/<skill-name>/SKILL.md` |
| Repo overview + install | [README.md](../README.md) |
| Contribute skill ใหม่ | [SKILL-TEMPLATE.md](../SKILL-TEMPLATE.md) |

---

## 🆘 ถ้าติดปัญหา

1. **Skill ไม่โหลด:** check `~/.claude/skills/<skill-name>/SKILL.md` exist มั้ย
2. **AI สร้างผิด:** อ่าน section "AI Guardrails" ใน SKILL.md ของ skill นั้น + check cross-reference
3. **ไม่รู้ใช้ skill ไหน:** ดู Decision Tree ด้านบน หรือ [references/sdp-mapping.md](../references/sdp-mapping.md) ตาราง "12 AI-Assisted Processes"
4. **Scale/Standard ไม่ตรง:** qa-standards.md คือ source of truth — skill/template ใดๆ ที่ไม่ตรงถือเป็น bug → report
