# Work Product Flow — IPO Diagrams + Token Economy

> **วัตถุประสงค์:** แสดง **Input → Process → Output** ของทุก skill ในหน้าเดียว
> — ให้ QA รู้ก่อนใช้ว่า "ต้องเตรียมอะไร / AI ทำอะไร / ได้อะไรกลับมา"
> — ช่วยประหยัด token + เวลา (ไม่เดา, ไม่ retry เปล่าๆ)
>
> **อ้างอิง:** Ayodia SDP §5 Testing — ตาราง "กระบวนการ / ผู้รับผิดชอบ / Work Products / AI-Assisted"

---

## 1. End-to-End Pipeline — Work Product Flow

```
                          ┌─────────────────────────────────┐
                          │   SRS / PRD / NFR (External)    │
                          └─────────────────┬───────────────┘
                                            │
              ┌─────────────────────────────┼─────────────────────────────┐
              │                             │                             │
              ▼                             ▼                             ▼
    ┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
    │ test-matrix-     │         │ test-plan-writer │         │ test-plan-writer │
    │ generator        │         │   (SIT Plan v1)  │         │   (mode=perf)    │
    │ (optional, quick)│         │   placeholder    │         │                  │
    └────────┬─────────┘         └────────┬─────────┘         └────────┬─────────┘
             │                            │                            │
             ▼                            ▼                            ▼
    ┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
    │ Coverage Matrix  │         │ SIT Plan (MD)    │         │ Perf Test Plan   │
    │ (CSV)            │         │ + Entry/Exit     │         │ + Workload Model │
    └────────┬─────────┘         └────────┬─────────┘         │ + NFR threshold  │
             │                            │                   └────────┬─────────┘
             │                            ▼                            │
             └──────────────────►┌──────────────────┐                  │
                                 │ test-case-writer │                  │
                                 │ (mode=sit)       │                  │
                                 └────────┬─────────┘                  ▼
                                          │                  ┌──────────────────┐
                                          ▼                  │ perf-test-       │
                                 ┌──────────────────┐        │ generator (k6)   │
                                 │ SIT TC (23 cols) │        └────────┬─────────┘
                                 │ + Sizing Summary │                 │
                                 │   Block ⭐       │                 ▼
                                 └────────┬─────────┘        ┌──────────────────┐
                                          │                  │ k6 Scripts       │
                       ┌──────────────────┤                  │ + Config + Data  │
                       │                  │                  └────────┬─────────┘
                       ▼                  ▼                           │
           ┌──────────────────┐  ┌──────────────────┐                 │
           │ test-plan-writer │  │ test-case-       │                 │
           │ (SIT Plan v2 —   │  │ reviewer         │                 │
           │  Schedule จาก    │  │                  │                 │
           │  Sizing Summary) │  └────────┬─────────┘                 │
           └────────┬─────────┘           │                           │
                    │                     ▼                           │
                    │          ┌──────────────────┐                   │
                    │          │ Peer Review      │                   │
                    │          │ Report + fix     │                   │
                    │          │ Must Fix issues  │                   │
                    │          └────────┬─────────┘                   │
                    │                   │                             │
                    └───────────────────┴───────────────┐             │
                                                        │             ▼
                                                        ▼    ┌──────────────────┐
                                               ┌──────────┐  │ [k6 Run]         │
                                               │ [Execute]│  │ → Raw Results    │
                                               └─────┬────┘  └────────┬─────────┘
                                                     │                │
                           ┌──────────────────┐      │                ▼
                           │ bug-report-      │ ◄────┤      ┌──────────────────┐
                           │ writer           │      │      │ perf-result-     │
                           └────────┬─────────┘      │      │ analyzer         │
                                    │                │      └────────┬─────────┘
                                    ▼                │               │
                           ┌──────────────────┐      │               ▼
                           │ Bug Reports      │      │    ┌──────────────────┐
                           │ (→ Jira)         │      │    │ Bottleneck +     │
                           └────────┬─────────┘      │    │ NFR Evaluation   │
                                    │                │    └────────┬─────────┘
                                    │                │             │
           ┌────────────────────────┴────────────────┴─────────────┘
           ▼
    ┌──────────────────┐
    │ test-report-     │
    │ writer           │
    │ (sit/uat/perf)   │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Test Report      │
    │ + Exit Criteria  │
    │ + Estimate vs    │
    │   Actual ⭐      │
    │ + AI Savings KPI │
    │   ⭐             │
    └──────────────────┘

 ⭐ = สิ่งที่ qa-standards.md บังคับให้มี
```

---

## 2. IPO Summary Table — 10 Skills ในหน้าเดียว

> Token/Time estimates เป็นค่าเฉลี่ยต่อ 1 module (~20 requirements). "Verify" = สิ่งที่ QC **ต้องตรวจ manually** ก่อน approve

| # | Skill | Input | Output (Work Product) | Token In/Out | AI Time | QC Verify (ก่อน approve) |
|---|-------|-------|----------------------|:------------:|:-------:|-------------------------|
| 1 | [test-plan-writer](../skills/test-plan-writer/) | SRS/NFR, scope, TC file (for Schedule), testers, mode | **Test Plan** (MD) — Objective, Scope, Entry/Exit, Env, Schedule+Effort, Risk, Defect Mgmt, Traceability, Sign-off | 5k/8k | 30 sec | Scope ตรง Contract, Exit Criteria ≠ "ผ่านทั้งหมด", Schedule = สูตร qa-standards |
| 2 | [test-case-writer](../skills/test-case-writer/) | SRS/PRD, Module ID, mode (sit/uat), UAT format (tc/checklist), lang, format | **Test Cases** (MD/CSV) — 23 cols + Traceability Matrix + **Sizing Summary Block** / **UAT Checklist** (multi-role workflow + C1/C2 categories + 3-way status) | 10k/25k | 1-2 min | ทุก req มี TC, Expected วัดได้, ไม่มี PII, Sizing Summary ครบ / checklist: ทุก role handoff มีสถานะคำขอ |
| 3 | [test-case-reviewer](../skills/test-case-reviewer/) | TC file, SRS, mode | **Peer Review Report** (MD) — Must Fix / Should Fix / OK + Coverage Gap | 15k/5k | 30 sec | Must Fix ถูก category, Coverage Gap ตรง SRS |
| 4 | [test-report-writer](../skills/test-report-writer/) | TC with actual results, Test Plan, Defects, AI Usage Log, mode | **Test Report** (MD) — Summary, Exit Criteria, Defect, **Estimate vs Actual**, **AI Savings KPI**, Conclusion | 20k/8k | 1 min | ตัวเลขตรง raw, Go/No-Go ตรง criteria, variance >30% flag |
| 5 | [test-matrix-generator](../skills/test-matrix-generator/) | Req file + scope, matrix type (Coverage/Combination/Platform) | **Test Matrix** (CSV, UTF-8 BOM) — compact, ~10-15 min to generate | 3k/3k | 15 sec | pairwise algorithm ถูก, ไม่มี platform combo เพี้ยน (Safari/Win) |
| 6 | [bug-report-writer](../skills/bug-report-writer/) | Symptom, Steps, Env, Severity, Priority, attachments | **Bug Report** (MD) — Title+Module+Condition, Env, Steps, Expected vs Actual, Severity/Priority (S1-S4/P0-P3) | 2k/2k | 15 sec | Steps reproduce ได้, ไม่มี PII, title มี module+symptom+condition |
| 7 | [robot-test-generator](../skills/robot-test-generator/) | TC file, feature, prefix, locator ref | **Robot Files** — `*.robot`, `keywords.robot`, `locators.yml`, `translations.yml` | 10k/15k | 1 min | Locator UPPER_SNAKE_CASE, keyword ไม่มี assertion, bilingual EN/TH |
| 8 | [e2e-test-generator](../skills/e2e-test-generator/) | TC file, framework (Playwright/Cypress/WDIO/Selenium), feature, prefix | **E2E Files** — `*.spec.ts`, `locators/*.ts` (POM), `pages/*.ts`, config | 10k/20k | 1-2 min | Advanced XPath, unique/shared locators, text-as-constants |
| 9 | [perf-test-generator](../skills/perf-test-generator/) | API spec, NFR, workload mode (RPS/VUs), scenarios | **k6 Files** — `tests/*.js`, `config/<env>.js`, `data/*.json`, threshold config | 5k/10k | 1 min | HttpClient wrapper, tag-based threshold, sleep/think time |
| 10 | [perf-result-analyzer](../skills/perf-result-analyzer/) | Raw result (CSV/JSON จาก k6/JMeter), NFR | **Analysis Report** (MD) — Bottleneck + NFR evaluation per endpoint + Tuning Recommendation | 30k/5k | 1 min | ตัวเลขตรง raw, ระบุ hypothesis ได้ (DB/cache/upstream) |

> **หมายเหตุ Token:** `Input` นับ file ที่ upload + prompt; `Output` นับ markdown ที่ AI generate. Claude Opus pricing: ~$15/M in, ~$75/M out (2026) — 1 module ≈ $0.5-2

---

## 3. IPO Detail — แต่ละ Skill

### 3.1 test-plan-writer

```
┌─ test-plan-writer ─────────────────────────────────────────────────────┐
│                                                                         │
│  INPUT                          PROCESS (AI)              OUTPUT        │
│  ─────                          ────────────              ──────        │
│                                                                         │
│  REQUIRED:                      1. อ่าน SRS/PRD          Test Plan     │
│  • SRS/PRD path                    ทั้งไฟล์               (Markdown)    │
│  • Module scope                                                         │
│  • Mode (sit/uat/perf)          2. Extract Scope         โครง 14 §:    │
│  • Language (TH/EN)                + map FR IDs          1. Objective  │
│  • Number of testers                                      2. Scope     │
│  • Test Case file               3. Infer Entry/Exit       3. Entry     │
│    (สำหรับ Schedule)                Criteria (มีตัวเลข)   4. Exit      │
│                                                           5. Approach  │
│  OPTIONAL:                      4. Read Sizing Summary    6. Env       │
│  • project-context.md              Block จาก TC file      7. Roles     │
│  • NFR (perf mode)                                        8. Schedule  │
│  • Existing SIT Plan            5. คำนวณ Schedule:          + Effort   │
│    (สำหรับ uat mode)               Prep + Review +            Breakdown│
│                                    Exec + Fix + Buffer    9. Risk      │
│                                    (qa-standards §4)     10. Defect    │
│                                                          11. Traceab.  │
│                                 6. Generate template     12. Test Data │
│                                    ตาม mode             13. Suspend    │
│                                                         14. Sign-off   │
│                                                                         │
│  Token: ~5k in / ~8k out        AI Time: 30 sec          Savings: ~50% │
│                                                                         │
│  QC Verify (ก่อน sign-off):                                             │
│  ❗ Scope ตรง Contract (ไม่ใช่ "ทดสอบทั้งระบบ")                         │
│  ❗ Exit Criteria มีตัวเลข (Pass Rate %, Bug count)                     │
│  ❗ Environment ตรง prod config (IP, DB, browser version)               │
│  ❗ Schedule มี Effort Breakdown (ไม่ใช่ `<days>` เฉยๆ)                 │
│  ❗ Severity = S1-S4, Priority = P0-P3 (ห้าม Blocker/High/Med)          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 test-case-writer

```
┌─ test-case-writer ─────────────────────────────────────────────────────┐
│                                                                         │
│  INPUT                          PROCESS (AI)              OUTPUT        │
│  ─────                          ────────────              ──────        │
│                                                                         │
│  REQUIRED:                      1. อ่าน Requirement       Test Cases   │
│  • Requirement file                ให้จบ                 (MD/CSV)      │
│  • Mode (sit/uat)                                                       │
│  • Module ID + Title            2. Pick Technique:       Header +      │
│  • Language (TH/EN)                ECP, BVA, Decision     Scope +      │
│  • Format (MD/CSV)                 Table, State,         23-col Table  │
│  • Priority = P0-P3                Use Case, Error       + Traceab.    │
│                                    Guessing               Matrix       │
│  OPTIONAL:                                                             │
│  • project-context.md           3. แตก Scenario:         ⭐ Sizing     │
│    (glossary, biz rules)           Positive / Negative /    Summary    │
│  • SIT TC (for UAT mode)           Boundary / Edge         Block       │
│                                                            (ท้ายไฟล์) │
│                                 4. Write TC 23 cols:     ────────────  │
│                                    ID, Desc, Role,       Count / hr   │
│                                    Pos/Neg, Priority,    by S/M/L/XL  │
│                                    Severity, Sizing,     + Priority   │
│                                    Technique, Step,        breakdown   │
│                                    Data, Expected,       + Severity   │
│                                    FR_ID, Automation,      breakdown   │
│                                    Labels                              │
│                                                                         │
│                                 5. UAT mode → รวม SIT                   │
│                                    TC เป็น E2E business                 │
│                                    scenario                             │
│                                                                         │
│                                 6. Generate Traceability              │
│                                    Matrix + Sizing Sum.                │
│                                                                         │
│  Token: ~10k in / ~25k out      AI Time: 1-2 min        Savings: ~50-60% │
│                                                                         │
│  QC Verify (ก่อน review):                                               │
│  ❗ ทุก FR ID ใน SRS มี TC อย่างน้อย 1 ตัว                              │
│  ❗ Expected Result วัดได้ (ไม่มี "ทำงานถูกต้อง", "แสดงผลปกติ")         │
│  ❗ ทุก input field มี Boundary Test (min, min-1, max, max+1)           │
│  ❗ ไม่มี password จริง / PII (ใช้ `[REDACTED]`)                        │
│  ❗ Sizing Summary Block ท้ายไฟล์ครบ (feed test-plan-writer)            │
│  ❗ UAT mode → ไม่ Copy SIT มาตรงๆ (ภาษา business, E2E flow)            │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.3 test-case-reviewer

```
┌─ test-case-reviewer ───────────────────────────────────────────────────┐
│                                                                         │
│  INPUT                          PROCESS (AI)              OUTPUT        │
│  ─────                          ────────────              ──────        │
│                                                                         │
│  REQUIRED:                      1. อ่าน TC + SRS          Peer Review  │
│  • Test Case file (MD/CSV)                                Report (MD)  │
│  • SRS / PRD                    2. Run 5 checks:                        │
│  • Mode (sit/uat)                  A) Syntactic          Summary:      │
│                                    B) Quality (วัดได้)   • Total TC    │
│  OPTIONAL:                         C) Coverage           • Must Fix    │
│  • Reviewer role                     (Pos/Neg/Boundary)  • Should Fix  │
│  • project-context.md              D) Traceability Gap   • OK          │
│                                    E) UAT-specific                     │
│                                                          Issues table: │
│                                 3. จำแนก Must Fix vs     | TC ID |     │
│                                    Should Fix              ปัญหา |     │
│                                                           ระดับ |      │
│                                 4. หา Coverage Gap        ข้อเสนอ |    │
│                                    (FR ใน SRS ไม่มี TC)               │
│                                                          Coverage Gap  │
│                                                          list + Sign   │
│                                                          -off section  │
│                                                                         │
│  Token: ~15k in / ~5k out       AI Time: 30 sec         Savings: ~40% │
│                                                                         │
│  QC Verify (ก่อน send back to writer):                                  │
│  ❗ Must Fix = จำเป็นต้องแก้ (ไม่ใช่ cosmetic)                          │
│  ❗ Coverage Gap ตรง SRS จริง (ไม่ hallucinate)                         │
│  ❗ ข้อเสนอแนะเฉพาะเจาะจง (ไม่ใช่ "ปรับแก้")                            │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.4 test-report-writer

```
┌─ test-report-writer ───────────────────────────────────────────────────┐
│                                                                         │
│  INPUT                          PROCESS (AI)              OUTPUT        │
│  ─────                          ────────────              ──────        │
│                                                                         │
│  REQUIRED:                      1. อ่าน Plan →           Test Report   │
│  • Mode (sit/uat/perf)             get Exit Criteria     (MD)           │
│  • Execution data                                                       │
│    (Jira/Excel/CSV)             2. Parse execution       11 §:         │
│  • Test Plan file                  data → compute        1. Exec Summ. │
│  • Defect list                     Pass Rate, Defect     2. Test Exec  │
│  • AI Usage Log                    by S1-S4              3. Exit Crit. │
│  • Language                                              4. Defect     │
│                                 3. Compare Exit Crit.    5. Deferred   │
│  OPTIONAL:                         line-by-line          6. S1/S2 Open │
│  • User Sign-off (UAT)                                   7. Est vs ⭐  │
│  • Perf raw result (perf)       4. Draft Exec Summary:      Actual     │
│  • project-context.md              Ready/Not Ready       8. AI Sav. ⭐ │
│                                                             KPI         │
│                                 5. Build 2 key          9. Risk        │
│                                    sections:           10. Conclusion  │
│                                    A) Estimate vs      11. Sign-off    │
│                                       Actual (qa-                      │
│                                       standards §4)                    │
│                                    B) AI Effort                        │
│                                       Savings KPI                      │
│                                       (qa-standards §6)                │
│                                                                         │
│                                 6. Rule-based Go/No-Go:                │
│                                    - S1/S2 Open > 0                    │
│                                      → No-Go                           │
│                                    - Exit Crit. fail                   │
│                                      → Conditional                     │
│                                                                         │
│  Token: ~20k in / ~8k out       AI Time: 1 min          Savings: ~60-70% │
│                                                                         │
│  QC Verify (ก่อน ส่ง TL/PM):                                            │
│  ❗ ตัวเลขตรง raw data (ทุก TC + defect)                                │
│  ❗ Pass Rate, Open bugs ≥ เกณฑ์ Plan — ถ้าไม่ผ่าน ต้องไม่ "Ready"     │
│  ❗ Variance > 30% → Remark flag + action                              │
│  ❗ AI Savings % คำนวณจาก baseline qa-standards §6                      │
│  ❗ Deferred bug มี PM approval reference (ไม่ใช่ AI เดาเอง)            │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.5 test-matrix-generator

```
┌─ test-matrix-generator ────────────────────────────────────────────────┐
│                                                                         │
│  INPUT                          PROCESS (AI)              OUTPUT        │
│  ─────                          ────────────              ──────        │
│                                                                         │
│  REQUIRED:                      1. อ่าน Req + scope      Test Matrix   │
│  • Matrix type                                           (CSV UTF-8    │
│    - Coverage                   2. เลือก algorithm:       BOM)          │
│    - Combination                   - Pairwise: PICT/                    │
│    - Platform                        allpairspy                        │
│  • Input source                    - Cartesian: ≤ 27                   │
│    (req file/params)                 combo                             │
│  • Scope                                                               │
│                                 3. Generate:                            │
│  OPTIONAL:                         - Coverage: ✓/-      Summary:       │
│  • Update existing file            - Combination: pair  • rows/cols    │
│                                    - Platform: P1/2/3   • gap found    │
│                                                         • orphan TC    │
│                                 4. Size check:                         │
│                                    >50×50? → warn split                │
│                                                                         │
│  Token: ~3k in / ~3k out        AI Time: 15 sec          Savings: 10x  │
│                                                                        vs full TC│
│  เหมาะเมื่อ:                                                             │
│  ✅ รีบ ไม่ทันเขียน TC — ต้องการ coverage ก่อน                          │
│  ✅ ต้องดู combination input ว่าครอบคลุมมั้ย                            │
│  ❌ ถ้ามีเวลา → ข้ามไปใช้ test-case-writer ดีกว่า (ได้ถึง execute)      │
│                                                                         │
│  QC Verify:                                                             │
│  ❗ Pairwise algorithm ถูก (ไม่หลุด pair)                               │
│  ❗ Platform combo สมเหตุสมผล (ไม่มี Safari บน Windows)                 │
│  ❗ UTF-8 BOM + CRLF (Excel ไทยเปิดได้)                                 │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.6 bug-report-writer

```
┌─ bug-report-writer ────────────────────────────────────────────────────┐
│                                                                         │
│  INPUT                          PROCESS (AI)              OUTPUT        │
│  ─────                          ────────────              ──────        │
│                                                                         │
│  REQUIRED:                      1. Check 12 inputs       Bug Report    │
│  • Symptom                         ครบมั้ย → ถ้าขาด      (MD, paste    │
│  • Steps to reproduce              ต้องถามก่อน            ลง Jira)     │
│  • Expected vs Actual                                                   │
│  • Environment                  2. เขียน Title:          โครง:         │
│  • Severity S1-S4                  [Module] Action →     • Title       │
│  • Language (TH/EN)                Symptom เมื่อ Cond.   • Environment │
│                                                          • Severity/P  │
│  OPTIONAL:                      3. แยก Severity vs       • Steps       │
│  • Priority P0-P3                  Priority (ห้ามรวม)    • Expected    │
│  • Frequency                                             • Actual      │
│  • Test data                    4. Format steps เป็น    • Attachments │
│  • Screenshot/HAR                  ข้อๆ + highlight     • Workaround  │
│  • Related TC ID                   จุด bug เกิด                         │
│                                                                         │
│  Token: ~2k in / ~2k out        AI Time: 15 sec         Savings: Dev   │
│                                                         ไม่ต้องถามกลับ │
│  QC Verify (ก่อน paste Jira):                                           │
│  ❗ Steps reproduce ได้จริง (ลองทำตามเอง)                               │
│  ❗ ไม่มี PII จริง (password, email ลูกค้าจริง)                         │
│  ❗ Severity ถูกตาม qa-standards §1 (S1-S4, ไม่ใช่ Blocker)             │
│  ❗ ไม่ได้รวม 2 bugs ใน 1 report                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.7-3.10 สรุป (Automation + Perf — รายละเอียดใน SKILL.md ของ skill นั้น)

| Skill | Input | Output | AI Time |
|-------|-------|--------|:-------:|
| [robot-test-generator](../skills/robot-test-generator/) | TC file + feature + locator ref | `*.robot`, `keywords.robot`, `locators.yml`, `translations.yml` | 1 min |
| [e2e-test-generator](../skills/e2e-test-generator/) | TC file + framework | `*.spec.ts` + POM + config | 1-2 min |
| [perf-test-generator](../skills/perf-test-generator/) | API spec + NFR + workload mode | `tests/*.js` + `config/` + `data/` | 1 min |
| [perf-result-analyzer](../skills/perf-result-analyzer/) | Raw k6/JMeter result + NFR | Analysis MD — Bottleneck + NFR eval + Tuning | 1 min |

---

## 4. Token Economy — ไม่ใช้ AI แบบสิ้นเปลือง

### 4.1 5 เทคนิคประหยัด

| # | เทคนิค | ประหยัดเท่าไหร่ |
|---|--------|----------------|
| 1 | **Send SRS ครั้งเดียว** สำหรับ Plan + TC + Review (prompt cache) | ~70% input token |
| 2 | **Batch ระดับ module** ไม่ใช่ทั้งระบบทีเดียว — ย่อย ≤ 30 req/ครั้ง | output quality ดีขึ้น + ไม่ timeout |
| 3 | **ใช้ test-matrix-generator ก่อน** test-case-writer ถ้ายังไม่ชัว coverage | ลด retry round |
| 4 | **เขียน project-context.md ครั้งเดียว** ใช้ทั้งทีม — ไม่ต้อง re-explain | ~15% input token/prompt |
| 5 | **Re-use Sizing Summary** — test-plan-writer v2 ไม่ต้องอ่าน SRS ใหม่ | ~50% input token |

### 4.2 กรณีที่ **ไม่ควร** ใช้ AI (เสียเวลา)

| สถานการณ์ | ทำไม | ทำอะไรแทน |
|-----------|------|-----------|
| Req < 5 ข้อ, TC < 10 ตัว | Prompt + review AI ใช้เวลาพอๆ กับเขียนเอง | เขียน manual ใน Excel |
| แก้ TC 1-2 ข้อ | Token cost ต่อ re-generate > เขียน edit เอง | edit file ตรง (ไม่ต้อง re-run skill) |
| Update สถานะ Pass/Fail ใน TC | เป็น data entry ไม่ต้อง AI | Excel macro / manual |
| Translate 3-4 string | overkill | Google Translate / DeepL |
| Bug ที่เห็น root cause ชัด | เสียเวลา review steps ที่ dev รู้อยู่แล้ว | message ตรง dev |

### 4.3 Prompt Cache — Trick ใน Claude Code

Claude cache ไฟล์ที่ upload ไป 5 นาที → ถ้าทำ Plan → TC → Review **ติดกัน** ภายใน 5 นาที จะได้ cache hit (ลด token ~70%)

```
❌ แย่:
   09:00 → prompt 1 (เขียน Plan)
   11:00 → prompt 2 (เขียน TC) ← cache หมดแล้ว ต้อง re-upload SRS
   14:00 → prompt 3 (review)   ← cache หมดอีก

✅ ดี:
   09:00 → prompt 1 (Plan draft v1)
   09:03 → prompt 2 (TC from same SRS) ← cache hit
   09:06 → prompt 3 (review TC)        ← cache hit
   09:10 → prompt 4 (Plan v2 from TC sizing) ← cache hit
```

### 4.4 When to Parallelize vs Sequentialize

| ทำพร้อมกันได้ (parallel) | ต้องทำตามลำดับ (sequential) |
|-------------------------|----------------------------|
| test-matrix-generator + test-plan-writer (v1) | test-case-writer ต้องรอ SRS พร้อม |
| robot-test-generator + e2e-test-generator (ถ้าทำทั้ง 2 stack) | test-case-reviewer ต้องรอ TC เสร็จ |
| bug-report-writer (ทำต่อ bug) | test-plan-writer (v2) ต้องรอ Sizing Summary จาก TC |
|  | test-report-writer ต้องรอ execute จบ |

---

## 5. QC = Review & Approve (ยึดหลัก SDP §5.3.3)

**AI Draft 70-80% → QC Review & Approve 20-30%** — QC ยัง **ต้อง** ทำงานต่อไปนี้ (AI แทนไม่ได้):

| หน้าที่ | ทำไม AI แทนไม่ได้ |
|--------|---------------------|
| Cross-check กับ Business Rule เฉพาะลูกค้า | AI ไม่รู้ promotion rule / VIP benefit ของ client นี้ |
| ตัดสินใจ Accept/Reject Coverage Gap | บาง gap ยอมได้ (Phase 2), บาง gap ต้องแก้ทันที |
| Verify Environment + Credential จริง | AI เดาไม่ได้ว่า IP/URL จริงของ env นี้คืออะไร |
| Sign-off Ready/Not Ready | รับผิดชอบทางวิชาชีพ — AI ไม่มี |
| Update Sizing Scale ตาม variance | AI ให้สูตรได้ แต่ commit scale ใหม่ = human call |

---

## 6. อ่านต่อ

- [qa-onboarding.md](qa-onboarding.md) — Decision Tree + E2E walkthrough (คู่กับไฟล์นี้)
- [qa-standards.md](../references/qa-standards.md) — Severity/Priority/Sizing/Buffer/KPI
- [sdp-mapping.md](../references/sdp-mapping.md) — Skill ↔ SDP §5 process
- [ai-guardrails.md](../references/ai-guardrails.md) — AI usage guardrails (SDP §5.3.3)
- Ayodia SDP §5 Testing — ตาราง Work Products ต้นฉบับ
