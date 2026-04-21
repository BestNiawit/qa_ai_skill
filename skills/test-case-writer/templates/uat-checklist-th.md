# UAT Checklist — <Project Name>

| Field | Value |
|-------|-------|
| Document ID | `UAT_CHECKLIST_<PROJECT>_<MODULE>_v1.0` |
| Version | 1.0 |
| Date | YYYY-MM-DD |
| Author | <BA + QC Lead> |
| Reviewer | <PM + User Representative> |
| Approver | <User (Customer)> |

---

## Scope & Assumptions

**Scope:**
- ครอบคลุม: Business Process ที่ทดสอบ (ระบุ FR IDs)
- ไม่ครอบคลุม: <list>

**Assumptions:**
- Test accounts ถูกสร้างแล้วใน UAT env
- Test data เตรียมแล้วตาม Test Data Sheet

---

## Status Legend

| Status | ความหมาย | Action |
|:------:|---------|--------|
| ☐ **Passed** | ผ่านตามคาด ครบทุก step | ไม่ต้องแก้ |
| ☐ **Passed w/ condition** | ผ่าน แต่มีข้อสังเกต (ต่าง UX เล็กน้อย, warning non-blocking) | ระบุ Remark + PM approve |
| ☐ **Failed** | ไม่ผ่าน step ใด step หนึ่ง | log bug (bug-report-writer) + Remark |

---

## C1 — <Category Title (ภาษาไทย)>

> Category = กลุ่ม scenario ที่ใช้ business function เดียวกัน (เช่น Medical benefits, Leave Management, Payment)

### 1. <Scenario Title ระบุ business intent + condition>

> ตัวอย่าง: "ข้าราชการเบิกสวัสดิการรักษาพยาบาลให้ตนเอง ค่าตรวจสุขภาพ 3,000 บาท กรณีเบิกจ่ายสวัสดิการ"

| Field | Value |
|-------|-------|
| **Scenario ID** | `UAT_<PROJECT>_<MOD>_001` |
| **Business Requirement** | `FR_<MOD>_01` (link กลับ SRS) |
| **Test Period** | YYYY-MM-DD |
| **เลขที่เอกสาร** | <ref> |
| **Pre-condition** | User accounts พร้อม, สิทธิ์เปิดใช้งาน |

**Multi-role Execution Flow:**

| # | ผู้ใช้งาน (Role / User / Pass) | ขั้นตอนการทดสอบ | ผลลัพธ์ที่คาดหวัง |
|:-:|-------------------------------|----------------|-----------------|
| 1 | **ข้าราชการ**<br>User: xxx<br>Pass: xxx | 1. กดเข้าเมนูเบิกสวัสดิการรักษาพยาบาล<br>2. กดปุ่มสร้างคำขอเบิกสวัสดิการ<br>3. เลือกขอเบิก = "ตนเอง"<br>4. เลือกประเภท = "ตรวจสุขภาพ" + ยืนยัน<br>5. เลือกประเภทการใช้สิทธิ์<br>6. ระบุข้อมูลการรักษา<br>7. กดเพิ่มใบเสร็จ + แนบไฟล์<br>8. กดบันทึกแบบร่าง → ส่งคำขอ → ตกลง | สถานะคำขอ = **"รอการเงินตรวจสอบ"** |
| 2 | **การเงิน**<br>User: xxx<br>Pass: xxx | 1. เข้าศูนย์อนุมัติ → แท็บคำขอเบิกฯ<br>2. กดพิจารณาคำขอ<br>3. เลือก "อนุมัติ" → บันทึก → ตกลง | สถานะคำขอ = **"รอหัวหน้าพิจารณา"** |
| 3 | **หัวหน้าสายบังคับบัญชา**<br>User: xxx<br>Pass: xxx | 1. เข้าศูนย์อนุมัติ → แท็บคำขอเบิกฯ<br>2. กดพิจารณาคำขอ<br>3. เลือก "อนุมัติ" → บันทึก → ตกลง | สถานะคำขอ = **"รอกองคลังพิจารณา"** |
| 4 | **กองคลัง**<br>User: xxx<br>Pass: xxx | 1. เข้าศูนย์อนุมัติ → แท็บคำขอเบิกฯ<br>2. กดพิจารณาคำขอ<br>3. เลือก "อนุมัติ" → บันทึก → ตกลง | สถานะคำขอ = **"ดำเนินการแล้ว"** |
| 5 | **ผู้ใช้ (เบิกจ่าย)**<br>User: xxx<br>Pass: xxx | 1. เข้าเมนูเบิกจ่ายสวัสดิการ<br>2. กดสร้างคำขอเบิกจ่าย<br>3. เลือกประเภท / วันที่ / สังกัด / ศูนย์ต้นทุน / รหัสโครงการ / OB / กิจกรรม<br>4. บันทึก → ยืนยัน → ส่งคำขอเบิก → ตกลง | ส่งไป ERP → สถานะการเบิกจ่าย = **"การเบิกจ่าย"** |

**Execution Result:**

| ผู้ทดสอบ | วันที่ | Test Status | Bug ID | Remark |
|---------|:------:|:-----------:|:------:|--------|
| <name>  | YYYY-MM-DD | ☐ Passed<br>☐ Passed w/ condition<br>☐ Failed | <ถ้า fail> | <note> |

---

### 2. <Scenario Title — variation เช่น กรณีกองคลังส่งกลับแก้ไข>

| Field | Value |
|-------|-------|
| **Scenario ID** | `UAT_<PROJECT>_<MOD>_002` |
| **Business Requirement** | `FR_<MOD>_01` |
| **Variation** | กองคลังส่งกลับแก้ไข → ผู้ใช้แก้ → re-approve |

**Multi-role Execution Flow:**

| # | ผู้ใช้งาน | ขั้นตอนการทดสอบ | ผลลัพธ์ที่คาดหวัง |
|:-:|----------|----------------|-----------------|
| 1 | ผู้ใช้ขอเบิก | ... | รอการเงินตรวจสอบ |
| 2 | การเงิน (อนุมัติ) | ... | รอหัวหน้า |
| 3 | หัวหน้า (อนุมัติ) | ... | รอกองคลัง |
| 4 | **กองคลัง (ส่งกลับแก้ไข)** | เลือก "ส่งแก้ไข" + กรอกหมายเหตุ | **ส่งกลับผู้ใช้** |
| 5 | ผู้ใช้ (แก้ไข + ส่งใหม่) | กดไอคอนปากกา → แก้ข้อมูล → ส่งคำขอ | รอการเงินตรวจสอบ (วนรอบใหม่) |
| 6-8 | การเงิน/หัวหน้า/กองคลัง (อนุมัติ) | ... | ดำเนินการแล้ว |

**Execution Result:** <same structure>

---

## C2 — <Next Category Title>

### 1. <Scenario Title>
<same structure>

---

## Coverage Matrix

| Business Req ID | Requirement | Scenario IDs | Pass Rate |
|-----------------|-------------|-------------|:---------:|
| FR_MDB_01 | เบิกสวัสดิการรักษาพยาบาล (happy path) | UAT_KMUTNB_MDB_001 | — |
| FR_MDB_01 | เบิกสวัสดิการรักษาพยาบาล (กองคลังส่งกลับ) | UAT_KMUTNB_MDB_002 | — |
| FR_MDB_02 | ... | UAT_KMUTNB_MDB_003 | — |

---

## Scenario Summary

| Category | Total Scenarios | Passed | Pass w/ cond | Failed | Pass Rate |
|----------|:---------------:|:------:|:------------:|:------:|:---------:|
| C1 — Medical benefits | 5 | — | — | — | — |
| C2 — Leave Management | 8 | — | — | — | — |
| **Total** | **13** | — | — | — | — |

---

## Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| User Representative | | | |
| BA | | | |
| QC Lead | | | |
| PM | | | |

**Sign-off Type:** ☐ Approved  ☐ Approved with Conditions  ☐ Rejected

---

## Field Reference

| Field | คำอธิบาย |
|-------|---------|
| **Category (C1, C2, ...)** | กลุ่ม business function เดียวกัน — เรียง C1, C2, C3 ... |
| **ลำดับ (1, 2, 3 ...)** | ลำดับ scenario ใน Category |
| **Scenario ID** | `UAT_<PROJECT>_<MOD>_<NUM>` — unique ทั่วทั้ง project |
| **ผู้ใช้งาน** | ระบุ Role + User + Pass (test account ใน UAT env) |
| **ขั้นตอนการทดสอบ** | Action เป็นข้อๆ (นับเลข 1., 2., 3. ...) |
| **ผลลัพธ์ที่คาดหวัง** | สิ่งที่ User เห็น / สถานะคำขอ (ภาษา business) |
| **เลขที่เอกสาร** | ref number ของ scenario (ถ้ามีระบบ doc tracking) |
| **Test Status** | Passed / Passed w/ condition / Failed |
| **Bug ID** | ถ้า Failed → Jira ID จาก bug-report-writer |
| **Remark** | ข้อสังเกต, reason for conditional, workaround |
