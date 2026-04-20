# UAT Report — <Module/Scope>

| Field | Value |
|-------|-------|
| Document ID | `UAT_REPORT_<SCOPE>_v1.0` |
| Date | YYYY-MM-DD |
| Test Period | YYYY-MM-DD → YYYY-MM-DD |
| Author | <BA + QC> |
| User Representative | <name> |
| Approver | <User (Customer)> |
| Reference Plan | `UAT_PLAN_<SCOPE>_v1.0` |

---

## 1. Executive Summary

<1-2 ย่อหน้า: ลูกค้ารับหรือไม่รับ + conditional?>

ตัวอย่าง:
> UAT สำหรับ Leave Management เสร็จสิ้น ณ 2026-04-30
> ลูกค้าทดสอบครบ 15 Scenarios — Pass Rate 100%
> ไม่มี Critical/Major Bug — Minor 2 ตัวจะแก้ใน Maintenance
>
> **User Sign-off:** ✅ Approved
> **Recommendation:** Go-Live ตาม schedule (2026-05-05)

---

## 2. User Participation

| Role | User Name | Scenarios Tested | Pass | Fail |
|------|-----------|-----------------:|-----:|-----:|
| Employee | <name 1> | 5 | 5 | 0 |
| Manager | <name 2> | 4 | 4 | 0 |
| HR Admin | <name 3> | 4 | 4 | 0 |
| Finance | <name 4> | 2 | 2 | 0 |
| **Total** | - | **15** | **15** | **0** |

---

## 3. Test Execution Summary

| Metric | Count |
|--------|------:|
| Total Scenarios | 15 |
| ✅ Pass | 15 |
| ❌ Fail | 0 |
| 🚫 Blocked | 0 |
| Pass Rate | **100%** |

### By Business Process

| Business Process | Scenarios | Pass Rate |
|------------------|----------:|----------:|
| ยื่นใบลา → อนุมัติ → บันทึก | 6 | 100% |
| ขอเบิกค่าเดินทาง → อนุมัติ | 5 | 100% |
| Report ลา/เบิก | 4 | 100% |

---

## 4. Exit Criteria Evaluation

| # | Criterion | Target | Actual | Status |
|---|-----------|--------|--------|:------:|
| 1 | ทุก UAT Scenario execute | 100% | 100% | ✅ |
| 2 | User Pass Rate | ≥ 95% | 100% | ✅ |
| 3 | Critical Bug (Open) | = 0 | 0 | ✅ |
| 4 | User Sign-off | Approved | Approved | ✅ |

**Overall:** ✅ All Criteria Met

---

## 5. Defect Summary

| Severity | Count | Status |
|----------|------:|--------|
| Critical | 0 | - |
| Major | 0 | - |
| Minor | 2 | 1 Open, 1 Deferred |

### Minor Defects Detail

| Bug ID | Summary | Status | Resolution Plan |
|--------|---------|--------|----------------|
| AYO-1301 | Dropdown เดือน ไม่มี "สิงหาคม" ตัวเลือก | Open | Fix ใน Sprint 2026-S09 |
| AYO-1305 | ข้อความ "Submit" ไม่แปลเป็น "ส่ง" บางหน้า | Deferred | Maintenance Phase (i18n refactor) |

---

## 6. User Feedback (Qualitative)

| User | Feedback |
|------|----------|
| <name 1> | "ใช้งานง่าย interface ดี, แต่ตอนอนุมัติใบลา notification ช้านิดนึง" |
| <name 2> | "Export Excel ใช้ได้ดี, เสนอให้เพิ่ม filter ตาม department" |

**Feedback → Backlog:** 2 items (improvement, ไม่ block Go-Live)

---

## 7. Conclusion + Recommendation

### 7.1 Conclusion
- ✅ UAT ผ่าน 100% — User approve
- ✅ Ready for Production Deployment
- ℹ️ Minor bug 2 ตัว (1 แก้ sprint หน้า, 1 deferred)
- ℹ️ User feedback 2 ข้อ → เพิ่มใน Backlog สำหรับ Phase 2

### 7.2 Recommendation
1. **Go-Live** 2026-05-05 ตาม schedule
2. **Release Note:** แจ้ง User เรื่อง Minor bugs + roadmap
3. **Post Go-Live:** Monitor 2 สัปดาห์แรก, prepare hotfix plan

---

## 8. User Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| User Representative (Customer) | | | |
| Department Head | | | |
| PM | | | |
| QC Lead | | | |

**Sign-off Type:** ☑ Approved   ☐ Approved with Conditions   ☐ Rejected

**Conditions (ถ้ามี):**
- N/A
