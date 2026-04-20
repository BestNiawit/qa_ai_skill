# Peer Review Report — <Module> <Mode>

| Field | Value |
|-------|-------|
| TC File | `<path>` |
| SRS | `<path>` |
| Mode | SIT / UAT |
| Reviewer | <name + role: QC/TL/BA> |
| Review Date | YYYY-MM-DD |

---

## Summary

| Metric | Count |
|--------|------:|
| Total TC | <N> |
| ✅ OK (no issue) | <N> |
| ⚠️ Should Fix | <N> |
| ❌ Must Fix | <N> |
| 🚨 Coverage Gap (SRS-REQ without TC) | <N> |

**Approval Status:** ☐ Approved   ☐ Approved with Must-Fix   ☐ Rejected

---

## Issues Found

| # | TC ID | Category | ปัญหาที่พบ | ระดับ | ข้อเสนอแนะ |
|---|-------|----------|-----------|-------|-----------|
| 1 | TC_LOGIN_005 | Quality | Expected Result กำกวม ("แสดงผลถูกต้อง") | Must Fix | เปลี่ยนเป็น "แสดง toast 'บันทึกสำเร็จ' สีเขียว + redirect ไป /dashboard" |
| 2 | TC_LOGIN_008 | Content | ไม่มี Precondition | Must Fix | เพิ่ม "User 'testuser01' ถูกสร้างแล้วใน DB" |
| 3 | - | Coverage | SRS-REQ-003 (Lock Account) ยังไม่มี TC | Must Fix | เพิ่ม TC ทดสอบ Lock หลัง Login ผิด 5 ครั้ง |
| 4 | TC_LOGIN_012 | Coverage | ขาด Boundary Test สำหรับ Password length | Should Fix | เพิ่ม TC password 7 ตัว (below min) + 129 ตัว (above max) |
| 5 | TC_LOGIN_015 | Document | ไม่ระบุ Automation flag | Should Fix | ใส่ Yes / No / Candidate / N/A |

**Category legend:**
- **Quality** — Expected Result กำกวม, steps รวบ
- **Content** — ขาด Precondition / Test Data / Positive-Negative
- **Coverage** — ขาด Boundary / Edge / FR gap
- **Document** — ขาด Priority / Severity / Automation / Ref FR ID
- **Traceability** — FR ID ชี้ไปที่ไม่มีใน SRS
- **UAT Business View** — ใช้ technical language (เฉพาะ mode=uat)

---

## Coverage Gap (Requirement without TC)

| SRS ID | Requirement Summary | Recommended TC |
|--------|---------------------|----------------|
| SRS-REQ-003 | Lock account after 5 failed logins | TC ทดสอบ Lock logic + error message |
| SRS-REQ-012 | Password must have uppercase + number + special | TC password ไม่มี uppercase, ไม่มี number, ไม่มี special |

---

## Automated Check Summary

### A. Syntactic Checks
| Check | Pass | Fail | Fail Rate |
|-------|-----:|-----:|----------:|
| TC ID unique | 45 | 0 | 0% |
| มี Description | 45 | 0 | 0% |
| มี Precondition | 43 | 2 | 4.4% |
| มี Test Step | 45 | 0 | 0% |
| มี Expected Result | 45 | 0 | 0% |
| มี Ref FR ID | 44 | 1 | 2.2% |

### B. Quality Checks
| Check | Pass | Fail |
|-------|-----:|-----:|
| Expected Result วัดได้ | 42 | 3 |
| ไม่มี password จริงใน Test Data | 45 | 0 |
| Steps ไม่รวบ | 44 | 1 |

### C. Coverage
| Check | Count | Note |
|-------|------:|------|
| Positive TC count | 20 | ≥ 1 ต่อ Req: ✅ |
| Negative TC count | 18 | ≥ 1 ต่อ Req: ✅ |
| Boundary TC count | 5 | มี 2 Req ที่ขาด |
| Edge case TC | 2 | Nice to have |

### D. Traceability
| SRS Requirements | Covered | Gap |
|-----------------:|--------:|----:|
| 15 | 13 | 2 |

---

## Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Reviewer | | | |
| TC Author | | | |
| QC Lead | | | |

**หลัง Must-Fix แก้เสร็จ → Re-review → Final Approval**
