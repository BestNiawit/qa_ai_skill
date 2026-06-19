# AI Guardrails — ข้อควรระวังเมื่อใช้ AI ในงาน Testing

> ใช้ร่วมกันทุก skill ใน repo นี้ — อ้างอิงจาก OneD SDP §5.3.3
> **หลักการ:** AI = Draft & Assist, QC = Review & Approve

---

## 5 ข้อควรระวังหลัก

| # | ข้อควรระวัง | ทำไมต้องระวัง | วิธีป้องกัน |
|---|------------|--------------|------------|
| 1 | **AI Hallucinate Requirement** | AI อาจสร้าง TC/Scenario จาก Requirement ที่ไม่มีในเอกสาร | Cross-check ทุก output กับ SRS/PRD ต้นทางเสมอ (ใช้ Traceability Matrix) |
| 2 | **ไม่รู้ Business Context เฉพาะ** | AI ไม่รู้ Business Rule เฉพาะลูกค้า (tax, discount logic, legacy data) | QC/BA เพิ่ม TC เฉพาะทางหลัง AI draft |
| 3 | **ไม่รู้ Environment จริง** | AI อาจระบุ Server/DB/URL ผิด | Update Environment ให้ตรงจริงทุกครั้ง (ใช้ `project-context.md`) |
| 4 | **อาจสรุปตัวเลขผิด** | Generate Report จาก raw data → อาจนับ/รวมผิด | ตรวจตัวเลขกับ source data (Jira/CSV) ทุก row |
| 5 | **ข้อมูล Sensitive ห้ามใส่ AI** | ชื่อจริง เลขบัตร ข้อมูลการเงิน อาจรั่วไปยัง LLM provider | ใช้ข้อมูล Dummy/Masked — redact เป็น `[REDACTED]` หรือ env var |

---

## Universal Rules (บังคับทุก skill)

### R1. Cross-check กับ source เสมอ
AI output ทุกอันต้อง **trace กลับ** ไปยังเอกสารต้นทางได้ — ถ้าไม่มี source ไม่ยอมรับ

**ตัวอย่าง:**
- Test Case → ต้องมี `Ref FR ID` ชี้ไป SRS requirement
- Test Report → ต้องมี source data (Jira export, CSV) แนบ
- Perf Analysis → ต้องมี raw result (JMeter CSV / k6 JSON)

### R2. ห้าม commit Sensitive data
ใช้ `[REDACTED]` หรือ placeholder สำหรับ:
- Password / API token / secret key
- PII: ชื่อ-นามสกุลจริง, เลขบัตรประชาชน, เลขบัญชี, เบอร์โทร, email ลูกค้าจริง
- Financial data: ยอดเงิน, transaction ID จริง
- Customer-specific: ชื่อบริษัทลูกค้า (ถ้า NDA)

โหลดจริงผ่าน env var / secret manager / `.env.local` (gitignored)

### R3. Expected Result ต้องวัดได้
ห้ามใช้คำกำกวม:
- ❌ "ทำงานถูกต้อง" / "แสดงผลปกติ" / "ระบบพร้อมใช้"
- ✅ "แสดง toast 'บันทึกสำเร็จ' สีเขียว ภายใน 2 วินาที, redirect ไป /dashboard, DB tbl_leave.status='PENDING'"

### R4. QC ต้อง Review ก่อน approve
AI draft → QC ตรวจ → approve → ใช้งาน

**ห้าม** ส่ง AI output ตรงๆ ไปให้ User/Dev โดยไม่ผ่าน QC review

### R5. ไม่ make up number
ถ้า AI ไม่มีข้อมูลจริง ห้ามเดาตัวเลข (effort, response time, defect count) — ต้องถาม user หรือระบุว่า "ต้องใส่ค่าจริงตรงนี้"

---

## Checklist ก่อน approve AI output

ทุก skill ต้องให้ user/QC ติ๊กก่อน:

- [ ] ทุก item ใน output **trace กลับ** source document ได้
- [ ] ตัวเลข (Pass rate, response time, effort) **ตรวจกับ raw data** แล้ว
- [ ] **Environment** (server, DB, URL) ตรงกับ production config
- [ ] **ไม่มี** password/PII/sensitive data
- [ ] Expected Result / Acceptance Criteria **วัดได้** ไม่กำกวม
- [ ] Business Rule เฉพาะโปรเจกต์ **เพิ่มเอง** หลัง AI draft

---

## เมื่อ AI ตอบผิด — วิธีแก้

| อาการ | แปลว่า | วิธีแก้ |
|-------|-------|---------|
| AI สร้าง TC อ้าง FR ที่ไม่มีใน SRS | Hallucination | ให้ SRS ใหม่ + บังคับ "ถ้าไม่มี FR ID ให้ระบุว่า assumed" |
| AI ใส่ URL/IP สุ่ม | ไม่มี environment context | ให้ `project-context.md` ที่มี env table |
| Expected result ซ้ำๆ เหมือนกันหมด | ไม่เข้าใจ business logic | ให้ตัวอย่าง TC ที่เขียนดีก่อน (few-shot) |
| ตัวเลขใน Report ไม่ตรง | นับผิดจาก raw data | ให้ structured data (CSV/JSON) + verify ทีละ row |

---

## References
- OneD SDP §5.3.3 (Software-Development-Process.md)
- OWASP LLM Top 10 — LLM06:2025 (Sensitive Information Disclosure)
- NIST AI Risk Management Framework (AI RMF 1.0) — MEASURE section
