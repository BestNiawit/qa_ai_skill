---
name: test-report-writer
description: สรุป Test Report จาก Test Execution Data (Jira/Excel/CSV) — รองรับ SIT Report / UAT Report / Performance Test Report — ครอบคลุม Summary (Total/Pass/Fail/Block/Not Run), Exit Criteria Evaluation, Defect Summary by Severity+Status, Deferred Bugs, User Sign-off Summary, Conclusion + Recommendation. Trigger เมื่อ user ขอ test report, SIT report, UAT report, performance report, "summarize test results", "draft SIT report", "สรุป test execution", "เขียน UAT report", "perf test report". Maps to SDP §5.3.1 (Process 4, 8, 12).
---

# Test Report Writer

> **คำย่อ (SIT / UAT / Perf / TC / KPI / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

Draft Test Report จาก raw execution data → QC review ตัวเลข + เขียน Recommendation

**Key rules:**
- Severity/Priority ใช้ Critical/Major/Minor/Trivial + Critical/High/Medium/Low ตาม [qa-standards.md §1-§2](../../references/qa-standards.md)
- **ต้องมี section "Estimate vs Actual"** — เทียบเวลาจริงกับ Plan Schedule (qa-standards §4)
- **ต้องมี section "AI Effort Savings"** — บันทึก AI draft / human review / savings % (qa-standards §6, KPI ทีม)
- Feedback loop: variance > 30% → flag ให้ refine Test Sizing Scale รอบถัดไป

**3 Mode:**
- **SIT Report** (default) — จาก Jira/Test Tool execution result
- **UAT Report** — + User Sign-off Summary
- **Perf Report** — + NFR Evaluation + Bottleneck (รับ input จาก `perf-result-analyzer`)

**Effort savings:**
- SIT: ~70% (SDP §5.3.4) — จาก 4 ชม. → 1.5 ชม.
- UAT: ~60% — จาก 4 ชม. → 1.5 ชม.
- Perf: ~50-60% — จาก 1 วัน → 4 ชม.

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 4 (SIT Report) + 8 (UAT Report) + 12 (Perf Report)

| สถานการณ์ | Mode |
|-----------|------|
| จบ SIT execution → ส่ง TL/PM | **mode=sit** |
| จบ UAT → ส่ง User Sign-off | **mode=uat** |
| จบ Perf test → ส่ง TL approval | **mode=perf** |
| ยังไม่รัน test จบ | ยังไม่ต้องใช้ skill นี้ |
| Perf analysis detail | `perf-result-analyzer` (แล้ว feed เข้า skill นี้) |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Mode | ✅ | SIT / UAT / Perf |
| Execution data | ✅ | Jira export / CSV / Excel — ต้องมี column "Actual Hours" ถ้า track |
| Test Plan (SIT/UAT/Perf) | ✅ | ใช้ Exit Criteria + **Effort Breakdown** (Estimate) เปรียบเทียบ |
| Defect list | ✅ | Jira export / bug report list — Severity ใช้ Critical/Major/Minor/Trivial เท่านั้น |
| Language | ✅ | TH / EN |
| **AI Usage Log** | ✅ | AI draft time (min) + Human review time (hr) ต่อ artifact — สำหรับ KPI |
| User Sign-off info (UAT mode) | ⚠️ | Who, date, approval status |
| Perf raw result (Perf mode) | ⚠️ | JMeter CSV / k6 JSON — หรือ output จาก `perf-result-analyzer` |
| `project-context.md` | ⚠️ | velocity override, NFR |

**Execution data format ที่ AI เข้าใจได้:**
- Jira JQL export (CSV)
- Excel: columns = TC_ID, Status (Pass/Fail/Blocked/Skipped/Not Run), Bug_ID, Severity, Bug_Status
- Markdown table จาก `test-case-writer` ที่กรอก Actual/Result แล้ว

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown

**Templates:**
- SIT: [`templates/sit-report-th.md`](templates/sit-report-th.md)
- UAT: [`templates/uat-report-th.md`](templates/uat-report-th.md)
- Perf: [`templates/perf-report-th.md`](templates/perf-report-th.md)

**File naming:**
- `sit_report_<scope>_<YYYYMMDD>.md`
- `uat_report_<scope>_<YYYYMMDD>.md`
- `perf_test_report_<scope>_<YYYYMMDD>.md`

**Structure (common):**
```
1. Executive Summary (ผ่าน/ไม่ผ่าน + ข้อเสนอแนะ)
2. Test Execution Summary
   | Total | Pass | Fail | Blocked | Skipped | Not Run | Pass Rate |
3. Exit Criteria Evaluation (เทียบกับ Test Plan)
   | Criterion | Target | Actual | Status |
4. Defect Summary
   a. By Severity: Critical / Major / Minor / Trivial × Open/Closed/Deferred
   b. By Module
5. Deferred Bugs (+ เหตุผล + PM approval)
6. Critical/Major Open Bugs (ชื่อ + steps สรุป)
7. Estimate vs Actual (hrs)  ← บังคับ (qa-standards §4 feedback)
   | Phase | Estimated (Plan) | Actual | Variance | Note |
8. AI Effort Savings (KPI)  ← บังคับ (qa-standards §6)
   | Artifact | AI Draft (min) | Human Review (hr) | Total | Baseline | Savings % |
9. Risk & Mitigation (ที่เหลือ)
10. Conclusion + Recommendation
11. Sign-off
```

**UAT-specific:**
```
2a. User Participation (Who tested, how many scenarios)
9a. User Sign-off (Name, Date, Approval/Reject/Conditional)
```

**Perf-specific** (layout เทียบเท่า JMeter government-style report — เช่น KMUTNB):
```
2.  Test Scenario (VUs / Duration / Time window) + NFR ต้นฉบับ
3.  Tools Used (k6 + Prometheus/Grafana + node_exporter — หรือ JMeter ถ้าโปรเจกต์ใช้)
4.  API List under Test (Method / URL / รายละเอียด — ต้องให้ user paste จาก API doc)
5.  Server Resource Usage per server (IP/OS/CPU/RAM + CPU graph + Memory graph + avg %)
    ⚠️ AI ไม่ generate ส่วนนี้เอง — ต้อง capture จาก node_exporter/Atop/Performance Monitor
6.  Test Result — NFR Evaluation per Endpoint
    | Endpoint | Samples | Avg | Min | Max | p95 | p99 | Std Dev | RPS | Error % | Sent KB/s | Recv KB/s | NFR p95 | Status |
    + Response Time Graph all endpoints (export จาก Grafana / xk6-dashboard)
7.  Stress Test — Metric per Load Level
8.  Soak Test (Memory Leak Check)
9.  Bottleneck Analysis (จาก `perf-result-analyzer`)
10. Tuning Recommendation (Must Fix / Should Fix / Nice to Have)
11. Metric Glossary (ทับศัพท์ k6/JMeter — สำหรับ reader ที่ไม่คุ้น)
```

---

## 5. Process — ขั้นตอน

### Step 1: Read Input
1. อ่าน Test Plan (เพื่อ get Exit Criteria)
2. Parse execution data (CSV/Jira export/Excel)
3. Parse defect list
4. ถ้า Perf mode: อ่าน `perf-result-analyzer` output (ถ้ามี)

### Step 2: Ask User (ถ้าขาด)
- Mode?
- Language?
- User Sign-off info (UAT mode)?

### Step 3: Compute Metrics

**Coverage:**
- Total TC, Pass, Fail, Blocked, Skipped, Not Run
- Pass Rate = Pass / (Total - Not Run) × 100%

**Defect:**
- Count by Severity (**Critical / Major / Minor / Trivial**) — ใช้ qa-standards §2
- Count by Status (Open/In Progress/Resolved/Closed/Deferred)
- Top 3 module with most defects

**Exit Criteria:**
- For each criterion ใน Plan → Compare target vs actual → Pass/Fail

**Estimate vs Actual (บังคับ):**
- อ่าน Plan §8 Effort Breakdown (Estimated hrs)
- อ่าน Actual Hours จาก execution data (ถ้าไม่มี → flag ให้ user fill)
- Variance = (Actual - Estimated) / Estimated × 100%
- Variance > ±30% → flag + comment (เช่น "TC 5 ตัว ใช้เวลามากกว่า Estimate — ควร upgrade sizing จาก M → L")

**AI Effort Savings (บังคับ — KPI):**
- ต่อ artifact (Plan, TC, Review, Report): AI Draft minutes + Human Review hours = Total
- Baseline manual hours จาก qa-standards §6
- Savings % = (Baseline - Total) / Baseline × 100%

### Step 4: Cross-check ตัวเลข (สำคัญ!)

AI จะแสดงตารางสรุปพร้อม **row-level detail** ให้ QC ตรวจ:
```
Total TC: 45
├── Pass: 42 (rows: TC_001, TC_002, ...)
├── Fail: 2 (rows: TC_015, TC_023)
├── Blocked: 1 (row: TC_030)
```

QC **ต้องตรวจ** ว่าตัวเลขตรงกับ Jira/Excel — ถ้าไม่ตรง → แก้ raw data ก่อนให้ AI run ใหม่

### Step 5: Draft Report

**Executive Summary template:**
```
SIT เสร็จสิ้น ณ วันที่ 2026-04-20 — ผล Pass Rate 93.3% (42/45)
✅ Exit Criteria ผ่าน 3/5 ข้อ
❌ Critical Open Bug = 0 (✅ ผ่าน)
❌ Major Open Bug = 2 (❌ ไม่ผ่าน — เป้า ≤ 0)

Recommendation: ไม่พร้อมไป UAT — ต้องแก้ Major bug 2 ตัว (AYO-1234, AYO-1287) ก่อน
```

### Step 6: Save + Summary
- ระบุ Conclusion: Ready / Not Ready / Conditional
- Flag ตัวเลขที่ **ต้อง verify manually** (เช่น "Pass Rate 93.3% — ควร double-check กับ Jira query")

---

## 6. Quality Gate — Checklist ก่อนส่ง

Derived จาก SDP §5.1.3 (SIT Report) + §5.1.6 (UAT Report) + §5.1.8 (Perf Report)

### Must Have (ทุก mode)
- [ ] Executive Summary ชัดเจน (Ready / Not Ready)
- [ ] Test Execution Summary table ครบ (Total/Pass/Fail/Block/Skipped/Not Run)
- [ ] Pass Rate = ตัวเลขที่คำนวณได้ (ไม่ใช่ "สูง")
- [ ] Exit Criteria Evaluation — เทียบกับ Plan criterion ทีละข้อ
- [ ] Defect Summary by **Critical/Major/Minor/Trivial** + Status (qa-standards §2 — อ้าง OneD TEST DEFINITION template)
- [ ] Critical/Major Open Bug list
- [ ] Deferred Bugs + เหตุผล + PM approval reference
- [ ] **Estimate vs Actual Hours** table (qa-standards §4 feedback)
- [ ] **AI Effort Savings** table (qa-standards §6 — KPI ทีม)
- [ ] Recommendation (Go / No-Go / Conditional)
- [ ] Sign-off section

### UAT-specific
- [ ] User Participation (who, how many)
- [ ] User Sign-off (Approved / Conditional / Rejected)
- [ ] ถ้า Conditional → ระบุเงื่อนไขชัด

### Perf-specific
- [ ] Test Scenario (VUs / Duration / Time window) + NFR ต้นฉบับ copy ตรง
- [ ] **Tools Used** section — ระบุ load tool (k6/JMeter) + monitoring stack (Prometheus/Grafana/Atop/PerfMon)
- [ ] **API List under Test** — Method/URL/รายละเอียด ครบทุก endpoint (รายละเอียด = paste จาก API doc, ไม่ใช่ AI generate)
- [ ] **Server Resource Usage** ต่อ server — IP/OS/CPU/RAM table + CPU graph + Memory graph + avg % table
  - ⚠️ ถ้าไม่มี graph = test ไม่ครบ ต้อง capture ใหม่ก่อน sign-off
- [ ] NFR Evaluation per endpoint (Pass/Fail) — มี p95 + p99 + Error Rate + RPS อย่างน้อย
- [ ] Response Time Graph all endpoints (export จาก Grafana / xk6-dashboard)
- [ ] Bottleneck identified (ถ้ามี)
- [ ] Tuning Recommendation (Must Fix / Should Fix / Nice to Have)
- [ ] **Metric Glossary** ครบทุก column ที่ใช้ (Samples, Avg, p95, p99, Throughput, Error %, ...)

### Red Flags (Reject)
- ❌ ตัวเลขไม่ตรงกับ raw data
- ❌ Exit Criteria ไม่เทียบกับ Plan
- ❌ มี Severity Critical/Major Open Bug แต่ Recommendation = "Ready"
- ❌ **ไม่มี Estimate vs Actual section** (หรือมีแต่ว่างหมด)
- ❌ **ไม่มี AI Effort Savings section** (KPI วัดไม่ได้)
- ❌ ใช้ severity scale นอก qa-standards (เช่น S1/S2, Cosmetic — legacy)
- ❌ UAT: ไม่มี User Sign-off
- ❌ Perf: Metric ไม่ผ่าน NFR แต่ไม่มี Waiver / explanation
- ❌ Perf: ไม่มี Server Resource graphs (CPU/Memory) ต่อ server — ไม่รู้ว่า bottleneck อยู่ client หรือ server side
- ❌ Perf: ตาราง NFR Evaluation ไม่มี p95 (เกณฑ์ NFR ส่วนใหญ่ใช้ p95 ตัดสินใจ)

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ⚠️ **AI อาจนับตัวเลขผิด** เมื่อข้อมูลเยอะ → ต้อง cross-check manually กับ raw data (§5 Step 4)
- ⚠️ AI อาจ **ลืม Deferred Bug** ถ้า raw data ไม่แยก "Deferred" status → ย้ำให้ user export column "resolution"
- ❌ AI ไม่รู้ว่า **PM approve Deferral แล้วหรือยัง** → flag ให้ user verify
- ❌ AI ไม่ควร **ออก Recommendation Ready** ถ้า Exit Criteria fail → rule-based check

**ข้อห้าม:**
- ❌ รวม 2 mode ในไฟล์เดียว (SIT + UAT)
- ❌ ใส่ข้อมูล sensitive ใน Executive Summary (PII, internal IP)
- ❌ เขียน Recommendation เอง โดยไม่ base บน Exit Criteria

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `test-plan-writer` — Plan (Exit Criteria) → ใช้เปรียบเทียบ
- `test-case-writer` — TC กรอก Actual/Result → execution data
- `bug-report-writer` — Defects → Defect Summary
- `perf-result-analyzer` — Bottleneck + NFR evaluation → Perf Report content

**Downstream:**
- [TL/PM/User Sign-off] — manual review
- Decision: Go/No-Go for next phase

**Workflow ตัวอย่าง:**
```
[SIT Execution] + [Jira Defect list] + test-plan-writer (Exit Criteria)
                          ↓
                 test-report-writer (mode=sit)
                          ↓
                 [TL/PM review] → Go → UAT Phase
                                → No-Go → Dev แก้ → Re-test
```

**Perf chain:**
```
perf-test-generator → [k6 run] → raw result
                                      ↓
                           perf-result-analyzer
                                      ↓
                     test-report-writer (mode=perf)
```

---

## ตัวอย่าง Executive Summary

### ✅ ดี
```
SIT Phase 1 เสร็จสิ้น 2026-04-20
- Pass Rate: 96.7% (58/60) ✅ ผ่าน (เป้า ≥ 95%)
- Critical Open: 0 ✅ ผ่าน
- Major Open: 0 ✅ ผ่าน
- Minor Open: 3 ✅ ยอมรับได้ (เป้า ≤ 5)

Recommendation: ✅ Ready to go UAT — แก้ Minor bugs ใน Maintenance Phase
```

### ❌ ไม่ดี
```
SIT Phase 1 ผลทดสอบดี
ไม่มี bug สำคัญ
พร้อมไป UAT
```

(ไม่มีตัวเลข, ไม่เทียบ Criteria, ไม่มี evidence)

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- [`references/perf-report-kmutnb-template.md`](../../references/perf-report-kmutnb-template.md) — KMUTNB government-style perf report (pre-test setup + section ownership)
- `templates/` — SIT/UAT/Perf report templates
- External: IEEE 829 (Test Summary Report), ISTQB Foundation Level Syllabus
