---
name: test-case-writer
description: เขียน test case จาก requirement document (PRD, spec, user story) ให้ครอบคลุมและอ่านง่าย — ใช้ testing techniques มาตรฐาน (ECP, BVA, Decision Table, State Transition, Use Case, Error Guessing) + horizontal table 23 columns (Module ID, TC ID, Role, Pos/Neg, Priority, Severity, Test Sizing S/M/L/XL, Technique, Pre-Req, Test Step, Test Data, Expected, Ref FR, Automation, Labels, Environment, Sprint, Actual, Test Result, Tested By, Test Date, Defect ID, Remark). รองรับ TH/EN + Markdown/CSV. Trigger เมื่อ user ส่ง requirement file/PRD/spec/user story และขอให้เขียน test case, test scenario, test plan, "write test cases", "create test scenarios".
---

# Test Case Writer

## เป้าหมาย
แปลง requirement → test case ที่:
- **ครอบคลุม** — ทุก requirement, ทุก scenario (positive/negative/boundary/edge)
- **อ่านง่าย** — tester คนไหนก็ทำตามได้, expected ไม่กำกวม
- **มี traceability** — รู้ว่า test case ไหนคุม requirement ข้อไหน (Ref FR ID)
- **พร้อม execute** — มีช่อง Actual / Test Result / Tested By / Date / Defect ID สำหรับ tester กรอกตอนรัน
- **ใช้ technique เหมาะกับปัญหา** — ไม่ใช่เขียนเดามั่ว

---

## Template Format — Horizontal (23 columns)

> ใช้ `templates/test-case-th.md` หรือ `templates/test-case-en.md` (Markdown table)
> หรือ `templates/test-case.csv` (import เข้า Excel/Sheets/Jira ได้)

### โครงสร้างไฟล์

```
┌─────────────────────────────────────┐
│ Module ID + Module Title (header)   │
├─────────────────────────────────────┤
│ Scope / Assumptions                 │
├─────────────────────────────────────┤
│ Test Cases table (horizontal)       │
│   - row: SC_xxx: scenario group     │  ← section header
│   - row: TC_xxx individual cases    │  ← test cases
├─────────────────────────────────────┤
│ Coverage Matrix (Req ↔ TC)          │
├─────────────────────────────────────┤
│ Field Reference (scale legend)      │
├─────────────────────────────────────┤
│ Test Data Reference (shared)        │
└─────────────────────────────────────┘
```

### Columns (ลำดับเดียวกันทุก template)

| # | Column | Req | กรอกตอน | คำอธิบาย |
|---|--------|-----|---------|----------|
| 1  | TC ID | ✱ | Design | `TC_<MODULE_ID>_<NUM>` running — `TC_PMS_LOG_001` |
| 2  | Test Case Description | ✱ | Design | ประโยคสั้น บอกสิ่งที่ทดสอบ |
| 3  | Role | ✱ | Design | End User / Admin / Super Admin / Guest |
| 4  | Positive/Negative | ✱ | Design | Positive / Negative / Boundary / Edge |
| 5  | Priority | ✱ | Design | `P0`/`P1`/`P2`/`P3` หรือ High/Med/Low (ให้ user เลือก) |
| 6  | Severity | | Design | `S1` Critical / `S2` Major / `S3` Minor / `S4` Cosmetic |
| 7  | **Test Sizing** | | Design | `S` / `M` / `L` / `XL` (ดู scale ด้านล่าง) |
| 8  | **Technique** | | Design | ECP / BVA / Decision Table / State Transition / Use Case / Error Guessing |
| 9  | Pre-Requisite | | Design | state ก่อนเริ่ม test |
| 10 | Test Step | ✱ | Design | ขั้นตอนเป็นข้อๆ — `1. ... 2. ...` (ใช้ `<br>` ใน Markdown ให้ขึ้นบรรทัดใน cell) |
| 11 | Test Data | | Design | ข้อมูล input (redact password: `[REDACTED]`) |
| 12 | Expected Result | ✱ | Design | ต้องเฉพาะเจาะจง: ข้อความอะไร, redirect ไหน, DB status อะไร |
| 13 | Ref FR ID | | Design | Requirement ID ที่ link ไป coverage matrix |
| 14 | **Automation** | | Design | `Yes` / `No` / `Candidate` / `N/A` |
| 15 | Labels | | Design | comma-separated: `smoke, regression, security, @mobile` |
| 16 | Environment | | Design→Exec | `dev` / `sit` / `uat` / `staging` / `prod` |
| 17 | Sprint | | Design | `<year>-S<num>` เช่น `2026-S08` |
| 18 | Actual Result | ✱ | Execution | tester กรอกจริงตอนรัน |
| 19 | Test Result | | Execution | Pass / Fail / Blocked / Skipped / Not Run |
| 20 | Tested By | | Execution | ชื่อ/initials tester |
| 21 | Test Date | | Execution | YYYY-MM-DD |
| 22 | Defect ID (Jira) | | Execution | `PMS-1234` ถ้า fail |
| 23 | Remark | | both | note เพิ่มเติม |

✱ = mandatory ตอนออกแบบ test

---

## Test Sizing Scale (S/M/L/XL)

| Size | เวลาโดยประมาณ | Steps | ลักษณะ |
|------|---------------|-------|--------|
| **S** | < 15 นาที | 1–3 | action เดียว / field validation / smoke check |
| **M** | 15–30 นาที | 4–8 | กรอก form + ตรวจผล / เปิด modal + save |
| **L** | 30–60 นาที | 9–15 | multi-step flow / มี data fixture / cross-page |
| **XL** | > 1 ชั่วโมง | 15+ | E2E ข้าม role / setup + teardown / external system |

**ใช้ทำอะไร:**
- ประเมิน test effort ต่อ sprint (sum ของ sizing = man-hours)
- วางแผน priority: XL ควรมี P0/P1 เท่านั้น — ถ้า P3 แล้ว XL = pain
- เลือก automation candidate: L/XL ที่รันบ่อยควร automate

---

## ขั้นตอน

### 1. เตรียมข้อมูล
1. อ่าน requirement file ให้จบทั้งไฟล์ก่อน (อย่าเขียนทันที)
2. สรุป feature/business rule ที่จะทดสอบ
3. ระบุ scope: ทำอะไร / ไม่ทำอะไร
4. **ถาม user** ถ้ายังไม่รู้:
   - Module ID + Module Title (เช่น `PMS_LOG` + "Login")
   - ภาษา output: ไทย หรือ English?
   - Format: Markdown table หรือ CSV? (CSV import Excel/Sheets ง่ายกว่า)
   - Priority scheme: `P0/P1/P2/P3` หรือ `High/Med/Low`?

### 2. เลือก Testing Techniques
อ่าน `references/testing-techniques.md` แล้วเลือกตามประเภทของ logic:

| ลักษณะ Requirement | Technique ที่ควรใช้ |
|---------------------|---------------------|
| Input field (เลข, ข้อความ, วันที่) | **ECP + BVA** |
| มีหลายเงื่อนไขรวมกัน (if A และ B แล้ว...) | **Decision Table** |
| มี state เปลี่ยน (draft → submitted → approved) | **State Transition** |
| End-to-end flow ของ user | **Use Case Testing** |
| Logic ซับซ้อน เสี่ยง edge case | **Error Guessing** เพิ่ม |

ใส่ technique ที่ใช้ในคอลัมน์ **Technique** ของแต่ละ TC

### 3. แตก Scenario
- จัดกลุ่มใต้ `SC_xxx: <scenario group name>` (section header row)
- แต่ละ group ต้องมีอย่างน้อย:
  - ✅ **Positive** — happy path
  - ❌ **Negative** — input ผิด, ไม่มีสิทธิ์, validation error
  - 📏 **Boundary** — ค่าขอบเขต (min, min-1, min+1, max-1, max, max+1)
  - 🎯 **Edge** — null, empty, special char, concurrent, network fail

### 4. เขียนตาม Template
- TH: `templates/test-case-th.md`
- EN: `templates/test-case-en.md`
- CSV (Excel/Sheets/Jira import): `templates/test-case.csv`

**Markdown table tips:**
- Multi-line ใน cell → ใช้ `<br>` (ไม่ใช่ `\n`)
- ถ้า field ว่าง ให้เว้น — อย่าใส่ "-" หรือ "N/A" (ดูสะอาดกว่า)
- mandatory column (มี `*`) ต้องกรอกก่อน review

**CSV tips:**
- field ที่มี comma → ครอบด้วย `"..."`
- steps หลายข้อใน cell เดียว → ใช้ `; ` คั่น (CSV ไม่มี newline ใน cell ถ้า export ไป Sheets)
- password → `[REDACTED]` เสมอ

### 5. สร้าง Coverage Matrix
ท้ายไฟล์: ตาราง Requirement ID ↔ Test Case IDs

```
| FR_PMS_LOG_01 | Login ด้วย email+password | TC_PMS_LOG_001 |
| FR_PMS_LOG_02 | Show error invalid cred    | TC_PMS_LOG_002 |
```

### 6. บันทึกไฟล์
File name: `testcases_<module_id>_<YYYYMMDD>.md` (หรือ `.csv`)

ตัวอย่าง: `testcases_PMS_LOG_20260420.md`

---

## Quality Checklist (เช็คก่อนส่ง user)

### Content
- [ ] Module ID + Module Title ครบ
- [ ] ครอบคลุมทุก requirement (ดู coverage matrix — ไม่มี FR ที่ว่าง)
- [ ] มี Positive + Negative + Boundary ครบทุก feature สำคัญ
- [ ] Steps ชัดเจน — tester คนใหม่อ่านแล้วทำตามได้
- [ ] Expected Result เฉพาะเจาะจง (กี่วินาที, ข้อความอะไร, status code อะไร)

### Columns (mandatory fields ครบ)
- [ ] ทุก TC มี: TC ID, Description, Role, Pos/Neg, Priority, Test Step, Expected Result
- [ ] Technique ระบุทุก TC (ไม่ใช่เขียนเดามั่ว)
- [ ] Test Sizing ระบุทุก TC (ใช้วาง plan effort)
- [ ] Automation ระบุทุก TC (Yes/No/Candidate/N/A — ไม่ว่าง)
- [ ] Ref FR ID → link กับ coverage matrix

### Style
- [ ] ภาษาตรงตามที่ user เลือก ไม่ปนกัน
- [ ] Password / PII ถูก redact → `[REDACTED]` หรือ env var reference
- [ ] Execution columns (Actual/Result/Tested By/Date/Defect) ปล่อยว่าง — ให้ tester กรอกตอนรัน

---

## ข้อห้าม

- ❌ อย่าเขียน test case โดยไม่อ่าน requirement ทั้งหมดก่อน
- ❌ อย่าใช้ expected กำกวม เช่น "ทำงานปกติ", "แสดงผลถูกต้อง"
- ❌ อย่าทำ steps รวบ — แยกเป็นขั้นๆ เบอร์กำกับ
- ❌ อย่าลืม negative case (มือใหม่มักลืม)
- ❌ อย่ากรอก Actual Result / Test Result / Tested By ตั้งแต่ design phase — ปล่อยว่าง
- ❌ อย่าใส่ password จริงใน Test Data column
- ❌ อย่าสร้าง TC ที่ sizing = XL โดยที่ Priority = P3 (over-invest)

---

## Integration กับ skills อื่น

- **ก่อน**: ใช้ `test-matrix-generator` ทำ coverage/pairwise matrix → ได้ scenario list → เอามาขยายเป็น full TC ด้วย skill นี้
- **หลัง**: TC ที่ Automation=Yes/Candidate → ส่งต่อให้
  - `test-script-generator` (ถ้าเป็น Robot Framework / athm_automation)
  - `test-script-generator-web` (ถ้าเป็น Playwright / Cypress / WDIO / Selenium-Java)
- **ระหว่างรัน**: ถ้า Test Result = Fail → feed Actual + screenshot + step → `bug-report-writer` เพื่อเขียน defect
