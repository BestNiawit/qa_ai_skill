# SKILL.md Template — Universal 8-Section

> Template สำหรับสร้าง skill ใหม่ใน repo นี้ — ทุก skill ต้อง follow 8 sections นี้ เพื่อให้ทีม QA เรียนรู้ได้เร็วและ skill chain ต่อกันได้
> **ไม่ใช่ skill จริง** — ไฟล์นี้ไม่มี frontmatter ดังนั้น Claude จะไม่ load เป็น skill

---

## Frontmatter (บังคับ)

```yaml
---
name: <skill-name>                                          # kebab-case, unique
description: <ทำอะไร> — <input> → <output> — <key features>.
  Trigger เมื่อ user <TH keywords>, "<EN keywords>", "<slash command name>".
  Maps to SDP §<section>.
---
```

**กฎ description:**
- ขึ้นต้นด้วย verb: "เขียน", "สร้าง", "วิเคราะห์", "ตรวจ"
- ระบุ input → output ชัดเจน
- ใส่ trigger keywords ทั้ง TH + EN (คั่นด้วย comma)
- ลงท้ายด้วย "Maps to SDP §X" ถ้ามี mapping กับ Software Development Process

---

## 8 Sections (ลำดับคงที่ทุก skill)

```markdown
# <Skill Name>

## 1. Purpose — เป้าหมาย
- ทำอะไร (1-2 ประโยค)
- Effort savings (ถ้ามี): "ลด effort ~50% เทียบกับ manual (SDP §5.3.4)"
- Key rules สั้นๆ (bullet 3-5 ข้อ)

## 2. When to Use — เมื่อไหร่ใช้
- SDP mapping: "Process: <SDP process name> (§X)"
- ตารางเทียบกับ skills พี่น้อง (ใช้ skill นี้ vs skill อื่นเมื่อไหร่)

## 3. Inputs — สิ่งที่ต้องเตรียม
- ตาราง Required / Optional inputs
- `project-context.md` placeholder (ถ้า skill ต้องการ env/glossary/NFR เฉพาะโปรเจกต์)
- ต้องถาม user อะไรบ้างถ้า input ไม่ครบ

## 4. Outputs — สิ่งที่ได้
- รูปแบบ output (Markdown/CSV/JSON/Script)
- Template ที่ใช้ (path → `templates/...`)
- File naming convention: `<prefix>_<scope>_<YYYYMMDD>.<ext>`
- ตัวอย่าง output สั้นๆ

## 5. Process — ขั้นตอน
- Step 1: Read input
- Step 2: Ask user (ถ้าจำเป็น)
- Step 3: Check existing assets (ห้ามสร้างซ้ำ)
- Step 4: Generate ตาม template
- Step 5: Verify / Lint (ถ้ามี)
- Step 6: Save + summary

## 6. Quality Gate — Checklist ก่อนส่ง
- [ ] Must-Have items (จาก SDP §5.1 ถ้าเกี่ยวกับ work product)
- [ ] Nice-to-Have items
- [ ] Red Flags (ทำแล้ว reject ทันที)

## 7. AI Guardrails — ข้อควรระวัง
- อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- Skill-specific ข้อควรระวัง (ถ้ามี)
- ข้อห้าม (bullet list)

## 8. Chain — เชื่อมกับ skills อื่น
- **Upstream** (skill ที่ feed เข้า): ...
- **Downstream** (skill ที่รับต่อ): ...
- Workflow ตัวอย่าง

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- Internal: `templates/`, `examples/`, `frameworks/`
- External: IEEE 829, ISTQB, ฯลฯ
```

---

## Folder Structure ของแต่ละ Skill

```
skills/<skill-name>/
├── SKILL.md              ← 8 sections ด้านบน
├── templates/            ← output templates (TH/EN, multiple formats)
│   ├── <name>-th.md
│   ├── <name>-en.md
│   └── <name>.csv
├── references/           ← skill-specific reference (ถ้ามี content ยาวเกิน SKILL.md)
│   └── <topic>.md
├── examples/             ← sample input → output
│   └── README.md
└── frameworks/           ← เฉพาะ generator skills ที่รองรับหลาย framework
    └── <framework>.md
```

**Shared references** อยู่ที่ repo root (`/references/`) — ไม่ต้อง copy เข้าแต่ละ skill

---

## Guidelines

### เขียน SKILL.md ให้ universal (ใช้กับโปรเจกต์อื่นได้)
- แยก **Standards** (IEEE 829, ISTQB) จาก **Company-specific** (sign-off flow, severity scale)
- Standards → embed ใน SKILL.md หรือ `references/` ของ skill
- Company-specific → `templates/` + `project-context.md` (user วางในโปรเจกต์ตัวเอง)

### ให้ skill รองรับ `project-context.md`
สร้างไฟล์ `project-context.md` ใน working directory เพื่อ override defaults:

```markdown
# Project Context
## Scope
- Modules: User Management, Payment Gateway
## NFR
- p(95) response time: 3s
- Error rate: <1%
## Environment
| Server | 10.0.1.50 |
| DB     | Oracle 19c — SIT_DB_v2.1 |
| URL    | https://sit.example.com |
## Glossary
- "AT" = Assessment Tax
- "PMS" = Property Management System
## Severity Scale
- P0 = แก้วันนี้, P1 = sprint นี้, P2 = sprint หน้า
```

Skill อ่านไฟล์นี้ก่อน แล้ว apply ใน output — ไม่ต้อง hardcode ค่าใน SKILL.md

### Dual-language description
Description ต้องมี trigger keywords ทั้ง TH + EN เช่น:
> "Trigger เมื่อ user ขอ test plan, testing strategy, 'write test plan', 'generate SIT plan'"

### ข้ามไม่ได้
- ❌ ข้าม section ไหนก็ได้ — ถ้าไม่มี content ใส่ "N/A" พร้อมเหตุผลสั้นๆ
- ❌ เปลี่ยนลำดับ section
- ❌ ใส่ company-specific data ใน SKILL.md โดยตรง (ให้ user override ผ่าน `project-context.md`)

---

## Checklist สำหรับ Contributor

สร้าง skill ใหม่ → ติ๊กก่อน PR:
- [ ] Frontmatter ครบ (name, description with TH+EN triggers)
- [ ] 8 sections ครบตามลำดับ
- [ ] Link ไปยัง `references/ai-guardrails.md` และ `references/sdp-mapping.md`
- [ ] มีตารางเทียบกับ skills พี่น้องใน §2
- [ ] Chain (§8) ระบุ upstream + downstream อย่างน้อย 1 skill
- [ ] มี `templates/` หรือ `examples/` อย่างน้อย 1 ไฟล์
- [ ] Update [`references/sdp-mapping.md`](references/sdp-mapping.md) (เพิ่มแถวในตาราง)
- [ ] Update [`README.md`](README.md) skill table
