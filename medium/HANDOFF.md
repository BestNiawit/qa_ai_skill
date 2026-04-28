# HANDOFF — Medium Series: QA AI Skills

> อัปเดตล่าสุด: 2026-04-28 (หลัง EP2 publish)

---

## สถานะปัจจุบัน

- **EP2 ปล่อยแล้ว** บน Medium → [EP2 published](https://medium.com/@nirawit.mail/ep2-how-13-ai-skills-actually-connect-and-why-token-cost-started-bothering-me-f965f4de7eed)
- กำลังเตรียม **EP3** — ยังไม่เริ่มเขียน

---

## ทำไปแล้ว ✅

- **EP1** publish แล้ว (TH) — เนื้อหาอยู่ใน conversation history เก่า
- **EP2** publish แล้ว (EN) → `medium/ep2-how-13-skills-connect.md`
- **EP2 assets** เก็บไว้ที่ `medium/assets/ep2/`
  - `img_token_compare.png` — Prompt A vs Prompt B comparison
  - `img_locator_source.png` — Without locators vs with `data-testid`
  - `img_pm_format.png` — Slack DM vs structured `requirement-analyzer` output
  - `make_images.py` — matplotlib script ที่ใช้ generate รูปทั้งหมด (เก็บไว้เผื่อปรับ style EP3)

---

## ยังไม่เสร็จ / ค้างอยู่ ⏳

| Task | Blocker | Priority |
|------|---------|----------|
| เขียน EP3 (draft) | ยังไม่เริ่ม | High |
| EP3 รูป (ถ้าต้องใช้) | รอ outline | Medium |

ดู `medium/ep3-prep.md` สำหรับ outline + topic

---

## Files

| File | เนื้อหา |
|------|---------|
| `medium/ep2-how-13-skills-connect.md` | EP2 ฉบับ published (final, EN) |
| `medium/ep3-prep.md` | Outline + topic plan สำหรับ EP3 |
| `medium/assets/ep2/` | รูปที่ใช้ใน EP2 + script |
| `skills/` | 14 skills ทั้งหมด — source material ของ series |
| `references/qa-standards.md` | single source of truth ที่พูดถึงใน EP1 |

---

## บทเรียนจาก process แก้ EP2 (สำคัญมากสำหรับ EP3) 📌

ใช้เป็น checklist ทุกครั้งที่เขียน draft ใหม่

### Tone & voice

- **ห้ามใช้ em dash (`—`) เด็ดขาด** ใช้ comma, period, วงเล็บ, หรือขึ้นประโยคใหม่แทน เป็น AI tell ที่ชัดที่สุด
- เขียนแบบ **คนพึ่งหัดเขียน** ไม่ใช่ professional writer ใส่ "kind of", "honestly", "basically", "like" ปนเข้ามา
- **ห้าม aphorism / punchline สั้นๆ คมๆ** เช่น "Format changes behavior." "Token is attention." → AI เขียนแน่นอน
- **ห้ามเขียนประโยค 2-ท่อนสมมาตร** "X is not Y. It's Z." pattern AI ชอบใช้
- ห้ามใช้ "Furthermore", "In conclusion", "It's worth noting", "Notably"
- ใช้ประโยคยาวสลับสั้น ไม่เป็น rhythm คาดเดาได้

### Structure

- ใช้ **`. . .`** เป็น section break (Medium native) ไม่ใช่ `——` หรือ `---`
- **Bold เฉพาะจุดสำคัญ section ละ 1 จุด** ไม่เกิน 5-6 ครั้งทั้งบทความ ไม่งั้นจะรกตาและสูญน้ำหนัก
- Heading ระดับ 2 (`##`) ใช้สำหรับ section หลัก ไม่ใช้ระดับ 3 ลึกกว่านั้น
- Recap intro ใส่ในรูป **block quote (`>`) + italic** ทำให้ contrast กับ body
- หัวข้อเปิด section "admitting something I got wrong" ใช้ italic เพื่อบ่งว่าเป็น callout ไม่ใช่ heading ปกติ

### Image strategy

- ทุก section หลักควรมี 1 รูปสนับสนุน (ไม่ใช่ทุก section)
- รูปต้อง **carry information** ที่ text ไม่ต้องบอกซ้ำ (ถ้าใส่รูปแล้วยัง explain เหมือนเดิม = ตัด text ออก)
- Style: clean white bg, side-by-side comparison สำหรับ before/after, ใช้ palette แดงอ่อน (bad/old) + เขียวอ่อน (good/new) + ส้ม accent
- Caption สั้น 1 บรรทัด มี value ของตัวเอง ไม่ใช่ซ้ำกับ heading

### Content

- ทุก section ต้อง **service core thesis** (token = attention, skills ≠ workflow) ไม่งั้นตัด
- เปิด section ด้วย anecdote/specific มากกว่า abstract
- มีอย่างน้อย 1 จุดที่ admit fail / ของที่ยังไม่ work (สร้าง credibility)
- ปิดด้วย hook ทิ้งไป EP ถัดไป

---

## ตัดสินแล้ว — ห้ามถามซ้ำ ⛔

- Series เขียน **ภาษาอังกฤษ** ตั้งแต่ EP2 เป็นต้นไป (EP1 เป็น TH)
- ห้ามระบุชื่อบริษัท
- เขียนให้ฟีลเหมือน engineer จริงๆ นั่งเล่า มี admit fail มีของไม่ work
- ไม่ต้องมี "Furthermore", "In conclusion", "It's worth noting"

---

## Core thesis ของ series ทั้งหมด

```
EP1: ปัญหา           ทีมใช้ AI แบบมั่ว → เลยสร้าง skills เพื่อ
                    standardize team context

EP2: ระบบที่ work    skills 13 ตัวเชื่อมเป็น workflow ได้ยังไง
                    + ทำไม token economy คือกุญแจ
                    Thesis: "tokens = attention, not just cost"

EP3: ความล้มเหลว     อะไรที่สร้างแล้วทิ้ง อะไรที่เกือบไม่ทำ
                    อะไรที่เถียงกันในทีม
                    Thesis: TBD (ดู ep3-prep.md)
```

---

## Next Step (ทำอันนี้ต่อทันที)

1. อ่าน `medium/ep3-prep.md` เพื่อดู outline + topics
2. เลือกว่าจะเปิดเรื่อง EP3 ด้วย angle ไหน (anecdote/skill ที่ทิ้ง/argument ภายใน)
3. Draft EP3 แบบ section-by-section ใน code box (ทำได้ดี process นี้)
4. Generate รูปประกอบ (ถ้ามี) ใส่ใน `medium/assets/ep3/`
5. Review tone กับ checklist ข้างบน ก่อนปล่อย

---

## Context ที่ EP3 ต้องใช้

- `data-type-matrix-generator` ถูกเพิ่มเข้ามาช่วงหลัง เดิมทีไม่ได้อยู่ใน plan — เป็น angle หลักของ EP3
- ทีมใช้ Claude Code เป็น plugin ผ่าน `.claude-plugin/plugin.json`
- Skills ทั้งหมดอยู่ที่ `skills/` แต่ละ skill มี `SKILL.md` ที่มี frontmatter + 8 sections บังคับ
- Validator: `python3 scripts/validate_skills.py`
- EP1 ภาษาไทย เนื้อหาเดิมอยู่ที่ `/Users/nirawit/.claude/projects/-Users-nirawit-Documents-GitHub-qa-ai-skill/819d1f5d-3b52-4977-830a-1717e104caa2.jsonl`
