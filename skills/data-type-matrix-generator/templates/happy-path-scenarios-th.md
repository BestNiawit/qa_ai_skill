# Happy Path E2E Scenarios — <Feature Name>

> **จุดประสงค์:** เล่นตาม user จริง ไม่ใช่เทสทีละ field — data-type matrix คุม "ส่วนประกอบ", ไฟล์นี้คุม "experience"
> **Oracle เมื่อไม่มี spec:** ผลลัพธ์ควร **consistent กับ base feature** ที่คล้ายกัน

---

## Meta

| Field | Value |
|-------|-------|
| **Feature** | เช่น Register with Middle Name |
| **Module** | เช่น PMS_REG |
| **Base reference** | เช่น /register เดิม (first_name + last_name) |
| **QA** | เช่น คุณ... |
| **Created** | YYYY-MM-DD |

---

## กฎการเขียน

1. **แต่ละ scenario = 1 persona + 1 motivation** — ไม่ใช่แค่ "กรอกฟอร์มแล้วกดส่ง"
2. **Precondition ต้องชัด** — login state, permission, data state
3. **Expected end state ต้องวัดได้** — ไม่ใช้ "ใช้งานได้"
4. **ทุก scenario ต้อง touch ฟีเจอร์ใหม่ + integration กับ base อย่างน้อย 1 จุด**

---

## Scenario HP-01 — <ชื่อ scenario>

**Persona:** เช่น "ผู้ใช้ใหม่สมัครด้วยชื่อไทยเต็ม 3 คำ (first / middle / last)"
**Motivation:** อยากสมัคร account เพื่อใช้บริการ

**Precondition:**
- ยังไม่เคย register
- Email ยังไม่ถูกใช้
- Browser: Chrome latest, Desktop

**Steps:**
1. เปิดหน้า /register
2. กรอก:
   - First name: `สมชาย`
   - Middle name: `ศักดิ์`
   - Last name: `ใจดี`
   - Email: `somchai@example.com`
   - Password: `Abcd1234!`
3. กด "สมัครสมาชิก"
4. เช็ค email inbox

**Expected end state:**
- Redirect ไปหน้า `/welcome` พร้อม message "ยินดีต้อนรับคุณ สมชาย ศักดิ์ ใจดี"
- Email verification ส่งถึง inbox ภายใน 30 วินาที
- DB: row ใน `users` ตาราง — first/middle/last เก็บครบ, middle_name = `"ศักดิ์"` (ไม่ trim)
- Profile page แสดงชื่อเต็ม 3 คำ (integration กับ base: ชื่อแสดงในทุกที่ที่ base แสดง)

**Oracle:** Baseline — Register เดิม (2-word name) behavior + ชื่อแสดงบน profile ปัจจุบัน

---

## Scenario HP-02 — <ชื่อ scenario>

**Persona:** "ผู้ใช้ต่างชาติที่ไม่มี middle name (optional)"
**Motivation:** ต้องการ register โดยเว้น middle name ว่าง

**Precondition:**
- ยังไม่เคย register
- Browser: Safari iOS, Mobile

**Steps:**
1. เปิด /register
2. กรอก first_name + last_name, เว้น middle_name ว่าง
3. กด submit

**Expected end state:**
- Register สำเร็จ (ไม่มี error)
- DB: middle_name = NULL
- Profile page: แสดงแค่ first + last (ไม่แสดง space ตรงกลางแทน middle)
- Display ทุกจุด (profile / header / comments) ไม่มี artifact ของ middle_name ว่าง

**Oracle:** Baseline — field optional อื่นใน Register เดิม + profile display logic

---

## Scenario HP-03 — <ชื่อ scenario>

**Persona:** "ผู้ใช้ที่แก้ profile เพิ่ม middle name หลัง register แล้ว"
**Motivation:** ลืมกรอก middle ตอน register, เพิ่มทีหลัง

**Precondition:**
- Register แล้ว (middle_name = NULL)
- Login อยู่

**Steps:**
1. เปิด /profile/edit
2. กรอก middle_name = `John`
3. Save

**Expected end state:**
- DB update: middle_name = `"John"`
- Profile page refresh แสดงชื่อ 3 คำ
- **Integration check:** ทุกหน้าที่ cache user name ต้อง invalidate (header, comments ที่ user เคย post)
- Audit log (ถ้ามี): บันทึกการเปลี่ยน field

**Oracle:** Baseline — edit first_name/last_name flow เดิม + cache invalidation pattern

---

## Red Flag Scenarios (ถ้ามีเวลา)

### HP-04 (optional) — Cross-session consistency

**Steps:** Register → logout → login ใหม่ → verify ชื่อยัง consistent ทุกหน้า

### HP-05 (optional) — Export + Import

**Steps:** ถ้ามี export profile CSV — verify middle_name column มาครบ + import กลับได้

---

## Coverage Check

- [ ] ทุก scenario มี precondition + steps + expected ครบ
- [ ] ทุก scenario touch ฟีเจอร์ใหม่ + integration กับ base
- [ ] Expected end state วัดได้ (ไม่มี "ใช้งานได้")
- [ ] Oracle source ระบุชัดทุก scenario
- [ ] มีทั้ง TH name + EN name + no-middle case
