---
name: test-matrix-generator
description: สร้าง test matrix แบบ compact (CSV) เพื่อครอบคลุม scope เร็วๆ ตอนเขียน full test case ไม่ทัน — รองรับ 3 matrix หลัก Coverage (Requirement × Scenario), Combination (Pairwise input), Platform (Feature × Browser/OS/Device). Trigger เมื่อ user ขอ test matrix, coverage matrix, pairwise matrix, compatibility matrix, "ไม่ทันเขียน test case", "ขอ matrix แทน", "generate test matrix", "pairwise testing".
---

# Test Matrix Generator

## เป้าหมาย
สร้าง test matrix แบบ **compact** ให้ QA ได้ coverage เร็ว เมื่อเขียน full test case ไม่ทัน
- ได้ไฟล์ CSV ใช้ต่อใน Excel/Sheets/Jira ทันที
- ไม่ต้องเขียน steps/expected แบบเต็ม — ใช้เป็นโครงขยายเป็น full TC ทีหลังได้
- ประหยัดเวลา + ประหยัด token (output สั้น, ตารางเดียวจบ)

## เมื่อไหร่ใช้ skill นี้ (vs test-case-writer)

| สถานการณ์ | ใช้ |
|-----------|-----|
| มีเวลา, ต้องการ TC พร้อมรัน | `test-case-writer` |
| รีบ, ต้องการ coverage ก่อน, รายละเอียดเขียนทีหลัง | **`test-matrix-generator`** ← skill นี้ |
| ต้องการดู combination ของ input ว่าครบมั้ย | **`test-matrix-generator`** (Combination) |
| ทดสอบ cross-browser/cross-device | **`test-matrix-generator`** (Platform) |
| Requirement เยอะ อยากเช็ค coverage | **`test-matrix-generator`** (Coverage) |

## 3 Matrix Types

### A. Coverage Matrix — Requirement × Scenario
ใช้เมื่อมี requirement หลายข้อ อยากเช็คว่า scenario ที่คิดไว้ครอบคลุมครบมั้ย
- แถว = Requirement ID
- คอลัมน์ = Scenario/Test ID
- Cell = `✓` ถ้า scenario นั้นคุม req ข้อนั้น, `-` ถ้าไม่เกี่ยว
- Template: `templates/coverage-matrix.csv`

### B. Combination Matrix — Pairwise Inputs
ใช้เมื่อมี input หลายตัว แต่ละตัวมีหลายค่า → combination ระเบิด ใช้ pairwise ลดเหลือ combinations ที่ครอบคลุม pair ทุกคู่
- ขั้นตอน:
  1. ระบุ parameters + values (เช่น Browser: Chrome/Firefox/Safari; Device: Desktop/Mobile; Role: Admin/User/Guest)
  2. สร้าง pairwise combinations (ไม่ต้อง full cartesian) — ใช้ All-Pairs algorithm
  3. แต่ละแถว = 1 test combination
- Template: `templates/combination-matrix.csv`

**Pairwise algorithm (manual):**
- ถ้า parameters ≤ 3 ตัว ค่าละ ≤ 3 → full cartesian product (`n × m × k`) ก็พอ
- ถ้ามากกว่านั้น → ใช้ pairwise (cover ทุก pair อย่างน้อย 1 ครั้ง) — แนะนำใช้ tool เช่น PICT / ACTS ถ้า combinations > 50 แถว
- เมื่อไม่แน่ใจ เขียน cartesian ก่อนแล้วแจ้ง user ว่า "ถ้าต้องการ pairwise ลดขนาด แจ้งกลับ"

### C. Platform Matrix — Feature × Browser/OS/Device
ใช้ตอน cross-platform testing — ทดสอบว่า feature ไหนต้องทำบน combination ของ browser/OS/device ไหนบ้าง
- แถว = Feature / Test scenario
- คอลัมน์ = Platform combo (เช่น `Chrome/Win11`, `Safari/iOS17`, `Firefox/macOS`)
- Cell = `✓` = ต้องทดสอบ, `-` = ไม่เกี่ยว, `P1/P2/P3` = priority
- Template: `templates/platform-matrix.csv`

## ขั้นตอน

### 1. ถาม user ถ้ายังไม่ชัด (ให้น้อยที่สุด)
- **Matrix ไหน:** Coverage / Combination / Platform (เลือกได้หลายอัน)
- **Input ต้นทาง:** requirement file path / feature list / input parameters?
- **Scope:** เฉพาะ flow ไหน / feature ไหน

อย่าถามภาษา — output เป็น CSV, column header ใช้ไทยหรืออังกฤษตาม input ที่ user ส่งมา

### 2. อ่าน / รวบรวมข้อมูล
- ถ้ามี requirement file → อ่านก่อน (ครั้งเดียว) สรุป req IDs
- ถ้า user พิมพ์รายการมา → ใช้ตามนั้น ไม่ต้องให้ขยาย

### 3. สร้าง Matrix ตาม Template
- Copy structure จาก `templates/<matrix-type>.csv`
- **ห้ามใส่ column ที่ไม่จำเป็น** (เช่น Steps, Expected) — skill นี้ไม่ใช่ TC writer
- ถ้าทำหลาย matrix พร้อมกัน → แยกไฟล์คนละ CSV

### 4. บันทึกไฟล์
Naming:
- `matrix_coverage_<feature>_<YYYYMMDD>.csv`
- `matrix_combination_<feature>_<YYYYMMDD>.csv`
- `matrix_platform_<feature>_<YYYYMMDD>.csv`

### 5. แจ้ง user (สั้นๆ)
- สรุปจำนวนแถว/คอลัมน์ของ matrix
- ชี้ gap ที่เห็น (เช่น "Req-05 ยังไม่มี scenario คุม", "Safari บน Windows ไม่ได้ทดสอบ — ปกติ Safari มีบน macOS/iOS เท่านั้น")
- เสนอต่อถ้าต้องการขยายเป็น full TC → ใช้ `test-case-writer`

## Quality Checklist
- [ ] CSV header ครบและตรงกับ template
- [ ] ไม่มี cell ว่าง — ใช้ `-` หรือ `N/A` แทน
- [ ] Coverage: ทุก requirement มีอย่างน้อย 1 scenario คุม (ถ้ามี gap → highlight)
- [ ] Combination: ระบุ parameters + values ชัด ไม่ผสมหลายตัวในคอลัมน์เดียว
- [ ] Platform: combo platform สมเหตุสมผล (เช่น Safari ไม่มีบน Windows)
- [ ] File naming ตาม convention
- [ ] ไม่เขียน steps/expected แบบ full TC (ผิด scope)

## ข้อห้าม
- ❌ อย่าเขียน full test case — skill นี้คือ matrix (สั้น, compact) เท่านั้น
- ❌ อย่า over-engineer — ถ้ามี param 2 ตัว ไม่ต้องทำ pairwise, ใช้ cartesian ตรงๆ
- ❌ อย่าเดา requirement ถ้าไม่มีไฟล์ — ถาม user ให้ระบุมา
- ❌ อย่าผสม matrix หลายประเภทในไฟล์เดียว — แยก CSV

## ตัวอย่างการใช้งาน

**Input:**
```
ช่วยทำ coverage matrix จาก docs/login-requirement.md
จะได้เห็นว่า scenario ที่วางไว้ครอบคลุม req ครบมั้ย
```

**Output:**
- ไฟล์ `matrix_coverage_login_20260420.csv`
- ข้อความสรุป: "Matrix มี 8 requirement × 12 scenario. Req-03 (password reset via SMS) ยังไม่มี scenario คุม แนะนำเพิ่ม TC-013"

---

**Input:**
```
ขอ pairwise matrix สำหรับ form สมัครสมาชิก:
- Age group: under-18, 18-60, over-60
- Country: TH, US, JP
- Plan: free, pro, enterprise
- Payment: credit card, bank transfer, wallet
```

**Output:**
- ไฟล์ `matrix_combination_signup_20260420.csv` (ประมาณ 9-12 combinations แทน 81)
- แจ้ง: "Pairwise ลดจาก 81 → 11 combinations ครอบคลุมทุก pair"
