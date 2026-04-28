# HANDOFF — Medium Series: QA AI Skills
> สร้างเมื่อ: 2026-04-28 | Skill: handoff-writer

---

## สถานะปัจจุบัน

- กำลัง: เขียน Medium series เกี่ยวกับ QA AI Skills repo
- ค้างอยู่ที่: EP2 เสร็จแล้ว รอเขียน EP3

---

## ทำไปแล้ว ✅

- EP1 เขียนเสร็จและ publish แล้ว (ภาษาไทย) — เนื้อหาใน conversation history
- EP2 เขียนเสร็จแล้ว (ภาษาอังกฤษ) → `medium/ep2-how-13-skills-connect.md`

---

## ยังไม่เสร็จ / ค้างอยู่ ⏳

| Task | Blocker | Priority |
|------|---------|----------|
| เขียน EP3 | - | High |

---

## Files ที่เกี่ยวข้อง

| File | เนื้อหา |
|------|---------|
| `medium/ep2-how-13-skills-connect.md` | EP2 ฉบับเต็ม (EN) |
| `skills/` | 14 skills ทั้งหมด — source material ของ series |
| `references/qa-standards.md` | single source of truth ที่พูดถึงใน EP1 |

---

## ตัดสินแล้ว — ห้ามถามซ้ำ ⛔

- Series เขียน **ภาษาอังกฤษ** ตั้งแต่ EP2 เป็นต้นไป
- Tone: **tech-accessible, first-person, honest** — ไม่ formal ไม่ AI-sounding
- ห้ามระบุชื่อบริษัท
- เขียนให้ฟีลเหมือน engineer จริงๆ นั่งเล่า — มีช่วงที่ admit ว่า fail, มีเรื่องที่ไม่ได้ผล
- ไม่ต้องมี "Furthermore", "In conclusion", "It's worth noting" — ตัดออกทั้งหมด

---

## Next Step (ทำอันนี้ต่อทันที)

เขียน EP3 ตาม hook ที่ EP2 ทิ้งไว้:

> *"EP3 is going to be the one where I talk about what we built and threw away, why `data-type-matrix-generator` almost didn't make it into the system, and the argument we had internally about whether AI should ever be allowed to estimate effort in a test plan."*

เนื้อหาหลักของ EP3 ควรครอบคลุม:
1. Skills ที่ build แล้วทิ้ง — อะไร ทำไม
2. `data-type-matrix-generator` — เกือบไม่ได้อยู่ใน system เพราะอะไร
3. ถกเถียงเรื่อง AI estimate effort ใน test plan — ทำไมทำ ทำไมถอย
4. Lesson จริงๆ ที่ไม่ได้มาจากสิ่งที่ work

---

## Context สำคัญ

- EP1 เขียนเป็นภาษาไทย เนื้อหาอยู่ใน conversation — ถ้าต้องการ อ่านจาก `/Users/nirawit/.claude/projects/-Users-nirawit-Documents-GitHub-qa-ai-skill/819d1f5d-3b52-4977-830a-1717e104caa2.jsonl`
- `data-type-matrix-generator` ถูกเพิ่มเข้ามาช่วงหลัง — เดิมทีไม่ได้อยู่ใน plan แรก context นี้สำคัญสำหรับ EP3
- ทีมใช้ Claude Code เป็น plugin ผ่าน `.claude-plugin/plugin.json`
- Skills ทั้งหมดอยู่ที่ `skills/` แต่ละ skill มี `SKILL.md` ที่มี frontmatter + 8 sections บังคับ
- Validator อยู่ที่ `scripts/validate_skills.py` — รัน `python3 scripts/validate_skills.py` เพื่อเช็ค build

---

## Skill ที่ใช้อยู่

| Skill | สถานะ | Output ล่าสุด |
|-------|-------|--------------|
| `handoff-writer` | เสร็จแล้ว | ไฟล์นี้ |
| (Medium writing — ไม่ใช่ QA skill) | กำลังทำ EP3 | `medium/ep2-how-13-skills-connect.md` |
