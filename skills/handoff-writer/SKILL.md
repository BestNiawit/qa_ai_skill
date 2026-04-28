---
name: handoff-writer
description: สร้าง HANDOFF.md สำหรับส่งงานข้าม AI session เมื่อ AI ตัวเดิม hit rate limit หรือต้องสลับ tool — บันทึกสถานะงาน, files ที่แก้, decision ที่ตัดสินแล้ว, และ next step ให้ AI ตัวใหม่เริ่มต่อได้ทันที Trigger เมื่อ user พูดว่า "ใกล้ limit", "สร้าง handoff", "ส่งต่อ AI", "cooldown", "เปลี่ยน AI", "สรุปงานไว้", "handoff"
---

# Handoff Writer

> **คำย่อ:** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

สร้าง `HANDOFF.md` ที่ให้ AI ตัวใหม่ (หรือคนอื่น) **เริ่มทำงานต่อได้ทันทีโดยไม่ถามซ้ำ**

ปัญหาที่ skill นี้แก้:
- AI ตัวใหม่ไม่รู้ context → ถามซ้ำ / ทำซ้ำ
- Decision ที่ตัดสินไปแล้วหาย → AI วนเสนอทางเลือกเก่า
- ไม่รู้ว่า next step คืออะไร → เสียเวลา re-scope

---

## 2. When to Use — เมื่อไหร่ใช้

| สัญญาณ | ใช้ skill นี้ |
|--------|-------------|
| ใกล้ถึง rate limit / context limit | ✅ ทันที |
| ต้องหยุดแล้วกลับมาทำต่อพรุ่งนี้ | ✅ |
| ส่งต่องานให้เพื่อนร่วมทีม | ✅ |
| สลับ AI tool (Claude → GPT / Gemini) | ✅ |
| งานเสร็จ section ใหญ่ แต่ยังมีงานต่อ | ✅ |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Skill ที่กำลังใช้อยู่ | ✅ | เช่น `e2e-test-generator`, `test-case-writer` |
| Feature / Module | ✅ | scope ของงาน |
| สถานะงาน (ทำไปแล้ว / ค้างอยู่) | ✅ | AI อ่านจาก conversation context |
| Files ที่แก้ล่าสุด | ✅ | path จริง |
| Decision ที่ตัดสินแล้ว | ✅ | สิ่งที่ไม่ควรถามซ้ำ |
| Next step | ✅ | action แรกที่ AI ตัวใหม่ต้องทำ |

AI ดึง context จาก conversation history เองได้ — ไม่ต้องให้ user ป้อนซ้ำ

---

## 4. Outputs — สิ่งที่ได้

**1 ไฟล์:** `HANDOFF.md` ใน folder งานปัจจุบัน

**File naming:** `HANDOFF.md` (ชื่อตายตัว — ให้ AI ตัวใหม่หาเจอง่าย)

**Output path:** folder ของงานที่กำลังทำ (เช่น `outputs/datatype-pack/<feature>/` หรือ root repo)

### Schema ของ HANDOFF.md (บังคับ)

```markdown
# HANDOFF — [Feature/Module]
> สร้างเมื่อ: YYYY-MM-DD HH:MM | Skill: [skill name]

## สถานะปัจจุบัน
- กำลัง: ...
- ค้างอยู่ที่: ...

## ทำไปแล้ว ✅
- ...

## ยังไม่เสร็จ / ค้างอยู่ ⏳
| Task | Blocker | Priority |
|------|---------|----------|

## Files ที่แก้ล่าสุด
| File | แก้อะไร |
|------|---------|

## ตัดสินแล้ว — ห้ามถามซ้ำ ⛔
- ...

## Next Step (ทำอันนี้ต่อทันที)
1. ...

## Context สำคัญ
- ...

## Skill ที่ใช้อยู่
| Skill | สถานะ | Output ล่าสุด |
|-------|-------|--------------|
```

**Template เต็ม:** [`references/handoff-guide.md`](../../references/handoff-guide.md)

---

## 5. Process — ขั้นตอน

### Step 1: อ่าน conversation context
- ดึง task ที่ทำไปแล้ว จาก conversation history
- ระบุ files ที่แก้ล่าสุด (path จริง)
- รวบรวม decision / assumption ที่ตัดสินแล้ว

### Step 2: ระบุ next step ที่ชัดที่สุด
- Next step ต้องเป็น **action ทันที** ไม่ใช่ goal คลุมเครือ
- ❌ "ทำ automation ต่อ"
- ✅ "รันคำสั่ง `npx playwright test tests/ui/payroll/ --headed` แล้วดู error ที่ got"

### Step 3: เขียน HANDOFF.md
- ใช้ template จาก `references/handoff-guide.md`
- Section "ตัดสินแล้ว" ต้องครอบคลุม **ทุก** decision ใน session นี้
- File paths ต้องเป็น absolute หรือ relative ที่ชัดเจน

### Step 4: สร้างไฟล์และแจ้ง user
- บันทึกที่ folder งานที่เหมาะสม
- แจ้ง user: path ของ HANDOFF.md + prompt ด้านล่างให้ copy ไปเปิด AI ตัวใหม่

**Prompt สำหรับ AI ตัวใหม่ (copy ไปใช้):**

```text
อ่าน [path/HANDOFF.md] ก่อน แล้วทำ next step ต่อได้เลย
ไม่ต้องถามซ้ำเรื่องที่อยู่ใน section "ตัดสินแล้ว"
```

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] Section "ตัดสินแล้ว" มี decision ครบทุกข้อจาก session
- [ ] Next Step เป็น action ทันที (verb + object ชัด)
- [ ] File paths ถูกต้อง ไม่ใช่ path สมมติ
- [ ] ระบุ skill ที่ใช้อยู่ + สถานะ
- [ ] ไม่มีข้อมูล sensitive (password, PII) ใน HANDOFF.md

### Red Flags (Reject)
- ❌ Next Step เขียนว่า "ทำต่อ" โดยไม่ระบุว่าทำอะไร
- ❌ File path ไม่มีในระบบจริง
- ❌ ไม่มี section "ตัดสินแล้ว" — AI ตัวใหม่จะวนซ้ำ

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

- ❌ ห้ามใส่ข้อมูล sensitive (password, token, PII) ใน HANDOFF.md — ใช้ `[REDACTED]` แทน
- ❌ ห้ามสรุป decision ที่ยังไม่ได้ตัดสินว่า "ตัดสินแล้ว" — AI ตัวใหม่จะทำตามโดยไม่ถาม
- ❌ ห้าม path สมมติ — ต้องเป็น path จริงในระบบ

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:** ใช้ได้หลัง **ทุก skill** — เป็น utility ที่ไม่ขึ้นกับ skill ใดเฉพาะ

**Downstream:** AI ตัวใหม่อ่าน HANDOFF.md → ทำงาน skill เดิมต่อ

**Workflow:**

```text
[skill ใดก็ได้]  →  ใกล้ limit  →  handoff-writer  →  HANDOFF.md
                                                            ↓
                                                   [เปิด AI ตัวใหม่]
                                                            ↓
                                                   อ่าน HANDOFF.md → ทำต่อ
```
