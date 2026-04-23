# QA Standards — มาตรฐานกลางทุกโปรเจค

> **วัตถุประสงค์:** กำหนด Severity / Priority / Test Sizing / Buffer / Velocity ที่ **ทุก skill** และ **ทุกโปรเจค** ต้องใช้เหมือนกัน
> เพื่อให้ข้อมูลไหลเชื่อมกันจาก **Test Case → Test Plan → Test Report** ได้โดยไม่ต้องแปลง scale
> **อ้างอิง:** Ayodia **TEST DEFINITION** template (source of truth ของ Severity/Priority) + SDP §5 Testing + IEEE 829 + ISTQB Foundation

---

## 1. Priority Scale (4 ระดับ — บังคับ)

**ความสำคัญของการทดสอบ** — ระดับความเร่งด่วนของการทดสอบ Test Case หรือการแก้ไขระบบเมื่อ Test Case นั้นล้มเหลว (Fail) โดยดูจากความสำคัญต่อธุรกิจ ความคาดหวังของผู้ใช้งาน และเวลาในการส่งมอบระบบ

| Level | ความหมาย | ตัวอย่าง |
|-------|---------|---------|
| 🔴 **Critical** | ต้องแก้ทันที เพราะ Blocked งานอื่น | ปุ่ม "Submit" พัง ทำให้ทดสอบต่อไม่ได้ |
| 🟠 **High** | สำคัญต่อ Core Function ต้องทำในรอบนี้ | Register ใช้งานไม่ได้ |
| 🟡 **Medium** | สำคัญรองลงมา แต่ควรให้ทันรอบถัดไป | การค้นหาข้อมูลทำงานช้ากว่าปกติ |
| 🔵 **Low** | ไม่เร่งด่วน ทำทีหลังก็ได้ | UI ไม่ตรงกับ Figma, สีผิดโทน, Wording ไม่ถูกต้อง |

---

## 2. Severity Scale (4 ระดับ — บังคับ)

**ความรุนแรงของปัญหา/ข้อผิดพลาด** — ระดับความรุนแรงของผลกระทบหาก Test Case นั้นล้มเหลว (Fail)

| Level | ความหมาย | ตัวอย่าง | SLA Fix (SIT) |
|-------|---------|----------|---------------|
| 🔴 **Critical** | ระบบหลักพัง ใช้งานไม่ได้ | ระบบล่ม, ชำระเงินไม่ผ่าน | ≤ 1 วันทำการ |
| 🟠 **Major** | ฟังก์ชันหลักใช้ไม่ได้ แต่ระบบยังรันได้ | Login พัง, ข้อมูลไม่บันทึก | ≤ 2 วันทำการ |
| 🟡 **Minor** | ปัญหาเล็กน้อย ไม่มีผลต่อการใช้งานหลัก | UI ไม่ตรง Figma, Validation แจ้งเตือนผิด | ใน sprint |
| 🔵 **Trivial** | จุกจิก ไม่กระทบการใช้งานเลย | Wording ไม่ถูกต้อง, Alignment เพี้ยน | best effort |

> **Priority ≠ Severity** — Trivial (typo) อาจเป็น Critical Priority ได้ถ้าลูกค้าใหญ่บ่น

---

## 2.1 Severity-Priority Matrix (Action Label)

ใช้ใน Bug Report, Exit Criteria, Sprint triage — เมื่อจับคู่ Severity กับ Priority แล้วได้ **Action Label** ที่บอกชัดว่าควรจัดการยังไง

| Severity \ Priority | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low |
|---------------------|-------------|---------|-----------|--------|
| 🔴 **Critical** | **Blocker** — ต้องดำเนินการโดยทันที เพื่อไม่ให้กระทบต่อระบบโดยรวม | **Urgent** — แก้ไขเร่งด่วนภายในรอบการพัฒนา เนื่องจากเป็นข้อผิดพลาดร้ายแรง | **Important** — สำคัญแต่ไม่ใช่ข้อผิดพลาดที่ทำให้ระบบหยุดทำงาน | **Deferred Critical** — ปัญหาสำคัญแต่ยังไม่เร่งด่วน |
| 🟠 **Major** | **High Business Risk** — ควรเร่งดำเนินการเพราะกระทบต่อฟังก์ชันหลัก | **Standard High** — ฟังก์ชันผิดพลาด ควรแก้ให้ทันในรอบทดสอบนี้ | **Manageable** — แก้ไขเมื่อมีเวลา เพราะยังมีวิธีแก้ไขทางอ้อม | **Can Delay** — อนุโลมให้เลื่อนได้ |
| 🟡 **Minor** | **Prioritize If Impacted** — เร่งแก้เฉพาะเมื่อฟีเจอร์นั้นเป็นจุดสำคัญ | **Optional but Noted** — ควรแก้ถ้ามีเวลา | **Acceptable Delay** — ไม่กระทบหลัก สามารถดำเนินการภายหลัง | **Low Impact Cosmetic** — ความคลาดเคลื่อนที่ไม่กระทบการใช้งาน |
| 🔵 **Trivial** | **Non-critical but Visible** — ควรแก้ในกรณีที่อยู่ในหน้าหลักหรือส่งผลต่อภาพลักษณ์ | **Minor Fix Suggested** — แนะนำให้แก้เพื่อความสมบูรณ์ | **Can Be Scheduled Later** — ไม่รีบ ทำในรอบถัดไป | **Optional** — ไม่จำเป็นต้องดำเนินการ |

> **Positive/Negative Case:** Positive = ยืนยันว่า feature ทำงาน "ได้จริง" | Negative = ยืนยันว่า feature "กันความผิดพลาดได้"

---

## 3. Test Sizing Scale (บังคับทุก TC)

| Size | เวลา (hrs) | Midpoint | Steps | ลักษณะงาน |
|:----:|:----------:|:--------:|:-----:|----------|
| **S** | < 0.25 hr (< 15 min) | **0.17 hr** | 1–3 | smoke check, single field validation |
| **M** | 0.25–0.5 hr (15–30 min) | **0.42 hr** | 4–8 | form + ตรวจผล |
| **L** | 0.5–1 hr (30–60 min) | **0.75 hr** | 9–15 | multi-step flow + data fixture |
| **XL** | > 1 hr | **1.25 hr** | 15+ | E2E ข้าม role / external system |

> **Midpoint** = ตัวเลขที่ใช้ใน Schedule Formula ของ [test-plan-writer](../skills/test-plan-writer/)
> **Sprint capacity:** XL ควรเป็น Critical/High Priority เท่านั้น — L/XL ที่รันบ่อย = automation candidate

---

## 4. Buffer Policy (บังคับใช้ใน Test Plan Schedule)

| Phase | Formula | หมายเหตุ |
|-------|---------|----------|
| **Test Prep** | Total TC × 0.1 hr/TC | setup env, test data, smoke test |
| **Execution Cycle 1** | Σ (TC_sizing midpoint) | อ่านจากไฟล์ TC |
| **Peer Review** | Total TC × 0.05 hr/TC | review TC ก่อน execute |
| **Defect Fix + Retest** | Execution × 30% | assume ~15% fail + retest รอบแรก |
| **Execution Cycle 2 (Regression)** | Execution × 20% | regression หลัง fix |
| **Report + Sign-off** | 4 hr (fixed) | เขียน report + ส่ง review |
| **Buffer** | (sum above) × 20% | unexpected issues, env down, meetings |

**Total Planned Hours** = Prep + Execution × 1.5 + Review + Report + Buffer

**Calendar Days** = Total Hours / (testers × [Team Velocity](#5-team-velocity))

---

## 5. Team Velocity (baseline — ปรับต่อโปรเจคได้ แต่ต้อง document ใน project-context.md)

| Indicator | Default | ที่มา |
|-----------|---------|-------|
| Productive hours / tester / day | **6 hrs** | 8 hr − (meeting 1 hr + misc 1 hr) |
| Working days / sprint (2 weeks) | **10 days** | exclude weekend |
| Sprint capacity / tester | **60 hrs** | 6 × 10 |
| Parallel testers per module | default **1** | ระบุใน Plan ถ้า > 1 |

> **Override ได้:** ถ้าโปรเจคมี data จริง ให้ update ใน `project-context.md` + reference เหตุผล

---

## 6. AI Effort Savings KPI (ต้องบันทึกทุก Report)

> **เป้าหมายทีม:** ลด manual effort ด้วย AI ใน testing phase → วัดผลได้จริง

| Artifact | Baseline Manual (hrs) | AI-Assisted Target (hrs) | Savings Target |
|----------|:---------------------:|:------------------------:|:--------------:|
| SIT Plan | 8 | 4 | 50% |
| SIT Test Case (per module, ~20 req) | 24 | 12 | 50% |
| Peer Review | — | — | 40% |
| SIT Report | 4 | 1.5 | 62% |
| UAT Plan | 8 | 4 | 50% |
| UAT Test Case | 16 | 8 | 50% |
| UAT Report | 4 | 1.5 | 62% |
| Perf Test Plan | 8 | 4 | 50% |
| Perf Report | 8 | 4 | 50% |

**วิธีวัด (เก็บใน Test Report section "AI Effort Savings"):**
```
- AI Draft Time:     <minutes AI generated>
- Human Review Time: <hrs QC spent reviewing/fixing>
- Total (AI-Assisted): AI + Human
- Manual Baseline:   <hrs estimated if no AI>
- Savings:           (Baseline − Total) / Baseline × 100%
```

อ้างอิง: SDP §5.3.4 Effort Estimation

---

## 7. Scale Mapping Examples (เมื่อ external tool ใช้ scale อื่น)

```
[Bug from external Jira / tracking tool]
  ├─ "Blocker" / "Highest"       → Critical Severity (ถ้าระบบพัง) หรือ Critical Priority (ถ้า block)
  ├─ "P1" / "S1" (legacy)        → Critical
  ├─ "P2" / "S2"                 → High (Priority) หรือ Major (Severity)
  ├─ "P3" / "S3"                 → Medium / Minor
  ├─ "P4" / "Cosmetic"           → Low / Trivial
  └─ "Nice to have"              → Low Priority

[Test Case Sizing]
  ├─ "ใช้เวลา 10 นาที"      → S  (0.17 hr)
  ├─ "กรอกฟอร์มแล้วตรวจ"    → M  (0.42 hr)
  ├─ "Flow ซับซ้อน ~45 นาที" → L  (0.75 hr)
  └─ "E2E 2 role + report"  → XL (1.25 hr)
```

> **หมายเหตุ:** ใน artifact ของทีม (TC/Plan/Report/Bug) ใช้ **Critical/High/Medium/Low** (Priority) + **Critical/Major/Minor/Trivial** (Severity) เท่านั้น การ map ข้างบนใช้ตอนรับข้อมูลจาก external tool เท่านั้น

---

## 8. Checklist — ใช้มาตรฐานครบมั้ย?

- [ ] Priority ทุก artifact ใช้ **Critical / High / Medium / Low** (4 ระดับ)
- [ ] Severity ทุก artifact ใช้ **Critical / Major / Minor / Trivial** (4 ระดับ)
- [ ] Bug Report ระบุ **Action Label** จาก Severity × Priority Matrix §2.1 (Blocker, Urgent, Standard High, ...)
- [ ] ทุก TC มี Test Sizing (S/M/L/XL)
- [ ] Test Plan Schedule คำนวณจากสูตร Buffer Policy §4
- [ ] Test Report มี section "Estimate vs Actual" + "AI Effort Savings"
- [ ] `project-context.md` override ค่า velocity ถ้าต่างจาก default

---

## References

- **Ayodia TEST DEFINITION template** — source of truth สำหรับ Severity/Priority scale + action label matrix
- [sdp-mapping.md](sdp-mapping.md) — Skill ↔ SDP process
- [ai-guardrails.md](ai-guardrails.md) — AI usage guardrails
- SDP §5 Testing + §5.1 Quality Gates + §5.3 AI-Assisted Testing
- IEEE 829 Test Documentation Standard
- ISTQB Foundation Level Syllabus
