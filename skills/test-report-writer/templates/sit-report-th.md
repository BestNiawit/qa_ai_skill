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

> Severity ใช้ qa-standards §1 — **S1 Critical / S2 Major / S3 Minor / S4 Cosmetic** (ห้าม Blocker/Trivial)

### 4.1 By Severity × Status

| Severity | Open | In Progress | Fixed | Verified | Deferred | Total |
|----------|-----:|------------:|------:|---------:|---------:|------:|
| S1 Critical | 0 | 0 | 0 | 2 | 0 | 2 |
| S2 Major | 0 | 0 | 0 | 5 | 0 | 5 |
| S3 Minor | 3 | 0 | 1 | 4 | 2 | 10 |
| S4 Cosmetic | 0 | 0 | 0 | 1 | 0 | 1 |
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

## 6. S1 / S2 Open Bugs
**ไม่มี** — ทุก S1 Critical/S2 Major bug ถูก Verified แล้ว ✅

---

## 7. Estimate vs Actual (Hours)

> อ้างอิง: `references/qa-standards.md §4 Buffer Policy` — feedback loop ไปปรับ Sizing Scale sprint ถัดไป

| Phase | Estimated (Plan) | Actual | Variance | Note |
|-------|-----------------:|-------:|---------:|------|
| Test Prep | 2.5 hr | 2.0 hr | -20% | env setup เร็วกว่าคาด |
| Peer Review | 1.25 hr | 1.5 hr | +20% | reviewer เจอ gap เพิ่ม 3 TC |
| Execution Cycle 1 | 11.31 hr | 14.8 hr | **+31%** ⚠️ | 5 TC sizing M จริงใช้เวลา L — refine |
| Defect Fix + Retest | 3.39 hr | 4.0 hr | +18% | |
| Execution Cycle 2 | 2.26 hr | 2.0 hr | -12% | |
| Report + Sign-off | 4.0 hr | 1.5 hr | -62% | ใช้ AI draft — ตรงตาม plan |
| **Total** | **24.71 hr** | **25.8 hr** | **+4%** | overall ใกล้ plan |

**Variance Analysis:**
- 🟢 Overall variance +4% — อยู่ในเกณฑ์ ±30%
- ⚠️ Execution Cycle 1 variance +31% → **action: upgrade sizing ของ 5 TC `<list>` จาก M → L ในโปรเจคถัดไป**
- 🟢 Report phase ประหยัด 62% จาก AI-assisted

---

## 8. AI Effort Savings (KPI)

> อ้างอิง: `references/qa-standards.md §6` — เป้าทีม: ลด manual effort ด้วย AI

| Artifact | AI Draft | Human Review | Total | Manual Baseline | Savings |
|----------|---------:|-------------:|------:|----------------:|--------:|
| SIT Plan | 30 min | 3.5 hr | 4 hr | 8 hr | **50%** ✅ |
| SIT Test Case (60 TC) | 1 hr | 11 hr | 12 hr | 24 hr | **50%** ✅ |
| Peer Review | 5 min | 2.5 hr | 2.6 hr | 4.3 hr | **40%** ✅ |
| SIT Report (this doc) | 15 min | 1.25 hr | 1.5 hr | 4 hr | **62%** ✅ |
| Bug Reports (18 bugs) | 30 min | 2.5 hr | 3 hr | 5 hr | **40%** ✅ |
| **Total** | **2.33 hr** | **20.75 hr** | **23.1 hr** | **45.3 hr** | **49%** |

**Skills ที่ใช้:**
- `test-plan-writer`, `test-case-writer`, `test-case-reviewer`, `test-report-writer`, `bug-report-writer`

**ข้อสังเกต:**
- Savings 49% ≈ เป้า qa-standards §6 (50%) — ✅ Pass
- Bottleneck: Peer Review ยังพึ่ง human มาก (96% ของ time) — consider automated checklist enhancement

---

## 9. Risk & Mitigation (ที่เหลือ)

| Risk | Mitigation | Owner |
|------|-----------|-------|
| UAT User ยังไม่ได้ training | Schedule training 2026-04-22 | BA |
| Minor bug 3 ตัว อาจ confuse User | Mention ใน UAT kickoff; prepare workaround | QC |

---

## 10. Conclusion + Recommendation

### 10.1 Conclusion
- ✅ SIT Phase 1 passed all Exit Criteria
- ✅ ระบบพร้อมเข้า UAT Phase
- ⚠️ มี 3 Minor Open Bug ที่ User จะเจอ — ต้องสื่อสารล่วงหน้า
- ✅ Effort variance +4% (อยู่ในเกณฑ์), AI savings 49% (ตามเป้าทีม)

### 10.2 Recommendation
1. **Go to UAT** ตาม schedule (2026-04-22)
2. **ก่อน UAT Kickoff:** Brief User เรื่อง 3 Minor bugs + workaround
3. **Minor bugs:** Plan แก้ใน Maintenance Phase (Sprint 2026-S10)
4. **Sizing refinement:** upgrade 5 TC จาก M → L ใน template ของ module ถัดไป (variance +31% ใน Cycle 1)

---

## 11. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QC Lead | | | |
| TL | | | |
| PM | | | |

**Attachments:**
- Full Test Execution Log: `<path>`
- Jira Defect Query: `<JQL link>`
- Traceability Matrix: `<path>`
