# EP3 — Prep & Outline

> สร้างเมื่อ: 2026-04-28 (ก่อนเริ่มเขียน EP3)
> Status: outline only, ยังไม่ draft

---

## Hook ที่ EP2 ทิ้งไว้

ปิดท้าย EP2 ด้วยประโยคนี้

> *EP3 is going to be the one where I talk about the stuff we built and then threw away, why `data-type-matrix-generator` almost didn't make it into the system at all, and the internal argument we had about whether AI should ever be allowed to estimate effort in a test plan. (Short answer: probably not, but I'll explain why we tried it anyway.)*
>
> *Basically the messier, less polished story of how this actually got built.*

EP3 ต้อง deliver 3 promise นี้ และ tone ต้อง "messier, less polished" มากกว่า EP2

---

## Working title (ลองคิด)

ตัวเลือก

1. *EP3: The Skills We Built and Threw Away*
2. *EP3: What We Got Wrong About `data-type-matrix-generator` and Other Quiet Failures*
3. *EP3: When the AI Tried to Estimate Effort, And Other Bad Ideas We Almost Shipped*
4. *EP3: The Less-Polished Version*

ผมชอบ #1 (ตรง direct เกี่ยวกับ failure) หรือ #3 (มี hook กว่า) เลือก final ตอนเขียนจริง

---

## 3 topics หลักที่ต้องครอบคลุม (ตาม EP2 promise)

### Topic A: Skills ที่สร้างแล้วทิ้ง

**Question to answer:** อะไรที่ลองทำแล้วไม่เวิร์ค ทำไม

ต้องเก็บข้อมูลจริงจาก git log / branches เก่า ก่อนเขียน

ตัวอย่างที่เป็นไปได้ (ต้องเช็คใน repo)
- skill ที่ generate test data fixtures (อาจถูกแทนด้วย `data-type-matrix-generator`)
- skill ที่ทำ regression analysis แต่ accuracy ต่ำ
- skill ที่ summarize Slack threads (out of scope)
- skill ที่ generate API contract tests จาก swagger

**Pattern ที่อยากให้คนอ่านเห็น:**
- ทิ้งเพราะ scope creep (พยายามทำเกินหน้าที่)
- ทิ้งเพราะ overlap กับ skill อื่น
- ทิ้งเพราะ output ใช้ไม่ได้จริง
- ทิ้งเพราะ tokens เปลืองเกินคุ้ม (link กลับ EP2)

### Topic B: `data-type-matrix-generator` เกือบไม่ได้อยู่ใน system

**Question to answer:** ทำไมเกือบไม่ทำ ทำไมสุดท้ายทำ

จาก HANDOFF เก่า: skill นี้ถูกเพิ่มเข้ามาช่วงหลัง ไม่ได้อยู่ใน plan แรก

Angles ที่น่าจะใช้
- ตอนแรกคิดว่าซ้ำกับ `test-case-writer` (cover boundaries อยู่แล้ว)
- เปลี่ยนใจเพราะเจอ case ที่ TC ขาด edge ของ data type (THB rounding, null handling)
- pivot moment: ตอนไหนที่ทีมเห็นว่าต้องมี
- บทเรียน: trust the gap, ไม่ใช่ trust the tool list

### Topic C: AI estimate effort ใน test plan

**Question to answer:** ทำไมเคยลอง ทำไมเลิก

Promise ใน EP2: *"short answer: it shouldn't, and here's why we tried it anyway"*

Angles
- บริบท: PM อยากได้ estimate วันที่ส่งจาก test-plan-writer
- ผลที่ได้: AI ตอบเลขสวยมาก แต่ไม่สัมพันธ์กับ reality
- ทำไมล้มเหลว: AI ไม่มี calibration กับ team velocity / context ของคน
- บทเรียน: AI ดี at structuring information, ไม่ดี at predicting human work
- Decision: เก็บ skill ไว้แต่ output เป็น "complexity tag" ไม่ใช่ "hours"

---

## Suggested structure

โครงเริ่มต้น (ปรับได้)

```
1. Hook opener (1-2 paragraphs)
   anecdote ของวันที่ทีมเถียงกันเรื่องสกิลตัวนึง
   หรือ moment ที่ skill ตัวนึงพังต่อหน้า

2. Context recap (สั้น)
   "EP2 was the polished story. This one isn't."

3. ... (section break)

4. Topic A: The graveyard of skills we built and threw away
   list 3-4 skills ที่ทิ้ง พร้อม reason
   อาจมีตาราง / รูป "skill graveyard" diagram

5. ... (section break)

6. Topic B: data-type-matrix-generator almost didn't exist
   the moment we changed our minds
   what tipped us over

7. ... (section break)

8. Topic C: The effort estimation argument
   why PM wanted it
   why we tried
   why it failed
   what we kept

9. ... (section break)

10. Pattern: what makes a skill worth keeping
    distill 2-3 principles จาก 3 topics ข้างบน
    aim สำหรับ practical takeaway

11. ... (section break)

12. What's coming in EP4 (ถ้าจะมี)
    หรือ closing reflection
```

---

## Image candidates (ตอนนี้ยังเป็น idea เฉยๆ)

1. **Skill graveyard** — ตาราง / grid ที่แสดง skill ที่ทิ้ง พร้อมเหตุผล color-coded
2. **Effort estimation: AI vs reality** — scatter plot ที่ AI estimate vs actual hours, แสดงว่าไม่ correlate
3. **Decision matrix** — 2x2 grid: keep vs throw away, axis = tokens spent / value delivered

ตัดสินตอน outline final แล้ว

---

## Tone reminders (อย่าลืม)

ดู `HANDOFF.md` section "บทเรียนจาก process แก้ EP2"

สรุปสำคัญ
- ไม่ใช้ em dash
- ไม่ใช้ aphorism punchy สั้นๆ
- เขียนแบบมือใหม่ ใส่ filler word
- bold เฉพาะ key insight section ละ 1 จุด
- ใช้ `. . .` เป็น section break
- ทุก section service core thesis (TBD ของ EP3) ไม่งั้นตัด

---

## Thesis candidates สำหรับ EP3

ยังไม่ตัดสินใจ พิจารณา

1. *"You learn more from skills you killed than skills you kept."*
2. *"AI is great at structuring what you already know. It's bad at guessing what you don't."*
3. *"The skills that survived weren't the smartest. They were the ones that knew their lane."*

#1 เปิดกว้างที่สุด, #2 specific มากที่สุด (link กับ topic C), #3 มี angle เกี่ยวกับ design

ตัดสินหลัง draft รอบแรก

---

## Research ที่ต้องทำก่อนเขียน

- [ ] เช็ค git log หา commit ที่ลบ skill ออก / branch ที่ตาย
- [ ] หา draft `SKILL.md` เก่าของ skill ที่ทิ้ง (ถ้ามีใน history)
- [ ] รวบรวม PM feedback เกี่ยวกับ effort estimation (Slack หรือ doc)
- [ ] note: timestamp ของ moment ที่ตัดสินใจเก็บ `data-type-matrix-generator`
- [ ] อ่าน EP2 published version จริงอีกครั้ง เพื่อ reference tone

---

## Open questions (ยังตอบไม่ได้)

- EP3 ควรยาวประมาณเท่ากับ EP2 (~1500 words) หรือยาวกว่า?
- จะมีตอน "what makes a skill worth keeping" เป็น principle list ดีไหม หรือทำให้รู้สึก polished เกิน
- จะมี EP4 ไหม หรือจบ series ที่ EP3
