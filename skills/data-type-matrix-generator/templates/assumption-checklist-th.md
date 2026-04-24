# Assumption Checklist — <Feature Name>

> **เอกสารนี้ใช้แทนการเขียน spec ใหม่** — QA สรุปสิ่งที่เดาไว้ให้ PM/BA tick yes/no ใช้เวลา 10 นาที แทน 2 ชม.

---

## Meta

| Field | Value |
|-------|-------|
| **Feature** | เช่น เพิ่ม field Middle Name ในหน้า Register |
| **Module ID** | เช่น PMS_REG |
| **Reviewer (PM/BA)** | เช่น คุณสมศรี |
| **QA** | เช่น คุณ... |
| **Created** | YYYY-MM-DD |
| **Deadline for feedback** | YYYY-MM-DD (2-3 วันทำการจากวันสร้าง) |
| **If no response by deadline** | QA ถือว่า assumption ทั้งหมดคือ ✅ และเดินหน้าเขียน TC / execute → หาก bug escape หลัง release อ้างอิงเอกสารนี้ได้ |

---

## วิธีใช้เอกสารนี้

1. อ่านแต่ละ assumption (A-01, A-02, ...)
2. Tick `[x]` ถ้า QA เข้าใจถูก (ใช้งานตามที่เขียน) → **Accept**
3. หากไม่ถูก → เลือก `[x]` ใน `Reject` และเขียนสิ่งที่ถูกต้องในคอลัมน์ `Correct behavior`
4. ส่งกลับ QA ภายใน deadline (reply email / Slack / Jira comment)

---

## Assumption Items

### A-01 — <ตั้งชื่อ assumption สั้นๆ เช่น "Empty string treatment">

**สิ่งที่ QA เดาไว้:**
> เมื่อ user submit field `middle_name` เป็น empty string (`""`) ระบบจะ treat เหมือน null (บันทึก DB = NULL) ไม่ reject

**เหตุผล / Baseline:** ฟีเจอร์ Register เดิมทำแบบนี้กับ field optional อื่น

**อาจกระทบอะไร:** ผู้ใช้เก่าที่มี profile empty middle_name จะ query ได้ปกติ; ถ้า PM อยากให้บังคับกรอก ต้องเปลี่ยนเป็น required

**Checkbox:**
- [ ] **Accept** — ใช้งานตามนี้
- [ ] **Reject** — ให้ทำเป็น: ____________________________________________________________

---

### A-02 — <เช่น "Whitespace trim policy">

**สิ่งที่ QA เดาไว้:**
> ระบบจะ `.trim()` whitespace ที่หัว/ท้าย + ถ้าเหลือเป็น empty ให้ treat เป็น null

**เหตุผล / Baseline:** [Assumption — ไม่มี baseline]

**อาจกระทบอะไร:** หาก user พิมพ์ `"  Somchai  "` จะเก็บเป็น `"Somchai"` — ถ้า PM อยากเก็บตาม user พิมพ์ ต้อง skip trim

**Checkbox:**
- [ ] **Accept** — trim ตามนี้
- [ ] **Reject** — ให้ทำเป็น: ____________________________________________________________

---

### A-03 — <เช่น "Emoji in name field">

**สิ่งที่ QA เดาไว้:**
> field `middle_name` จะ reject emoji (`😀`) พร้อม error "ชื่อต้องเป็นตัวอักษร"

**เหตุผล / Baseline:** [Assumption — industry standard ไม่ให้ emoji ในชื่อ]

**อาจกระทบอะไร:** ถ้า product เน้น friendly/personal branding อาจอยาก allow

**Checkbox:**
- [ ] **Accept** — reject emoji
- [ ] **Reject** — ให้ allow emoji, หรือ: ____________________________________________________________

---

### A-04 — <เช่น "RTL/Arabic/Hebrew characters">

**สิ่งที่ QA เดาไว้:**
> ระบบยอมรับ RTL scripts (Arabic, Hebrew) ปกติ เช่น `"محمد"`

**เหตุผล / Baseline:** Unicode-safe DB (utf8mb4)

**อาจกระทบอะไร:** หาก UI render RTL ไม่ถูก อาจเห็นชื่อพันกับตัวอื่น

**Checkbox:**
- [ ] **Accept** — รับ RTL
- [ ] **Reject** — จำกัดแค่ TH + EN เท่านั้น

---

### A-05 — <เช่น "Max length boundary">

**สิ่งที่ QA เดาไว้:**
> field มี max length = 100 ตัวอักษร (ตาม first_name/last_name เดิม)

**เหตุผล / Baseline:** Baseline: column length ใน DB ของ first_name

**อาจกระทบอะไร:** ชื่อบางวัฒนธรรมยาวเกิน 100 ตัว (เช่น Spanish/Portuguese compound)

**Checkbox:**
- [ ] **Accept** — max 100
- [ ] **Reject** — ใช้ max = _______ ตัวอักษร

---

### A-06 — <เช่น "API wrong-type handling">

**สิ่งที่ QA เดาไว้:**
> หาก API รับ payload ที่ middle_name เป็น array (`["A","B"]`) จะ return HTTP 400 + error validation

**เหตุผล / Baseline:** REST convention

**อาจกระทบอะไร:** client ที่ส่งข้อมูลผิด type จะรู้ error ชัดเจน

**Checkbox:**
- [ ] **Accept** — 400 + error
- [ ] **Reject** — ให้ behavior เป็น: ____________________________________________________________

---

### A-07 — <เช่น "Null-byte / injection sanitization">

**สิ่งที่ QA เดาไว้:**
> ระบบ sanitize null-byte (`\x00`) และ injection pattern ทั้งหมด — ไม่ bypass validation

**เหตุผล / Baseline:** Baseline: security policy (OWASP A03)

**อาจกระทบอะไร:** กัน injection attack, compliance

**Checkbox:**
- [ ] **Accept** — sanitize
- [ ] **Reject** — ให้ทำเป็น: ____________________________________________________________

---

## Additional Open Questions (ไม่ใช่ assumption — ต้องการ PM ตอบเพิ่ม)

1. [Optional] มี rate limit ต่อ IP หรือ account สำหรับ endpoint นี้ไหม?
2. [Optional] เก็บ history การ edit middle_name ไว้ไหม (audit log)?
3. [Optional] Export CSV / API GET ต้องคืน field นี้ด้วยไหม (affect downstream)?

---

## Summary ให้ PM

- **จำนวน assumption ที่ต้อง tick:** 7 ข้อ
- **Critical (ต้องตอบก่อน execute):** A-01, A-02, A-05
- **High (ตอบก่อน release):** A-03, A-04, A-07
- **Medium (ตอบก่อน next sprint):** A-06
- **เวลาคาดว่าใช้:** ~10 นาที

**หลัง PM tick กลับ → QA จะ:**
1. Update `datatype_matrix_*.csv` — เปลี่ยน `Assumption: A-NN` → `Confirmed` / `Rejected`
2. Adjust Test Value + Expected Behavior ตาม feedback
3. Feed matrix เข้า `test-case-writer` เพื่อสร้าง full TC
