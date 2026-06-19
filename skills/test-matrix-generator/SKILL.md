---
name: test-matrix-generator
description: สร้าง test matrix แบบ compact ครอบคลุม scope เร็วๆ ตอนเขียน full test case ไม่ทัน — รองรับ 3 matrix หลัก Coverage (Requirement × Scenario), Combination (Pairwise input), Platform (Feature × Browser/OS/Device) — output ได้ทั้ง CSV (ภายใน) และ Typst → PDF branded สำหรับส่งลูกค้า (cover page + TOC + KPI + sign-off). Trigger เมื่อ user ขอ test matrix, coverage matrix, pairwise matrix, compatibility matrix, "ไม่ทันเขียน test case", "ขอ matrix แทน", "generate test matrix", "pairwise testing", "ส่งลูกค้า", "matrix สวยๆ", "PDF report". Maps to SDP §5 (ก่อน SIT Test Case — quick coverage check).
---

# Test Matrix Generator

> **คำย่อ (TC / SRS / SIT / QA / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

สร้าง test matrix แบบ **compact** ให้ QA ได้ coverage เร็ว เมื่อเขียน full TC ไม่ทัน
- ได้ CSV ใช้ต่อใน Excel/Sheets/Jira ทันที
- ไม่ต้องเขียน steps/expected เต็ม — ใช้เป็นโครงขยายเป็น full TC ทีหลัง
- ประหยัดเวลา + ประหยัด token (output สั้น, ตารางเดียวจบ)

**Effort savings:** เหมาะสำหรับ time-crunch — ได้ matrix 10-15 นาที vs full TC 1-3 วัน

**Not in scope (ใช้ skill อื่น / manual):**
- Risk-based matrix (Risk × Severity × Likelihood) → ทำ manual + ดู [references/qa-standards.md §2](../../references/qa-standards.md) สำหรับ Severity scale
- Full test case with steps/expected → ใช้ `test-case-writer`
- State transition table / Decision table → ใช้ `test-case-writer` (รองรับ techniques: ECP / BVA / Decision Table / State Transition / Use Case / Error Guessing)

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5 — ก่อน Process 2 (SIT Test Case) เป็น quick coverage check

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| มีเวลา, ต้องการ TC พร้อมรัน | `test-case-writer` |
| รีบ, ต้องการ coverage ก่อน | **`test-matrix-generator`** (skill นี้) |
| ดู combination ของ input ครบมั้ย | **`test-matrix-generator`** (Combination mode) |
| Cross-browser/cross-device testing | **`test-matrix-generator`** (Platform mode) |
| Requirement เยอะ อยากเช็ค coverage | **`test-matrix-generator`** (Coverage mode) |
| วิเคราะห์ risk / severity | manual + ดู `qa-standards.md §2` (Severity scale) |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Matrix type | ✅ | Coverage / Combination / Platform (เลือกได้หลาย) |
| Input source | ✅ | requirement file / feature list / input parameters |
| Scope | ✅ | เฉพาะ flow/feature/release ไหน |
| Output format | ⬜ | `csv` (default — ทีมใช้ภายใน) / `pdf` (Typst → PDF, สำหรับส่งลูกค้า) / `both` |
| Project metadata | conditional | ถ้า `pdf` หรือ `both` → ต้องมี: `project`, `customer`, `version`, `date`, `author` |
| Update mode | ⬜ | new (default) / update existing file |

**Output language rule:**
- Header + cell content **ตามภาษาของ input** — input ไทย → header ไทย, input อังกฤษ → header อังกฤษ
- Column key (Req ID, TC ID) = อังกฤษเสมอ (เพื่อ sort/filter ง่าย)

---

## 4. Outputs — สิ่งที่ได้

**Format:** เลือกได้ตาม audience

| Format | ใช้กับใคร | ตอนไหน |
|--------|----------|--------|
| **CSV** (default) | ทีม QA / PM ภายใน | Import เข้า Jira/Sheets, edit ต่อง่าย |
| **Typst → PDF** | ลูกค้า / สรุปส่ง stakeholder | ต้องการเอกสาร branded สวย, sign-off ได้ |
| **Both** | งานที่ต้องส่งทั้งภายใน+ลูกค้า | Generate ทั้ง CSV (working) + PDF (deliverable) |

### 4.1 CSV Technical Spec (บังคับ)

| Spec | Value | เหตุผล |
|------|-------|--------|
| Encoding | **UTF-8 with BOM** (`\uFEFF`) | Excel ไทยเปิดไม่เพี้ยน |
| Delimiter | `,` (comma) | มาตรฐาน CSV |
| Line ending | `\r\n` (CRLF) | compatible Windows/Mac Excel |
| Quoting | field ที่มี `,` `"` หรือ newline → ครอบด้วย `"..."` ; `"` ใน field → escape เป็น `""` |
| Header row | บังคับ row แรก = header |
| Empty cell | ใช้ `-` หรือ `N/A` ห้าม empty string |

### 4.2 Output Path

- Save ที่ `./outputs/matrix/` (สร้างถ้าไม่มี)
- Return `computer://` link ให้ user

### 4.3 File Naming

- `matrix_coverage_<feature>_<YYYYMMDD>.csv`
- `matrix_combination_<feature>_<YYYYMMDD>.csv`
- `matrix_platform_<feature>_<YYYYMMDD>.csv`
- `matrix_<type>_<feature>_<YYYYMMDD>.pdf` (เมื่อ format = pdf)
- **Update existing:** เพิ่ม `_v2`, `_v3` ต่อท้าย ไม่ overwrite ของเก่า

### 4.4 Matrix Types + CSV Sample

#### A. Coverage Matrix — Requirement × Scenario

- **แถว** = Requirement ID
- **คอลัมน์** = Scenario/Test ID
- **Cell** = `✓` คุม, `-` ไม่เกี่ยว
- **Summary row/column** = count ของ `✓` ต่อ req/tc

```csv
Req ID,Description,TC-001,TC-002,TC-003,TC-004,Total
REQ-01,Login with email,✓,-,-,-,1
REQ-02,Login with phone OTP,-,✓,✓,-,2
REQ-03,Password reset via SMS,-,-,-,-,0
REQ-04,Lock after 5 failed attempts,-,-,-,✓,1
Total,,1,1,1,1,
```

> Gap check: REQ-03 = 0 → ต้องเพิ่ม TC หรือ TC ที่ไม่ trace req ไหนเลย (orphan)

#### B. Combination Matrix — Pairwise Inputs

- **แถว** = test combination
- **คอลัมน์** = parameter ละ 1 คอลัมน์ (ห้ามผสม)
- Pairwise algorithm — cover ทุก pair อย่างน้อย 1 ครั้ง

```csv
Combo ID,Age,Country,Plan,Payment
C-001,under-18,TH,free,credit card
C-002,under-18,US,pro,bank transfer
C-003,under-18,JP,enterprise,wallet
C-004,18-60,TH,pro,wallet
C-005,18-60,US,enterprise,credit card
C-006,18-60,JP,free,bank transfer
C-007,over-60,TH,enterprise,bank transfer
C-008,over-60,US,free,wallet
C-009,over-60,JP,pro,credit card
```

#### C. Platform Matrix — Feature × Browser/OS/Device

- **แถว** = Feature / Test scenario
- **คอลัมน์** = Platform combo (Chrome-Win11, Safari-iOS17, ...)
- **Cell** = `High/Medium/Low` = priority (qa-standards §1), `-` = ไม่เกี่ยว
- **Priority criteria (เกณฑ์แนะนำ):**
  - `High` = critical flow + market share >20% (เช่น Chrome desktop)
  - `Medium` = market share 5-20% หรือ secondary flow
  - `Low` = market share <5% หรือ edge case

```csv
Feature,Chrome-Win11,Safari-macOS14,Safari-iOS17,Chrome-Android14,Firefox-Win11
Login form,High,High,High,High,Medium
File upload,High,Medium,Medium,Medium,Low
Payment checkout,High,High,High,High,Medium
Admin dashboard,High,Medium,-,-,Low
Push notification,-,-,High,High,-
```

### 4.5 Typst PDF Output (สำหรับส่งลูกค้า)

ใช้เมื่อต้องการเอกสาร branded สวย ส่งลูกค้า / sign-off — Compile จาก Typst template เป็น PDF

#### Prerequisites
- `typst` CLI ≥ 0.13 (Mac: `brew install typst`)
- Font ไทย: **Sukhumvit Set** (ติดตั้งใน macOS อยู่แล้ว) — fallback `Sarabun`, `Helvetica`
- Logo: `assets/oned-logo.png` (อยู่ใน skill folder แล้ว)

#### Template Files
- `templates/report-style.typ` — theme/layout (อย่าแก้เว้นแต่จำเป็น)
- `templates/report.typ` — caller template ที่ AI fill data ลงไป

#### How to Generate

1. Copy `templates/report.typ` → `outputs/matrix/report_<feature>_<YYYYMMDD>.typ`
2. แก้ค่าใน `#show: report.with(...)` ให้ตรงโปรเจกต์จริง:
   - `project`, `customer`, `version`, `date`, `author`
   - `summary` (KPI: requirements, scenarios, coverage %, pass/fail/pending)
   - `scope-in` / `scope-out` (list of strings)
   - `test-types` (list of `(name, desc, count)`)
   - `coverage` / `combination` / `platform` (set ตัวที่ไม่ใช้เป็น `none`)
   - `notes` (optional, content block)
3. Compile:
   ```bash
   cd skills/test-matrix-generator
   typst compile --root . <path-to-report.typ> outputs/matrix/<output>.pdf
   ```
   `--root .` ต้องชี้ที่ skill folder (เพื่อให้อ่าน `assets/oned-logo.png` ได้)

#### File Naming
- `matrix_<type>_<feature>_<YYYYMMDD>.typ` (source)
- `matrix_<type>_<feature>_<YYYYMMDD>.pdf` (deliverable)
- Demo file: `outputs/matrix/sample_login_matrix.pdf`

#### What's in the PDF
1. **Cover page** — logo OneD + project + customer + version + date
2. **Table of Contents** (auto-generated)
3. **Executive Summary** — 4 KPI tiles (req, scenario, coverage %, pass/fail/pending)
4. **Test Scope** — In Scope / Out of Scope
5. **Test Types** — Positive/Negative/Boundary/Security counts
6. **Coverage Matrix** — Requirement × Scenario (มี status badge สี)
7. **Combination Matrix** — Pairwise input (ถ้า provide)
8. **Platform Matrix** — Feature × Platform (ถ้า provide)
9. **Notes** — ข้อสังเกต + ขั้นตอนถัดไป
10. **Sign-off page** — 4 ช่อง: QA Engineer / QA Lead / PM / Customer

#### Status Badge Values (ใช้ใน coverage/platform cell)
รองรับ string ต่อไปนี้ (case-insensitive) — anything else แสดง raw:
| Input | Badge | สี |
|-------|-------|-----|
| `PASS`, `P`, `✓`, `Y`, `YES` | PASS | เขียว |
| `FAIL`, `F`, `✗`, `X`, `NO` | FAIL | แดง |
| `BLOCK`, `BLOCKED`, `B` | BLOCK | ม่วง |
| `PENDING`, `NOT RUN`, `NR` | PENDING | เทา |
| `N/A`, `NA`, `-` | N/A | เทาอ่อน |

---

## 5. Process — ขั้นตอน

### Step 1: ถาม user (ให้น้อยที่สุด)
- Matrix type?
- Input source (path of requirement / list of features)?
- Scope?
- **Output format?** (`csv` / `pdf` / `both`) — ถ้า `pdf` หรือ `both` ต้องถามต่อ:
  - Customer name? Project name? Version? Author?
- Update existing file? (optional)

### Step 2: อ่าน/รวบรวมข้อมูล
- ถ้ามี requirement file → อ่านครั้งเดียว, สรุป req IDs
- ถ้า user พิมพ์รายการมา → ใช้ตามนั้น
- **ห้ามเดา requirement** — ถ้าไม่ชัดต้องถาม

### Step 3: สร้าง Matrix

**Pairwise algorithm (เลือกตามขนาด):**

| ขนาด input | Algorithm | เครื่องมือ |
|-----------|-----------|-----------|
| params ≤ 3 × values ≤ 3 (≤27 combo) | Full cartesian | ทำมือได้ |
| params 4-6 × values 2-4 | **Pairwise (greedy)** | PICT / ACTS / `allpairspy` (Python) |
| params > 6 หรือ values > 5 | Pairwise + tool บังคับ | PICT / ACTS |

**Fallback เมื่อไม่มี PICT/ACTS:**
```python
# Python greedy pairwise fallback
# pip install allpairspy
from allpairspy import AllPairs
params = [
    ["under-18", "18-60", "over-60"],
    ["TH", "US", "JP"],
    ["free", "pro", "enterprise"],
    ["credit card", "bank transfer", "wallet"],
]
for i, pairs in enumerate(AllPairs(params), 1):
    print(f"C-{i:03d},{','.join(pairs)}")
```

### Step 4: Size check + Split
- Coverage matrix > **50 × 50** → เตือน user + แนะนำ split ตาม module
- Combination > **100 rows** → เตือน user + แนะนำ prioritize หรือ split
- Platform > **20 platform columns** → แนะนำ group เป็น tier (Tier-1/2/3)

### Step 5: บันทึก + สรุป
- Path + computer:// link
- จำนวนแถว/คอลัมน์
- **Gap ที่พบ (2 ทิศทาง):**
  - Req ที่ไม่มี TC คุม
  - TC ที่ไม่ได้ trace req ไหนเลย (orphan test)
- Sanity check: "Safari บน Windows ไม่มี — ปกติ Safari มีบน macOS/iOS"
- เสนอต่อ: "ถ้าต้องการขยายเป็น full TC → ใช้ `test-case-writer`"

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] CSV encoding = UTF-8 with BOM
- [ ] Delimiter = `,` + quote field ที่มี special char
- [ ] Header row ครบและตรงกับ template
- [ ] ไม่มี cell ว่าง — ใช้ `-` หรือ `N/A`
- [ ] Coverage: ทุก req มี ≥ 1 scenario คุม + ทุก TC trace ≥ 1 req
- [ ] Combination: params + values ชัด ไม่ผสมหลาย param ในคอลัมน์เดียว
- [ ] Platform: combo สมเหตุสมผล (Safari ไม่มีบน Windows) + มี priority
- [ ] Size ไม่เกิน threshold (ถ้าเกิน → warn + split)
- [ ] File save ที่ `./outputs/matrix/` + return `computer://` link

### Must Have (PDF format เท่านั้น)
- [ ] Compile ผ่าน — `typst compile --root .` ไม่มี error
- [ ] Customer/Project/Version/Date ใส่ครบ ไม่มี placeholder `<...>` หลงเหลือ
- [ ] Logo render ที่ cover page ถูกต้อง (ตรวจหน้า 1)
- [ ] TOC แสดงครบทุก section + เลขหน้าตรง (ตรวจหน้า 2)
- [ ] Status badge สีถูกตาม semantic (PASS=เขียว, FAIL=แดง)
- [ ] Sign-off page มีครบ 4 ช่อง (QA / Lead / PM / Customer)

### Red Flags / Anti-patterns
- ❌ ใส่ steps/expected/actual แบบ full TC ใน cell — ผิด scope (นั่น `test-case-writer`)
- ❌ ผสม matrix หลายประเภทในไฟล์เดียว
- ❌ คอลัมน์เดียวเก็บ 2 parameters เช่น `Browser+OS = "Chrome/Win11"` ใน Combination matrix → แยกเป็น 2 คอลัมน์
- ❌ เดา requirement ถ้าไม่มีไฟล์ → ต้องถาม user
- ❌ Overwrite ไฟล์เดิมโดยไม่ถาม → ใช้ `_v2` suffix
- ❌ Empty cell (CSV parser บางตัว error) → ใช้ `-`

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจ **คำนวณ pairwise ผิด** ถ้า params เยอะ → ใช้ PICT/ACTS/allpairspy ตรวจ
- ❌ AI อาจ **ลืม requirement** บางข้อ → Cross-check กับ SRS ทุกข้อ
- ❌ AI อาจ **สร้าง platform combo ไม่สมเหตุสมผล** (Safari บน Windows, IE บน macOS) → sanity check list
- ❌ AI อาจ **encoding พลาด** ไทยเป็น `???` → บังคับ UTF-8 BOM

**ข้อห้าม:**
- ❌ เขียน full TC — skill นี้คือ matrix compact เท่านั้น
- ❌ Over-engineer — 2 params = ใช้ cartesian ไม่ต้อง pairwise

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `test-plan-writer` — plan อาจ feed scope ของ matrix
- Requirement file (SRS/PRD)
- User input (feature list / parameters)

**Downstream:**
- `test-case-writer` — matrix → ขยายเป็น full 23-col TC
- `test-plan-writer` — matrix = ส่วนหนึ่งของ Test Approach ใน Plan
- `test-case-writer` — รวม Traceability Matrix (Requirement ↔ TC) ใน output อยู่แล้ว

**Workflow ตัวอย่าง:**
```
SRS → test-matrix-generator (Coverage) → [review team, เช็ค gap]
                                           └→ test-case-writer (ขยายเป็น full TC)
```

---

## ตัวอย่างการใช้งาน

**Input:**
```
ช่วยทำ coverage matrix จาก docs/login-requirement.md
จะได้เห็นว่า scenario ที่วางไว้ครอบคลุม req ครบมั้ย
```
**Output:**
- `./outputs/matrix/matrix_coverage_login_20260420.csv` (8 req × 12 scenario)
- Summary:
  - REQ-03 (password reset via SMS) ยังไม่มี scenario → แนะนำเพิ่ม TC-013
  - TC-008 ไม่ได้ trace req ไหน (orphan) → ตรวจว่าจำเป็นมั้ย

---

**Input:**
```
ขอ pairwise matrix สำหรับ form สมัครสมาชิก:
- Age: under-18, 18-60, over-60
- Country: TH, US, JP
- Plan: free, pro, enterprise
- Payment: credit card, bank transfer, wallet
```
**Output:**
- `./outputs/matrix/matrix_combination_signup_20260420.csv` — 9 combinations (pairwise) แทน 81 (full cartesian)
- Algorithm: allpairspy greedy
- Coverage: ทุก pair (36 pairs) cover 100%

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- External standards:
  - ISO/IEC/IEEE 29119-4:2015 — Test techniques (combinatorial testing)
  - ISTQB Advanced Level Test Analyst — combinatorial testing
- Tools: PICT (Microsoft), ACTS (NIST), allpairspy (Python), Hexawise
