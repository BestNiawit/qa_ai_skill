# สิ่งที่ QA เข้าใจจาก BRD — ขอ Confirm ก่อนเขียน Test Case

> เอกสารนี้สรุป**ความเข้าใจของทีม QA** ที่ได้จากการอ่าน BRD — กรุณา **confirm หรือแก้ไข** แต่ละข้อ
> ถ้าข้อไหนผิด → QA จะไปเขียน Test Case ตาม assumption ที่ผิด → เสียเวลา rework ทั้งทีม
> **ใช้เวลา review: ~15-30 นาที**

---

## Overview

| Field | Value |
|-------|-------|
| **Module** | `{{MODULE_ID}}` — {{Module Title}} |
| **Source BRD** | `{{path/to/brd.md}}` (version {{...}}, date {{...}}) |
| **QA Owner** | {{QA name / email}} |
| **Reviewer** | {{PM / BA name}} |
| **Deadline for feedback** | **{{YYYY-MM-DD}}** (ถ้าเกินกำหนด — QA จะเริ่มตาม Assumption ที่ list ไว้) |
| **Readiness Score** | {{X}}/8 — {{Ready / Needs-clarification / Not-ready}} |

---

## ✅ Section 1 — สิ่งที่ชัดเจนแล้ว

> สรุป requirement ที่ QA เข้าใจตรงกับ BRD 100% — **โปรด scan ดูว่าไม่มีอะไรตกหล่น**

1. **FR_{{MODULE}}_01** — {{สรุป 1 บรรทัด: "User login ด้วย email + password ได้"}}
2. **FR_{{MODULE}}_02** — {{...}}
3. **FR_{{MODULE}}_03** — {{...}}
   *(ดูรายละเอียดใน [`normalized_req_{{module_id}}_{{date}}.md`](normalized_req_{{module_id}}_{{date}}.md))*

---

## ❓ Section 2 — Open Questions (ต้อง Confirm)

> คำถามที่ BRD ไม่ได้ตอบ — **ต้องได้คำตอบก่อนเขียน TC** (ไม่งั้น QA จะใช้ Assumption ใน Section 3)

| # | Question | Context (ทำไมถาม) | PM/BA Answer |
|:-:|----------|-------------------|--------------|
| Q1 | {{คำถามชัดเจน — ex: "ถ้า user login fail 5 ครั้ง — lock account ยังไง? unlock ยังไง?"}} | {{ทำไมสำคัญ — "ต้องการเพื่อเขียน TC negative case"}} | _______________________ |
| Q2 | {{...}} | {{...}} | _______________________ |
| Q3 | {{...}} | {{...}} | _______________________ |
| Q4 | {{...}} | {{...}} | _______________________ |
| Q5 | {{...}} | {{...}} | _______________________ |

---

## 🔍 Section 3 — Assumptions ที่ QA ใช้ไปก่อน

> ถ้า PM/BA ไม่ตอบภายใน deadline — QA จะเริ่มเขียน TC ตาม Assumption เหล่านี้
> **โปรด confirm ทีละข้อ** (✅ ตกลง / ❌ ผิด — แก้เป็น...)

| # | Assumption | Rationale | Confirm? |
|:-:|------------|-----------|:--------:|
| A1 | {{assumption — ex: "Login response time ต้อง < 3 วินาที"}} | {{industry standard / common practice / ผล experience ทีม}} | ☐ ✅ / ☐ ❌ → _______ |
| A2 | {{ex: "Session timeout = 30 นาที idle"}} | common default | ☐ ✅ / ☐ ❌ → _______ |
| A3 | {{ex: "SSO / Social Login ไม่ได้อยู่ใน sprint นี้"}} | BRD ไม่ได้กล่าวถึง | ☐ ✅ / ☐ ❌ → _______ |
| A4 | {{...}} | {{...}} | ☐ ✅ / ☐ ❌ → _______ |

---

## 📋 Section 4 — Out-of-Scope (QA เข้าใจว่าไม่รวม)

> **กัน scope creep** — โปรด confirm ว่าของเหล่านี้ไม่อยู่ใน sprint นี้ / module นี้

- [ ] {{ex: SSO / Social Login}}
- [ ] {{ex: Biometric authentication}}
- [ ] {{ex: Multi-factor authentication (MFA)}}
- [ ] {{...}}

**ถ้ามีข้อไหนที่ QA เข้าใจผิด (จริงๆ อยู่ใน scope) → เติมใน Section 2 Open Questions**

---

## 📌 Section 5 — Action Items หลัง Review

- [ ] PM/BA ตอบ Open Questions Section 2 ครบ
- [ ] PM/BA confirm/reject Assumptions Section 3 ทีละข้อ
- [ ] PM/BA confirm Out-of-Scope Section 4
- [ ] **QA update** [`normalized_req_{{module_id}}_{{date}}.md`](normalized_req_{{module_id}}_{{date}}.md) ตาม feedback
- [ ] **QA เริ่ม** `test-case-writer` + `test-plan-writer` หลัง normalized req update เสร็จ

---

## Review Sign-off

| Reviewer | Role | Date | Signature / Approval |
|----------|------|------|----------------------|
| {{PM name}} | PM | {{YYYY-MM-DD}} | ☐ Approved / ☐ Need rework |
| {{BA name}} | BA | {{YYYY-MM-DD}} | ☐ Approved / ☐ Need rework |

**หมายเหตุ:** Approval = confirm ว่าความเข้าใจของ QA ถูกต้อง — QA จะดำเนินการเขียน TC ต่อตาม version นี้
