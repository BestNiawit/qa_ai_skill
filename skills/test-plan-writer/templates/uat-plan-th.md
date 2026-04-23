# UAT Plan — <Module/Scope>

| Field | Value |
|-------|-------|
| Document ID | `UAT_PLAN_<SCOPE>_v1.0` |
| Version | 1.0 |
| Date | YYYY-MM-DD |
| Author | <BA + QC Lead> |
| Reviewer | <PM + User Representative> |
| Approver | <User (Customer)> |

---

## 1. Objective
<เป้าหมาย UAT — ต้องการให้ User ยืนยันว่าระบบตอบโจทย์ Business requirement>

## 2. Scope

### 2.1 In-Scope (Business Process)
- **Process:** รับคำขอลา → หัวหน้าอนุมัติ → HR บันทึก (Leave Management)
- **Process:** ขออนุมัติเบิกค่าเดินทาง → Finance อนุมัติ → โอนเงิน (Expense Claim)

### 2.2 Out-of-Scope
- Admin configuration (ทำใน Super Admin ไม่ใช่ User)
- Performance / Load testing

## 3. Entry Criteria
1. SIT ผ่านแล้ว — Pass Rate ≥ 95%, Severity Critical/Major Bug (Open) = 0
2. UAT Environment พร้อม (URL: <https://uat.example.com>)
3. UAT Test Case ได้รับการ confirm จาก User
4. User Tester มีบัญชี + training แล้ว
5. Test Data (dummy data ใน UAT env) prepared

## 4. Exit Criteria
1. ทุก UAT Test Case ถูก execute
2. User Pass Rate ≥ 95%
3. Severity Critical Bug (Open) = 0
4. User Sign-off (approval / conditional with defined conditions)

## 5. Test Approach
- **Scenario-based testing** — End-to-End business flow (ไม่ใช่ feature-by-feature)
- **Real-world data** — ใช้ dummy data ที่คล้าย production
- **User-driven** — User เป็นคนทดสอบเอง, QC/BA support

## 6. Test Environment

| รายการ | รายละเอียด |
|-------|-----------|
| URL | <https://uat.example.com> |
| Browser | Chrome 120+, Edge 120+ (ตาม User) |
| Test Accounts | <ระบุ 3-5 accounts + role> |
| Support Contact | <QC/BA name + channel> |

## 7. User Testers

| Role | User Name | Department | Scenarios |
|------|-----------|-----------|-----------|
| Employee | <name> | HR | ยื่นใบลา, ขอเบิก |
| Manager | <name> | Sales | อนุมัติใบลาทีม |
| HR Admin | <name> | HR | จัดการใบลา |
| Finance | <name> | Finance | อนุมัติเบิก |

## 8. Schedule

> คำนวณจาก UAT TC Sizing Summary + Buffer Policy (`references/qa-standards.md §4`)
> ใช้ `sprint-tracking-th.csv` track Est vs Actual hours ระดับ task

### 8.1 Effort Breakdown (hrs)

| Phase | Formula | Hours |
|-------|---------|------:|
| User Training | fixed | 4 |
| UAT Execution | Σ UAT TC Sizing | <hr> |
| Defect Fix + Retest | Execution × 0.25 | <hr> |
| UAT Re-test | Execution × 0.15 | <hr> |
| Report + Sign-off | fixed | 4 |
| **SubTotal** | | **<hr>** |
| Buffer | SubTotal × 0.20 | <hr> |
| **Total Planned Hours** | | **<hr>** |

### 8.2 Calendar Schedule

| Phase | Start | End | Duration |
|-------|-------|-----|----------|
| User Training | YYYY-MM-DD | YYYY-MM-DD | <days> |
| UAT Execution | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Defect Fix (if any) | YYYY-MM-DD | YYYY-MM-DD | <days> |
| UAT Re-test | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Sign-off | YYYY-MM-DD | YYYY-MM-DD | <day> |

## 9. Risk & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| User ไม่มีเวลาทดสอบ | Medium | High | Schedule ล่วงหน้า, แจ้งหัวหน้า User, เปลี่ยน tester ได้ |
| User ไม่เข้าใจระบบ | Medium | Medium | Training session ก่อน UAT, มี QC/BA support |
| Bug ใหญ่ใน UAT | Medium | High | SIT ต้อง pass ก่อน; มี hotfix plan |
| User requirement เปลี่ยน | Low | High | Change Request process; re-baseline |

## 10. Defect Management
- เหมือน SIT Plan — ใช้ Critical/Major/Minor/Trivial + Critical/High/Medium/Low ตาม `references/qa-standards.md §1-§2`
- **เพิ่ม:** User Champion เป็นผู้ยืนยัน defect (ไม่ใช่ QC)

## 11. Traceability
ดู `traceability_matrix_uat_<scope>.csv` — map Business Process ↔ UAT Scenario

## 12. Suspension & Resumption
- Suspend: Critical Bug block > 20% ของ Scenario, หรือ Env down > 2 ชั่วโมง
- Resume: Bug fixed + verified

## 13. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| User Representative (Customer) | | | |
| BA | | | |
| QC Lead | | | |
| PM | | | |
