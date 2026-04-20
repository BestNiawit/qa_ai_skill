# QA AI Skills

รวม Claude Code skills สำหรับทีม QA — ใช้ AI ช่วยเขียน test case, bug report, และ test script (functional + performance) ตามมาตรฐานทีม

## Skills

| Skill | คำอธิบาย | สถานะ |
|-------|----------|-------|
| [test-case-writer](skills/test-case-writer/) | เขียน test case จาก requirement (PRD/spec/user story) ใช้ testing techniques (ECP, BVA, Decision Table, ฯลฯ) — horizontal table 23 cols + Test Sizing (S/M/L/XL) + Automation flag — รองรับ TH/EN + MD/CSV | ✅ พร้อมใช้ |
| [test-matrix-generator](skills/test-matrix-generator/) | สร้าง test matrix แบบ compact (CSV) — Coverage / Pairwise / Platform — ใช้ตอนเขียน full TC ไม่ทัน | ✅ พร้อมใช้ |
| [bug-report-writer](skills/bug-report-writer/) | สร้าง bug report มาตรฐาน (steps, expected vs actual, severity, priority) | ✅ พร้อมใช้ |
| [robot-test-generator](skills/robot-test-generator/) | **(Functional) Robot Framework** — 3-tier POM + ui_keywords wrapper + i18n YAML (athm_automation pattern) | ✅ พร้อมใช้ |
| [e2e-test-generator](skills/e2e-test-generator/) | **(Functional) Web E2E** — เลือก framework ได้ (Playwright/Cypress/WebdriverIO/Selenium+Java) ใช้ POM + advanced XPath (no index) + shared locators + text-as-constants | ✅ พร้อมใช้ |
| [perf-test-generator](skills/perf-test-generator/) | **(Performance) k6** — smoke/load/stress + RPS/VUs load model + per-endpoint thresholds + Grafana/Prometheus-ready (k6-perf-test-ayodia pattern) | ✅ พร้อมใช้ |

### แบ่งตาม Test Type

```
Functional tests
├── robot-test-generator   — Robot Framework (Python, athm pattern)
└── e2e-test-generator     — Modern web (TS: Playwright/Cypress/WDIO, Java: Selenium)

Performance tests
└── perf-test-generator    — k6 (JS, load/stress/soak/spike)
```

---

## วิธี Install

### แบบที่ 1: User-level (ใช้กับทุก project)
```bash
# Symlink (แนะนำ — pull repo แล้ว skill อัปเดตอัตโนมัติ)
ln -s "$(pwd)/skills/test-case-writer"        ~/.claude/skills/test-case-writer
ln -s "$(pwd)/skills/test-matrix-generator"   ~/.claude/skills/test-matrix-generator
ln -s "$(pwd)/skills/bug-report-writer"       ~/.claude/skills/bug-report-writer
ln -s "$(pwd)/skills/robot-test-generator"    ~/.claude/skills/robot-test-generator
ln -s "$(pwd)/skills/e2e-test-generator"      ~/.claude/skills/e2e-test-generator
ln -s "$(pwd)/skills/perf-test-generator"     ~/.claude/skills/perf-test-generator
```

### แบบที่ 2: Project-level (เฉพาะ project)
```bash
mkdir -p /path/to/your/project/.claude/skills
cp -r skills/* /path/to/your/project/.claude/skills/
```

### ตรวจสอบ
เปิด Claude Code แล้วพิมพ์ `/help` หรือลองสั่งงาน เช่น "ช่วยเขียน test case จากไฟล์ requirement.md" — Claude ควร trigger skill อัตโนมัติ

---

## วิธีใช้

Skill จะ **trigger อัตโนมัติ** เมื่อคำสั่งของคุณตรงกับ description ใน `SKILL.md` — ไม่ต้องเรียกชื่อ skill ตรงๆ

### 1. test-case-writer

**เตรียม:** วาง requirement file (PRD, spec, user story) ไว้ใน project แล้วบอก Claude path ของไฟล์

**ตัวอย่างคำสั่ง:**
```
ช่วยเขียน test case จากไฟล์ docs/requirement-login.md ให้หน่อย
ใช้ภาษาไทย และเน้น negative case
```
```
Read requirement.pdf and create test cases in English
using ECP and BVA, output as CSV
```

**สิ่งที่ Claude จะทำ:**
1. อ่าน requirement ทั้งไฟล์
2. ถามภาษา + format (MD/CSV) + Priority scheme (P0/P1 หรือ High/Med/Low) + Module ID
3. แตก scenario: positive / negative / boundary / edge
4. เขียนตาม horizontal template 23 cols — มี Test Sizing (S/M/L/XL) + Technique + Automation ครบ
5. ทำ coverage matrix ท้ายไฟล์
6. บันทึกเป็น `testcases_<module_id>_<YYYYMMDD>.md`

**Tip:**
- บอก scope ชัดๆ เช่น "เฉพาะ flow login ไม่รวม register"
- TC ไหนที่ Automation=Yes/Candidate → ส่งต่อให้ `robot-test-generator` / `e2e-test-generator` ได้ทันที

---

### 2. test-matrix-generator

**ใช้เมื่อ:** เขียน full test case ไม่ทัน ต้องการ coverage ก่อน — ได้ CSV ไป paste ใน Excel/Sheets/Jira ทันที

**3 matrix ที่ generate ได้:**
- **Coverage** — Requirement × Scenario (หา gap)
- **Combination** — Pairwise inputs (ลด combination ระเบิด)
- **Platform** — Feature × Browser/OS/Device (cross-platform)

**Tip:**
- ใช้เสริมกับ `test-case-writer` — ได้ matrix ก่อน, ค่อยขยายเป็น TC เต็มทีหลัง
- ถ้า combinations > 50 แถว → skill จะแนะนำใช้ tool เฉพาะ (PICT/ACTS) แทน

---

### 3. bug-report-writer

**เตรียม:** มีอาการ + steps + screenshot/log อยู่กับตัว

**ตัวอย่างคำสั่ง:**
```
ช่วยเขียน bug report ให้หน่อย:
- กดปุ่ม Submit ในหน้า checkout แล้วหน้าค้าง
- เกิดเฉพาะตอนใส่ coupon ซ้อน 2 ใบ
- Chrome 130 บน macOS, staging
- Severity: Major
```

**สิ่งที่ Claude จะทำ:**
1. เช็คข้อมูลครบมั้ย (env, steps, expected, actual, severity) — ขาดจะถาม
2. แต่ง title ตาม pattern `[Module] Action ทำให้เกิด Symptom เมื่อ Condition`
3. แยก Severity (impact) vs Priority (urgency)
4. เขียนตาม template + `[REDACTED]` ข้อมูล sensitive

**Tip:**
- ถ้า paste ลง Jira/Linear โดยตรง บอก "format สำหรับ Jira" → ปรับ markdown ให้เข้ากัน

---

### 4. robot-test-generator (Functional — Robot Framework)

**ใช้เมื่อ:** สร้าง Robot Framework test ตาม pattern ของ `athm_automation` (3-tier POM + robocop)

**Framework:** Robot Framework 6.x + SeleniumLibrary 6.1.2 + robocop 3.2.1 + robotidy + pabot

**ตัวอย่างคำสั่ง:**
```
สร้าง Robot test จาก testcases_login_20260420.md
feature: login, prefix: AUTH, TC_IDs: AUTH_SC_001_TC_001..003
```
```
เพิ่ม page object + locator สำหรับหน้า "Employee Management"
element: search box (data-test-id=emp-search), add button, table
ภาษา: TH + EN
```

**สิ่งที่ Claude จะทำ:**
1. เช็คว่า page/locator/feature/translation key มีอยู่แล้วมั้ย (ไม่สร้างซ้ำ)
2. สร้างไฟล์ตาม 3-tier: locator → page kw → feature kw → test case
3. เพิ่ม translation key ทั้ง `en/` และ `th/`
4. เพิ่ม test data ใน `testdata.yaml`
5. รัน `robocop --threshold W` ให้ผ่าน

**Tip:**
- ทำงานใน `athm_automation` โดยตรง → Claude อ่าน page ใกล้เคียงเพื่อ match style เป๊ะ
- ห้าม hardcode UI text — ใช้ translation YAML เสมอ

---

### 5. e2e-test-generator (Functional — Playwright / Cypress / WDIO / Selenium-Java)

**ใช้เมื่อ:** สร้าง E2E web automation แบบเลือก framework ได้ — pattern จาก `automation-starter-kit-playwright`

**Framework ที่รองรับ:**
- **Playwright + TypeScript** (primary) — `frameworks/playwright-ts.md` + `examples/playwright-ts/`
- **Cypress + TypeScript** — `frameworks/cypress-ts.md`
- **WebdriverIO + TypeScript** — `frameworks/webdriverio-ts.md`
- **Selenium + Java + TestNG** — `frameworks/selenium-java.md`

**กฎเหล็ก 4 ข้อ:**
1. **POM** — page class + base page; test ไม่รู้จัก locator
2. **Advanced XPath** — ไม่ใช้ index (`[1]`, `[last()]`); ใช้ `data-test-id`, ARIA role, `normalize-space()`, relationship axes
3. **Unique / Shared Locators** — pattern ที่ใช้ข้ามหน้า centralize ใน `locators/common.locators.ts`
4. **Text-as-Constants** — UI text ทุกตัวเก็บใน `labels/*.labels.ts`

**ตัวอย่างคำสั่ง:**
```
สร้าง Playwright test จาก testcases_login_20260420.md
feature: login, prefix: AUTH, TC_IDs: AUTH_SC_001_TC_001..003
```
```
convert TC-045 (checkout flow) เป็น Cypress test + page object
```

**Tip:**
- Claude ตรวจ framework จาก config file (`playwright.config.ts` / `cypress.config.ts` / `wdio.conf.ts` / `pom.xml`)
- ทำงานใน `automation-starter-kit-playwright` โดยตรง → Claude อ่าน page ใกล้เคียงเพื่อ match style

---

### 6. perf-test-generator (Performance — k6)

**ใช้เมื่อ:** สร้าง k6 performance test ตาม pattern ของ `k6-perf-test-ayodia`

**Framework:** k6 ≥ 0.45 + Node.js (สำหรับ `npm run` scripts) + Prometheus/Grafana output (optional) + k6 Cloud (optional)

**ครอบคลุม test type:**
- **smoke** — sanity check (1 VU × 30s)
- **load** — normal traffic (RPS หรือ VUs)
- **stress** — breaking-point discovery (3x normal + sustained peak)
- **soak** — memory leak (long duration + steady load)
- **spike** — sudden burst (ramping-arrival-rate)

**7 กฎเหล็ก:**
1. ใช้ `HttpClient` wrapper (ไม่ใช้ `k6/http` ตรง)
2. Tag endpoint ด้วย `{ name: '...' }` เสมอ (per-endpoint threshold)
3. Threshold ตั้งใน `config/<env>.js` (ไม่ hardcode ใน test)
4. ใช้ `checkResponse` / `checkJsonResponse` (ไม่ใช้ raw `check()`)
5. Sleep ระหว่าง request (1s smoke / 0.5s load / 0.3s stress)
6. Test data ใน `data/*.json` (ห้าม hardcode credential จริง)
7. Export `handleSummary` → JSON + HTML report

**ตัวอย่างคำสั่ง:**
```
เขียน k6 load test สำหรับ /api/v1/orders
- endpoints: GET /orders (list), POST /orders (create)
- SLO: p(95)<400ms, error rate <1%
- load: 200 req/s (RPS mode)
```
```
สร้าง stress test สำหรับ checkout flow
login → browse products → add to cart → checkout
target: 500 concurrent users (VUs mode), stage 5m
```
```
convert smoke.test.js เป็น spike test (ramping-arrival-rate)
burst จาก 50 → 1000 req/s ภายใน 30s แล้วตกลงกลับ
```

**สิ่งที่ Claude จะทำ:**
1. ถาม scope: endpoints, SLO, load model (RPS vs VUs), auth flow
2. เช็ค asset (`utils/httpClient.js`, `scenarios/*.js`, `config/<env>.js`, `data/testData.json`) — reuse
3. สร้าง test file + update `config/<env>.js` (base URL + endpointThresholds) + update `data/testData.json`
4. Verify smoke ก่อน → load → stress
5. แนะนำ Grafana dashboard ID `19665` + Prometheus remote-write

**Tip:**
- ทำงานใน `k6-perf-test-ayodia` โดยตรง → Claude อ่าน `load.test.js` ใกล้เคียง
- อ่าน [`references/load-model-decision.md`](skills/perf-test-generator/references/load-model-decision.md) เพื่อเลือก RPS vs VUs
- อ่าน [`references/threshold-design.md`](skills/perf-test-generator/references/threshold-design.md) เพื่อออกแบบ SLO ที่ไม่ false-alarm

---

## Workflow แนะนำสำหรับทีม

```
1. PM ส่ง PRD      →  /test-matrix-generator   → coverage matrix (เช็ค scope + gap เร็วๆ)
                   →  /test-case-writer        → test cases 23 cols (review ในทีม)

2. ทดสอบเจอ bug   →  /bug-report-writer        → paste ลง Jira

3. TC approved     →  /robot-test-generator     → Robot Framework (ทีม athm_automation)
                   →  /e2e-test-generator       → Playwright/Cypress/WDIO/Selenium (ทีมอื่น)

4. Performance    →  /perf-test-generator       → k6 smoke/load/stress + Grafana dashboard
```

**เวลาเขียน TC ไม่ทัน:** ใช้ `/test-matrix-generator` อย่างเดียวก่อน ได้ CSV coverage/pairwise/platform ส่ง review ในทีม — ค่อยขยายเป็น full TC ใน sprint ถัดไป

**เวลาเจอ performance issue:** `/perf-test-generator` รัน smoke → load → stress → ดู Grafana → ถ้า threshold fail → `/bug-report-writer` พร้อม HTML report attachment

---

## โครงสร้าง Repo
```
qa_ai_skill/
├── README.md
├── skills/
│   ├── test-case-writer/           — TC designer (23 cols + Sizing + Automation)
│   ├── test-matrix-generator/      — 3 matrix types (CSV)
│   ├── bug-report-writer/          — bug report TH/EN
│   ├── robot-test-generator/       — Robot Framework + 3-tier POM (athm_automation)
│   ├── e2e-test-generator/         — Multi-framework web E2E (Playwright/Cypress/WDIO/Selenium-Java)
│   │   ├── SKILL.md                — framework picker + 4 rules
│   │   ├── references/             — advanced-xpath, pom-locator-dedupe
│   │   ├── frameworks/             — pattern per framework
│   │   └── examples/playwright-ts/ — working reference
│   └── perf-test-generator/        — k6 performance (smoke/load/stress + RPS/VUs)
│       ├── SKILL.md                — 7 rules + load model + per-endpoint threshold
│       ├── references/             — load-model-decision, threshold-design
│       └── examples/               — config/scenarios/utils/tests/data
```

## Contribute เพิ่ม Skill
1. สร้าง folder ใหม่ใน `skills/<skill-name>/`
2. เขียน `SKILL.md` พร้อม frontmatter:
   ```yaml
   ---
   name: skill-name
   description: ทำอะไร + เมื่อไหร่ควร trigger (ทั้ง TH/EN)
   ---
   ```
3. เพิ่มแถวใน table ด้านบน
4. เปิด PR
