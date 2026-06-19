# How to Use — SIT → UAT Full Chain

> **สำหรับ:** QC/QA ที่ต้องรัน SIT แล้วต่อด้วย UAT — อยากรู้ว่า "พิมพ์อะไรให้ AI" ทุกขั้น
> **ใช้เวลาอ่าน:** 5 นาที — copy-paste prompt ได้เลย

ไฟล์นี้คือ **prompt cookbook** ของ SIT→UAT chain ตาม [README Workflow](../README.md#workflow-แนะนำ-end-to-end). ไม่ซ้ำกับ [qa-onboarding End-to-End Walkthrough](qa-onboarding.md#-end-to-end-walkthrough--login-module-ตัวอย่างจริง) (ที่เป็น SIT-only 7 prompts) — ไฟล์นี้ครอบคลุม **SIT + UAT** 10 steps

---

## 🧭 Pre-flight Checklist

ก่อนพิมพ์ prompt แรก เช็คว่า:

- [ ] Skills ติดตั้งแล้ว (ดู [qa-onboarding Quick Start](qa-onboarding.md#-quick-start-5-นาที))
- [ ] มี SRS/BRD/PRD ที่ `docs/` (เช่น `docs/srs-leave.md`)
- [ ] สร้าง `project-context.md` ที่ root (env, glossary, business rules) — ดู [README §การใช้ข้าม Project](../README.md#การใช้ข้าม-project-universal)
- [ ] เปิด Claude Code ใน working directory ของโปรเจกต์

> 💡 ตัวอย่างด้านล่างใช้ **Leave Management module** เป็นเคสสาธิต — เปลี่ยนชื่อไฟล์/module ตามโปรเจกต์จริง

---

## 🔵 SIT Chain — 6 Steps

### Step 0 — Requirement Readiness Gate (Pre-Testing)

เช็ค SRS พร้อมเขียน TC หรือยัง — ป้องกัน rework

```
วิเคราะห์ SRS ที่ docs/srs-leave.md ด้วย requirement-analyzer
module: LEAVE, project: <ชื่อโปรเจกต์>, ภาษาไทย
```

**ได้:** Readiness Score + Open Questions + PM Confirmation Doc

⏸ **Gate:** ถ้า Score < 70% → ส่ง PM/BA confirm ก่อน **ห้ามข้ามไปทำ TC**

---

### Step 1 — SIT Plan v1 (placeholder schedule)

```
เขียน SIT Plan จาก docs/srs-leave.md
scope: Leave Management (FR-LEAVE-001..015)
ภาษาไทย, qa: 1 คน
Exit Criteria เบื้องต้น: Pass Rate ≥ 95%, Severity Critical=0, Severity Major=0
```

**ได้:** `sit_plan_leave_20260422.md` (Schedule = TBD เพราะยังไม่มี TC Sizing)

---

### Step 2 — Coverage Matrix (optional — เมื่อรีบ)

```
ทำ coverage matrix จาก docs/srs-leave.md
เช็ค scenario coverage ก่อนขยายเป็น TC เต็ม
```

**ได้:** matrix ช่วยหา scenario ที่ขาด ก่อนเขียน TC จริง

---

### Step 3 — SIT Test Case

```
เขียน SIT test case จาก docs/srs-leave.md
ภาษาไทย format=markdown
module ID: LEAVE, prefix: TC_LEAVE
เน้น Positive + Negative + BVA + Error Guessing
Priority Critical/High/Medium/Low, Severity Critical/Major/Minor/Trivial, Sizing S/M/L/XL
```

**ได้:** `testcases_sit_LEAVE_20260422.md` + **Sizing Summary Block** ท้ายไฟล์

---

### Step 4 — Peer Review

```
review test case ใน testcases_sit_LEAVE_20260422.md
เทียบกับ docs/srs-leave.md — หา coverage gap + quality issue
```

**ได้:** `peer_review_LEAVE_20260422.md` → แก้ Must-Fix ก่อน execute

---

### Step 5 — SIT Plan v2 (Schedule จริงจาก Sizing)

```
update sit_plan_leave_20260422.md
ให้คำนวณ Schedule จาก testcases_sit_LEAVE_20260422.md
(อ่าน Sizing Summary Block แล้วใช้ Buffer Policy ใน qa-standards.md §4)
qa: 1 คน
```

**ได้:** Plan v2 มี Effort Breakdown + Buffer 20% + Calendar Days

➡ **ส่ง TL/PM sign-off → Execute SIT**

---

### Step 6 — SIT Report (หลัง execute เสร็จ)

ระหว่าง execute: เจอ bug → ใช้ [bug-report-writer](../skills/bug-report-writer/) → Jira

หลัง execute:

```
สรุป SIT Report จาก testcases_sit_LEAVE_20260422.md (กรอก actual แล้ว)
+ bug list ใน ./bugs/
เทียบ Exit Criteria ใน sit_plan_leave_20260422.md
ใส่ section Estimate vs Actual + AI Effort Savings
```

**ได้:** `sit_report_leave_20260428.md` — มี Estimate vs Actual + AI Savings KPI

✅ **SIT Done — เข้า UAT Chain**

---

## 🟢 UAT Chain — 4 Steps

### Step 7 — Convert SIT TC → UAT TC

**Option A — TC format (23 cols, business view):**
```
convert SIT TC ในไฟล์ testcases_sit_LEAVE_20260422.md เป็น UAT TC
mode=uat format=tc
ตัด technical term (API/SQL/HTTP status) → ใช้ภาษา business
```
**ได้:** `testcases_uat_LEAVE_20260429.md`

**Option B — UAT Checklist (multi-role workflow):**
```
เขียน UAT Checklist จาก docs/srs-leave.md
mode=uat format=checklist
roles: พนักงาน, หัวหน้า, HR, Payroll
```
ใช้เมื่อเป็น approval flow ข้าม role (เบิกสวัสดิการ, ลางาน, ขออนุมัติ)

---

### Step 8 — Review UAT TC

```
review UAT test case ในไฟล์ testcases_uat_LEAVE_20260429.md
mode=uat
เช็ค: ภาษา business + ไม่มี technical term + user role ครบ + ไม่ได้ copy SIT มาตรงๆ
```

---

### Step 9 — UAT Plan

```
draft UAT Plan จาก sit_plan_leave_20260422.md
mode=uat (business view)
Entry Criterion: SIT ผ่าน (Pass Rate ≥ 95%, Severity Critical=0)
User QA: <ชื่อ + role>
TC file: testcases_uat_LEAVE_20260429.md (ใช้คำนวณ Schedule จาก Sizing)
```

**ได้:** `uat_plan_leave_20260429.md`

➡ **User execute UAT**

---

### Step 10 — UAT Report + User Sign-off

```
เขียน UAT Report จาก testcases_uat_LEAVE_20260429.md (กรอก actual แล้ว)
เทียบ Exit Criteria ใน uat_plan_leave_20260429.md
User Sign-off: <ชื่อ user> (<วันที่>, Approved/Rejected)
ใส่ section Estimate vs Actual + AI Effort Savings
```

**ได้:** `uat_report_leave_20260506.md` พร้อม sign-off section

✅ **UAT Done — Production ready**

---

## 📋 Cheat Sheet — Input ที่ AI ต้องการทุก step

| Step | Skill | Input หลัก | Input เสริม |
|------|-------|-----------|------------|
| 0 | requirement-analyzer | SRS/BRD/PRD | module, project |
| 1 | test-plan-writer (SIT v1) | SRS + module scope | qa count, Exit Criteria target |
| 2 | test-matrix-generator | SRS | — |
| 3 | test-case-writer (SIT) | SRS | เทคนิค (negative/BVA/EG), prefix |
| 4 | test-case-reviewer | TC file + SRS | — |
| 5 | test-plan-writer (SIT v2) | Plan v1 + TC file (Sizing) | qa count |
| 6 | test-report-writer (SIT) | TC (executed) + bugs + Plan | AI time used |
| 7 | test-case-writer (UAT) | SIT TC file **หรือ** SRS | mode=uat, format=tc/checklist, roles |
| 8 | test-case-reviewer (UAT) | UAT TC file | mode=uat |
| 9 | test-plan-writer (UAT) | SIT Plan + UAT TC | User QA ชื่อ/role |
| 10 | test-report-writer (UAT) | UAT TC (executed) + Plan | user sign-off ชื่อ+วันที่+ผล |

---

## 📁 File Naming Convention (ใช้ทุก step)

| Type | Pattern | ตัวอย่าง |
|------|---------|---------|
| Plan | `<phase>_plan_<scope>_<YYYYMMDD>.md` | `sit_plan_leave_20260422.md` |
| TC | `testcases_<phase>_<MODULE>_<YYYYMMDD>.md` | `testcases_uat_LEAVE_20260429.md` |
| Review | `peer_review_<MODULE>_<YYYYMMDD>.md` | `peer_review_LEAVE_20260422.md` |
| Bug | `bug_<module>_<short>_<YYYYMMDD>.md` | `bug_leave_approval_20260425.md` |
| Report | `<phase>_report_<scope>_<YYYYMMDD>.md` | `uat_report_leave_20260506.md` |

> `<phase>` = `sit` / `uat` / `perf`

---

## ⚠️ Gate Rules — ห้ามข้าม

1. **Step 0 ต้องผ่าน** ก่อนไป Step 3 (TC design) — ถ้า SRS ยังไม่พร้อม TC จะ rework หนัก
2. **Step 5 ต้องผ่าน** ก่อน Execute — Schedule ต้องคำนวณจาก Sizing + Buffer 20% (ไม่ใช่เดา)
3. **Step 6 ผ่าน Exit Criteria** ก่อนไป UAT — ถ้า Pass Rate < 95% / Severity Critical > 0 ต้อง fix ก่อน
4. **Step 9 Entry Criterion = SIT ผ่าน** — ห้ามเริ่ม UAT ถ้า SIT ยังไม่ sign-off
5. **Severity / Priority** ใช้ Critical/Major/Minor/Trivial + Critical/High/Medium/Low ทุก step (ตาม OneD TEST DEFINITION template)

---

## 🆘 เจอปัญหา?

| อาการ | ดูที่ |
|-------|-------|
| SRS ไม่ครบ / ambiguous | [Scenario ใน qa-onboarding](qa-onboarding.md#-common-scenarios--ฉันเจอแบบนี้-ทำยังไง) |
| SIT ต้องหยุดกลางคัน | [qa-onboarding Scenario 5](qa-onboarding.md#scenario-5--ต้องหยุด-sit-กลางคัน-env-down-dev-slip) |
| AI savings ต่ำกว่า 50% | [qa-onboarding Scenario 6](qa-onboarding.md#scenario-6--ai-savings-ต่ำกว่าเป้า--50) |
| รายละเอียด skill ใดๆ | ไปที่ `skills/<name>/SKILL.md` |
| Standards (Severity/Priority, Buffer, KPI) | [references/qa-standards.md](../references/qa-standards.md) |

---

## 📚 อ่านต่อ

- [README.md](../README.md) — overview + ตัวอย่าง prompt ของแต่ละ skill
- [docs/qa-onboarding.md](qa-onboarding.md) — Day 1 onboarding + Decision Tree + Role-based shortcut
- [docs/work-product-flow.md](work-product-flow.md) — IPO diagram ทุก skill
- [references/qa-standards.md](../references/qa-standards.md) — Severity/Priority/Sizing/Buffer/KPI

### ไม่อยู่ใน SIT→UAT flow (Perf + QA Lead utilities)

- **Performance:** [test-plan-writer](../skills/test-plan-writer/) `mode=perf` → [perf-test-generator](../skills/perf-test-generator/) → [perf-result-analyzer](../skills/perf-result-analyzer/) → [test-report-writer](../skills/test-report-writer/) `mode=perf` (MD, internal) หรือ [perf-typst-report](../skills/perf-typst-report/) (PDF, client-facing)
- **Weekly Update Email:** [weekly-update-writer](../skills/weekly-update-writer/) — ส่ง C-level / Manager / Team
- **Handoff ข้าม AI session:** [handoff-writer](../skills/handoff-writer/) — สร้าง HANDOFF.md เมื่อใกล้ context limit / สลับ tool
