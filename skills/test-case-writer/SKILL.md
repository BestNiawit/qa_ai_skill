---
name: test-case-writer
description: เขียน test case จาก requirement document (SRS/PRD/spec/user story) ให้ครอบคลุมและอ่านง่าย — รองรับ SIT mode (technical view, 23 cols), UAT mode (business view 23 cols หรือ UAT Checklist multi-role workflow) + testing techniques (ECP, BVA, Decision Table, State Transition, Use Case, Error Guessing) + Traceability Matrix. รองรับ TH/EN + Markdown/CSV. Trigger เมื่อ user ส่ง requirement file/SRS/PRD/spec/user story และขอให้เขียน test case, test scenario, SIT test case, UAT test case, UAT checklist, "write test cases", "create test scenarios", "generate UAT checklist", "multi-role workflow test". Maps to SDP §5.3.1 (Process 2, 6).
---

# Test Case Writer

> **คำย่อ (SRS / PRD / FR / TC / SIT / UAT / BVA / ECP / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

แปลง requirement → test case ที่:
- **ครอบคลุม** — ทุก requirement, ทุก scenario (positive/negative/boundary/edge)
- **อ่านง่าย** — tester คนไหนก็ทำตามได้, expected ไม่กำกวม
- **Traceability ครบ** — ทุก TC มี `Ref FR ID` link ไป SRS
- **พร้อม execute** — มีช่อง Actual/Result/Tested By/Date/Defect ID สำหรับ tester
- **ใช้ technique เหมาะกับปัญหา** — ไม่ใช่เขียนเดามั่ว

**Effort savings:** ~50-60% (SDP §5.3.4) — จาก 3 วัน/module → 1.5 วัน

**Mode รองรับ:**
- **SIT mode** (default) — Technical view, 23-col table, testing จาก SRS/DS perspective
- **UAT mode** — Business view, End-to-end business scenario, ภาษาที่ User เข้าใจ
  - **Format: `tc`** (default) — 23-col table (เหมือน SIT แต่ภาษา business) — เหมาะกับ single-role scenario
  - **Format: `checklist`** — Multi-role workflow + Category grouping (C1/C2...) + 3-way status — เหมาะกับ approval flow ข้าม role (เบิกสวัสดิการ, ลางาน, ขออนุมัติ)

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 2 (SIT Test Case) + Process 6 (UAT Test Case)

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| มีเวลา, ต้องการ TC พร้อมรัน | **`test-case-writer`** (skill นี้) |
| รีบ, ต้องการ coverage ก่อน | `test-matrix-generator` (ก่อน skill นี้) |
| มี SIT TC แล้ว อยากแปลงเป็น UAT | **`test-case-writer` mode=uat format=tc** |
| UAT approval flow ข้าม role (เบิก / ลา / อนุมัติ) | **`test-case-writer` mode=uat format=checklist** |
| อยากตรวจ TC ที่เขียนแล้ว | `test-case-reviewer` (หลัง skill นี้) |
| TC approved แล้ว อยาก automate | `robot-test-generator` / `e2e-test-generator` |

**เลือก UAT Format (tc vs checklist):**

| ลักษณะ Scenario | ใช้ Format |
|-----------------|-----------|
| Single-role (User ทำเองจบ เช่น Login, Reset Password, View Profile) | **tc** (23-col) |
| Multi-role handoff (Approve flow ผ่าน 3+ role) | **checklist** |
| Category-based tracking (C1/C2/C3) + 3-way status (Pass/Pass w/ cond/Fail) | **checklist** |
| ต้องการ automate → นำไป robot/e2e-test-generator | **tc** (checklist ไม่ map กับ automation) |
| Client ใช้ format Excel sign-off มาตรฐาน | **checklist** |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Requirement file (SRS/PRD/spec/user story) | ✅ | path ของไฟล์ |
| Mode: SIT หรือ UAT | ✅ | default = SIT ถ้าไม่ระบุ |
| **UAT Format: tc / checklist** (UAT mode เท่านั้น) | ✅\* | default = `tc` — ใช้ `checklist` เมื่อเป็น multi-role approval flow |
| Module ID + Module Title | ✅ | เช่น `PMS_LOG` + "Login" / `KMUTNB_MDB` + "Medical Benefits" |
| Project code (checklist เท่านั้น) | ⚠️ | เช่น `KMUTNB`, `PEA` — ใช้ใน Scenario ID: `UAT_<PROJECT>_<MOD>_<NUM>` |
| Roles involved (checklist เท่านั้น) | ⚠️ | list of roles + example user/pass — เช่น "ข้าราชการ, การเงิน, หัวหน้า, กองคลัง" |
| ภาษา output: TH / EN | ✅ | ถ้าไม่ระบุ → ถาม |
| Format: Markdown / CSV | ✅ | CSV import Excel/Sheets/Jira ง่ายกว่า |
| Priority scheme | — | **บังคับ P0/P1/P2/P3** ตาม [qa-standards.md §2](../../references/qa-standards.md) |
| `project-context.md` | ⚠️ | env, glossary, severity scale, business rules, role list |
| SIT Test Cases (สำหรับ UAT mode) | ⚠️ | path ไฟล์ SIT TC ถ้าต้องการแปลง → UAT |

**`project-context.md` format:**
```markdown
## Environment
- SIT URL: https://sit.example.com
- UAT URL: https://uat.example.com
## Glossary
- "AT" = Assessment Tax
## Severity Scale
- S1=Critical, S2=Major, S3=Minor, S4=Cosmetic
## Business Rules
- Leave balance = 10 days/year, reset 1 Jan
```

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown table หรือ CSV (ตาม input)

**Templates:**
- TH SIT / UAT (tc format): [`templates/test-case-th.md`](templates/test-case-th.md)
- EN SIT: [`templates/test-case-en.md`](templates/test-case-en.md)
- CSV: `templates/test-case.csv`
- **UAT Checklist (TH):** [`templates/uat-checklist-th.md`](templates/uat-checklist-th.md) — Markdown (multi-role workflow)
- **UAT Checklist CSV (TH):** [`templates/uat-checklist-th.csv`](templates/uat-checklist-th.csv) — Excel-friendly

**File naming:**
- SIT: `testcases_sit_<module_id>_<YYYYMMDD>.md` / `.csv`
- UAT (tc format): `testcases_uat_<module_id>_<YYYYMMDD>.md` / `.csv`
- **UAT (checklist format):** `uat_checklist_<project>_<module_id>_<YYYYMMDD>.md` / `.csv`

**โครงสร้างไฟล์:**
```
┌─────────────────────────────────────┐
│ Module ID + Module Title (header)   │
│ Mode: SIT / UAT                     │
├─────────────────────────────────────┤
│ Scope / Assumptions                 │
├─────────────────────────────────────┤
│ Test Cases table (horizontal 23 col)│
│   SC_xxx: scenario group (header)   │
│   TC_xxx: individual cases          │
├─────────────────────────────────────┤
│ Traceability Matrix (Req ↔ TC)      │
├─────────────────────────────────────┤
│ Field Reference (scale legend)      │
└─────────────────────────────────────┘
```

**23 Columns (ลำดับเดียวกันทุก mode):**

| # | Column | Req | กรอกตอน | คำอธิบาย |
|---|--------|-----|---------|----------|
| 1  | TC ID | ✱ | Design | `TC_<MODULE>_<NUM>` — `TC_PMS_LOG_001` |
| 2  | Description | ✱ | Design | ประโยคสั้น บอกสิ่งที่ทดสอบ |
| 3  | Role | ✱ | Design | End User / Admin / Super Admin / Guest |
| 4  | Positive/Negative | ✱ | Design | Positive / Negative / Boundary / Edge |
| 5  | Priority | ✱ | Design | **P0/P1/P2/P3** (qa-standards §2) |
| 6  | Severity | ✱ | Design | **S1/S2/S3/S4** (qa-standards §1) |
| 7  | Test Sizing | ✱ | Design | **S/M/L/XL** (qa-standards §3) — ป้อน test-plan-writer |
| 8  | Technique | | Design | ECP / BVA / Decision Table / State Transition / Use Case / Error Guessing |
| 9  | Pre-Requisite | | Design | state ก่อนเริ่ม |
| 10 | Test Step | ✱ | Design | ขั้นตอนเป็นข้อๆ `1. ... 2. ...` |
| 11 | Test Data | | Design | redact password: `[REDACTED]` |
| 12 | Expected Result | ✱ | Design | ต้องวัดได้ ไม่กำกวม |
| 13 | Ref FR ID | ✱ | Design | SRS ID link ไป Traceability |
| 14 | Automation | | Design | Yes / No / Candidate / N/A |
| 15 | Labels | | Design | `smoke, regression, security` |
| 16 | Environment | | Design→Exec | dev/sit/uat/staging/prod |
| 17 | Sprint | | Design | `2026-S08` |
| 18 | Actual Result | | Execution | tester กรอกตอนรัน |
| 19 | Test Result | | Execution | Pass/Fail/Blocked/Skipped/Not Run |
| 20 | Tested By | | Execution | ชื่อ/initials |
| 21 | Test Date | | Execution | YYYY-MM-DD |
| 22 | Defect ID | | Execution | `PMS-1234` ถ้า fail |
| 23 | Remark | | both | note เพิ่มเติม |

✱ = mandatory ตอน design

---

## 5. Process — ขั้นตอน

### Step 1: Read Input + Check Mode
1. อ่าน requirement file ให้จบทั้งไฟล์
2. อ่าน `project-context.md` ถ้ามี
3. ระบุ mode: SIT หรือ UAT

### Step 2: Ask User (ถ้ายังไม่ครบ)
- Module ID + Title
- Language (TH/EN)
- Format (MD/CSV)
- Priority scheme

### Step 3: เลือก Testing Techniques

| ลักษณะ Requirement | Technique |
|---------------------|-----------|
| Input field (เลข, ข้อความ, วันที่) | **ECP + BVA** |
| หลายเงื่อนไขรวมกัน | **Decision Table** |
| State เปลี่ยน (draft→submitted→approved) | **State Transition** |
| End-to-end user flow | **Use Case Testing** |
| Logic ซับซ้อน, เสี่ยง edge case | **Error Guessing** (เสริม) |

ดูรายละเอียด: [`references/testing-techniques.md`](references/testing-techniques.md)

### Step 4: แตก Scenario
จัดกลุ่มใต้ `SC_xxx: <scenario group>` — แต่ละ group ต้องมี:
- ✅ **Positive** — happy path
- ❌ **Negative** — input ผิด, ไม่มีสิทธิ์, validation error
- 📏 **Boundary** — min, min-1, min+1, max-1, max, max+1
- 🎯 **Edge** — null, empty, special char, concurrent, network fail

### Step 5: เขียนตาม Mode

**SIT Mode (Technical):**
- Expected Result เป็น technical detail (API response, DB state, error message)
- Steps เป็นภาษา technical ("POST /api/leave", "tbl_leave.status='PENDING'")

**UAT Mode — Format `tc` (default, 23-col):**
- รวม SIT TC ที่เกี่ยวข้องเป็น End-to-End Business Scenario
- Expected Result เป็นสิ่งที่ User เห็นบนหน้าจอ
- ภาษา User เข้าใจ (ไม่ใช่ศัพท์ technical)
- Precondition เป็นสิ่งที่ User ต้องเตรียม

ตัวอย่างแปลง:
| SIT (Technical) | → | UAT (Business) |
|----------------|---|----------------|
| Verify POST /api/leave returns 201 | → | กด "ส่งใบลา" → ระบบแสดง "ส่งใบลาสำเร็จ" |
| Verify tbl_leave.status = 'APPROVED' | → | หัวหน้ากด "อนุมัติ" → สถานะเปลี่ยนเป็น "อนุมัติแล้ว" |

**UAT Mode — Format `checklist` (multi-role workflow):**
- **Category grouping** (C1, C2, C3 ...) — กลุ่ม business function เดียวกัน
- Each scenario = **1 end-to-end flow ข้าม role** (ข้าราชการ → การเงิน → หัวหน้า → กองคลัง → ผู้ใช้)
- Multi-role Execution Flow: 1 row ต่อ 1 role handoff
- **3-way Status:** Passed / Passed w/ condition / Failed (scenario-level ไม่ใช่ step-level)
- ไม่มี 23 cols — โครงสร้างคือ `Category > Scenario > Role Execution Steps`

Scenario ID pattern: `UAT_<PROJECT>_<MOD>_<NUM>` (unique ทั่ว project) — เช่น `UAT_KMUTNB_MDB_001`

ตัวอย่าง Scenario (checklist):
```
C1 — สวัสดิการรักษาพยาบาล
  1. เบิกค่าตรวจสุขภาพ 3,000 บาท (happy path)
     UAT_KMUTNB_MDB_001
     Role 1: ข้าราชการ → สร้างคำขอ → "รอการเงินตรวจสอบ"
     Role 2: การเงิน → อนุมัติ → "รอหัวหน้า"
     Role 3: หัวหน้า → อนุมัติ → "รอกองคลัง"
     Role 4: กองคลัง → อนุมัติ → "ดำเนินการแล้ว"
     Role 5: ผู้ใช้ → เบิกจ่าย → "ส่ง ERP"

  2. เบิกค่ารักษาตัว (กรณีกองคลังส่งกลับแก้ไข — variation)
     UAT_KMUTNB_MDB_002
     ...
```

### Step 6: สร้าง Traceability Matrix
ท้ายไฟล์: Requirement ID ↔ Test Case IDs

```
| FR_PMS_LOG_01 | Login ด้วย email+password | TC_PMS_LOG_001, TC_PMS_LOG_002 |
| FR_PMS_LOG_02 | Show error invalid cred    | TC_PMS_LOG_003                 |
```

### Step 7: บันทึก + สรุป + Sizing Summary (บังคับ)

ท้ายไฟล์ TC ต้องมี **Sizing Summary Block** ให้ `test-plan-writer` consume:

```markdown
## Sizing Summary (for Test Plan)

| Size | Count | Midpoint (hr) | Total (hr) |
|:----:|:-----:|:-------------:|:----------:|
| S    | 10    | 0.17          | 1.70       |
| M    | 8     | 0.42          | 3.36       |
| L    | 5     | 0.75          | 3.75       |
| XL   | 2     | 1.25          | 2.50       |
| **Total** | **25** | — | **11.31 hr** |

Priority distribution: P0=3, P1=12, P2=8, P3=2
Severity distribution: S1=2, S2=10, S3=11, S4=2
Automation candidates: 7 TC (L+XL with repeating frequency)
```

> **ทำไมต้องมี:** test-plan-writer อ่าน block นี้คำนวณ Schedule ตาม [qa-standards.md §4 Buffer Policy](../../references/qa-standards.md#4-buffer-policy-บังคับใช้ใน-test-plan-schedule)

แจ้ง user:
- จำนวน TC total + แยกตาม Positive/Negative/Boundary/Edge
- **Sizing Summary ตารางด้านบน (feed ให้ test-plan-writer)**
- Coverage: SRS coverage %
- Gap (ถ้ามี): "SRS-REQ-05 ยังไม่มี TC — ต้องเพิ่ม"

---

## 6. Quality Gate — Checklist ก่อนส่ง

Derived จาก SDP §5.1.2 (SIT TC) + §5.1.5 (UAT TC)

### Must Have
- [ ] ทุก TC มี: TC ID unique, Description, Role, Pos/Neg, **Priority (P0-P3), Severity (S1-S4), Test Sizing (S/M/L/XL)**, Test Step, Expected Result
- [ ] Priority/Severity/Sizing ใช้ scale เดียวตาม `references/qa-standards.md` (ไม่มี High/Med/Low, ไม่มี Blocker/Trivial)
- [ ] Expected Result **วัดได้** — ไม่มี "ทำงานถูกต้อง" / "แสดงผลปกติ"
- [ ] ครอบคลุม Positive + Negative ครบทุก Requirement
- [ ] มี Boundary Test สำหรับ input field
- [ ] Traceability Matrix ครบ — ทุก FR ID มี TC รองรับ
- [ ] Technique ระบุทุก TC (ไม่เดามั่ว)
- [ ] Password / PII redact เป็น `[REDACTED]`
- [ ] **Sizing Summary Block ท้ายไฟล์** (Count/Midpoint/Total hr) — ให้ test-plan-writer consume

### Nice to Have
- [ ] Automation flag ระบุทุก TC
- [ ] Labels + Sprint ครบ
- [ ] Regression TC ถ้าเกี่ยวกับ feature ที่แก้ impact

### UAT-specific (เฉพาะ mode=uat)
- [ ] ภาษา Business (ไม่มี API/SQL/log term)
- [ ] ครอบคลุม End-to-End Flow (ไม่ใช่ Copy SIT มาตรงๆ)
- [ ] Precondition เป็นสิ่งที่ User ทำได้เอง
- [ ] Expected Result = สิ่งที่เห็นบนหน้าจอ/ใบปริ้นท์

### UAT Checklist-specific (format=checklist)
- [ ] Category (C1/C2..) แยกตาม business function
- [ ] Scenario ID format: `UAT_<PROJECT>_<MOD>_<NUM>` unique
- [ ] **ทุก role handoff** มี expected "สถานะคำขอ" (รอการเงิน / รอหัวหน้า / ดำเนินการแล้ว)
- [ ] Multi-role flow ครบตาม business process จริง (ไม่ข้าม role)
- [ ] มี variation scenario (ส่งกลับแก้ไข / reject / conditional approve)
- [ ] Status 3-way: Passed / Passed w/ condition / Failed (scenario-level)
- [ ] Coverage Matrix ครบทุก FR ↔ Scenario ID
- [ ] Scenario Summary table (Total / Passed / Failed / Pass Rate ต่อ Category)

### Red Flags (Reject ทันที)
- ❌ มี Requirement ไม่ครอบคลุม (gap ใน Traceability Matrix)
- ❌ Expected Result กำกวม ("ระบบทำงานปกติ")
- ❌ ไม่มี Negative Case
- ❌ UAT Copy SIT มาโดยไม่ปรับภาษา
- ❌ UAT Checklist: role handoff ข้าม step (เช่น ข้าม "หัวหน้า" ไปกองคลังเลย) = business process ผิด
- ❌ UAT Checklist: ไม่ระบุ "สถานะคำขอ" หลังแต่ละ role action

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจสร้าง TC จาก Requirement ที่ **ไม่มีใน SRS** → Cross-check ทุก TC กับ SRS
- ❌ AI ไม่รู้ **Business Rule เฉพาะ** (เช่น ส่วนลด VIP, promotion rule) → QC/BA เพิ่มเอง
- ❌ AI อาจ **ลืม negative case** บางตัวที่ซับซ้อน (concurrent, race condition) → QC เติม

**ข้อห้าม:**
- ❌ เขียน TC โดยไม่อ่าน requirement ทั้งหมดก่อน
- ❌ Expected result กำกวม
- ❌ Steps รวบ — ต้องแยกเป็นข้อๆ มีเบอร์
- ❌ ใส่ password จริงใน Test Data
- ❌ กรอก Actual/Result/Tested By ตั้งแต่ design phase (ปล่อยว่างให้ tester)
- ❌ TC sizing = XL แต่ Priority = P3 (over-invest)

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream (feed เข้า):**
- `test-matrix-generator` — coverage matrix → ขยายเป็น full TC ด้วย skill นี้
- `test-plan-writer` — SIT/UAT Plan → กำหนด scope + Exit Criteria → ใช้เป็น context เขียน TC

**Downstream (รับต่อ):**
- `test-case-reviewer` — TC ที่เขียนเสร็จ → peer review → ปรับแก้
- `robot-test-generator` / `e2e-test-generator` — TC.Automation=Yes/Candidate → automate
- `bug-report-writer` — TC ที่ fail ตอน execute → bug report
- `test-report-writer` — ผล execute TC → SIT/UAT Report

**Workflow ตัวอย่าง:**
```
SRS → test-case-writer (mode=sit) → test-case-reviewer → [approved]
                                                              ├→ robot-test-generator
                                                              └→ test-case-writer (mode=uat) → test-case-reviewer → [user sign-off]
```

---

## Test Sizing Scale

> **Source of truth:** [qa-standards.md §3](../../references/qa-standards.md#3-test-sizing-scale-บังคับทุก-tc) — ห้าม override scale, override ได้แค่ midpoint ใน `project-context.md` ถ้ามี data จริง

| Size | เวลา | Midpoint (hr) | Steps | ลักษณะ |
|:----:|------|:-------------:|:-----:|--------|
| S  | < 15 นาที | **0.17** | 1–3 | smoke check, field validation |
| M  | 15–30 นาที | **0.42** | 4–8 | form + ตรวจผล |
| L  | 30–60 นาที | **0.75** | 9–15 | multi-step flow, data fixture |
| XL | > 1 ชั่วโมง | **1.25** | 15+ | E2E ข้าม role, external system |

**Pipeline:** sizing totals → Sizing Summary Block → test-plan-writer Schedule (ตาม [qa-standards.md §4 Buffer Policy](../../references/qa-standards.md#4-buffer-policy-บังคับใช้ใน-test-plan-schedule))
**Rules:** XL ควร P0/P1 เท่านั้น; L/XL ที่รันบ่อย = automation candidate

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md) — guardrails universal
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md) — process mapping
- [`references/testing-techniques.md`](references/testing-techniques.md) — ECP/BVA/Decision Table/etc.
- [`templates/test-case-th.md`](templates/test-case-th.md) / [`test-case-en.md`](templates/test-case-en.md) — MD templates
- `templates/test-case.csv` — CSV template
- External: IEEE 829, ISTQB Foundation Level Syllabus
