# SIT Report — <Module/Scope>

| Field | Value |
|-------|-------|
| Document ID | `SIT_REPORT_<SCOPE>_v1.0` |
| Date | YYYY-MM-DD |
| Test Period | YYYY-MM-DD → YYYY-MM-DD |
| Author | <QC Lead> |
| Reviewer | <TL> |
| Approver | <PM> |
| Reference Plan | `SIT_PLAN_<SCOPE>_v1.0` |

---

## 1. Executive Summary

<1-2 ย่อหน้า สรุป: SIT ผ่าน/ไม่ผ่าน + Recommendation ชัดเจน>

ตัวอย่าง:
> SIT Phase 1 สำหรับ Module Leave Management เสร็จสิ้น ณ 2026-04-20
> Pass Rate 96.7% (58/60 TC) — ผ่าน Exit Criteria ทั้ง 5 ข้อ
> Critical/Major Open Bug = 0, Minor Open Bug = 3 (ยอมรับได้)
>
> **Recommendation:** ✅ Ready to proceed UAT Phase

---

## 2. Test Execution Summary

| Metric | Count | % |
|--------|------:|---:|
| Total TC | 60 | 100% |
| ✅ Pass | 58 | 96.7% |
| ❌ Fail | 1 | 1.7% |
| 🚫 Blocked | 1 | 1.7% |
| ⏭️ Skipped | 0 | 0% |
| 🕐 Not Run | 0 | 0% |

**Pass Rate:** 96.7% (58 / 60)

### Execution by Module

| Module | Total | Pass | Fail | Block | Pass Rate |
|--------|------:|-----:|-----:|------:|----------:|
| Leave Request | 25 | 24 | 1 | 0 | 96% |
| Approval Flow | 20 | 20 | 0 | 0 | 100% |
| Leave Balance | 15 | 14 | 0 | 1 | 93% |

---

## 3. Exit Criteria Evaluation

| # | Criterion | Target | Actual | Status |
|---|-----------|--------|--------|:------:|
| 1 | Test Case Execution | 100% | 100% | ✅ |
| 2 | Pass Rate | ≥ 95% | 96.7% | ✅ |
| 3 | Critical Bug (Open) | = 0 | 0 | ✅ |
| 4 | Major Bug (Open) | = 0 | 0 | ✅ |
| 5 | Minor Bug (Open) | ≤ 5 | 3 | ✅ |

**Overall:** ✅ All Criteria Met

---

## 4. Defect Summary

### 4.1 By Severity × Status

| Severity | Open | In Progress | Fixed | Verified | Deferred | Total |
|----------|-----:|------------:|------:|---------:|---------:|------:|
| Critical | 0 | 0 | 0 | 2 | 0 | 2 |
| Major | 0 | 0 | 0 | 5 | 0 | 5 |
| Minor | 3 | 0 | 1 | 4 | 2 | 10 |
| Cosmetic | 0 | 0 | 0 | 1 | 0 | 1 |
| **Total** | **3** | **0** | **1** | **12** | **2** | **18** |

### 4.2 By Module

| Module | Total Defect | Open | Fix Rate |
|--------|-------------:|-----:|---------:|
| Leave Request | 8 | 1 | 87.5% |
| Approval Flow | 6 | 1 | 83.3% |
| Leave Balance | 4 | 1 | 75% |

---

## 5. Deferred Bugs

| Bug ID | Summary | Severity | Reason for Defer | Approved By |
|--------|---------|----------|-----------------|-------------|
| AYO-1234 | UI text ภาษาอังกฤษตกหล่น 2 จุด | Minor | จะแก้ใน Maintenance Phase ร่วมกับ i18n refactor | PM (2026-04-18) |
| AYO-1287 | Pagination load ช้า 1.5s (>1s เป้า) | Minor | ยังผ่านเกณฑ์ UX, แก้ใน Perf Tuning Phase | PM (2026-04-19) |

---

## 6. Critical / Major Open Bugs
**ไม่มี** — ทุก Critical/Major bug ถูก Verified แล้ว ✅

---

## 7. Risk & Mitigation (ที่เหลือ)

| Risk | Mitigation | Owner |
|------|-----------|-------|
| UAT User ยังไม่ได้ training | Schedule training 2026-04-22 | BA |
| Minor bug 3 ตัว อาจ confuse User | Mention ใน UAT kickoff; prepare workaround | QC |

---

## 8. Conclusion + Recommendation

### 8.1 Conclusion
- ✅ SIT Phase 1 passed all Exit Criteria
- ✅ ระบบพร้อมเข้า UAT Phase
- ⚠️ มี 3 Minor Open Bug ที่ User จะเจอ — ต้องสื่อสารล่วงหน้า

### 8.2 Recommendation
1. **Go to UAT** ตาม schedule (2026-04-22)
2. **ก่อน UAT Kickoff:** Brief User เรื่อง 3 Minor bugs + workaround
3. **Minor bugs:** Plan แก้ใน Maintenance Phase (Sprint 2026-S10)

---

## 9. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QC Lead | | | |
| TL | | | |
| PM | | | |

**Attachments:**
- Full Test Execution Log: `<path>`
- Jira Defect Query: `<JQL link>`
- Traceability Matrix: `<path>`
