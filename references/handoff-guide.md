# AI Handoff Guide — ส่งงานข้าม AI Session

> ใช้เมื่อ AI ตัวเดิม hit rate limit / cooldown แล้วต้องสลับไปใช้ตัวใหม่

---

## ทำไมต้องมี Handoff

| ปัญหา | ผลกระทบ | แก้ด้วย |
|-------|---------|--------|
| AI ตัวใหม่ไม่รู้ context | ถามซ้ำ / ทำซ้ำ / แก้สิ่งที่ทำแล้ว | `HANDOFF.md` ใน folder งาน |
| Decision ที่ตัดสินไปแล้วหาย | AI ตัวใหม่เสนอทางเลือกเก่าอีกรอบ | บันทึก "ตัดสินแล้ว ห้ามถามซ้ำ" |
| ไม่รู้ว่า next step คืออะไร | เสียเวลา re-scope งาน | ระบุ next step ชัดในไฟล์ |

---

## วิธีใช้

### ขั้นตอนที่ 1 — ก่อน AI ตัวเก่า cooldown

สั่ง AI ตัวเก่าว่า:
```
สร้าง HANDOFF.md ไว้ใน [folder งาน] โดยใช้ template จาก references/handoff-guide.md
```

### ขั้นตอนที่ 2 — เปิด AI ตัวใหม่

Prompt แรกที่ส่ง:
```
อ่าน HANDOFF.md ใน [folder งาน] ก่อน แล้วทำ next step ต่อได้เลย
ไม่ต้องถามซ้ำเรื่องที่อยู่ใน section "ตัดสินแล้ว"
```

### ขั้นตอนที่ 3 — หลังงานเสร็จ section หรือ session

อัปเดต `HANDOFF.md` ให้สะท้อนสถานะปัจจุบันก่อนปิด

---

## Template: HANDOFF.md

```markdown
# HANDOFF — [ชื่อ Feature / Module]
> สร้างเมื่อ: YYYY-MM-DD HH:MM | Skill ที่ใช้: [skill name]

---

## สถานะปัจจุบัน
<!-- 1-2 ประโยค: กำลังทำอะไรอยู่ในส่วนไหน -->
- กำลัง: ...
- ค้างอยู่ที่: ...

---

## ทำไปแล้ว ✅
<!-- bullet สั้นๆ ต่อ task — พอให้รู้ว่า "ทำแล้ว ไม่ต้องทำซ้ำ" -->
- [ ] สร้าง data type matrix (DTM) → `outputs/datatype-pack/.../datatype_matrix_*.csv`
- [ ] Generate happy path scenarios → `happy_path_*.md`
- [ ] ...

---

## ยังไม่เสร็จ / ค้างอยู่ ⏳
<!-- ระบุให้ชัด: task + blocker (ถ้ามี) -->
| Task | Blocker | Priority |
|------|---------|----------|
| ... | - | High |
| ... | รอ PM confirm A-03 | Medium |

---

## Files ที่แก้ล่าสุด
<!-- path + แก้อะไร — AI ตัวใหม่จะอ่านไฟล์เหล่านี้ก่อน -->
| File | แก้อะไร |
|------|---------|
| `path/to/file.ts` | เพิ่ม waitForSpinner() |
| `data/ui/payroll-verify.csv` | แก้ hasAllowance ของ ชัชยุกรณ์ → true |

---

## ตัดสินแล้ว — ห้ามถามซ้ำ ⛔
<!-- decision ที่ผ่านมาแล้ว — AI ตัวใหม่ต้องใช้ตามนี้ ไม่ต้องเสนอทางเลือกอื่น -->
- เลือก **X แทน Y** เพราะ: ...
- Assumption A-01 confirmed: "แสดงแยก 2 แถว"
- ไม่ใช้ serial mode ใน test.describe เพราะต้องการให้ fail แล้วรันต่อ

---

## Next Step (ทำอันนี้ต่อทันที)
1. [ขั้นตอนแรก — ชัดที่สุด]
2. [ขั้นตอนถัดไป]
3. ...

---

## Context สำคัญ
<!-- สิ่งที่ AI ต้องรู้ แต่ไม่เห็นในโค้ด/ไฟล์ -->
- Base URL: https://...
- ข้อมูลใน Excel ≠ ระบบ (salary bug อยู่ระหว่างแก้) → ใช้ regex check แทน exact match
- สาลินี อาจารีย์ มีช่องว่างหลายตัวในชื่อ — ยังไม่ได้แก้
- ...

---

## Skill ที่ใช้อยู่
| Skill | สถานะ | Output ล่าสุด |
|-------|-------|--------------|
| `data-type-matrix-generator` | เสร็จแล้ว | `datatype_matrix_*.csv` |
| `e2e-test-generator` | กำลังทำ | `tests/ui/payroll/DTM_PAY_PAYROLL.spec.ts` |
| `test-case-writer` (UAT checklist) | pending | - |
```

---

## เมื่อไหรควรสร้าง HANDOFF.md

| สัญญาณ | Action |
|--------|--------|
| ใกล้ถึง rate limit / context limit | สั่ง AI สร้าง HANDOFF.md ก่อน session หมด |
| ต้องหยุดทำงานแล้วกลับมาทำต่อพรุ่งนี้ | สร้าง HANDOFF.md ก่อนปิด |
| ส่งต่องานให้คนอื่น | สร้าง HANDOFF.md ให้เพื่อนร่วมทีม |
| สลับ AI tool (Claude → GPT / Gemini / ...) | สร้าง HANDOFF.md เพราะ memory ไม่ข้าม tool |

---

## Tips

- **อย่าสรุปยาว** — AI ตัวใหม่อ่านไม่หมด → bullet สั้น ชัด พอ
- **"ตัดสินแล้ว" section สำคัญที่สุด** — ป้องกัน AI วนซ้ำ
- **ระบุ file path จริง** — ให้ AI อ่านได้ทันที ไม่ต้อง search
- **Next Step ต้องเป็น action ทันที** — ไม่ใช่ goal คลุมเครือ
