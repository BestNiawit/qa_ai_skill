# BRD Readiness Guide — เขียน BRD/PRD แบบไหนให้ AI ทำ Test Case ได้ดี

> **สำหรับ:** PM / BA / Product Owner ที่เขียน BRD หรือ User Story
> **ทำไมต้องอ่าน:** BRD ที่ดี → AI เขียน TC ได้แม่น → QA ไม่ต้อง rework → ส่ง feature ไว
> **ใช้เวลาอ่าน:** 5 นาที

> Cross-link: QA จะใช้ skill [`requirement-analyzer`](../skills/requirement-analyzer/) ประเมิน BRD ตาม checklist ด้านล่าง
> ก่อนส่งเข้า test-case-writer

---

## TL;DR — 8 สิ่งที่ต้องมีใน BRD

| # | ต้องมี | ถ้าไม่มี → ผลลัพธ์ |
|:-:|---------|-------------------|
| 1 | **Actor / Role** ชัดเจน | AI สร้าง TC ให้ role ผิด / ไม่ทดสอบ permission |
| 2 | **Main Flow** เป็น step นับได้ | AI สร้าง TC จับ flow ไม่ครบ → coverage ต่ำ |
| 3 | **Alt Flow / Error Handling** | AI ลืม negative case → bug หลุด production |
| 4 | **Acceptance Criteria** วัดได้ | AI ใส่ expected "ระบบทำงานถูกต้อง" (ใช้ไม่ได้) |
| 5 | **Business Rules** (formula/constraint) | AI เดา rule เอง → TC ผิด business logic |
| 6 | **Data / Input format** | AI ไม่รู้ boundary → ไม่มี BVA test |
| 7 | **NFR** (perf/security) | QA ไม่รู้ว่าต้องทำ perf test หรือไม่ |
| 8 | **Out-of-scope** | Scope creep → sprint spill |

---

## Template ที่แนะนำ — BRD Section

### 1. Context / Goal (1-2 ย่อหน้า)
- ทำไมต้องมี feature นี้
- Who benefits + KPI ที่จะวัด

### 2. Actors & Roles
```
- End User: พนักงานทั่วไป (ใช้งานปกติ)
- Admin: HR (ตั้งค่า leave policy, approve leave)
- Super Admin: IT (จัดการ user, permission)
```

### 3. Functional Requirements (แตกเป็น FR ID ย่อย)
```
FR-01: User สามารถสร้างใบลาได้
  Actor: End User
  Precondition: Login + มี leave balance > 0
  Main Flow:
    1. User คลิก "ขอลา" → เปิด form
    2. เลือกประเภทลา (annual/sick/personal)
    3. เลือกวันที่เริ่ม + สิ้นสุด
    4. ระบุเหตุผล (required, min 10 ตัว)
    5. Submit → ส่ง notify หัวหน้า
  Alt Flow:
    E1: ลาเกิน balance → error "Leave balance ไม่พอ"
    E2: วันที่เริ่ม > สิ้นสุด → error "วันที่ไม่ถูกต้อง"
    E3: ลาย้อนหลังเกิน 3 วัน → error "ลาย้อนหลังได้ไม่เกิน 3 วัน"
  Acceptance Criteria (ต้องวัดได้):
    AC1: หลัง submit, record ถูก save ใน DB ภายใน 2 วินาที
    AC2: หัวหน้าได้รับ email notification ภายใน 1 นาที
    AC3: Form แสดง error message ภาษาไทยที่ user เข้าใจได้
  Business Rules:
    BR1: Leave balance = 10 วัน/ปี, reset 1 Jan
    BR2: Sick leave ไม่หัก balance
    BR3: ลาติดต่อ > 3 วัน ต้องแนบใบรับรองแพทย์
  Data:
    - leave_type: enum (annual/sick/personal), required
    - start_date: date, required, >= today - 3 days
    - end_date: date, required, >= start_date
    - reason: string(500), required, min 10 chars
```

### 4. NFR (Non-Functional Requirements)
```
- Performance: API response p(95) ≤ 2s at 100 concurrent users
- Security: HTTPS only, session timeout 30 min idle
- Compatibility: Chrome 120+, Firefox 115+, Safari 16+
- Accessibility: WCAG 2.1 AA
```

### 5. Out-of-Scope (สำคัญ!)
```
- ไม่รวม: SSO / Social Login (phase 2)
- ไม่รวม: Mobile app native (web responsive เท่านั้น)
- ไม่รวม: Bulk leave approval (1-by-1 เท่านั้นใน sprint นี้)
```

### 6. Glossary
```
- "หัวหน้า" = Direct Supervisor ตาม org chart
- "Leave Balance" = จำนวนวันลาคงเหลือ (แยกตามประเภท)
```

---

## 3 สิ่งที่ BRD ห้ามเขียน (Red Flags)

### ❌ 1. "ทำงานถูกต้อง" / "ระบบแสดงผลปกติ"
→ ไม่วัดได้ AI จะเดา หรือ tester จะ argue กันว่าแบบไหนคือ "ถูกต้อง"
✅ เขียนแบบวัดได้: "แสดงข้อความ 'บันทึกสำเร็จ' สีเขียว ภายใน 2 วินาที"

### ❌ 2. "User ทำ..." โดยไม่ระบุ role
→ User คือใคร? permission ต่างกันไหม? Admin ทำเหมือน End User มั้ย?
✅ ระบุ role ที่เฉพาะเจาะจง: "End User (พนักงานทั่วไป) ทำ..." / "Admin (HR) ทำ..."

### ❌ 3. รวม 2-3 behaviour ในประโยคเดียว
```
❌ "User สามารถสร้าง / แก้ไข / ลบ / approve ใบลาได้"
✅ แยกเป็น FR-01 (Create), FR-02 (Edit), FR-03 (Delete), FR-04 (Approve)
   — เพราะ permission + flow ต่างกัน
```

---

## การใช้ร่วมกับ AI

QA จะใช้ skill `requirement-analyzer` ประเมิน BRD → ส่งผลกลับมาเป็น `pm_confirmation_*.md`
ซึ่งจะมี:

1. **Readiness Score** (ทำตาม checklist 8 ข้อด้านบน)
2. **Open Questions** — คำถามที่ QA ต้องรู้ก่อนเขียน TC
3. **Assumptions** — สิ่งที่ QA สมมุติไปก่อน ถ้า PM/BA ไม่ confirm

**Role ของ PM/BA:**
- ตอบ Open Questions ภายใน deadline (2-3 วันทำการ)
- Confirm/reject Assumptions ทีละข้อ
- ไม่ใช่แค่ "OK" ทั้งหมด — ต้องอ่านจริง เพราะ Assumption ผิด = TC ผิด = rework

---

## Checklist ก่อนส่ง BRD ให้ QA

- [ ] ครบ 8 criteria ในตาราง TL;DR
- [ ] ทุก FR มี ID (FR-01, FR-02, ...)
- [ ] ทุก Acceptance Criteria วัดได้ (ไม่มี "ถูกต้อง"/"ปกติ")
- [ ] แยก Main Flow / Alt Flow / Error Handling
- [ ] ระบุ Out-of-scope ชัดเจน
- [ ] มี Data Dictionary (field, type, length, required)
- [ ] Glossary ย่อ/คำเฉพาะ
- [ ] Version + Date + Author ระบุ

---

## FAQ

**Q: BRD ยังไม่ finalize ส่งให้ QA ได้ไหม?**
A: ได้ — ระบุ version = "Draft v0.3" และ mark section ที่ยังไม่ชัดเจน QA จะใช้ `requirement-analyzer` ประเมินความพร้อม แล้วชี้ gap ให้กลับไปทำต่อ

**Q: ถ้า BRD ภาษาธุรกิจ ไม่เข้าใจ technical?**
A: ได้ — AI จะ normalize ให้ QA ใช้เอง แต่ **ต้องมี Business Rule + AC ที่ชัดเจน** (ไม่ต้อง technical แค่ต้อง measurable)

**Q: มี template BRD มาตรฐานที่ทีมใช้ไหม?**
A: ใช้ template ใน section "Template ที่แนะนำ" ด้านบน — หรือถ้ามี template บริษัทอยู่แล้ว QA จะ map ให้ตอน normalize

---

## References

- IEEE 830 — Software Requirements Specification
- ISO/IEC/IEEE 29148:2018 — Systems and software engineering — Life cycle processes — Requirements engineering
- INVEST criteria — Independent / Negotiable / Valuable / Estimable / Small / Testable (User Story quality)
- [`requirement-analyzer` skill](../skills/requirement-analyzer/) — เครื่องมือ QA ประเมิน BRD
