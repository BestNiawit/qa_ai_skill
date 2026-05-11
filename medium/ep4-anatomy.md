<!--
  EP4 — Draft v1
  Language: Thai (per user request)
  Tone: tech-heavy, casual, no em dash in prose, frontmatter quoted as-is
  Target length: ~1,300 คำ
-->

# EP4: ผ่าดูข้างใน · skill ตัวจริงประกอบด้วยอะไร และ Claude ตัดสินใจโหลดมันยังไง

> *Recap สั้นๆ. EP1 เล่าปัญหา EP2 เล่าระบบที่ work EP3 เล่าของที่พังกับที่เกือบไม่ทำ. EP4 นี่คือฉบับ "เปิดฝา" คนถามมาเยอะว่าใน skill จริงๆ มีอะไร ตอบใน Slack ทีละคนไม่ไหว เลยรวมไว้นี่ที่เดียว.*

. . .

## *เริ่มด้วย bug ที่ใช้เวลาหนึ่งสัปดาห์ถึงจะรู้ว่าเป็น bug*

ตอนสร้าง skill ตัวที่ 7 หรือ 8 มีตัวหนึ่งที่ทุกคนในทีมบอกว่า "ไม่เคยใช้เลย ลืมไปแล้วว่ามี". ผมก็งงเพราะมัน design มาดีแล้วนะ.

ผ่านไปสัปดาห์หนึ่งถึงเข้าใจว่าปัญหาไม่ใช่คนไม่อยากใช้. ปัญหาคือเวลาเขาพิมพ์ขอใช้ skill นั้น Claude ไม่ trigger มันขึ้นมาเลย. ไปเรียก skill อื่นที่ใกล้เคียงแทน. คนใช้ก็ไม่รู้ว่ามี skill เฉพาะตัวอยู่ เพราะ output มันก็ออกมาได้ระดับนึง.

สาเหตุอยู่ที่บรรทัดเดียว. **`description` ของ skill ตัวนั้นเขียนสวยมากในเชิงภาษา แต่ไม่มี keyword ที่คนใช้พูดเลย**. AI เลยไม่รู้จะ match ตอนไหน. แก้ description ใหม่ใส่ trigger phrase ตามภาษาที่ทีมใช้จริง วันรุ่งขึ้น skill ก็เริ่มเด้งขึ้นมา.

ตั้งแต่นั้นเลยเริ่มเข้าใจว่า skill ไม่ใช่แค่ไฟล์ markdown ที่เขียน instruction ใส่ AI. ของข้างในมันมีกลไกเล็กๆ หลายอย่างที่ตัดสินว่า skill จะ work หรือไม่ work ก่อนที่ AI จะอ่านเนื้อหามันด้วยซ้ำ. EP4 นี้คือเรื่องของกลไกพวกนั้น.

. . .

## ผ่าดู skill ตัวเดียว: `test-case-writer`

จะเริ่มจาก skill ที่ใหญ่สุดในระบบเรา. structure ของมันเป็นแบบนี้.

```
skills/test-case-writer/
├── SKILL.md                          (372 บรรทัด)
├── templates/
│   ├── test-case-th.md              (template หลัก, ภาษาไทย)
│   ├── test-case-en.md              (template หลัก, อังกฤษ)
│   ├── test-case.csv                (สำหรับ import เข้า Excel/Jira)
│   ├── uat-checklist-th.md          (UAT mode multi-role)
│   └── uat-checklist-th.csv
└── references/
    └── testing-techniques.md        (ECP, BVA, Decision Table, ...)
```

ทุก skill ในระบบมี shape คล้ายๆ กัน. SKILL.md เป็น brain, templates กับ references เป็นของที่ skill เลือกหยิบมาใช้ตอน generate. ของในโฟลเดอร์ไม่ได้โหลดเข้า context ทั้งหมดทุกครั้ง อันนี้สำคัญมาก เดี๋ยวจะอธิบายต่อใน section ถัดไป.

ทีนี้เปิด `SKILL.md` มาดูข้างใน. บรรทัดแรกๆ ของไฟล์เป็นแบบนี้

```yaml
---
name: test-case-writer
description: เขียน test case จาก requirement document (SRS/PRD/spec/user story)
  ให้ครอบคลุมและอ่านง่าย — รองรับ SIT mode (technical view, 23 cols), UAT mode
  (business view 23 cols หรือ UAT Checklist multi-role workflow) + testing
  techniques (ECP, BVA, Decision Table, State Transition, Use Case, Error
  Guessing) + Traceability Matrix. รองรับ TH/EN + Markdown/CSV. Trigger เมื่อ
  user ส่ง requirement file/SRS/PRD/spec/user story และขอให้เขียน test case,
  test scenario, SIT test case, UAT test case, UAT checklist, "write test
  cases", "create test scenarios", "generate UAT checklist", "multi-role
  workflow test". Maps to SDP §5.3.1 (Process 2, 6).
---
```

แค่ส่วนนี้ส่วนเดียวมีของให้สังเกตหลายเรื่อง.

`name` ต้องตรงกับชื่อโฟลเดอร์ และต้องไม่ซ้ำกับ skill ตัวอื่น. ถ้าผิดกฎข้อนี้ CI ของ repo จะ fail ก่อน merge ด้วยซ้ำ (มี `validate_skills.py` คอยเช็ค).

`description` ส่วนแรกบอกว่า skill ทำอะไร, ส่วนกลางบอก mode ที่รองรับ, ส่วนสุดท้ายเป็น trigger keyword ทั้ง TH กับ EN รวมกันยาวเฟื้อย. ตอนเขียนใหม่ๆ ผมเคยคิดว่าเขียน description ยาวขนาดนี้น่าจะรก แต่ผ่าน bug ที่เล่าตอนต้นไป แล้วเข้าใจว่า description ไม่ใช่ documentation ให้คนอ่าน. มันเป็น signal ให้ AI ตัดสินใจว่าจะหยิบ skill นี้มาใช้หรือเปล่า. ทุก keyword ที่ใส่ไว้ = สถานการณ์หนึ่งที่ user น่าจะพิมพ์.

ส่วน body ของ SKILL.md ตามมาด้วย 8 section ที่ทุก skill ในระบบเราใช้เหมือนกัน. ลำดับ fix.

```
1. Purpose — เป้าหมาย + effort savings
2. When to Use — SDP mapping + เทียบกับ skill ที่ใกล้เคียง
3. Inputs — สิ่งที่ต้องเตรียม (รวม project-context.md placeholder)
4. Outputs — format, template, file naming convention
5. Process — ขั้นตอน step-by-step
6. Quality Gate — checklist ก่อนส่ง
7. AI Guardrails — ข้อควรระวัง
8. Chain — เชื่อมกับ skill อื่น (upstream/downstream)
```

ถามตรงๆ ว่าทำไม 8 ไม่ใช่ 5 หรือ 12. คำตอบไม่ romantic เลย คือ trial-and-error. รอบแรก skill มี 12 section ตามที่คิดว่าควรครอบ ปรากฏว่ามันยาวเกินจะอ่านจบ tester ใช้แค่ section 3 (Inputs) กับ 4 (Outputs) จริงๆ. รอบสอง compress เหลือ 5 ปรากฏว่าหลายเรื่องที่ตัดออก (Quality Gate, Guardrails) กลับมาเป็นปัญหาตอน skill ขยาย. รอบสาม settle ที่ 8 และอยู่มาตั้งแต่ตอนนั้น. **โครงสร้างที่อยู่นานในระบบไหนก็ตาม ส่วนใหญ่ไม่ได้มาจาก insight แต่มาจากของที่ตัดทิ้งจนเหลือเท่านี้**.

. . .

## เวลา skill ถูกโหลด เกิดอะไรขึ้นจริงๆ

อันนี้คือส่วนที่หลายคนถามกันเยอะสุด. ทำไมระบบไม่ช้าทั้งที่มี skill 14 ตัวอยู่. ทำไมบางครั้ง skill ก็เด้งมา บางครั้งไม่เด้ง.

คำตอบคือ Claude Code โหลด skill แบบ lazy. ลำดับเวลาประมาณนี้.

**ตอน session เริ่ม:** Claude อ่านเฉพาะ frontmatter (`name` + `description`) ของทุก skill. ไม่อ่าน body. รวม 14 skill ก็ใช้แค่หลักพัน token ไม่กระทบ context window เลย.

**ตอน user พิมพ์ message:** Claude scan keyword ใน description ของทุก skill เทียบกับ user intent. ถ้า match หนึ่งหรือหลายตัว → load *body ทั้งหมด* ของ skill นั้นเข้า context.

**ตอน skill ทำงาน:** ถ้า body พูดถึง template ในโฟลเดอร์ skill, Claude ค่อยอ่านไฟล์ template เพิ่ม. references ก็เหมือนกัน. ทุกอย่างเป็น on-demand.

ผลคือระบบรับ skill ใหม่ได้เรื่อยๆ โดย context ไม่บวม เพราะของที่อยู่ใน context จริงๆ มีแค่ frontmatter ทุกตัว + body ของ skill ที่ trigger จริงในรอบนั้น. EP2 ที่เคยพูดเรื่อง token = attention ก็จุดนี้แหละที่ทำให้ argument ใช้ได้จริงในระบบจริงๆ.

ของที่ตามมาจากกลไกนี้คือ description เลยกลายเป็นไฟล์ที่สำคัญที่สุดต่อความสำเร็จของ skill มากกว่า body ด้วยซ้ำ. body จะเขียนดีแค่ไหน ถ้า description ไม่ match keyword ของ user, skill จะไม่ถูก load body มาใช้เลยตั้งแต่แรก. นี่คือเหตุผลที่ bug ที่เล่าตอนต้น EP4 หาเจอช้าจัง คือเรา debug ผิดที่ ไปดู body ทั้งที่ปัญหาอยู่ที่ frontmatter.

. . .

## skill เชื่อมกันยังไง โดยที่ไม่มี API ระหว่าง skill

อันนี้เป็นคำถามที่คนถามแล้วผมตอบไปก็เห็นหน้าเขางงทุกครั้ง.

ของจริงคือ **ไม่มี glue layer ระหว่าง skill เลย**. ไม่มี dispatch, ไม่มี call API, ไม่มี state ที่ persist ระหว่างการเรียก. ทุก skill ทำงานจบในรอบของตัวเอง.

แล้วทำไม EP2 พูดถึง chain ได้ ทำไมเขียนใน documentation ว่า skill A → skill B → skill C.

คำตอบคือเราใช้ filename เป็น message format ระหว่าง skill. ทุก skill เขียน output เป็นไฟล์ตาม naming convention ตายตัว เช่น

```
testcases_sit_login_20260420.md          (output ของ test-case-writer)
review_report_sit_login_20260420.md      (output ของ test-case-reviewer)
sit_report_login_20260425.md             (output ของ test-report-writer)
```

แล้ว skill ตัวต่อไปอ่านไฟล์นั้นเป็น input ของตัวเอง. user เป็นคนพิมพ์ chain เองโดยอ้างไฟล์

```
@testcases_sit_login_20260420.md review หน่อย เทียบกับ SRS ที่ docs/srs.md
```

แค่นี้ test-case-reviewer ก็รู้ว่า input คืออะไร. ไม่ต้องมี orchestrator ไม่ต้องมี state.

ถามว่าทำไมไม่ทำ programmatic chain. หลายเหตุผลปนกัน. AI ไม่เห็น state ระหว่าง session อยู่แล้ว. user ที่เห็นทุก step ก็ debug ได้เร็วกว่า. แล้วถ้ามี bug ในกลางทาง user แก้ไฟล์ตรงๆ ได้เลยไม่ต้องรอ skill รัน.

ที่ผมว่าน่าสนใจคือ design นี้ไม่ได้ตั้งใจตั้งแต่แรก. มันเกิดเพราะข้อจำกัดของ AI tool มี state เดียวต่อ session. แต่พอใช้ไปสักพัก กลายเป็นว่าระบบ debuggable กว่าระบบที่มี orchestrator เยอะ. **ข้อจำกัดที่เราไม่ได้ตั้งใจ กลายเป็นโครงสร้างของระบบ** ซึ่งเป็น pattern ที่จะเห็นซ้ำใน section ถัดไปด้วย.

. . .

## skill ตัวเดียว ใช้ได้หลาย project ได้ยังไง

ถ้า skill มี environment URL hardcode อยู่ใน SKILL.md ก็จบเลย เปลี่ยน project ทีต้องแก้ทุก skill. เราเลยแยก context ออกเป็น 3 layer.

**Layer 1: SKILL.md** เก็บแต่ของที่ universal. logic การเขียน TC ก็คือ logic ไม่ว่า project ไหน. ห้ามมีชื่อบริษัท ห้ามมี URL จริง ห้ามมี business rule เฉพาะลูกค้า.

**Layer 2: shared references** ที่ root ของ repo. ไฟล์เด่นคือ `references/qa-standards.md` ที่กำหนด Severity, Priority, Sizing, Buffer, KPI ที่ทุก skill ต้องใช้เหมือนกัน. ทำไมต้องมี layer นี้แยกออกมา. เพราะถ้าฝัง standard ใน skill ตรงๆ วันที่ทีมเปลี่ยน Severity scale (จาก 5 ระดับเป็น 4) ต้องตามแก้ทุก skill ทีละตัว. แยก layer แล้วแก้ที่เดียวทั้งระบบเปลี่ยนตาม.

**Layer 3: `project-context.md`** ที่ user สร้างใน working directory ของ project. ใส่ environment, NFR, glossary, business rule เฉพาะ. skill จะอ่าน 3 layer นี้รวมกันก่อน generate.

```
project-context.md (per-project, override)
        ↓
qa-standards.md (team-shared, single source of truth)
        ↓
SKILL.md (universal)
```

ทำไมเลือก layer แบบนี้ ไม่ใช่ใส่ทุกอย่างไว้ที่เดียว. คำตอบคือลองมาแล้วทุกแบบ. เคยใส่ทุกอย่างใน SKILL.md → skill บวมเขียนไม่ทันเปลี่ยน. เคยใส่ทุกอย่างใน project-context.md → ทีมไม่มีมาตรฐานกลาง ต่างคนต่างกำหนด Severity. การมี 3 layer ชัดเจนทำให้ "อันนี้ของใคร อันนี้แก้ที่ไหน" ตอบได้ในวินาทีเดียว.

. . .

## ของที่ไม่ได้ตั้งใจ กลายเป็น architecture

ถ้าจะ distill EP4 เป็นข้อสรุปเดียว มันคือเรื่องนี้.

lazy load ไม่ได้ design มาเพื่อ scale. มันเป็นข้อจำกัดของ context window ที่กลายเป็น scaling property.

filename chain ไม่ได้ design มาเพื่อ debuggability. มันเป็นข้อจำกัดของ AI ที่ไม่มี persistent state ที่กลายเป็น property ที่ทำให้ระบบ inspectable.

3-layer override ไม่ได้ design มาเพื่อ DRY. มันเป็นผลลัพธ์ของการลองใส่ทุกอย่างที่เดียวแล้วเจ็บ.

แม้แต่ 8-section structure ก็ไม่ได้มาจาก insight. มันมาจากของที่ตัดทิ้งจนเหลือเท่านี้.

ทุกครั้งที่ผมไปอ่าน blog ของทีมอื่นที่ออกแบบ AI system ก็เห็น pattern แบบเดียวกัน. ของที่ดูเป็น architecture สวยๆ ส่วนใหญ่เป็น **ข้อจำกัดที่อยู่กับมันนานพอจนเริ่มดูเหมือนการตัดสินใจ**. ผมไม่คิดว่ามันเป็นเรื่องแย่. คือมันเป็นวิธีที่ระบบจริงๆ ถูกสร้างขึ้น. แค่ตอนเขียน blog เราชอบเขียนให้ดูเหมือนทุกอย่างเป็น decision ที่คิดมาดี ทั้งที่จริงๆ คือทดลองมั่วแล้วเจอจุดที่อยู่ได้.

. . .

## EP5 จะเล่าอะไร

ของที่ EP3 ค้างไว้ยังเหลืออยู่ 3 เรื่อง. skill ที่เคยทำงานพังเพราะ context overflow. ทีมที่ไม่อยากใช้ skill บางตัวเพราะไม่ trust output. คนใหม่ที่ onboarding ช้ากว่าที่คิด เพราะ skill มันเยอะเกินจะจำได้.

EP5 จะเป็นเรื่องของ scaling ในมุมของคนใช้ ไม่ใช่ของระบบ. EP4 เปิดฝาให้ดูว่าข้างในเป็นยังไง EP5 จะดูว่าเมื่อระบบใหญ่ขึ้น คนกับมันสัมพันธ์กันยังไง อะไรที่ scale ไม่ได้แม้ว่า technical จะ scale.

ถ้าเขียนทันก็ปล่อย ถ้าไม่ทันก็จบ series ที่นี่. แต่ EP4 อย่างน้อยก็ตอบคำถามที่ค้างมาจากตอน EP2 ว่า "ของข้างในมันเป็นยังไงจริงๆ" ได้ครบที่อยากเล่าแล้ว.

. . .
