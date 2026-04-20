# Test Cases: <ชื่อ Feature>

| Meta | Value |
|------|-------|
| **Requirement Ref** | `<link / file path / version>` |
| **Created Date** | YYYY-MM-DD |
| **Author** | <ชื่อผู้เขียน> |
| **Reviewed By** | <ชื่อ reviewer> |
| **Total Test Cases** | <จำนวน> |

---

## Summary

**Scope:**
- ครอบคลุม: ...
- ไม่ครอบคลุม (out of scope): ...

**Assumptions:**
- ...

---

## TC-001: <ชื่อ test case แบบสั้น บอกสิ่งที่ทดสอบ>

| Field | Value |
|-------|-------|
| **Priority** | High / Medium / Low |
| **Technique** | ECP / BVA / Decision Table / State Transition / Use Case / Error Guessing |
| **Type** | Positive / Negative / Boundary / Edge |
| **Module** | <module/screen> |

**Precondition:**
- ผู้ใช้ login ด้วย role X
- มีข้อมูล Y อยู่ในระบบ

**Test Data:**
| Field | Value |
|-------|-------|
| email | `valid@example.com` |
| password | `Pass1234!` |

**Steps:**
1. ไปที่หน้า ...
2. กรอก ... ในช่อง ...
3. กดปุ่ม ...

**Expected Result:**
- ระบบแสดง popup ข้อความ "..."
- redirect ไปที่หน้า `/...`
- record ใน DB table `...` มี field `status = 'active'`

---

## TC-002: <ชื่อ test case>

(ทำซ้ำตาม pattern ด้านบน)

---

## Coverage Matrix

| Requirement ID | Description | Test Case IDs |
|----------------|-------------|---------------|
| REQ-001 | ผู้ใช้สามารถ login ด้วย email + password | TC-001, TC-002, TC-003 |
| REQ-002 | ระบบล็อก account หลัง login ผิด 5 ครั้ง | TC-004, TC-005 |
| REQ-003 | ... | TC-006 |

---

## Test Data Reference (ถ้าใช้ร่วมกัน)

| Dataset | Description | Used By |
|---------|-------------|---------|
| valid_user | email + password ที่ผ่าน validation | TC-001, TC-003 |
| locked_user | account ที่ถูกล็อก | TC-005 |
