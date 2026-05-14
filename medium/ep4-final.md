<!--
  EP4 — Final (publication-ready)
  Language: Thai
  Tone: tech-heavy, casual, no em dash, filler words, no AI aphorisms
  Target length: ~1,600 คำ
  Images: 5 (img_anatomy, img_lazy_load, img_filename_chain, img_3_layer_override, img_improve)
  Series: EP สุดท้าย — สรุป EP1-4 ไว้ท้าย
-->

# EP4: เปิดฝา — กลไกข้างใน skill ที่ไม่มีใครเล่า

> *Recap สั้นๆ ก่อน. EP1 เล่าปัญหาที่เริ่มต้นว่าทำไมทีม QA ถึงต้องสร้าง skill system ขึ้นมา. EP2 เล่าว่า 13 skill เชื่อมกันยังไงตอนทุกอย่างเข้าที่ และทำไม token ถึงสำคัญ. EP3 เล่าของที่พัง skill ที่ตัดทิ้ง และตอนที่ให้ AI ทายเวลาทำงานแล้วมันทายไม่ตรงสักรอบ. EP4 นี้คือฉบับ "เปิดฝา" คนถามมาเยอะว่าใน skill จริงๆ มีอะไร ตอบใน Slack ทีละคนไม่ไหวแล้ว เลยรวมมาไว้นี่ที่เดียว. และนี่คือ EP สุดท้ายของ series.*

. . .

## เริ่มด้วย bug ที่ใช้เวลาหนึ่งสัปดาห์ถึงจะรู้ว่าเป็น bug

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

`description` ส่วนแรกบอกว่า skill ทำอะไร, ส่วนกลางบอก mode ที่รองรับ, ส่วนสุดท้ายเป็น trigger keyword ทั้ง TH กับ EN รวมกันยาวเฟื้อย. ตอนเขียนใหม่ๆ ผมเคยคิดว่าเขียน description ยาวขนาดนี้น่าจะรก แต่ผ่านเรื่อง bug ที่เล่าตอนต้นแล้ว เข้าใจแล้วว่า description ไม่ใช่ documentation ให้คนอ่าน. มันเป็น signal ให้ AI ตัดสินใจว่าจะหยิบ skill นี้มาใช้หรือเปล่า. ทุก keyword ที่ใส่ไว้ = หนึ่งสถานการณ์ที่ user น่าจะพิมพ์.

ส่วน body ของ SKILL.md ตามมาด้วย 8 section ที่ทุก skill ในระบบเราใช้เหมือนกัน. ลำดับ fix.

```
1. Purpose      — เป้าหมาย + effort savings
2. When to Use  — SDP mapping + เทียบกับ skill ที่ใกล้เคียง
3. Inputs       — สิ่งที่ต้องเตรียม (รวม project-context.md placeholder)
4. Outputs      — format, template, file naming convention
5. Process      — ขั้นตอน step-by-step
6. Quality Gate — checklist ก่อนส่ง
7. AI Guardrails— ข้อควรระวัง
8. Chain        — เชื่อมกับ skill อื่น (upstream/downstream)
```

ถามตรงๆ ว่าทำไม 8 ไม่ใช่ 5 หรือ 12. คำตอบไม่ romantic เลย คือ trial-and-error. รอบแรก skill มี 12 section ตามที่คิดว่าควรครอบ ปรากฏว่ามันยาวเกินจะอ่านจบ tester ใช้แค่ section 3 กับ 4 จริงๆ. รอบสอง compress เหลือ 5 ปรากฏว่าหลายเรื่องที่ตัดออก (Quality Gate, Guardrails) กลับมาเป็นปัญหาตอน skill ขยาย. รอบสาม settle ที่ 8 และอยู่มาตั้งแต่ตอนนั้น. **โครงสร้างที่อยู่นานในระบบไหนก็ตาม ส่วนใหญ่ไม่ได้มาจาก insight แต่มาจากของที่ตัดทิ้งจนเหลือเท่านี้**.

> *[IMAGE: img_anatomy.png]*
>
> *Caption: folder layout ของ test-case-writer + frontmatter ที่ Claude อ่านตอน session เริ่ม + 8 section มาตรฐาน. ของทั้งหมดนี้ไม่ได้อยู่ใน context พร้อมกัน ตัดสินใจโหลดแบบ on-demand.*

. . .

## เวลา skill ถูกโหลด เกิดอะไรขึ้นจริงๆ

อันนี้คือส่วนที่หลายคนถามมาเยอะสุด. ทำไมระบบไม่ช้าทั้งที่มี skill 14 ตัวอยู่. ทำไมบางครั้ง skill ก็เด้งมา บางครั้งไม่เด้ง.

คำตอบคือ Claude Code โหลด skill แบบ lazy. ลำดับเวลาประมาณนี้.

**ตอน session เริ่ม:** Claude อ่านเฉพาะ frontmatter (`name` + `description`) ของทุก skill. ไม่อ่าน body. รวม 14 skill ก็ใช้แค่หลักพัน token ไม่กระทบ context window เลย.

**ตอน user พิมพ์ message:** Claude scan keyword ใน description ของทุก skill เทียบกับ user intent. ถ้า match → load body ทั้งหมดของ skill นั้นเข้า context.

**ตอน skill ทำงาน:** ถ้า body พูดถึง template ในโฟลเดอร์ skill, Claude ค่อยอ่านไฟล์ template เพิ่ม. references ก็เหมือนกัน. ทุกอย่างเป็น on-demand.

ผลคือระบบรับ skill ใหม่ได้เรื่อยๆ โดย context ไม่บวม เพราะของที่อยู่ใน context จริงๆ มีแค่ frontmatter ทุกตัว + body ของ skill ที่ trigger จริงในรอบนั้น. EP2 ที่เคยพูดเรื่อง token = attention ก็จุดนี้แหละที่ทำให้ argument ใช้ได้จริงในระบบจริงๆ.

ของที่ตามมาจากกลไกนี้คือ description เลยกลายเป็นไฟล์ที่สำคัญที่สุดต่อความสำเร็จของ skill มากกว่า body ด้วยซ้ำ. body จะเขียนดีแค่ไหน ถ้า description ไม่ match keyword ของ user, skill จะไม่ถูก load body มาใช้เลยตั้งแต่แรก. นี่คือเหตุผลที่ bug ที่เล่าตอนต้นหาเจอช้าจัง คือเรา debug ผิดที่ ไปดู body ทั้งที่ปัญหาอยู่ที่ frontmatter.

> *[IMAGE: img_lazy_load.png]*
>
> *Caption: 3 phase ของการโหลด skill. body ไม่เข้า context จนกว่า trigger จะ match. ถ้า skill ไม่ถูกใช้ในรอบนั้น token cost เป็นศูนย์.*

. . .

## skill เชื่อมกันยังไง โดยที่ไม่มี API ระหว่าง skill

อันนี้เป็นคำถามที่คนถามแล้วผมตอบไปก็เห็นหน้าเขางงทุกครั้ง.

ของจริงคือ **ไม่มี glue layer ระหว่าง skill เลย**. ไม่มี dispatch, ไม่มี call, ไม่มี state ที่ persist ระหว่างการเรียก. ทุก skill ทำงานจบในรอบของตัวเอง.

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

แค่นั้น test-case-reviewer ก็รู้ว่า input คืออะไร. ไม่ต้องมี orchestrator ไม่ต้องมี state.

ทำไมไม่ทำ programmatic chain. หลายเหตุผลปนกัน. AI ไม่เห็น state ระหว่าง session อยู่แล้ว. user ที่เห็นทุก step ก็ debug ได้เร็วกว่า. แล้วถ้ามี bug กลางทาง user แก้ไฟล์ตรงๆ ได้เลยโดยไม่ต้องรอ skill รัน.

ที่น่าสนใจคือ design นี้ไม่ได้ตั้งใจตั้งแต่แรก. มันเกิดเพราะข้อจำกัดของ AI tool มี state เดียวต่อ session. แต่พอใช้ไปสักพัก กลายเป็นว่าระบบ debuggable กว่าระบบที่มี orchestrator เยอะ. ข้อจำกัดที่เราไม่ได้ตั้งใจ กลายเป็นโครงสร้างของระบบ ซึ่งเป็น pattern ที่จะเห็นซ้ำใน section ถัดไปด้วย.

> *[IMAGE: img_filename_chain.png]*
>
> *Caption: ไม่มี API ระหว่าง skill. file = message. user = orchestrator. chain พัง แก้ไฟล์ตรงๆ แล้วเดินต่อ.*

. . .

## skill ตัวเดียว ใช้ได้หลาย project ได้ยังไง

ถ้า skill มี environment URL hardcode อยู่ใน SKILL.md ก็จบเลย เปลี่ยน project ทีต้องแก้ทุก skill. เราเลยแยก context ออกเป็น 3 layer.

**Layer 1: SKILL.md** เก็บแต่ของที่ universal. logic การเขียน TC ก็คือ logic ไม่ว่า project ไหน. ห้ามมีชื่อบริษัท ห้ามมี URL จริง ห้ามมี business rule เฉพาะลูกค้า.

**Layer 2: shared references** ที่ root ของ repo. ไฟล์เด่นคือ `references/qa-standards.md` ที่กำหนด Severity, Priority, Sizing, Buffer, KPI ที่ทุก skill ต้องใช้เหมือนกัน. ทำไมต้องมี layer นี้แยกออกมา. เพราะถ้าฝัง standard ใน skill ตรงๆ วันที่ทีมเปลี่ยน Severity scale (จาก 5 ระดับเป็น 4) ต้องตามแก้ทุก skill ทีละตัว. แยก layer แล้วแก้ที่เดียวทั้งระบบเปลี่ยนตาม.

**Layer 3: `project-context.md`** ที่ user สร้างใน working directory ของ project. ใส่ environment, NFR, glossary, business rule เฉพาะ. skill จะอ่าน 3 layer นี้รวมกันก่อน generate.

```
project-context.md   (per-project, override)
        ↓
qa-standards.md      (team-shared, single source of truth)
        ↓
SKILL.md             (universal)
```

ทำไมเลือก layer แบบนี้ ไม่ใช่ใส่ทุกอย่างไว้ที่เดียว. คำตอบคือลองมาแล้วทุกแบบ. เคยใส่ทุกอย่างใน SKILL.md → skill บวมเขียนไม่ทันเปลี่ยน. เคยใส่ทุกอย่างใน project-context.md → ทีมไม่มีมาตรฐานกลาง ต่างคนต่างกำหนด Severity. การมี 3 layer ชัดเจนทำให้ "อันนี้ของใคร อันนี้แก้ที่ไหน" ตอบได้ในวินาทีเดียว.

> *[IMAGE: img_3_layer_override.png]*
>
> *Caption: 3 layer ของ context. แก้ layer ไหน กระทบแค่ layer นั้น. เปลี่ยน Severity scale ทั้งทีม แก้ที่ qa-standards.md ที่เดียวจบ.*

. . .

## ของที่ยังต้องแก้ (ตรงๆ ไม่ตัดออก)

อยากจบ EP สุดท้ายนี้ด้วยเรื่องนี้. ตลอด 4 EP ผมเล่าของที่ work เยอะ แต่ระบบไม่ได้ perfect. ยังมี 3 เรื่องที่ยังแก้ไม่ได้จริงๆ.

**Context overflow เมื่อ TC ใหญ่เกิน.** skill ที่ต้องดึง test case มา review ทำงานได้ดีตอนไฟล์มี 50-80 TC แต่พอ module ใหญ่ขึ้น 200+ TC ก็เริ่มมีปัญหา Claude อ่านไฟล์ได้ แต่ attention มันกระจาย output คุณภาพตกชัดเจน แก้ชั่วคราวด้วยการตัด TC เป็น batch แต่มันเป็น workaround ไม่ใช่ solution.

**ทีมบางส่วนยังไม่ trust output.** เรื่องนี้ไม่ใช่ความผิดของ AI ตอนเราถามคนที่ไม่ใช้ skill คำตอบที่ได้คือ "ไม่แน่ใจว่า AI เข้าใจ business context จริงๆ หรือเปล่า" ซึ่งก็ไม่ผิด skill มัน universal ไม่รู้ว่า project นี้มี edge case อะไรโดยเฉพาะ ยกเว้นจะเขียนลงใน project-context.md ซึ่งคนที่ไม่ trust ก็ยังไม่ได้ทำ วงจรนี้ยังแก้ไม่ได้.

**Onboarding ช้ากว่าที่คิด.** 14 skill ฟังดูเยอะ และมันก็เยอะจริงๆ. คนใหม่ที่เข้ามาในทีมต้องเรียนรู้ว่า skill ไหนทำอะไร เมื่อไหร่ควรใช้ตัวไหน naming convention ของ output file เป็นยังไง. ถ้าไม่มีคนพาก็ใช้เวลา 2-3 สัปดาห์กว่าจะ comfortable. เรามี `qa-onboarding.md` แต่มันยาวกว่าที่ควรเป็น คนอ่านทั้งไฟล์ก็น้อย.

> *[IMAGE: img_improve.png]*
>
> *Caption: 3 เรื่องที่ยังแก้ไม่ได้จริงๆ พร้อม workaround ชั่วคราวที่ใช้อยู่. เอาไว้เตือนตัวเองว่าอะไรที่ยังค้างอยู่.*

. . .

## ถ้าคุณอยากลองทำ skill ของตัวเอง

EP1 ถึง EP4 เล่าเรื่องทีมเรา. แต่คำถามที่คนถามมาหลังจากแต่ละ EP คือ "จะเริ่มยังไง".

ไม่ต้องทำ 14 skill ตั้งแต่วันแรก. เริ่มจาก 1 skill สำหรับงานที่ทีมทำซ้ำมากที่สุดและเสียเวลานานที่สุด. สำหรับเราคือ test-case-writer. สำหรับคุณอาจเป็น bug report, weekly update, หรืออะไรก็ได้ที่ทำซ้ำทุก sprint แล้วรู้สึกว่าน่าเบื่อ.

เรื่องที่สำคัญกว่า body ของ skill คือ description. เขียน keyword ที่ทีมใช้พูดจริงๆ ไม่ใช่ keyword ที่ดูสวย. bug ที่เล่าตอนต้น EP นี้เกิดเพราะ description สวยเกินไป.

8 section ที่บอกไปข้างบน ใช้เป็น checklist ได้เลย. ไม่ต้องเขียนครบทุก section ตั้งแต่แรก แต่ถ้าขาด Quality Gate หรือ Guardrails เมื่อไหร่ก็จะเจอปัญหาเองในภายหลัง. EP3 เล่าไว้แล้วว่า feature ที่ตัดออกตั้งแต่แรกมักกลับมาในภายหลัง.

**skill คือ constraint ที่ออกแบบ ไม่ใช่ AI ที่ฉลาดขึ้น**. มันคือการจำกัดขอบเขตว่า AI จะรับ input อะไรและ output อะไร ซึ่งนั่นแหละที่ทำให้ output ใช้ได้จริงในทีม. ระบบที่ดีไม่ได้มาจาก AI เก่งขึ้น มันมาจากการออกแบบกล่องที่ AI ที่มีอยู่แล้วทำงานได้จริงสำหรับทีมของคุณ.

. . .

## สรุปทั้ง series ก่อนปิด

EP1 ถึง EP4 ใช้เวลาเขียนประมาณ 3 เดือน. ถ้าสรุปให้สั้นก็คือ

**EP1:** ปัญหาของทีม QA ที่ทุกคนมี prompt เป็นของตัวเอง คุณภาพ output ขึ้นอยู่กับว่าใครเขียน prompt เก่งกว่าใคร แทนที่จะขึ้นอยู่กับ process ที่ดี.

**EP2:** วิธีที่เราแก้คือสร้าง skills เพื่อให้ context อยู่ใน skill ไม่ใช่ใน prompt ของคนใช้. เล่าว่า 13 skill เชื่อมกันยังไงตอนทุกอย่างเข้าที่ และทำไม token cost ถึงสำคัญกว่าที่คิด.

**EP3:** เรื่องที่ไม่ค่อยอยากเล่า skill ที่ตัดทิ้ง feature ที่พัง และบทเรียนว่า AI ดีที่ "จัดระเบียบของที่มีอยู่แล้ว" ไม่ใช่ "ทายของที่ยังไม่รู้".

**EP4 (ฉบับนี้):** เปิดฝาดูข้างใน กลไกที่ทำให้ skill work หรือไม่ work และสิ่งที่ยังต้องแก้.

pattern ที่ pull ออกมาได้จาก 4 EP คือ ระบบที่ทำงานได้จริงในทีมไม่ใช่เรื่องของ AI ฉลาดแค่ไหน. มันเป็นเรื่องของ constraint ที่ตั้งใจ ว่า AI ตัวนี้รับอะไรได้ ทำอะไรได้ และส่งให้ใครต่อ. งานของเราไม่ใช่สร้าง AI ที่ฉลาด งานของเราคือสร้างกล่องที่ AI ที่มีอยู่แล้ว ทำงานได้จริงสำหรับทีม.

ขอบคุณที่อ่านมาถึง EP4 ครับ.

. . .
