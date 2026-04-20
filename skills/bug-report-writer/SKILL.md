---
name: bug-report-writer
description: สร้าง bug report ที่มีโครงสร้างมาตรฐาน พร้อมใช้ใน Jira/Linear/GitHub Issues — ครอบคลุม title, environment, steps to reproduce, expected vs actual, severity, priority, attachments. รองรับภาษาไทยและอังกฤษ. Trigger เมื่อ user รายงานปัญหา/bug ที่พบจากการทดสอบ และขอให้เขียนเป็น bug report, defect report, issue, "log a bug", "report defect".
---

# Bug Report Writer

## เป้าหมาย
เขียน bug report ที่ developer อ่านแล้ว reproduce ได้ทันที ไม่ต้องถามกลับ

## ขั้นตอน

### 1. รวบรวมข้อมูล (ห้ามเขียนถ้าข้อมูลไม่ครบ)
ตรวจว่า user ให้ครบหรือยัง — ถ้าขาด **ถามก่อนเขียน**:

| ข้อมูล | จำเป็น | หมายเหตุ |
|-------|--------|----------|
| อาการที่พบ | ✅ | "เกิดอะไรขึ้น" |
| Steps to reproduce | ✅ | ทำตามแล้ว bug ขึ้นซ้ำได้ |
| Expected behavior | ✅ | ควรเป็นอย่างไร |
| Actual behavior | ✅ | เป็นอย่างไรจริง |
| Environment | ✅ | OS, browser/app version, device, network |
| URL/screen ที่เจอ | ✅ | ถ้าเป็น web/mobile |
| Severity | ✅ | impact ทางเทคนิค |
| Priority | ⚠️ | ความเร่งด่วนทางธุรกิจ (อาจให้ PM ตัดสิน) |
| Frequency | ⚠️ | always / sometimes / once |
| Test data | ⚠️ | account, input ที่ใช้ |
| Attachments | ⚠️ | screenshot, video, log, har file |
| Related ticket | ⚠️ | regression จาก ticket ไหน |

### 2. ถามภาษา
ถ้ายังไม่ทราบ → ถาม TH หรือ EN

### 3. เขียน Title
**Pattern:** `[<Module>] <Action> ทำให้เกิด <Symptom> เมื่อ <Condition>`

✅ ดี:
- `[Login] กดปุ่ม Submit แล้วหน้าค้าง เมื่อ email มี whitespace นำหน้า`
- `[Checkout] ยอดรวมคำนวณผิด เมื่อใช้ coupon ซ้อนกัน 2 ใบ`

❌ แย่:
- `bug` / `ระบบพัง` / `ใช้ไม่ได้` (ไม่บอกว่าตรงไหน)

### 4. แยก Severity vs Priority
ห้ามรวมกัน — สองอันนี้คนละเรื่อง:

| Severity (impact ทางเทคนิค) | Priority (ความเร่งด่วน) |
|---------------------------|-------------------------|
| **Blocker** — ระบบพังใช้ไม่ได้เลย | **P0** — แก้ทันทีวันนี้ |
| **Critical** — feature หลักพัง ไม่มี workaround | **P1** — แก้ใน sprint นี้ |
| **Major** — feature พัง มี workaround | **P2** — แก้ sprint หน้า |
| **Minor** — UI/UX/text ผิด | **P3** — แก้เมื่อมีเวลา |
| **Trivial** — typo, สีเพี้ยน | — |

ตัวอย่าง: typo บนหน้า login (Trivial severity) แต่ลูกค้าใหญ่บ่น → P0 priority

### 5. Steps to Reproduce ต้องชัด
- เป็นข้อๆ เรียงเลข
- เริ่มจาก state ที่รู้ (logged out, fresh DB, ฯลฯ)
- ระบุ test data ที่ใช้
- ถ้าขั้นที่ทำให้ bug เกิด → highlight

✅ ดี:
```
Precondition: logged in as customer with empty cart
Steps:
1. Go to /products/SKU-12345
2. Click "Add to cart"
3. Click "Add to cart" อีกครั้งภายใน 1 วินาที  ← bug เกิดที่นี่
```

❌ แย่: `กดปุ่ม add to cart แล้วพัง`

### 6. Expected vs Actual
แยก 2 หัวข้อชัดเจน:
- **Expected:** ระบบควรเพิ่ม quantity เป็น 2
- **Actual:** ระบบ add เป็น 2 record แยก, quantity 1 + 1

### 7. ใช้ Template
อ่าน `templates/bug-report-th.md` หรือ `templates/bug-report-en.md`

## Quality Checklist
- [ ] Title มี module + symptom + condition
- [ ] Steps reproduce ได้แน่นอน (ทำตามทีละข้อ)
- [ ] Expected ≠ Actual ระบุชัด
- [ ] Environment ครบ (OS, browser, version)
- [ ] Severity + Priority แยก
- [ ] มี screenshot/log ถ้าเป็น UI/error
- [ ] ไม่ใช้คำกำกวม ("พัง", "ใช้ไม่ได้")

## ข้อห้าม
- ❌ อย่าเขียนถ้าข้อมูลไม่พอ — ถาม user ก่อน
- ❌ อย่าใส่ความเห็นส่วนตัว/ตำหนิ developer
- ❌ อย่าใส่ข้อมูล sensitive (password จริง, PII) — ใช้ `[REDACTED]`
- ❌ อย่ารวม 2 bugs ใน 1 report — แยกแต่ละ defect
