# EP4 — Prep & Outline

> สร้างเมื่อ: 2026-05-08 (หลัง EP3 publish)
> Status: outline only, ยังไม่ draft
> Angle: tech-heavy ตามที่ user ขอ "อยากเห็นของข้างใน"

---

## Hook ที่ EP3 ทิ้งไว้

ปิดท้าย EP3 ด้วยประโยคนี้

> *ยังเหลือเรื่องที่ไม่ได้เล่า. ที่เขียนไป 3 เคสเป็นแค่ส่วนหนึ่งของของที่ messy. ยังมีเรื่องที่ skill เคยทำงานพังเพราะ token limit, เรื่องที่ทีมไม่อยาก trust output, เรื่อง onboarding ที่ใช้เวลานานกว่าคิด*

ปกติ EP4 จะหยิบ 3 เรื่องนี้มาเล่าต่อก็ได้ แต่ user ต้องการ tech มากๆ ไม่ใช่เรื่องเล่า ดังนั้น EP4 จะ **pivot** ไปอีกทาง: ผ่าดูข้างในของ skill ตัวจริง อธิบายกลไกที่เกิดขึ้นเวลา Claude โหลด trigger run skill — แล้วใช้ token / chaining / onboarding 3 เรื่องที่ค้างจาก EP3 มาเป็น *ตัวอย่าง* ของ implication ทาง engineering แทน

อีกนัยคือ EP3 = "เรื่องของทีม", EP4 = "เรื่องของระบบ"

---

## Working title (ลองคิด)

ตัวเลือก

1. *EP4: ผ่าดูข้างใน — ของจริงในหนึ่ง skill มีอะไรบ้าง*
2. *EP4: How a Skill Actually Loads (and Why That Matters for Tokens)*
3. *EP4: The Anatomy of a SKILL.md and the Quiet Mechanics Around It*
4. *EP4: เขียน skill ให้ AI โหลด — เบื้องหลังของ frontmatter, lazy load, และ chain*

ผมชอบ #1 ภาษาไทย ตรง direct มี hook "ของข้างใน" ตามที่ user ขอ
ตัดสินตอนเขียน draft จริง

---

## Language

ดู series:
- EP1 = TH
- EP2 = EN
- EP3 = TH (user override จาก HANDOFF)
- EP4 = ? (default → ทำต่อเป็น TH ให้ flow กับ EP3)

ถ้าจะกลับไป EN ต้อง confirm ก่อนเขียน draft

---

## 4 topics ที่ต้อง cover (เน้น tech)

### Topic A — Anatomy ของ skill ตัวเดียว

**Question to answer:** SKILL.md ตัวจริงข้างในเป็นยังไง

ใช้ `test-case-writer` เป็น case study (เป็น skill ที่ใหญ่ที่สุดในระบบ ~372 บรรทัด มี templates 5 ไฟล์ + reference 1 ไฟล์)

ต้องโชว์
- folder layout: `SKILL.md` + `templates/` + `references/` + (บางตัวมี) `examples/` `frameworks/`
- frontmatter (name + description) — กี่ token, ทำหน้าที่อะไร
- 8 sections — Purpose / When to Use / Inputs / Outputs / Process / Quality Gate / AI Guardrails / Chain
- ทำไม 8 ไม่ใช่ 5 หรือ 12 (มาจาก trial-and-error)
- ไฟล์ใน `templates/` — ใช้ token เพิ่มเฉพาะตอนต้องการ output format นั้น

**Pattern ที่อยากให้คนอ่านเห็น:** skill ไม่ใช่แค่ไฟล์เดียว มันเป็น *bundle* ที่จัดวางให้ Claude เลือกหยิบเฉพาะที่ต้องใช้

### Topic B — Trigger + Lazy Loading

**Question to answer:** Claude รู้ได้ยังไงว่าเมื่อไหร่ต้องเรียก skill ไหน + อะไรโหลดเข้า context เมื่อไหร่

ของจริงใน Claude Code plugin:
- ตอนเปิด session: load *เฉพาะ frontmatter* ของทุก skill (name + description)
- ทุกครั้งที่ user พิมพ์ message: Claude scan keyword ใน description match กับ user intent
- ถ้า match → load body ทั้งหมดของ skill นั้นเข้า context
- ถ้าไม่ match → skip

ทำไม description ต้องเขียน keyword-heavy ไม่ใช่ flowery prose:
- description คือ **prompt to the model that decides whether to load you**
- ถ้าเขียนสวยแต่ไม่มี keyword ที่ user น่าจะพูด → skill จะไม่ถูก trigger

ตัวอย่าง: description ของ test-case-writer มีทั้ง TH + EN keywords + slash command name + SDP mapping — ทุกอย่างเป็น signal

**Implication ทาง token:** lazy loading = ระบบรับ skill ใหม่ได้เรื่อยๆ โดยไม่ระเบิด context limit

ลิงก์ EP2: token = attention. EP4 ขยายว่า attention ก็เป็น loading order ด้วย

### Topic C — Chaining ระหว่าง skill (ใช้ filename เป็น message)

**Question to answer:** skill 14 ตัวเชื่อมกันยังไง ถ้า Claude ไม่มี API ทางการระหว่าง skill

The unsexy answer: **ไม่มี glue layer** ที่ designed ขึ้นเลย

ของจริงคือ skill เขียน output เป็นไฟล์ตาม naming convention เช่น `testcases_sit_<module>_<YYYYMMDD>.md` — แล้ว skill ตัวถัดไป (เช่น test-case-reviewer) อ่านไฟล์นั้นเป็น input

User เป็นคนพิมพ์ chain เอง:
```
@testcases_sit_login_20260420.md review หน่อย
```

filename + path = "ข้อความที่ skill ส่งให้กัน" ผ่านมือ user

ทำไมไม่ทำ programmatic chain:
- AI ไม่เห็น state ระหว่าง session
- user เห็นทุก step → debug ได้ → trust สูงกว่า
- accidentally architectural: constraint นี้ทำให้ระบบ debuggable

นี่คือจุดที่ "skills ≠ workflow" จาก EP2 ออกมาให้เห็นเป็นรูปธรรม

### Topic D — Override Layer: project-context.md + shared references

**Question to answer:** skill ตัวเดียวกันใช้ข้าม project ได้ยังไงโดยไม่ต้องแก้

Layer ทั้ง 3:
1. **SKILL.md** — universal (ห้าม hardcode company-specific)
2. **`references/qa-standards.md`** (root) — shared rules (Severity/Priority/Sizing) ที่บังคับทุก skill
3. **`project-context.md`** (working dir) — override per-project (NFR / Glossary / Environment)

skill อ่าน 3 layer นี้รวมกัน → output ที่ถูก project แต่ไม่ rewrite skill

ทำไมไม่ฝัง config ใน skill โดยตรง:
- skill จะ ตาย ถ้าย้าย project
- ทุกการเปลี่ยน scale ต้องไปแก้ทุก skill (ไม่ DRY)
- shared layer ทำให้ "เปลี่ยน Severity scale ทั้งระบบ = แก้ที่เดียว"

อันนี้เชื่อมกับ "feedback: qa-standards as single source of truth" ใน memory

---

## 5th topic ที่อาจใส่ถ้ามีพื้นที่

**Topic E — validate_skills.py (CI ที่ enforce architecture)**

`scripts/validate_skills.py` เช็ค 5 อย่าง:
1. frontmatter ครบ + name = folder + unique
2. 8 sections มาครบ + ลำดับถูกต้อง
3. link ไป `references/ai-guardrails.md`
4. ไม่ใช้ deprecated code (P0-P3, Sev1-4)
5. markdown link ไม่ตาย

เป็น *enforcement* ของทุก decision ใน 4 topics ข้างบน — ถ้า PR ผิด architecture, CI fail

ใช้ปิดท้ายเป็น "the architecture isn't aspirational, it's enforced" ก็ได้

ถ้า EP4 ยาวเกิน → ตัดออกไป EP5

---

## Suggested structure

```
1. Hook opener
   anecdote ของวันที่ skill ตัวหนึ่งทำงานพังเพราะ context overflow
   หรือ: moment ที่เห็นว่า trigger ไม่ทำงาน เพราะ description ผิด

2. Recap
   "EP3 เป็นเรื่องของทีม. EP4 เป็นเรื่องของระบบ."
   "ถ้าใครงงตอน EP2 ว่ามันเชื่อมกันยังไงจริงๆ — EP4 จะเปิดฝาให้ดู"

3. ... (section break)

4. Topic A: ผ่าดู test-case-writer
   folder layout + frontmatter + 8 sections
   มีรูป anatomy diagram

5. ... (section break)

6. Topic B: เวลา skill ถูกโหลด เกิดอะไรขึ้น
   lazy loading sequence + ทำไม description ต้อง keyword-heavy
   มีรูป loading timeline

7. ... (section break)

8. Topic C: Chain ที่ไม่มี glue
   filename = message
   user เป็น orchestrator
   มีรูป data flow diagram

9. ... (section break)

10. Topic D: 3 layer ของ override
    SKILL.md + qa-standards + project-context
    มีรูป layer diagram

11. ... (section break)

12. Pattern: constraint ที่ไม่ได้ design กลายเป็น architecture
    distill 2-3 insight
    aim ให้ practical สำหรับคนกำลังออกแบบ skill ของตัวเอง

13. ... (section break)

14. Closing + EP5 (ถ้ามี) — token limit story / trust / onboarding
```

---

## Image candidates

1. **SKILL.md anatomy diagram** — exploded view ของ folder + zoom เข้าไป frontmatter + 8 section labels (น่าจะใช้ test-case-writer เป็นต้นแบบ)
2. **Lazy load timeline** — 3 phase: session start (load all frontmatter ~few KB) → user typed prompt (keyword match) → triggered skill body loaded (full file)
3. **Chain via filename** — diagram ที่ skill A เขียนไฟล์ → user pastes filename → skill B อ่านไฟล์ (no API arrow, แต่มี user arrow ตรงกลาง)
4. **3-layer override** — stacked diagram: SKILL.md (universal) + qa-standards (team-shared) + project-context (per-project)
5. **CI enforcement** — flow ของ PR → validate_skills.py runs → 5 checks → green/red

ไม่ต้องครบทุกรูป ตัดสินตอน outline final

---

## Tone reminders

ดู `HANDOFF.md` section "บทเรียนจาก process แก้ EP2" + ที่ทำ EP3 จริง

สรุปสำคัญ
- ห้ามใช้ em dash เด็ดขาด
- เขียนแบบมือใหม่ ใส่ filler word ("kind of", "honestly", "แบบว่า", "จริงๆ")
- ห้าม punchy aphorism คมสั้น
- bold เฉพาะ key insight section ละ 1 จุด ไม่เกิน 6 จุดทั้ง EP
- ใช้ `. . .` เป็น section break
- caption รูปต้อง carry information ของตัวเอง

**เพิ่มสำหรับ EP4 (เพราะเป็น tech):**
- code block ใส่ได้ แต่ตัด context ก่อน (เช่น YAML frontmatter ของ test-case-writer ตัวจริง — paste ทั้ง block)
- อย่าเขียน code documentation style (ห้าม "Note:" "Important:") ให้คุยเหมือนเล่าเพื่อน
- พูด "การ trigger" / "matching" แทน "invocation" / "dispatch"
- ถ้าต้องใช้ jargon → อธิบายแบบ casual ครั้งแรกแล้วใช้ต่อได้เลย

---

## Thesis candidates สำหรับ EP4

ยังไม่ตัดสิน

1. *"Constraints we didn't plan became the architecture we have."*
2. *"A skill description is not documentation. It's a prompt to the model that decides whether to load you."*
3. *"The most interesting parts of a skill are the boring ones — the filename, the frontmatter, the convention."*

#1 กว้าง connect ทุก topic ได้ (lazy load = ข้อจำกัดของ context window, chain via filename = ไม่มี API ระหว่าง skill, 3-layer override = constraint ของ universal skill)
#2 specific link Topic B ดี
#3 เป็น storytelling angle มากกว่า

ตัดสินหลัง draft รอบแรก — แต่ #1 มีน้ำหนักมากที่สุดสำหรับ EP4

---

## Research ที่ต้องทำก่อนเขียน

- [ ] วัด token count ของ frontmatter ทั้ง 14 skill รวม (ใช้ `tiktoken` กับ approximation 1 word ≈ 1.3 token) — เอาไว้ pitch lazy loading argument
- [ ] วัด token count ของ body ทั้ง 14 skill รวม (เทียบกับข้างบน)
- [ ] นับจำนวน templates / references ในแต่ละ skill — distribution
- [ ] ดู `validate_skills.py` รายละเอียดของ 5 check
- [ ] หาตัวอย่าง chain จริงในประวัติ (TC file ที่ test-case-reviewer review ต่อ)
- [ ] เช็คว่า `project-context.md` ถูก reference จาก skill กี่ตัว (grep)
- [ ] ดู Claude Code plugin docs สำหรับ "how plugin auto-discovery works" — confirm สิ่งที่อธิบายตรงกับของจริง
- [ ] อ่าน EP3 published version ก่อนเขียน เพื่อ flow ต่อ

---

## Open questions

- EP4 ภาษาอะไร — TH ต่อจาก EP3 หรือกลับ EN?
- ลึก tech ขนาดไหน — ใส่ YAML frontmatter เต็มของ test-case-writer (~10 บรรทัด) ได้ไหม หรือเอาแค่ snippet?
- ใส่ token count จริง (numbers) หรือใช้ approximate ("a few hundred tokens")
- หนึ่ง skill teardown หรือเทียบ 2-3 skill?
- ความยาวเทียบ EP2/EP3? EP3 ~860 words (Thai). EP4 อาจยาวกว่าเพราะ tech ต้องอธิบายมากขึ้น — น่าจะ 1,200-1,500
- จะมี EP5 ไหม? ถ้าเก็บ token-limit-story / trust / onboarding ของ EP3 ค้างไว้ → มี slot อยู่ EP5 พอดี

---

## Notes สำคัญสำหรับตอนเขียน

- **ห้ามขายของ** — EP4 เป็น tech post ไม่ใช่ promo อย่าเอ่ยว่า skill เก่ง / save effort เท่านี้ %; เก็บให้เป็น engineering tone ตลอด
- **ใส่ failure ทาง tech อย่างน้อย 1 จุด** เพื่อ credibility (เช่น มี skill ที่ description เขียนผิดแล้วไม่ trigger สัปดาห์กว่าจะรู้)
- **ทุก section service thesis** "constraint = architecture"; ถ้าจุดไหนไม่ link กลับ → ตัด
- **ปิดด้วย hook ทิ้ง EP5** ถ้าตัดสินใจเขียนต่อ ไม่งั้นปิดแบบ closing series

---

## Context ที่ EP4 ต้องใช้ (อยู่ใน repo แล้ว)

| ไฟล์ | ใช้ทำอะไร |
|------|-----------|
| `skills/test-case-writer/SKILL.md` | case study หลักของ Topic A |
| `skills/test-case-writer/templates/` | โชว์ template structure |
| `SKILL-TEMPLATE.md` | reference สำหรับ "8 sections มาตรฐาน" |
| `scripts/validate_skills.py` | source ของ Topic E ถ้าใส่ |
| `references/qa-standards.md` | layer 2 ของ override system |
| `references/ai-guardrails.md` | shared reference อีกตัว |
| `.claude-plugin/marketplace.json` | mechanic ของ Claude Code plugin |

---

## Next Step (ทำต่อทันที)

1. รัน research checklist ข้างบน (เก็บ token counts + ตัวเลขจริง)
2. ตัดสินภาษา + thesis
3. Draft section-by-section ใน code box
4. Generate รูป (ถ้าใช้) ใน `medium/assets/ep4/` reuse `make_images.py` ของ EP3 เป็น base
5. Tone review ก่อนปล่อย
