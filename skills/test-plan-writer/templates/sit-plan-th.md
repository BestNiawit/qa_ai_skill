# SIT Plan — <Module/Scope>

| Field | Value |
|-------|-------|
| Document ID | `SIT_PLAN_<SCOPE>_v1.0` |
| Version | 1.0 |
| Date | YYYY-MM-DD |
| Author | <QC Lead> |
| Reviewer | <TL> |
| Approver | <PM> |

---

## 1. Objective
<เป้าหมายของการทดสอบ SIT — ต้องการยืนยันอะไร?>

## 2. Scope

### 2.1 In-Scope
- Module: <Module A> (SRS-REQ-001..015)
- Module: <Module B> (SRS-REQ-030..042)
- Integration: <A ↔ B>

### 2.2 Out-of-Scope
- Module: <Module C> (Phase 2)
- Performance Testing (แยก Plan)

## 3. Entry Criteria
1. Dev complete 100% ของ Feature ใน Scope (Jira Status = Done)
2. SIT Environment พร้อม (Server: <IP>, DB: <DB name + version>)
3. Test Data prepared ตาม `<Test Data Sheet path>`
4. Smoke Test ผ่าน 100% (ทดสอบ <list>)

## 4. Exit Criteria
1. Test Case Execution ≥ 100% (ไม่มี Not Run)
2. Pass Rate ≥ 95%
3. Critical Bug (Open) = 0
4. Major Bug (Open) = 0 หรือ Defer พร้อมเหตุผลที่ PM อนุมัติ
5. Minor Bug (Open) ≤ 5

## 5. Test Approach
- **Functional Testing** — ทุก Feature ใน Scope
- **Integration Testing** — ทดสอบการทำงานร่วมกันระหว่าง Module
- **Regression Testing** — Feature ที่ได้รับผลกระทบจาก code change
- **Smoke Testing** — ก่อนเริ่ม SIT ทุกวัน

## 6. Test Environment

| รายการ | รายละเอียด |
|-------|-----------|
| Server | <IP + OS + version> |
| Application Server | <Tomcat/Nginx + version> |
| Database | <Oracle/MySQL + version + DB name> |
| Browser | <Chrome 120+, Edge 120+> |
| URL | <https://sit.example.com> |
| Test Tool | <Jira / TestRail / Excel> |

## 7. Roles & Responsibilities

| Role | Responsibility | Person |
|------|---------------|--------|
| QC Lead | Plan, coordinate, report | <name> |
| QC | Execute TC, log defect | <names> |
| TL | Code review, unblock | <name> |
| Dev | Fix defect | <names> |
| PM | Approve deferral, sign-off | <name> |
| BA | Clarify requirement | <name> |

## 8. Schedule

> คำนวณตาม `references/qa-standards.md §4 Buffer Policy` — consume Sizing Summary จาก Test Case file

### 8.1 Input จาก Test Case Sizing Summary

| Source | Value |
|--------|-------|
| Test Case file | `<path>` |
| Total TC | <n> |
| Σ Execution Effort (sum of midpoints) | **<total_hr> hr** |
| Testers (parallel) | <n> (default 1) |
| Productive hr/tester/day | 6 (qa-standards §5) |

### 8.2 Effort Breakdown (hrs)

| Phase | Formula | Hours |
|-------|---------|------:|
| Test Prep | Total TC × 0.1 | <hr> |
| Peer Review | Total TC × 0.05 | <hr> |
| Execution Cycle 1 | Σ Sizing | <hr> |
| Defect Fix + Retest | Execution × 0.30 | <hr> |
| Execution Cycle 2 (Regression) | Execution × 0.20 | <hr> |
| Report + Sign-off | fixed | 4 |
| **SubTotal** | | **<hr>** |
| Buffer | SubTotal × 0.20 | <hr> |
| **Total Planned Hours** | | **<hr>** |
| **Calendar Days** | Total / (testers × 6) | **<days>** |

### 8.3 Calendar Schedule (Phase-level)

| Phase | Start | End | Duration (days) |
|-------|-------|-----|:---------------:|
| Test Prep | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Peer Review TC | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Test Execution (Cycle 1) | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Defect Fix + Retest | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Test Execution (Cycle 2) | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Report + Sign-off | YYYY-MM-DD | YYYY-MM-DD | <days> |

### 8.4 Sprint Tracking (Task-level)

> ใช้ควบคู่กับไฟล์ `sprint-tracking-th.csv` (Excel) — track Est vs Actual hours รายสัปดาห์
> Columns ที่ต้องมี: Task ID, Task Name, Req/Module Ref, TC Count, Sizing Mix, **Est Hours, Actual Hours, Variance %, AI-Assisted**, Owner, Plan/Actual Start-End, Status, Remark, Linked Bugs

```
ดู template: ./sprint-tracking-th.csv
```

**Rules:**
- Task name ≤ 60 chars — ใส่ context ยาวใน Req/Module Ref แทน
- Variance > ±30% → flag ใน Remark + พิจารณา refine Sizing Scale ต่อ sprint ถัดไป
- AI-Assisted column บันทึกชื่อ skill ที่ใช้ (เช่น `AI-Assisted (test-case-writer)`)
- Status task-level: Todo / In-progress / Done / Blocked (ไม่ใช่ Passed — Passed ใช้ sprint-level summary)

> **Note:** ถ้ามีการเปลี่ยน Sizing ของ TC → re-run test-plan-writer ให้ refresh Schedule
> Actual hours จะถูกเก็บใน Test Report section "Estimate vs Actual" → feedback refine sizing scale

## 9. Risk & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Environment ไม่เสถียร | Medium | High | มี backup env; coordinate กับ DevOps |
| Test data ไม่พร้อม | Medium | Medium | Prepare 1 week before; มี data refresh script |
| Requirement เปลี่ยน | Low | High | Freeze scope before SIT; BA sign-off |
| Dev late | Medium | High | Weekly sync; re-baseline ถ้าจำเป็น |

## 10. Defect Management

> ใช้ scale ตาม `references/qa-standards.md §1-§2` (อ้างอิง Ayodia TEST DEFINITION template)

- **Tool:** Jira (Project: `<PROJECT_KEY>`)
- **Severity:** Critical / Major / Minor / Trivial (qa-standards §2)
- **Priority:** Critical / High / Medium / Low (qa-standards §1)
- **Action Label:** อ้าง Severity × Priority Matrix (qa-standards §2.1) — Blocker / Urgent / Standard High / Manageable / ...
- **Status flow:** Open → In Progress → Fixed → Ready to Retest → Verified / Reopened

**SLA (SIT):**

- Severity Critical: fix ≤ 1 วันทำการ
- Severity Major: fix ≤ 2 วันทำการ
- Severity Minor: fix ใน sprint
- Severity Trivial: best effort

## 11. Traceability
ดู `traceability_matrix_<scope>.csv` — map SRS Requirement ↔ SIT Test Case

## 12. Test Data Preparation Plan
- Test Data Sheet: `<path>`
- Preparation Owner: <QC name>
- Refresh schedule: <daily / weekly>
- PII masking: <strategy>

## 13. Suspension & Resumption Criteria

**Suspend:**
- Environment ล่ม > 4 ชั่วโมง
- Critical Bug block > 30% ของ TC

**Resume:**
- Environment restored + smoke test ผ่าน
- Critical Bug fixed + verified

## 14. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QC Lead | | | |
| TL | | | |
| PM | | | |
