---
name: test-case-reviewer
description: Peer Review test case อัตโนมัติ — ตรวจ checklist (Expected Result ชัด, Precondition ครบ, Positive/Negative/Boundary ครบ, Traceability ไม่มี gap กับ SRS) + แสดงผลเป็นตาราง "TC ID / ปัญหา / ระดับ Must Fix/Should Fix / ข้อเสนอแนะ". รองรับ SIT TC และ UAT TC. Trigger เมื่อ user ขอ review test case, peer review, check test case, audit test case, "review SIT TC", "review UAT TC", "ตรวจ test case", "Peer Review". Maps to SDP §5.3.1 (Process 3, 7).
---

# Test Case Reviewer

## 1. Purpose — เป้าหมาย

Draft Peer Review Report ให้ QC/TL/BA approve — ลดเวลา manual review ตาราง checklist

**Effort savings:** ~40% (SDP §5.3.4) — AI ตรวจ syntactic + traceability, QC ตรวจ business logic

**Output:**
- ตาราง "TC ID / ปัญหาที่พบ / ระดับ (Must Fix / Should Fix) / ข้อเสนอแนะ"
- Coverage gap report (Requirement ที่ยังไม่มี TC)
- Summary: total TC, must-fix count, should-fix count, approved count

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 3 (Peer Review SIT TC) + Process 7 (Peer Review UAT TC)

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| Review SIT TC ที่ AI/QC เขียน | **`test-case-reviewer`** (mode=sit) |
| Review UAT TC (business view check) | **`test-case-reviewer`** (mode=uat) |
| ยังเขียน TC ไม่เสร็จ | `test-case-writer` ก่อน |
| TC approved แล้ว | `robot/e2e-test-generator` ต่อ |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Test Case file | ✅ | path (MD/CSV จาก `test-case-writer`) |
| SRS / PRD | ✅ | สำหรับ Traceability gap check |
| Mode | ✅ | SIT / UAT |
| Reviewer role | ⚠️ | QC / TL / BA (ใช้แสดงใน report header) |
| `project-context.md` | ⚠️ | business rules, glossary |

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown report

**Template:** [`templates/peer-review-report.md`](templates/peer-review-report.md)

**File naming:** `peer_review_<module>_<YYYYMMDD>.md`

**Structure:**
```
# Peer Review Report — <Module> <Mode>
## Summary
- Total TC: 45
- Must Fix: 3
- Should Fix: 7
- OK: 35
- Coverage Gap: 2 requirements (SRS-REQ-05, SRS-REQ-12)

## Issues Found
| TC ID | ปัญหา | ระดับ | ข้อเสนอแนะ |
|-------|------|------|-----------|
| TC-005 | Expected Result กำกวม ("แสดงผลถูกต้อง") | Must Fix | เปลี่ยนเป็น "แสดง toast 'บันทึกสำเร็จ' + redirect ไป /dashboard" |
| TC-008 | ไม่มี Precondition | Must Fix | เพิ่ม "User 'testuser01' ถูกสร้างใน DB" |
| -     | SRS-REQ-003 (Lock Account) ยังไม่มี TC | Must Fix | เพิ่ม TC ทดสอบ Lock หลัง Login ผิด 5 ครั้ง |
| TC-012 | ขาด Boundary Test (Password length) | Should Fix | เพิ่ม TC password 7 ตัว + 129 ตัว |

## Coverage Gap
- SRS-REQ-05: ... (ยังไม่มี TC)
- SRS-REQ-12: ... (ยังไม่มี TC)

## Sign-off
Reviewer: _____________
Date: _____________
```

---

## 5. Process — ขั้นตอน

### Step 1: Read Input
1. อ่าน Test Case file
2. อ่าน SRS / PRD
3. อ่าน `project-context.md` ถ้ามี

### Step 2: Ask User (ถ้าขาด)
- Mode (SIT / UAT)?
- Reviewer role?

### Step 3: Run Automated Checks

#### A. Syntactic Checks (ทุก TC)
- [ ] มี TC ID unique
- [ ] มี Description
- [ ] มี Precondition
- [ ] มี Test Step (≥ 1 ขั้น)
- [ ] มี Expected Result
- [ ] มี Ref FR ID
- [ ] มี Test Data (redact password)

#### B. Quality Checks
- [ ] Expected Result **วัดได้** — ไม่มี "ทำงานถูกต้อง" / "แสดงผลปกติ" / "ระบบพร้อม"
- [ ] Expected Result ระบุ **state หลังจาก action** (UI message, DB state, API response)
- [ ] Steps ไม่รวบ — แต่ละข้อ 1 action
- [ ] ไม่มี password จริง / PII ใน Test Data

#### C. Coverage Checks (Positive/Negative/Boundary)
สำหรับแต่ละ Requirement:
- [ ] มี Positive TC ≥ 1
- [ ] มี Negative TC ≥ 1 (invalid input, no permission, validation error)
- [ ] ถ้ามี input field → มี Boundary TC (min, max, min-1, max+1)
- [ ] ถ้ามี multiple conditions → มี Decision Table coverage
- [ ] ถ้ามี state machine → มี State Transition TC

#### D. Traceability Gap (ต่อ SRS)
สำหรับแต่ละ FR ใน SRS:
- [ ] มี TC อย่างน้อย 1 ตัวอ้าง FR นี้ใน `Ref FR ID`
- ถ้าไม่มี → **Coverage Gap** (Must Fix)

#### E. UAT-specific (ถ้า mode=uat)
- [ ] TC เป็น Business Scenario (End-to-End)
- [ ] ภาษา Business (ไม่มี API/SQL/log term)
- [ ] Precondition User ทำได้เอง
- [ ] ไม่ใช่ Copy SIT TC มาตรงๆ (check similarity)

### Step 4: จำแนกระดับ

| ปัญหา | ระดับ |
|------|------|
| ไม่มี Expected Result / Steps / Precondition | **Must Fix** |
| Expected Result กำกวม | **Must Fix** |
| Coverage Gap (FR ไม่มี TC) | **Must Fix** |
| UAT ใช้ technical language | **Must Fix** |
| ไม่มี Negative / Boundary TC | **Must Fix** |
| Priority / Severity ไม่ครบ | **Should Fix** |
| Test Sizing ไม่ระบุ | **Should Fix** |
| Automation flag ไม่ระบุ | **Should Fix** |
| Regression TC ขาดบาง edge case | **Should Fix** |

### Step 5: Generate Report + Save

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have (Peer Review Report)
- [ ] Summary ระบุ total TC + must/should/ok count
- [ ] ทุก issue มี TC ID (หรือ "-" ถ้าเป็น coverage gap)
- [ ] ระดับ (Must/Should) จำแนกถูกต้อง
- [ ] ข้อเสนอแนะเฉพาะเจาะจง (ไม่ใช่ "ปรับแก้")
- [ ] Coverage Gap list ครบ (เทียบกับ SRS)
- [ ] Sign-off section (Reviewer name + date ปล่อยว่างให้คน)

### Red Flags (Reject)
- ❌ ไม่เช็ค Traceability (skip SRS cross-check)
- ❌ จำแนกระดับผิด (เช่น Must Fix แต่ใส่เป็น Should Fix)
- ❌ ข้อเสนอแนะกำกวม

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจ **judge Business Logic ผิด** (ไม่รู้ business rule เฉพาะ) → QC ต้องเป็น final reviewer
- ❌ AI อาจ **false positive Coverage Gap** ถ้า FR ID ใน TC อ้างไม่ตรง pattern → ระบุ pattern ชัดใน SRS
- ❌ AI อาจ **เคร่งเกิน** — flag everything → ให้ priority Must/Should ชัด

**ข้อห้าม:**
- ❌ Auto-approve TC โดยไม่มี human reviewer
- ❌ ลบ TC ทิ้งเอง — แค่ flag ให้ QC ตัดสินใจ

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `test-case-writer` — TC ที่เขียนเสร็จ → feed เข้า skill นี้
- SRS / PRD — สำหรับ Traceability gap check

**Downstream:**
- `test-case-writer` (re-edit) — Must Fix issues → แก้ TC
- [Manual approval by QC/TL] — Sign-off
- `robot/e2e-test-generator` — TC approved → automate

**Workflow ตัวอย่าง:**
```
test-case-writer → peer_review_report.md (skill นี้)
                          ├→ [Must Fix] → test-case-writer (re-edit)
                          └→ [all OK] → [QC Sign-off] → automation skills
```

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- `templates/peer-review-report.md`
- SDP §5.1.2 (SIT TC acceptance criteria) + §5.1.5 (UAT TC)
