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

| Phase | Start | End | Duration |
|-------|-------|-----|----------|
| Test Prep | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Test Execution (Cycle 1) | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Defect Fix + Retest | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Test Execution (Cycle 2) | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Report + Sign-off | YYYY-MM-DD | YYYY-MM-DD | <days> |

## 9. Risk & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Environment ไม่เสถียร | Medium | High | มี backup env; coordinate กับ DevOps |
| Test data ไม่พร้อม | Medium | Medium | Prepare 1 week before; มี data refresh script |
| Requirement เปลี่ยน | Low | High | Freeze scope before SIT; BA sign-off |
| Dev late | Medium | High | Weekly sync; re-baseline ถ้าจำเป็น |

## 10. Defect Management

- **Tool:** Jira (Project: `<PROJECT_KEY>`)
- **Severity:** S1 Critical / S2 Major / S3 Minor / S4 Cosmetic
- **Priority:** P0 / P1 / P2 / P3
- **Status flow:** Open → In Progress → Fixed → Ready to Retest → Verified / Reopened

**SLA:**
- S1: fix within 1 day
- S2: fix within 3 days
- S3: fix within current sprint
- S4: best effort

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
