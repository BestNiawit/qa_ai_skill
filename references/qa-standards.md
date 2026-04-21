# QA Standards — มาตรฐานกลางทุกโปรเจค

> **วัตถุประสงค์:** กำหนด Severity / Priority / Test Sizing / Buffer / Velocity ที่ **ทุก skill** และ **ทุกโปรเจค** ต้องใช้เหมือนกัน
> เพื่อให้ข้อมูลไหลเชื่อมกันจาก **Test Case → Test Plan → Test Report** ได้โดยไม่ต้องแปลง scale
> **อ้างอิง:** SDP §5 Testing + IEEE 829 + ISTQB Foundation

---

## 1. Severity Scale (4 ระดับ — บังคับ)

| Code | ชื่อ | นิยาม | SLA Fix (SIT) |
|------|------|------|--------------|
| **S1** | Critical | ระบบพังทั้งหมด / feature หลักใช้งานไม่ได้ / data corruption / security breach | ≤ 1 วันทำการ |
| **S2** | Major | feature สำคัญพังแต่มี workaround / integration fail / performance เกิน 2× NFR | ≤ 3 วันทำการ |
| **S3** | Minor | UI ผิดเล็กน้อย / validation ไม่ครบ / edge case fail / performance เกิน 1.2× NFR | ใน sprint |
| **S4** | Cosmetic | typo / alignment เพี้ยน / สีไม่ตรง spec / icon หาย | best effort |

> ❌ **ห้ามใช้คำอื่น** เช่น Blocker, Trivial, High/Med/Low (severity) — ให้ map เข้า 4 ระดับนี้:
> - "Blocker" → **S1 Critical**
> - "Trivial" → **S4 Cosmetic**

---

## 2. Priority Scale (4 ระดับ — บังคับ)

| Code | ชื่อ | ความหมาย |
|------|------|----------|
| **P0** | Critical | ต้องแก้/ทดสอบทันทีวันนี้ — block release |
| **P1** | High | แก้/ทดสอบใน sprint นี้ — ต้อง release พร้อมกัน |
| **P2** | Medium | แก้/ทดสอบ sprint หน้า |
| **P3** | Low | แก้/ทดสอบเมื่อมีเวลา / maintenance phase |

> Priority ≠ Severity — typo (S4) อาจเป็น P0 ได้ถ้าลูกค้าใหญ่บ่น

---

## 3. Test Sizing Scale (บังคับทุก TC)

| Size | เวลา (hrs) | Midpoint | Steps | ลักษณะงาน |
|:----:|:----------:|:--------:|:-----:|----------|
| **S** | < 0.25 hr (< 15 min) | **0.17 hr** | 1–3 | smoke check, single field validation |
| **M** | 0.25–0.5 hr (15–30 min) | **0.42 hr** | 4–8 | form + ตรวจผล |
| **L** | 0.5–1 hr (30–60 min) | **0.75 hr** | 9–15 | multi-step flow + data fixture |
| **XL** | > 1 hr | **1.25 hr** | 15+ | E2E ข้าม role / external system |

> **Midpoint** = ตัวเลขที่ใช้ใน Schedule Formula ของ [test-plan-writer](../skills/test-plan-writer/)
> **Sprint capacity:** XL ควรเป็น P0/P1 เท่านั้น — L/XL ที่รันบ่อย = automation candidate

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

## 7. Scale Mapping Examples

```
[Bug from tester]
  ├─ Jira/external tool: Blocker    → แปลงเป็น S1 Critical ใน report
  ├─ Jira/external tool: Trivial    → แปลงเป็น S4 Cosmetic
  └─ "High priority"                → แปลงเป็น P1 High

[Test Case Sizing]
  ├─ "ใช้เวลา 10 นาที"      → S  (0.17 hr)
  ├─ "กรอกฟอร์มแล้วตรวจ"    → M  (0.42 hr)
  ├─ "Flow ซับซ้อน ~45 นาที" → L  (0.75 hr)
  └─ "E2E 2 role + report"  → XL (1.25 hr)
```

---

## 8. Checklist — ใช้มาตรฐานครบมั้ย?

- [ ] Severity ทุก artifact ใช้ S1/S2/S3/S4 (ไม่มี Blocker/Trivial)
- [ ] Priority ทุก artifact ใช้ P0/P1/P2/P3 (ไม่มี High/Med/Low)
- [ ] ทุก TC มี Test Sizing (S/M/L/XL)
- [ ] Test Plan Schedule คำนวณจากสูตร Buffer Policy §4
- [ ] Test Report มี section "Estimate vs Actual" + "AI Effort Savings"
- [ ] `project-context.md` override ค่า velocity ถ้าต่างจาก default

---

## References
- [sdp-mapping.md](sdp-mapping.md) — Skill ↔ SDP process
- [ai-guardrails.md](ai-guardrails.md) — AI usage guardrails
- SDP §5 Testing + §5.1 Quality Gates + §5.3 AI-Assisted Testing
- IEEE 829 Test Documentation Standard
- ISTQB Foundation Level Syllabus
