# Test Cases: <Module Title>

| Module ID | <MODULE_ID> |
|-----------|-------------|
| **Module Title** | <Module Title> |
| **Requirement Ref** | `<link / file path / version>` |
| **Created Date** | YYYY-MM-DD |
| **Author** | <ชื่อผู้เขียน> |
| **Reviewed By** | <ชื่อ reviewer> |
| **Total Test Cases** | <จำนวน> |

---

## Scope & Assumptions

**Scope:**
- ครอบคลุม: ...
- ไม่ครอบคลุม (out of scope): ...

**Assumptions:**
- ...

---

## Test Cases

> **วิธีอ่าน**: แถว `SC_xxx: ...` = scenario group (ใช้เป็น section header) — TC รายตัวอยู่ใต้แถวนั้น

| TC ID* | Test Case Description* | Role* | Pos/Neg* | Priority* | Severity | Test Sizing | Technique | Pre-Requisite | Test Step* | Test Data | Expected Result* | Ref FR ID | Automation | Labels | Environment | Sprint | Actual Result* | Test Result | Tested By | Test Date | Defect ID (Jira) | Remark |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **SC_001: ผู้ใช้ login ด้วย username + password** |||||||||||||||||||||||
| TC_PMS_LOG_001 | Login สำเร็จด้วย credentials ที่ถูกต้อง | End User | Positive | P1 | S2 | S | Use Case | มี account พร้อมใช้งาน | 1. เปิดหน้า `/login`<br>2. กรอก username<br>3. กรอก password<br>4. กดปุ่ม "เข้าสู่ระบบ" | username=`superayodia`<br>password=`[REDACTED]` | 1. redirect ไป `/home`<br>2. แสดงข้อความ "ยินดีต้อนรับสู่ระบบจัดการข้อมูล"<br>3. token ถูกเก็บใน localStorage | FR_PMS_LOG_01 | Yes | smoke, regression | dev | 2026-S08 | | | | | | |
| TC_PMS_LOG_002 | Login ไม่ผ่านเมื่อ password ผิด | End User | Negative | P1 | S2 | S | Error Guessing | มี account พร้อมใช้งาน | 1. เปิดหน้า `/login`<br>2. กรอก username<br>3. กรอก password ผิด<br>4. กดปุ่ม "เข้าสู่ระบบ" | username=`superayodia`<br>password=`wrong-pw` | 1. แสดงข้อความ error "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"<br>2. ไม่ redirect ออกจากหน้า login | FR_PMS_LOG_02 | Yes | regression | dev | 2026-S08 | | | | | | |
| TC_PMS_LOG_003 | Lock account หลัง login ผิด 5 ครั้งติดกัน | End User | Negative | P0 | S1 | M | Decision Table | มี account ที่ยังไม่ถูก lock | 1. login ผิด 5 ครั้ง<br>2. พยายาม login ครั้งที่ 6 ด้วย pw ที่ถูก | username=`locked_test`<br>password=`Wrong!@#` | 1. ครั้งที่ 6 แสดงข้อความ "บัญชีถูกล็อก โปรดติดต่อ admin"<br>2. DB field `is_locked = true` | FR_PMS_LOG_03 | Candidate | regression, security | dev | 2026-S08 | | | | | | |
| **SC_002: Validation ช่อง input** |||||||||||||||||||||||
| TC_PMS_LOG_004 | Username ว่าง → disable ปุ่ม login | End User | Negative | P2 | S3 | S | BVA | อยู่หน้า `/login` | 1. เปิดหน้า `/login`<br>2. ปล่อย username ว่าง<br>3. กรอก password | password=`any` | ปุ่ม "เข้าสู่ระบบ" ถูก disabled | FR_PMS_LOG_04 | Yes | regression | dev | 2026-S08 | | | | | | |

---

## Coverage Matrix

| Requirement ID | Description | Test Case IDs |
|----------------|-------------|---------------|
| FR_PMS_LOG_01 | Login ด้วย email + password | TC_PMS_LOG_001 |
| FR_PMS_LOG_02 | แสดง error เมื่อ credential ผิด | TC_PMS_LOG_002 |
| FR_PMS_LOG_03 | Lock account หลัง fail 5 ครั้ง | TC_PMS_LOG_003 |
| FR_PMS_LOG_04 | ปุ่ม login disable เมื่อ input ไม่ครบ | TC_PMS_LOG_004 |

---

## Field Reference

| Field | ค่าที่ใช้ / คำอธิบาย |
|-------|----------------------|
| **TC ID** | `TC_<MODULE_ID>_<NUM>` (เรียง running) เช่น `TC_PMS_LOG_001` |
| **Role** | User role ที่ใช้ทดสอบ (End User / Admin / Super Admin / Guest) |
| **Pos/Neg** | Positive / Negative / Boundary / Edge |
| **Priority** | `P0` (Critical blocker) / `P1` (High) / `P2` (Medium) / `P3` (Low) — หรือ High/Med/Low |
| **Severity** | `S1` Critical / `S2` Major / `S3` Minor / `S4` Cosmetic |
| **Test Sizing** | `S` (< 15 min, 1–3 steps) / `M` (15–30 min, 4–8 steps) / `L` (30–60 min, 9–15 steps) / `XL` (> 1 hr, E2E + setup) |
| **Technique** | `ECP` / `BVA` / `Decision Table` / `State Transition` / `Use Case` / `Error Guessing` (ดู `references/testing-techniques.md`) |
| **Automation** | `Yes` (automated แล้ว) / `No` (manual only) / `Candidate` (ควร automate ยังไม่ทำ) / `N/A` (ไม่เหมาะ automate เช่น visual/UX) |
| **Labels** | tag คั่นด้วย comma เช่น `smoke, regression, security, @mobile` |
| **Environment** | `dev` / `sit` / `uat` / `staging` / `prod` |
| **Sprint** | `<year>-S<num>` เช่น `2026-S08` |
| **Test Result** | `Pass` / `Fail` / `Blocked` / `Skipped` / `Not Run` |
| **Defect ID** | Jira/Linear ticket เช่น `PMS-1234` ถ้า fail |

---

## Test Data Reference (shared datasets)

| Dataset | Description | Used By |
|---------|-------------|---------|
| valid_user | username + password ที่ผ่าน validation | TC_PMS_LOG_001, TC_PMS_LOG_004 |
| locked_user | account ที่ถูก lock | TC_PMS_LOG_003 |
