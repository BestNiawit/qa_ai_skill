---
name: test-plan-writer
description: เขียน Test Plan จาก SRS/PRD — รองรับ 3 mode (SIT / UAT / Performance) + ครอบคลุม Objective, Scope (In/Out), Entry/Exit Criteria, Test Approach, Environment, Schedule, Risk & Mitigation, Defect Management, Sign-off. Trigger เมื่อ user ขอ test plan, SIT plan, UAT plan, performance test plan, workload model, "write test plan", "generate SIT plan", "draft UAT plan", "สร้าง test plan", "เขียน perf test plan". Maps to SDP §5.3.1 (Process 1, 5, 9).
---

# Test Plan Writer

## 1. Purpose — เป้าหมาย

Draft Test Plan จาก SRS/PRD + NFR ให้ QC review — ลด effort ทำงานเอกสารซ้ำๆ

**3 Mode:**
- **SIT** (default) — System Integration Test Plan (QC)
- **UAT** — User Acceptance Test Plan (QC + BA, business language)
- **Perf** — Performance Test Plan (QC + TL, Workload Model + NFR)

**Effort savings:** ~40-50% (SDP §5.3.4) — จาก 1 วัน → 4 ชั่วโมง

**Key rules:**
- Entry/Exit Criteria **ต้องวัดได้** (เลข, ไม่ใช่ "พร้อมทดสอบ")
- Scope ต้อง trace กลับ SRS (ระบุ FR ID)
- Environment ต้อง **ตรงกับ Production config**
- Risk & Mitigation ต้องมี
- **Schedule ต้องคำนวณจาก TC Sizing** (ไม่เดา) ตาม [qa-standards.md §4 Buffer Policy](../../references/qa-standards.md#4-buffer-policy-บังคับใช้ใน-test-plan-schedule)
- **Severity/Priority** ใช้ S1-S4 / P0-P3 ตาม [qa-standards.md §1-§2](../../references/qa-standards.md)

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 1 (SIT Plan) + 5 (UAT Plan) + 9 (Perf Test Plan)

| สถานการณ์ | Mode ที่ใช้ |
|-----------|-----------|
| เริ่มต้น SIT, ต้องการ Test Plan | **mode=sit** |
| SIT ผ่านแล้ว เตรียม UAT | **mode=uat** |
| Perf test สำหรับ release | **mode=perf** |
| มี SIT Plan แล้ว อยากทำ UAT Plan ต่อ | **mode=uat** (feed SIT Plan เป็น input) |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Mode (SIT / UAT / Perf) | ✅ | default = SIT |
| SRS / PRD path | ✅ | สำหรับ Scope + Traceability |
| Module(s) in scope | ✅ | ระบุ module หรือ "ทั้งระบบ" |
| ภาษา output: TH / EN | ✅ | default ตาม SRS |
| **Test Case file (สำหรับ Schedule)** | ✅\* | path ไฟล์ TC ที่มี **Sizing Summary Block** — ใช้คำนวณ Schedule ด้วยสูตรแทนการเดา |
| **Number of testers** | ✅\* | default = 1 (override ถ้าหลายคนขนาน) |
| Contract / NFR (สำหรับ Perf mode) | ⚠️ | response time, throughput, error rate |
| Existing SIT Plan (สำหรับ UAT mode) | ⚠️ | ใช้ปรับเป็น business view |
| `project-context.md` | ⚠️ | env, team velocity override, NFR |

> \* ถ้ายังไม่มี Test Case file → สร้าง Plan ก่อนแบบ placeholder Schedule + flag ให้ re-run เมื่อมี TC

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown

**Templates:**
- SIT Plan: [`templates/sit-plan-th.md`](templates/sit-plan-th.md) / [`sit-plan-en.md`](templates/sit-plan-en.md)
- UAT Plan: [`templates/uat-plan-th.md`](templates/uat-plan-th.md) / [`uat-plan-en.md`](templates/uat-plan-en.md)
- Perf Plan: [`templates/perf-test-plan-th.md`](templates/perf-test-plan-th.md) / [`perf-test-plan-en.md`](templates/perf-test-plan-en.md)
- **Sprint Tracking (Excel-friendly):** [`templates/sprint-tracking-th.csv`](templates/sprint-tracking-th.csv) — ใช้ track task-level Est vs Actual hours + AI-Assisted flag รายสัปดาห์ (feedback loop ไปหา Test Report + qa-standards refinement)

**File naming:**
- `sit_plan_<scope>_<YYYYMMDD>.md`
- `uat_plan_<scope>_<YYYYMMDD>.md`
- `perf_test_plan_<scope>_<YYYYMMDD>.md`

**Structure (Common ทุก mode):**
```
1. Objective
2. Scope (In-Scope / Out-of-Scope) — trace SRS
3. Entry Criteria (วัดได้)
4. Exit Criteria (วัดได้)
5. Test Approach / Strategy
6. Test Environment (Server, DB, URL, Browser)
7. Roles & Responsibilities
8. Schedule / Timeline
   8a. Effort Breakdown (จาก TC Sizing Summary + Buffer Policy)
   8b. Calendar Schedule
9. Risk & Mitigation Plan
10. Defect Management Process (Severity S1-S4 / Priority P0-P3)
11. Traceability (SRS ↔ Plan scope)
12. Test Data Preparation
13. Suspension & Resumption Criteria
14. Sign-off
```

**เพิ่มใน Perf Mode:**
```
5a. Workload Model (RPS หรือ VUs, ramp-up/sustain/ramp-down)
5b. Scenarios (Load / Stress / Soak / Spike)
5c. Performance Metrics (Response Time p95/p99, Throughput, Error Rate)
5d. NFR Thresholds per endpoint
```

---

## 5. Process — ขั้นตอน

### Step 1: Read Input + Detect Mode
1. อ่าน SRS/PRD ทั้งไฟล์
2. อ่าน `project-context.md` (env, team velocity override, NFR)
3. **อ่าน Test Case file → extract Sizing Summary Block** (ถ้ามี)
4. ถ้า UAT mode + มี SIT Plan → อ่าน SIT Plan เพื่อ "inherit" scope/criteria

### Step 2: Ask User (ถ้าขาด)
- Module scope ชัดเจน?
- Entry/Exit Criteria มีตัวเลขเป้าหมายมั้ย? (เช่น Pass Rate ≥ 95%)
- Perf mode: NFR เป็นอะไร? (p95 response time, throughput, error rate)
- **Number of testers** (default 1)
- **มี TC file แล้วหรือยัง?** ถ้ายัง → Schedule จะ placeholder
- Schedule: สัปดาห์ที่เริ่ม/จบ?

### Step 2.5: คำนวณ Schedule ตาม qa-standards §4 Buffer Policy

ถ้ามี Sizing Summary:
```
Σ Execution Effort  = total_hr (จาก TC file)
Total_TC            = total count

Test Prep           = Total_TC × 0.1 hr
Peer Review         = Total_TC × 0.05 hr
Execution Cycle 1   = Σ Execution Effort
Defect Fix + Retest = Execution × 0.30
Execution Cycle 2   = Execution × 0.20  (regression)
Report + Sign-off   = 4 hr
SubTotal            = sum above
Buffer              = SubTotal × 0.20
Total Planned Hours = SubTotal + Buffer

Calendar Days       = Total Planned Hours / (testers × 6 hr/day)
```

ตัวอย่าง: TC 25 ตัว (Σ sizing = 11.31 hr), tester = 1
- Prep: 2.5 hr, Review: 1.25 hr, Exec1: 11.31, Fix: 3.39, Exec2: 2.26, Report: 4 → SubTotal 24.71 hr
- Buffer 20%: 4.94 hr → **Total: 29.65 hr ≈ 5 วัน**

### Step 3: Draft ตาม Template + Mode

**SIT Mode:** Technical view, เน้น integration between modules

**UAT Mode:**
- แปลงภาษา Technical → Business (ปรึกษา BA)
- Scope = Business process ไม่ใช่ technical module
- Exit Criteria เน้น User Sign-off

**Perf Mode:**
- ถ้าไม่มี Production Log → ใช้ "ประมาณการ" พร้อม flag ให้ TL review
- Workload Model ต้อง map กับ Business Flow จริง (Login → Search → Create → Report)

### Step 4: Traceability + Quality Gate Check
- ทุก Scope item → มี FR ID
- Entry/Exit criteria → มีตัวเลข
- Env → ตรงกับ prod config
- **Severity = S1-S4 / Priority = P0-P3** (ห้าม Blocker/High/Med/Low)
- **Schedule มี Effort Breakdown + Buffer** (ห้ามเดาเป็น `<days>` เฉยๆ)

### Step 5: Save + Summary
แจ้ง user:
- Must-Have items ครบมั้ย (checklist §6)
- Red Flags ที่เจอ (ถ้ามี)
- Next step: "ให้ TL/PM review + sign-off ก่อนใช้"

---

## 6. Quality Gate — Checklist ก่อนส่ง

Derived จาก SDP §5.1.1 (SIT Plan) + §5.1.4 (UAT Plan) + §5.1.7 (Perf Test Plan)

### Must Have (ทุก mode)
- [ ] Objective ชัดเจน
- [ ] Scope (In-Scope / Out-of-Scope) ครบ trace SRS
- [ ] Entry Criteria **วัดได้** (ไม่มี "พร้อมทดสอบ")
- [ ] Exit Criteria **วัดได้** (มีตัวเลข Pass Rate + Bug Severity S1-S4)
- [ ] Test Environment (Server, DB, URL) ครบ
- [ ] Test Approach ระบุชัด
- [ ] **Schedule มี Effort Breakdown** (จาก TC Sizing × Buffer Policy) — ไม่ใช่ `<days>` เฉยๆ
- [ ] **Buffer 20% ระบุในตาราง** (ตาม qa-standards §4)
- [ ] Roles & Responsibilities
- [ ] Risk & Mitigation
- [ ] Defect Management Process (ใช้ S1-S4 / P0-P3)
- [ ] Traceability SRS ↔ Plan
- [ ] Sign-off section

### Nice to Have
- [ ] Test Data Preparation Plan
- [ ] Suspension & Resumption Criteria

### UAT-specific
- [ ] User Tester ระบุชื่อ/role
- [ ] ต้อง "SIT ผ่าน" เป็น Entry Criterion
- [ ] ภาษา Business (ไม่มี API/SQL term)

### Perf-specific
- [ ] NFR เป็นตัวเลข (p95, p99, throughput, error rate)
- [ ] Workload Model ระบุ executor + ramp + sustain
- [ ] Per-endpoint threshold

### Red Flags (Reject)
- ❌ Scope เขียน "ทดสอบระบบทั้งหมด" (ไม่ระบุ module)
- ❌ Exit Criteria = "ทดสอบผ่านทั้งหมด" (ไม่มีตัวเลข)
- ❌ ไม่ระบุ Environment
- ❌ **Schedule มีแค่ `<days>` ไม่แสดง Effort Breakdown / Buffer**
- ❌ **ใช้ severity/priority scale นอก qa-standards** (Blocker, Trivial, High/Med/Low)
- ❌ Copy จากโปรเจกต์เก่าโดยไม่ปรับ
- ❌ UAT: ไม่มี User Tester
- ❌ Perf: ไม่มี NFR ตัวเลข

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจ **สร้าง FR ID ปลอม** — Cross-check กับ SRS ทุกตัว
- ❌ AI อาจ **ประมาณ Schedule ผิด** ถ้าไม่รู้ team velocity → ใช้ "TBD" ดีกว่าเดา
- ❌ AI อาจ **ตั้ง NFR threshold เกินจริง** → ถาม baseline จาก prod monitoring
- ❌ AI ไม่รู้ **Contract ที่ลูกค้าเซ็น** → QC ต้อง cross-check ทุกข้อ

**ข้อห้าม:**
- ❌ Copy SIT Plan มาเป็น UAT Plan โดยไม่ปรับภาษา
- ❌ ใส่ IP/URL/credential จริงใน Plan (public document) → placeholder

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- SRS / PRD (external docs)
- NFR document / SLA / Contract
- `project-context.md` (team velocity override)
- **`test-case-writer` output — Sizing Summary Block → Schedule calculation**

**Downstream:**
- `test-case-writer` — ใช้ Plan scope + criteria เป็น context เขียน TC (iteration 1)
- `test-matrix-generator` — quick coverage matrix ก่อนขยายเป็น full TC
- `perf-test-generator` (mode=perf) — Workload Model + NFR → k6 script
- `test-report-writer` — Plan เป็น baseline สำหรับ Exit Criteria + Estimate vs Actual ใน Report

**Workflow ตัวอย่าง (iterative):**
```
SRS/NFR
  ├→ test-plan-writer (draft v1: placeholder Schedule)
  │         ↓
  ├→ test-case-writer → TC + Sizing Summary
  │         ↓
  └→ test-plan-writer (v2: Schedule from Sizing Summary) → [TL/PM sign-off]
                                                                ├→ [Execute]
                                                                └→ test-report-writer
                                                                      (Exit Criteria + Estimate vs Actual → feedback to refine sizing)
```

---

## เทคนิคเขียน Criteria ให้ "วัดได้"

### Entry Criteria

| ❌ ไม่ดี | ✅ ดี |
|---------|-------|
| "ระบบพร้อมทดสอบ" | 1. Dev complete 100% ของ Feature ใน Scope (Jira Status = Done)<br>2. SIT Environment พร้อม (Server: 10.0.1.50, DB: SIT_DB_v2.1)<br>3. Test Data prepared ตาม Test Data Sheet v1.0<br>4. Smoke Test ผ่าน 100% |

### Exit Criteria

| ❌ ไม่ดี | ✅ ดี |
|---------|-------|
| "ทดสอบผ่านทั้งหมด" | 1. Test Case Execution ≥ 100%<br>2. Pass Rate ≥ 95%<br>3. Critical Bug = 0 (Open)<br>4. Major Bug = 0 (Open) หรือ Defer พร้อมเหตุผลที่ PM อนุมัติ<br>5. Minor Bug ≤ 5 (Open) |

### Scope

| ❌ ไม่ดี | ✅ ดี |
|---------|-------|
| "ทดสอบระบบทั้งหมด" | **In-Scope:**<br>- Module: User Management (SRS-REQ-001..015)<br>- Module: Payment Gateway (SRS-REQ-030..042)<br>- Integration: User Mgmt ↔ Payment<br><br>**Out-of-Scope:**<br>- Module: Report Dashboard (Phase 2)<br>- Performance Testing (แยก Plan) |

### Environment

| ❌ ไม่ดี | ✅ ดี |
|---------|-------|
| "SIT Server" | \| Server \| 10.0.1.50 (Linux CentOS 7) \|<br>\| App Server \| Tomcat 9.0.65 \|<br>\| Database \| Oracle 19c — SIT_DB_v2.1 \|<br>\| Browser \| Chrome 120+, Edge 120+ \|<br>\| URL \| https://sit.example.com \| |

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- `templates/` — SIT/UAT/Perf plan templates
- External: IEEE 829 (Test Plan), ISTQB Foundation Level Syllabus
