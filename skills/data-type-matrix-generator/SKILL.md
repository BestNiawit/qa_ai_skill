---
name: data-type-matrix-generator
description: สร้าง "test pack ฉบับไม่มี requirement" — Data Type Matrix (per field × data-type categories) + Happy Path E2E + Integration Points + Assumption Checklist สำหรับให้ PM tick yes/no แทนเขียน spec ใหม่ — เหมาะเวลา requirement ไม่ชัดแต่ต้องส่งงาน ใช้ existing behavior เป็น baseline oracle + เรียงทดสอบตาม risk (null, empty, unicode, boundary ก่อน). Trigger เมื่อ user ขอ data type matrix, field matrix, boundary matrix, negative test matrix, "ไม่มี requirement แต่ต้องเทส", "ฟีเจอร์ใหม่ต่อ base เดิม", "PM ยังไม่ confirm แต่ deadline ใกล้", "data type testing", "equivalence partitioning", "boundary value analysis", "assumption checklist for PM", "ECP BVA matrix". Maps to SDP §5.3.1 (Pre-Process 2 — defensive fallback เมื่อ requirement-analyzer Score = Not-ready แต่ต้องเดินต่อ).
---

# Data Type Matrix Generator

> **คำย่อ (TC / ECP / BVA / FR / AC / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

สร้าง **test pack ฉบับไม่มี requirement ชัด** ที่ QA ใช้ส่งงานได้จริงและ "cover ตัวเอง" เมื่อบั๊กหลุดไปหลัง release

สถานการณ์ที่ skill นี้ออกแบบมาแก้: **requirement ไม่ชัด + เวลาไม่มี + ต้องส่งงาน** — แทนที่จะรอ PM เขียน spec ใหม่ 2 ชม. ให้ QA เดินหน้าเลยด้วย 4 artifact พร้อม assumption log ให้ PM tick 10 นาที

**Output 4 ชิ้น (บังคับทุกชิ้น ห้ามใช้แค่ matrix):**

1. **Data Type Matrix** — per field × data-type categories (Null / Empty / Valid / Boundary / Wrong-type / Unicode / Special-char / Whitespace / Overflow) — เป็นโครง ECP + BVA แบบ pragmatic
2. **Happy Path E2E Scenarios** — เล่นตาม user จริง ไม่ใช่เทสทีละ field
3. **Integration Points with Base** — จุดเชื่อมระหว่างฟีเจอร์ใหม่กับระบบเดิม (เจอบั๊กบ่อยสุด)
4. **Assumption Checklist** — bullet list ให้ PM tick yes/no ใช้แทน spec

**Oracle Strategy:** เมื่อไม่มี requirement บอกว่า "ถูก/ผิด" ให้ใช้ **existing behavior ของฟีเจอร์เดิมที่คล้ายกัน** เป็น baseline — ถ้าของเก่ารับ input แบบนี้แล้วตอบ Y, ของใหม่ควร consistent

**Effort savings:** ~30-50% เทียบกับนั่งเดา manual — ได้ test pack ใน 30-45 นาที พร้อมเอกสาร cover ตัวเอง

**Key rules:**
- ห้ามส่งแค่ Data Type Matrix เดี่ยวๆ — ต้องมีครบทั้ง 4 ชิ้นเสมอ (matrix จับ field-level, 3 ชิ้นอื่นจับสิ่งที่ matrix จับไม่ได้)
- ทุก expected behavior ใน matrix ต้อง map ไปที่ oracle ชัดๆ: `Source:` (BRD §X) / `Baseline:` (ฟีเจอร์เดิม Y) / `Assumption:` (รอ PM confirm)
- เรียง execution ตาม **risk-based priority** (Critical → Low) — null/empty/unicode/boundary ต้องรันก่อนเสมอ
- Assumption Checklist ต้องใช้ภาษาที่ PM อ่าน 10 นาทีเสร็จ ไม่ใช่ technical jargon

**Not in scope (ใช้ skill อื่น):**
- Requirement ที่ชัดแล้ว → ข้าม skill นี้ ใช้ `test-case-writer` เลย
- Readiness Score ของ BRD → `requirement-analyzer`
- Pairwise combination ของหลาย parameter → `test-matrix-generator` (Combination mode)
- Coverage matrix ระดับ requirement → `test-matrix-generator` (Coverage mode)
- Full TC 23 cols พร้อม steps/expected → `test-case-writer` (ขั้นถัดไป)

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** Pre-§5.3.1 (Process 2) — **defensive fallback** เมื่อ `requirement-analyzer` ตัดสิน Not-ready/Needs-clarification แต่ timeline บังคับให้เดินต่อ

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| Requirement ชัด + มี AC | `test-case-writer` |
| Requirement กำกวม → อยากเช็คก่อน | `requirement-analyzer` (gate ก่อน) |
| Requirement กำกวม + **ไม่มีเวลา wait PM** + ต้องส่งงาน | **`data-type-matrix-generator`** (skill นี้) |
| ฟีเจอร์ใหม่ต่อ base เดิม แต่ไม่มี spec ระบุ data type | **`data-type-matrix-generator`** (skill นี้) |
| รีบ coverage ระดับ requirement (ไม่ใช่ field) | `test-matrix-generator` (Coverage mode) |
| Pairwise ของ input parameters หลายตัว | `test-matrix-generator` (Combination mode) |
| เทสข้าม browser/OS | `test-matrix-generator` (Platform mode) |

**Decision flow:**
```
requirement-analyzer → Readiness Score
  ├→ Ready               → test-case-writer
  ├→ Needs-clarification → PM confirm ได้ทัน? → yes: wait + test-case-writer
  │                                            → no:  **data-type-matrix-generator** (skill นี้)
  └→ Not-ready           → PM confirm ได้ทัน? → yes: wait + test-case-writer
                                               → no:  **data-type-matrix-generator** (skill นี้)
                                                      + ส่ง Assumption Checklist ให้ PM ก่อน execute
```

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Feature scope | ✅ | ฟีเจอร์อะไร, เช่น "เพิ่มฟิลด์ Middle Name ในหน้า Register" |
| Field list | ✅ | รายชื่อ input field + type ที่คาดว่าจะเป็น (string/number/date/enum) |
| Base reference | ⚠️ | URL/path/screenshot ของฟีเจอร์เดิมที่ใช้เป็น baseline oracle |
| Project context | ⚠️ | `project-context.md` (Glossary, business rules, environment) |
| Existing BRD/PRD (ถ้ามีบางส่วน) | — | ใส่ไว้เพื่อ extract AC ที่มีอยู่ก่อน — ส่วนที่ไม่มีค่อย fallback เป็น assumption |
| ภาษา output: TH / EN | ✅ | default = TH |
| PM/BA name + deadline | ✅ | ใส่ใน Assumption Checklist |

**ถ้า input ไม่ครบ → ต้องถาม:**
- ฟิลด์อะไรบ้าง? (ต้องได้ list ก่อนถึงสร้าง matrix ได้)
- มีฟีเจอร์เดิมที่คล้ายกันมั้ย (baseline oracle)? ถ้าไม่มี → ทุก expected ต้องเป็น `[Assumption]`
- PM คือใคร, ต้อง confirm ภายในเมื่อไหร่?
- Scale ของ boundary (ถ้า field เป็น number/string length) — ใช้ spec เดิม หรือเดาตาม industry default?

**ห้ามเดา field list เอง** — ถ้า user ไม่ให้มา ต้องถาม (field ผิด 1 ตัว = matrix ทั้งใบผิด)

---

## 4. Outputs — สิ่งที่ได้

**4 ไฟล์ (บังคับครบ ห้ามส่งแค่บางชิ้น):**

| # | File | Template | เพื่ออะไร |
|---|------|----------|-----------|
| 1 | Data Type Matrix | [`templates/data-type-matrix-th.csv`](templates/data-type-matrix-th.csv) | Field-level coverage (ECP + BVA) |
| 2 | Happy Path Scenarios | [`templates/happy-path-scenarios-th.md`](templates/happy-path-scenarios-th.md) | E2E flow จริงของ user |
| 3 | Integration Points | [`templates/integration-points-th.md`](templates/integration-points-th.md) | จุดเชื่อมกับ base (เจอบั๊กบ่อย) |
| 4 | Assumption Checklist | [`templates/assumption-checklist-th.md`](templates/assumption-checklist-th.md) | ส่ง PM tick yes/no |

**File naming:**
- `datatype_matrix_<feature>_<YYYYMMDD>.csv`
- `happy_path_<feature>_<YYYYMMDD>.md`
- `integration_points_<feature>_<YYYYMMDD>.md`
- `assumption_checklist_<feature>_<YYYYMMDD>.md`

**Output path:** `./outputs/datatype-pack/<feature>/` (สร้างถ้าไม่มี)

### 4.1 Data Type Matrix — CSV Schema (บังคับ)

**Columns (fixed order):**

| # | Column | เนื้อหา |
|---|--------|--------|
| 1 | `TC ID` | `DTM-<feature>-<NNN>` เช่น DTM-REG-001 |
| 2 | `Field` | ชื่อ field เช่น `email`, `amount`, `birth_date` |
| 3 | `Field Type` | `string` / `number` / `date` / `enum` / `boolean` / `file` |
| 4 | `Category` | `Null` / `Empty` / `Valid-typical` / `Boundary-min` / `Boundary-max` / `Below-min` / `Above-max` / `Wrong-type` / `Unicode` / `Whitespace` / `Special-char` / `Overflow` |
| 5 | `Test Value` | ค่าที่ใส่จริง เช่น `null`, `""`, `"  "`, `"😀"`, `"<script>"`, `"A".repeat(1000)` |
| 6 | `Expected Behavior` | ผลที่คาดว่าจะได้ |
| 7 | `Oracle Source` | `BRD §X` / `Baseline: <ชื่อฟีเจอร์เดิม>` / `Assumption: A-NN` |
| 8 | `Risk` | `Critical` / `High` / `Medium` / `Low` (ตาม [qa-standards §1](../../references/qa-standards.md)) |
| 9 | `Exec Order` | เลขลำดับรัน (risk-based: Critical ก่อน) |
| 10 | `Notes` | เช่น "ใช้ทดแทน SIT-TC-012 ที่ยังไม่มี spec" |

**CSV Technical Spec (บังคับเหมือน `test-matrix-generator` §4.1):**

| Spec | Value |
|------|-------|
| Encoding | UTF-8 with BOM (`﻿`) |
| Delimiter | `,` |
| Line ending | `\r\n` |
| Quoting | field ที่มี `,` `"` newline → ครอบ `"..."` ; `"` → `""` |
| Empty cell | ใช้ `-` ห้าม empty string |

**ตัวอย่าง CSV (ย่อ):**
```csv
TC ID,Field,Field Type,Category,Test Value,Expected Behavior,Oracle Source,Risk,Exec Order,Notes
DTM-REG-001,email,string,Null,null,"แสดง ""กรุณากรอก email""",Baseline: Login form,Critical,1,-
DTM-REG-002,email,string,Empty,"""""",แสดง error เหมือน Null case,Baseline: Login form,Critical,2,-
DTM-REG-003,email,string,Whitespace,"""   """,treat as empty → error,Assumption: A-01,High,3,ถาม PM ว่า trim whitespace มั้ย
DTM-REG-004,email,string,Valid-typical,user@example.com,register สำเร็จ,Baseline: Login form,Medium,10,-
DTM-REG-005,email,string,Unicode,สมชาย@example.com,"[Assumption] อนุญาต (RFC 6531)",Assumption: A-02,High,4,ถาม PM ว่ารับ IDN หรือไม่
DTM-REG-006,email,string,Special-char,"""<script>alert(1)</script>""",sanitized or rejected,Baseline: XSS policy,Critical,5,OWASP A03
DTM-REG-007,email,string,Overflow,"""a"".repeat(500) + ""@x.com""",reject เกิน 254 ตัว (RFC 5321),Assumption: A-03,Medium,15,standard email max
```

### 4.2 Happy Path, Integration, Assumption — Markdown

ดูตัวอย่างเต็มใน [`templates/`](templates/) — แต่ละไฟล์มี schema ชัดเจนและ example

---

## 5. Process — ขั้นตอน

### Step 1: ถาม user ถ้าไม่ครบ
- Feature scope + Field list (required)
- Base/baseline feature (oracle fallback)
- PM + deadline for assumption confirmation
- Existing BRD fragment (ถ้ามี)

### Step 2: อ่าน existing assets
- Existing BRD/PRD (ถ้ามี) — extract AC ที่ชัดแล้วก่อน
- `project-context.md` (Glossary, business rules, NFR)
- Base feature behavior (ถ้า user ชี้ path/URL ได้)

### Step 3: สร้าง Data Type Matrix (artifact #1)
ต่อ field ละ 1 block:
1. List ทุก Category ที่ applicable ตาม field type (ดู [`references/data-type-categories.md`](references/data-type-categories.md))
2. ต่อแถว: กำหนด Test Value + Expected Behavior + Oracle Source
3. ถ้า Expected ไม่มีใน BRD → ใช้ Baseline oracle; ถ้าไม่มี baseline → ใช้ `Assumption: A-NN` + บันทึกใน Assumption Checklist
4. Risk rating ตามเกณฑ์ใน §4.1 (ใช้ [qa-standards §1](../../references/qa-standards.md) Priority scale)
5. เรียง `Exec Order` ตาม Risk — Critical/High ของ `Null` `Empty` `Unicode` `Special-char` ต้องอยู่ 10 แถวแรก

**Category selection matrix (บังคับ):**
ดู [`references/data-type-categories.md`](references/data-type-categories.md) — ตารางบอกว่า field type ไหน ควรเทส category อะไรเป็น minimum

### Step 4: สร้าง Happy Path E2E (artifact #2)
- 3-5 scenarios ตาม user จริง (ไม่ใช่แค่ field-level)
- แต่ละ scenario: precondition → steps → expected end state
- Expected = "consistent กับ base" ถ้าไม่มี spec
- ทุก scenario ครอบคลุม feature ใหม่ **รวมกับ** touch point กับ base (ถ้ามี)

### Step 5: สร้าง Integration Points (artifact #3)
- List จุดเชื่อมระหว่างฟีเจอร์ใหม่กับ base (API call, DB write, shared state, session, permission)
- ต่อจุด: ระบุ direction (ใหม่ → เก่า / เก่า → ใหม่), data contract, failure mode ที่คิดได้
- **Red flag zones:** ถ้าฟีเจอร์ใหม่ modify field ที่ฟีเจอร์เดิมอ่านอยู่ → บัง highlight

### Step 6: สร้าง Assumption Checklist (artifact #4)
- รวมทุก `Assumption: A-NN` จาก matrix + scenario + integration
- เรียง A-01, A-02, ... ตาม importance
- ภาษา business — PM อ่าน 10 นาทีเสร็จ + tick yes/no ได้
- มี Deadline for feedback (2-3 วันทำการ)

### Step 7: Sanity check
- Matrix > 50 rows/field → warn user + แนะนำลด Category
- ทุก `Assumption: A-NN` ใน matrix/scenario ต้องมีใน Assumption Checklist
- ทุก field ต้องมีอย่างน้อย 5 Category (Null / Empty / Valid / Boundary / Wrong-type)

### Step 8: บันทึก + สรุป
- Path 4 ไฟล์ + `computer://` links
- จำนวน TC ใน matrix + จำนวน assumption ที่ต้อง confirm + จำนวน integration point
- Recommended next step:
  - ส่ง Assumption Checklist ให้ PM **ก่อน** เริ่ม execute (deadline: 2-3 วัน)
  - ถ้าต้องการ full TC 23 cols → feed matrix เข้า `test-case-writer`
  - ถ้าต้องการ automation → feed matrix เข้า `robot-test-generator` / `e2e-test-generator`

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have (ครบทั้ง 4 ไฟล์)
- [ ] Data Type Matrix CSV — UTF-8 BOM, 10 cols ครบ, ไม่มี empty cell
- [ ] Happy Path Scenarios — อย่างน้อย 3 scenarios, มี precondition + steps + expected end state
- [ ] Integration Points — อย่างน้อย 1 จุด (ถ้าฟีเจอร์ standalone จริง ให้เขียน "N/A — standalone, no touch point" + เหตุผล)
- [ ] Assumption Checklist — มี Deadline, numbered, ภาษา business
- [ ] ทุก `Assumption: A-NN` ใน matrix/scenario/integration ต้อง appear ใน Checklist
- [ ] ทุก field มี ≥ 5 Category (Null, Empty, Valid-typical, Boundary, Wrong-type เป็นขั้นต่ำ)
- [ ] Exec Order เรียงตาม Risk (Critical > High > Medium > Low)
- [ ] ทุกแถว matrix มี Oracle Source ระบุ (BRD §X / Baseline: / Assumption: A-NN)

### Nice to Have
- [ ] มี baseline feature URL/path ใน Integration Points
- [ ] Unicode test มีทั้ง Thai + emoji + RTL (ถ้า product รับ multi-language)
- [ ] Special-char test ครอบ OWASP Top 10 (XSS, SQLi, path traversal) ถ้าเป็น user-input field

### Red Flags (Reject ทันที)
- ❌ ส่งแค่ matrix ไม่มี 3 ชิ้นอื่น → incomplete pack (skill นี้บังคับ 4 ชิ้น)
- ❌ Matrix มีแต่ `Valid-typical` — ไม่มี negative case (Null/Empty/Wrong-type) → skill นี้ไม่มีประโยชน์
- ❌ Expected Behavior ทุกแถวเขียนว่า "ทำงานถูกต้อง" / "ระบบแสดง error" (ไม่ measurable) → violate AI guardrail §4
- ❌ Oracle Source ว่างทุกแถว (ไม่มี BRD / Baseline / Assumption) — ไม่รู้ pass/fail ได้ยังไง
- ❌ Assumption Checklist เขียนเป็น technical jargon — PM อ่านไม่เข้าใจ
- ❌ Exec Order ไม่เรียงตาม Risk — Critical ไปอยู่ row 50 → เสียจุดประสงค์ risk-based

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI ชอบ **เดา Expected Behavior** จาก common sense → บังคับระบุ Oracle Source ทุกแถว (BRD / Baseline / Assumption)
- ❌ AI ชอบ **ลืม Unicode/RTL/emoji** เมื่อ field เป็น string ไทย → `data-type-categories.md` มี checklist บังคับ
- ❌ AI ชอบ **ใส่ Wrong-type test ผิด** เช่น ส่ง string เข้า field ที่ frontend validate แล้ว → ต้องเทส API ตรงด้วย ไม่ใช่แค่ UI
- ❌ AI ชอบ **ลืม integration เมื่อ feature ดู standalone** — ต้องถาม "feature นี้ trigger event/notification/cache invalidation ไหม" ก่อนสรุปว่า standalone
- ❌ AI ชอบ **เขียน Assumption ยาวเกิน** → PM อ่านไม่ไหว → จำกัด 1-2 ประโยค/ข้อ
- ❌ AI ชอบ **set Risk = Critical ทั้งหมด** → Exec Order เสียจุดประสงค์ → บังคับกระจาย distribution (Critical ≤ 30% ของแถว)

**ข้อห้าม:**
- ❌ เดา field list ที่ user ไม่ได้บอก
- ❌ ใช้ Baseline oracle ที่ user ไม่ได้ชี้ (เช่น "ดูฟีเจอร์เก่าๆ" แบบลอยๆ)
- ❌ ข้าม Assumption Checklist (ทำให้ PM ไม่มีเอกสาร tick → skill นี้เสียจุดประสงค์)
- ❌ สร้าง Integration Points แบบ make-up โดยไม่รู้ architecture จริง — ถ้าไม่มีข้อมูลให้เขียน "ต้องยืนยันกับ Dev"

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream (feed เข้า):**
- `requirement-analyzer` — ถ้า Readiness Score = Not-ready + timeline บังคับ → fallback มาที่ skill นี้
- Field list จาก Figma / UI mockup / API spec (manual input โดย user)
- Base feature documentation (ใช้เป็น oracle)

**Downstream (รับต่อ):**
- **PM/BA** — รับ Assumption Checklist ไป tick (ไม่ใช่ skill)
- `test-case-writer` — ขยาย matrix + scenario → full 23-col TC (หลัง PM confirm assumption)
- `test-matrix-generator` — ถ้าอยากได้ pairwise ระหว่าง field → ใช้ skill นั้นต่อ
- `robot-test-generator` / `e2e-test-generator` — matrix = input สำหรับ parameterized test
- `bug-report-writer` — bug ที่เจอจาก execution → Jira

**Workflow ตัวอย่าง:**
```
Feature brief (ไม่มี BRD ชัด)
    ↓
requirement-analyzer → Score = Not-ready + no time to wait
    ↓
data-type-matrix-generator  (skill นี้)
    ├→ Data Type Matrix CSV
    ├→ Happy Path Scenarios
    ├→ Integration Points
    └→ Assumption Checklist  → [ส่ง PM, tick, deadline 2-3 วัน]
              ↓
        [PM tick กลับมา]
              ↓
     Update matrix: Assumption → Confirmed/Rejected
              ↓
   test-case-writer (ขยายเป็น full TC)  +  robot/e2e-test-generator (automation)
              ↓
         [Execute SIT]
              ↓
   bug-report-writer  +  test-report-writer
```

**ทำไมต้องใช้ skill นี้ต่อจาก `requirement-analyzer`:**
- `requirement-analyzer` บอก "ยังไม่พร้อม" — แต่ถ้าหยุดเลย timeline พัง
- skill นี้ช่วยให้ QA **เดินหน้าทำงานได้ทันที** พร้อม document cover ตัวเอง (Assumption Checklist)
- เมื่อ bug escape ไปหลัง release → มีหลักฐานว่า QA ถาม PM แล้ว, PM tick แบบนี้ → shift responsibility จากจุดที่ควรเป็น

---

## ตัวอย่างการใช้งาน

**Input:**
```
feature ใหม่: เพิ่ม field Middle Name ในหน้า Register
- field: middle_name (string, optional)
- base: ฟีเจอร์ Register เดิมที่ /register (รับ first_name + last_name อยู่แล้ว)
- BRD: ไม่มี เลยต้องเดินต่อ
- PM: คุณสมศรี, deadline confirm: 2026-04-27
```

**Output:**
```
./outputs/datatype-pack/register-middlename/
├── datatype_matrix_register-middlename_20260424.csv    (14 rows — 1 field × 14 categories)
├── happy_path_register-middlename_20260424.md          (3 scenarios: TH name, EN name, no middle)
├── integration_points_register-middlename_20260424.md  (2 points: DB schema, profile display)
└── assumption_checklist_register-middlename_20260424.md (7 assumptions — deadline 2026-04-27)

Summary:
- 14 TC in matrix (3 Critical, 5 High, 4 Medium, 2 Low)
- 7 assumptions ต้อง PM confirm (A-01..A-07)
- 2 integration points (DB + profile page)
- Exec order: 10 แถวแรกเป็น Null/Empty/Unicode/Wrong-type (เจอบั๊กเร็ว)

Next step:
→ ส่ง assumption_checklist_*.md ให้ คุณสมศรี รอ tick ภายใน 2026-04-27
→ หลัง tick → update matrix + feed เข้า test-case-writer
```

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md) — AI usage guardrails
- [`references/qa-standards.md`](../../references/qa-standards.md) — Priority/Severity/Risk scale
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md) — SDP Process mapping
- [`references/data-type-categories.md`](references/data-type-categories.md) — taxonomy ของ data type category ต่อ field type
- External:
  - ISO/IEC/IEEE 29119-4:2015 — Test techniques (ECP, BVA)
  - ISTQB Foundation — Equivalence Partitioning + Boundary Value Analysis
  - OWASP LLM Top 10 / OWASP Top 10 (Special-char test ideas)
  - RFC 5321 / RFC 6531 (email boundary examples)
