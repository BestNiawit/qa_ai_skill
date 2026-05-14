# QA AI Workflow — Input/Output Summary

> **สำหรับ:** แชร์ทีม QA + ผู้บริหาร — เห็นภาพ End-to-End ใน 1 หน้า ใส่อะไร → ได้อะไร → ประหยัดเท่าไหร่
>
> **อ้างอิงต้นทาง:** [README §Workflow แนะนำ (End-to-End)](../README.md#workflow-แนะนำ-end-to-end) · [work-product-flow.md](work-product-flow.md) (technical detail) · [qa-standards.md §6](../references/qa-standards.md) (KPI baseline)

---

## 1. Executive Summary

ทีม QA Ayodia ใช้ AI assist ใน **3 testing chains** ตาม SDP §5 — แต่ละ chain มี Input ชัดเจน Output ที่ map กับ deliverable ทางการ และมี Quality Gate ก่อนส่ง

| Chain | Input หลัก | Output ขั้นสุดท้าย (ส่ง stakeholder) | Effort Savings | Cycle Time |
|-------|-----------|--------------------------------------|:--------------:|:----------:|
| **SIT** (System Integration Test) | BRD/PRD/SRS + Module scope | SIT Report (Pass/Fail vs Exit Criteria) + Defect List | **~50%** | ~3 วัน → ~1.5 วัน |
| **UAT** (User Acceptance Test) | SIT TC ที่ผ่านแล้ว + User roles | UAT Report + User Sign-off | **~55%** | ~2 วัน → ~1 วัน |
| **Performance** | NFR + API Spec | Perf Report + Bottleneck Analysis | **~50%** | ~2 วัน → ~1 วัน |

**หลักการสำคัญ (5 AI Guardrails จาก SDP §5.3.3):**

1. **AI = Draft & Assist (70-80%) · Tester = Review & Approve (20-30%)** — AI ไม่ sign-off แทนคน
2. **Cross-check กับ source ทุกครั้ง** ผ่าน Traceability Matrix
3. **ห้าม commit Sensitive data** (PII, password) — ใช้ `[REDACTED]`
4. **Expected Result วัดได้** — ห้าม "ทำงานถูกต้อง"/"แสดงผลปกติ"
5. **ห้าม make up number** — ถ้าไม่มี data ให้ระบุ "TBD"

**ทุก Output บังคับใช้ qa-standards กลาง:**
- Severity: Critical / Major / Minor / Trivial (Ayodia TEST DEFINITION)
- Priority: Critical / High / Medium / Low
- Schedule = Σ Sizing × Buffer 20%
- Test Report ต้องมี **Estimate vs Actual** + **AI Effort Savings KPI** (เป้าทีม ≥ 50%)

---

## 2. SIT Chain — Input/Output รายขั้น

```
BRD/PRD/SRS ──► [0] requirement-analyzer ──► [PM Confirm] ──► [1] test-plan-writer
                                                              ──► [2] test-case-writer
                                                              ──► [3] test-case-reviewer
                                                              ──► [Execute SIT]
                                                              ──► [4a] bug-report-writer (ถ้าเจอ defect)
                                                              ──► [4b] test-report-writer
```

| # | Step (Skill) | Input | Output (Work Product) | Owner | Manual → AI-Assisted | Savings |
|:-:|--------------|-------|----------------------|:-----:|:--------------------:|:-------:|
| 0 | **requirement-analyzer**<br>(Pre-SIT gate) | BRD/PRD/SRS ดิบ | **Readiness Score** + Normalized Requirement + **PM Confirmation Doc** (ส่ง PM/BA review ก่อน) | QA Lead | 4h → 1.5h | ~60% |
| 0b | **data-type-matrix-generator**<br>(Fallback ถ้า req ไม่ชัด + ไม่มีเวลา wait PM) | Field list + Base feature reference | Data Type Matrix + Happy Path + Integration Points + **Assumption Checklist** (PM tick 10 นาที) | QA | 6h → 2h | ~65% |
| 1 | **test-plan-writer**<br>(SIT Plan) | SRS + Scope + Module + Number of testers | **SIT Test Plan** (14 sections — Objective, Scope, Entry/Exit Criteria, Schedule + Effort Breakdown, Risk, Sign-off) | QA Lead | 8h → 4h | ~50% |
| 2 | **test-case-writer**<br>(mode=sit) | SRS + Module ID + project-context.md | **SIT Test Cases** (23-col table) + Traceability Matrix + **Sizing Summary Block** (feed ขั้นถัดไป) | QA | 24h → 12h<br>(per module ~20 req) | ~50% |
| 3 | **test-case-reviewer** | SIT TC + SRS | **Peer Review Report** — Must Fix / Should Fix / Coverage Gap | QA Peer | (40% saved on syntactic + traceability check) | ~40% |
| 3b | *(optional)* **robot-test-generator**<br>หรือ **e2e-test-generator** | TC ที่มี `Automation=Yes` | Robot/Playwright/Cypress/WDIO scripts + Page Object + Locator | QA Auto | ~50% (per script) | ~50% |
| — | **[Execute SIT]** | TC approved + Test environment | Execution log (Pass/Fail/Block) + raw defects | QA | manual | — |
| 4a | **bug-report-writer**<br>(ทุก defect) | Symptom + Steps + Env + Severity | **Bug Report** (Title/Env/Steps/Expected vs Actual + Severity×Priority Action Label) → Jira | QA | 30 min → 10 min | ~65% |
| 4b | **test-report-writer**<br>(SIT Report) | Test Plan + Execution data + Defect list + AI Usage Log | **SIT Test Report** (Exec Summary, Exit Criteria evaluation, Defect by Severity, **Estimate vs Actual**, **AI Savings KPI**, Go/No-Go Conclusion) | QA Lead | 4h → 1.5h | ~62% |

**🎯 Final SIT Deliverables ที่ส่ง stakeholder:**
- **SIT Test Plan** (เริ่มต้น phase, sign-off PM/TL)
- **SIT Test Cases + Traceability Matrix** (สำหรับ audit)
- **Bug Reports ใน Jira** (ตลอด phase)
- **SIT Test Report + Go/No-Go** (จบ phase, sign-off PM)

---

## 3. UAT Chain — Input/Output รายขั้น

```
SIT TC approved ──► [1] test-case-writer (mode=uat) ──► [2] test-case-reviewer
                                                       ──► [3] test-plan-writer (mode=uat)
                                                       ──► [Execute by User]
                                                       ──► [4] test-report-writer (mode=uat)
```

| # | Step (Skill) | Input | Output (Work Product) | Owner | Manual → AI-Assisted | Savings |
|:-:|--------------|-------|----------------------|:-----:|:--------------------:|:-------:|
| 1 | **test-case-writer**<br>(mode=uat, format=tc/checklist) | SIT TC ที่ approved + User roles + project-context.md | **UAT Test Cases** (business view, E2E scenario) **หรือ** **UAT Checklist** (multi-role workflow + 3-way status) | QA + BA | 16h → 8h | ~50% |
| 2 | **test-case-reviewer**<br>(mode=uat) | UAT TC + Business Requirement | Peer Review Report — focus business clarity + role coverage | QA Peer / BA | — | ~40% |
| 3 | **test-plan-writer**<br>(mode=uat) | UAT TC + User group info + Schedule constraint | **UAT Test Plan** — User communication, training, Sign-off process | QA Lead | 8h → 4h | ~50% |
| — | **[Execute by User]** | UAT TC + UAT environment + Training | User feedback + raw results | End User | manual | — |
| 4 | **test-report-writer**<br>(mode=uat) | UAT Plan + Execution data + User Sign-off | **UAT Test Report** + **User Sign-off Summary** + Deferred bugs (with PM approval) | QA Lead + BA | 4h → 1.5h | ~62% |

**🎯 Final UAT Deliverables:**
- **UAT Test Cases / Checklist** (สำหรับ End User)
- **UAT Test Plan** (training + schedule)
- **UAT Test Report + User Sign-off** (formal acceptance — gate ก่อน Production)

---

## 4. Performance Chain — Input/Output รายขั้น

```
NFR + API Spec ──► [1] test-plan-writer (mode=perf) ──► [2] perf-test-generator
                                                       ──► [Run Load/Stress/Soak/Spike]
                                                       ──► [3] perf-result-analyzer
                                                       ──► [4a] test-report-writer (mode=perf)  — internal MD
                                                       └─► [4b] perf-typst-report               — client-facing PDF
```

| # | Step (Skill) | Input | Output (Work Product) | Owner | Manual → AI-Assisted | Savings |
|:-:|--------------|-------|----------------------|:-----:|:--------------------:|:-------:|
| 1 | **test-plan-writer**<br>(mode=perf) | NFR (p95/TPS/Error) + API Spec + Workload requirement (RPS/VUs) | **Perf Test Plan** + **Workload Model** + Threshold map per endpoint | QA Perf Lead | 8h → 4h | ~50% |
| 2 | **perf-test-generator**<br>(k6) | API Spec + NFR + Workload mode + Scenarios (smoke/load/stress/soak/spike) | **k6 Scripts** (`tests/*.js`) + Config per env + Test Data + Threshold (tag-based) | QA Perf | 6h → 3h | ~50% |
| — | **[Execute Perf]** | k6 scripts + dedicated perf env | Raw results (CSV/JSON, k6/JMeter format) | QA Perf | manual run | — |
| 3 | **perf-result-analyzer** | Raw result + NFR | **Bottleneck Analysis** — per endpoint Avg/p95/p99/TPS/Error + NFR Pass/Fail + Tuning Recommendation (DB/cache/infra) | QA Perf | 4h → 2h | ~50% |
| 4a | **test-report-writer**<br>(mode=perf) | Perf Plan + Analysis + raw result | **Perf Test Report** (Markdown, internal) + Capacity Recommendation | QA Perf Lead | 8h → 4h | ~50% |
| 4b | **perf-typst-report**<br>(client-facing) | k6 JSON summary + NFR + customer info | **Perf Test Report PDF** (~5-6 หน้า, Ayodia branding, exec summary + NFR traffic-light + bottleneck cards + sign-off) — สำหรับ stakeholder non-technical | QA Perf Lead | 8h → 2.5h | ~70% |

**🎯 Final Perf Deliverables:**
- **Perf Test Plan + Workload Model** (sign-off ก่อน execute)
- **Perf Test Scripts (k6)** (commit ลง repo, run ซ้ำได้)
- **Perf Test Report (MD)** — สำหรับทีมภายใน (technical detail ครบ)
- **Perf Test Report (PDF)** — สำหรับลูกค้า/ผู้บริหาร (Ayodia branding, ~5-6 หน้า)

---

## 4b. QA Lead Utility Skills (ไม่อยู่ใน chain — ใช้คู่ขนาน)

Skills เหล่านี้ไม่ผูกกับ SDP §5.3.1 process ตรงๆ แต่ใช้บ่อยใน QA Lead workflow

| Skill | Input | Output | Use Case |
|-------|-------|--------|----------|
| **weekly-update-writer** | QA Lead Weekly Review (markdown/note) + audience + tone | Weekly Update email ภาษาธรรมชาติ (Progress, AI Savings KPI, Blockers, Next-week Plan) | ส่ง C-level / Manager / Team / Cross-functional ทุก Friday |
| **handoff-writer** | สถานะงาน + files ที่แก้ + decisions + next steps | **HANDOFF.md** | ส่งงานข้าม AI session เมื่อใกล้ context limit / สลับ tool / cooldown |

---

## 5. Summary — Total Effort Savings ต่อ 1 Module (~20 requirements)

| Phase | Manual Baseline | AI-Assisted Target | Savings (hrs) | Savings (%) |
|-------|:---------------:|:------------------:|:-------------:|:-----------:|
| SIT (Plan + TC + Review + Report) | **40 hrs** | **19.5 hrs** | 20.5 hrs | **~51%** |
| UAT (Plan + TC + Review + Report) | **32 hrs** | **15 hrs** | 17 hrs | **~53%** |
| Performance (Plan + Script + Analyze + Report) | **26 hrs** | **13 hrs** | 13 hrs | **~50%** |
| **รวม E2E ต่อ module** | **98 hrs** | **47.5 hrs** | **50.5 hrs** | **~52%** |

> **หมายเหตุ:** ตัวเลขเป็น default baseline จาก [qa-standards §6](../references/qa-standards.md) — ทีม/โปรเจคควรเก็บข้อมูลจริง 1–2 sprint แรกแล้ว override ใน `project-context.md`

---

## 6. Quality Gates (สิ่งที่ Tester ต้องตรวจก่อน sign-off ทุก Output)

| Output | Quality Gate (Must Pass) |
|--------|---------------------------|
| Test Plan | Scope ตรง Contract · Exit Criteria มีตัวเลข (ไม่ใช่ "ผ่านทั้งหมด") · Schedule = สูตร qa-standards |
| Test Cases | ทุก FR ID มี TC ≥ 1 · Expected Result วัดได้ · Boundary test ครบทุก field · ไม่มี PII · Sizing Summary ครบ |
| Peer Review | Must Fix = ของจริง (ไม่ใช่ cosmetic) · Coverage Gap ตรง SRS (ไม่ hallucinate) |
| Bug Report | Steps reproduce ได้จริง · ไม่มี PII · Severity×Priority ถูกตาม qa-standards |
| Test Report | ตัวเลขตรง raw data · Pass Rate/Open bugs ≥ Plan · Variance >30% flag · Deferred bug มี PM approval |

---

## 7. Decision Points สำคัญ (Gate ใน E2E flow)

| Decision Point | ผู้รับผิดชอบ | Output เป็น Input ของ |
|----------------|:------------:|------------------------|
| Requirement Ready? (Score) | PM/BA + QA Lead | ปลดล็อค test-case-writer (ถ้า Not-ready → fallback data-type-matrix) |
| TC Coverage พอมั้ย? (Peer Review) | QA Peer | ปลดล็อค Execute SIT |
| SIT Pass Exit Criteria? (Go/No-Go) | QA Lead + PM | ปลดล็อค UAT |
| UAT Sign-off? | End User + BA | ปลดล็อค Production |
| Perf Pass NFR? | QA Perf + Architect | ปลดล็อค Production (parallel กับ UAT) |

---

## 8. ความรับผิดชอบ — AI ทำอะไรไม่ได้ (Tester ยังต้องเป็นเจ้าของ)

| งาน | ทำไม AI แทนไม่ได้ |
|-----|---------------------|
| Cross-check Business Rule เฉพาะลูกค้า | AI ไม่รู้ promotion rule / VIP benefit ของ client นี้ |
| Accept/Reject Coverage Gap | บาง gap ยอมได้ (Phase 2), บาง gap ต้องแก้ทันที — human judgment |
| Verify Environment + Credential จริง | AI เดา IP/URL/DB จริงไม่ได้ |
| Sign-off Ready/Not Ready | รับผิดชอบทางวิชาชีพ — AI ไม่มี |
| Approve Deferred Bug | ต้องเป็น PM/Stakeholder decision |

---

## อ่านต่อ

- [work-product-flow.md](work-product-flow.md) — IPO diagram + token economy (technical view)
- [qa-onboarding.md](qa-onboarding.md) — Decision Tree + E2E walkthrough สำหรับ QA ใหม่
- [qa-standards.md](../references/qa-standards.md) — Severity/Priority/Sizing/Buffer/KPI ตัวเต็ม
- [sdp-mapping.md](../references/sdp-mapping.md) — Skill ↔ SDP §5 process mapping
- [ai-guardrails.md](../references/ai-guardrails.md) — AI usage guardrails (SDP §5.3.3)
