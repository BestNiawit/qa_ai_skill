# QA AI Skills

รวม Claude Code skills สำหรับทีม QA — ใช้ AI ช่วยเขียน test case, bug report และ test script ตามมาตรฐานทีม

## Skills

| Skill | คำอธิบาย | สถานะ |
|-------|----------|-------|
| [test-case-writer](skills/test-case-writer/) | เขียน test case จาก requirement (PRD/spec/user story) ใช้ testing techniques (ECP, BVA, Decision Table, ฯลฯ) รองรับ TH/EN | ✅ พร้อมใช้ |
| [test-matrix-generator](skills/test-matrix-generator/) | สร้าง test matrix แบบ compact (CSV) — Coverage / Pairwise / Platform — ใช้ตอนเขียน full TC ไม่ทัน | ✅ พร้อมใช้ |
| [bug-report-writer](skills/bug-report-writer/) | สร้าง bug report มาตรฐาน (steps, expected vs actual, severity, priority) | ✅ พร้อมใช้ |
| [test-script-generator](skills/test-script-generator/) | สร้าง Robot Framework test + Page Object + locator ตาม pattern athm_automation (3-tier POM, robocop-clean, i18n YAML) | ✅ พร้อมใช้ |
| [test-script-generator-web](skills/test-script-generator-web/) | สร้าง E2E web automation test — เลือก framework ได้ (Playwright/Cypress/WebdriverIO/Selenium+Java) ใช้ POM + advanced XPath (no index) + unique/shared locators + text-as-constants | ✅ พร้อมใช้ |

## วิธี Install

### แบบที่ 1: User-level (ใช้กับทุก project)
```bash
# Symlink (แนะนำ — pull repo แล้ว skill อัปเดตอัตโนมัติ)
ln -s "$(pwd)/skills/test-case-writer"           ~/.claude/skills/test-case-writer
ln -s "$(pwd)/skills/test-matrix-generator"      ~/.claude/skills/test-matrix-generator
ln -s "$(pwd)/skills/bug-report-writer"          ~/.claude/skills/bug-report-writer
ln -s "$(pwd)/skills/test-script-generator"      ~/.claude/skills/test-script-generator
ln -s "$(pwd)/skills/test-script-generator-web"  ~/.claude/skills/test-script-generator-web
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
using ECP and BVA, output as markdown table
```

**สิ่งที่ Claude จะทำ:**
1. อ่าน requirement ทั้งไฟล์
2. ถามภาษา (ถ้ายังไม่บอก) + format (md/csv)
3. แตก scenario: positive / negative / boundary / edge
4. เขียน test case ตาม template + ระบุ technique ที่ใช้
5. ทำ coverage matrix ท้ายไฟล์
6. บันทึกเป็น `testcases_<feature>_<YYYYMMDD>.md`

**Tip:**
- บอก scope ชัดๆ เช่น "เฉพาะ flow login ไม่รวม register"
- ระบุ priority scheme ถ้ามีของบริษัท ("ใช้ P0/P1/P2 แทน High/Med/Low")
- ส่งตัวอย่าง TC เก่าให้ Claude ดูเพื่อให้ style ตรงทีม

---

### 2. test-matrix-generator

**ใช้เมื่อ:** เขียน full test case ไม่ทัน ต้องการ coverage ก่อน — ได้ CSV ไป paste ใน Excel/Sheets/Jira ทันที

**ตัวอย่างคำสั่ง:**
```
ช่วยทำ coverage matrix จาก docs/login-requirement.md
จะได้เช็คว่า scenario ที่วางไว้ครอบคลุม req ครบมั้ย
```
```
ขอ pairwise matrix สำหรับ form สมัครสมาชิก:
- Age: under-18, 18-60, over-60
- Country: TH, US, JP
- Plan: free, pro, enterprise
```
```
ทำ platform matrix ของ feature login + checkout
browser: Chrome, Safari, Firefox / OS: Win, macOS, iOS, Android
```

**3 matrix ที่ generate ได้:**
- **Coverage** — Requirement × Scenario (หา gap)
- **Combination** — Pairwise inputs (ลด combination ระเบิด)
- **Platform** — Feature × Browser/OS/Device (cross-platform)

**Tip:**
- ใช้เสริมกับ `test-case-writer` — ได้ matrix ก่อน, ค่อยขยายเป็น TC เต็มทีหลัง
- ประหยัด token มาก: output เป็น CSV ตารางเดียว ไม่มี steps/expected ยาวๆ
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
```
Write a bug report in English for: login button unresponsive
on iOS 17 Safari when keyboard is open. Steps: open /login,
focus password field, tap Login. Expected: navigate to /home.
Actual: nothing happens.
```

**สิ่งที่ Claude จะทำ:**
1. เช็คว่าข้อมูลครบมั้ย (env, steps, expected, actual, severity) — ถ้าขาดจะถาม
2. แต่ง title ตาม pattern `[Module] Action ทำให้เกิด Symptom เมื่อ Condition`
3. แยก Severity (impact) vs Priority (urgency)
4. เขียนตาม template พร้อม checklist `[REDACTED]` ข้อมูล sensitive

**Tip:**
- แนบ screenshot/log path → Claude จะใส่ใน section Attachments ให้
- ถ้าจะ paste ลง Jira/Linear โดยตรง บอก "format สำหรับ Jira" → จะปรับ markdown ให้เข้ากัน

---

### 4. test-script-generator (Robot Framework)

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
```
convert TC-045 (checkout flow) เป็น Robot test + feature keyword
```

**สิ่งที่ Claude จะทำ:**
1. เช็คก่อนว่า page/locator/feature/translation key มีอยู่แล้วมั้ย (ไม่สร้างซ้ำ)
2. สร้างไฟล์ตาม 3-tier:
   - `resources/locators/<feature>_locator.robot` — locator UPPER_SNAKE_CASE + translation interpolation
   - `keywords/ui/page/<feature>_page.robot` — page object (interact + wait, no assertion)
   - `keywords/ui/feature/<feature>_keywords.robot` — business workflow (ถ้าจำเป็น)
   - `testcases/ui/<feature>/TC_<PREFIX>_SC_<NUM>.robot` — test case
3. เพิ่ม translation key ทั้ง `en/` และ `th/`
4. เพิ่ม test data ใน `testdata.yaml`
5. รัน `robocop --threshold W` ให้ผ่าน

**Tip:**
- ถ้าทำงานใน `athm_automation` โดยตรง → Claude จะอ่านไฟล์ใกล้เคียง (เช่น `login_page.robot`) เพื่อ match style เป๊ะ
- ถ้าใช้ใน repo อื่นที่ใช้ pattern เดียวกัน → อ้างอิง [`examples/`](skills/test-script-generator/examples/) แทน
- ห้าม hardcode UI text — ใช้ translation YAML เสมอ (ทีมนี้บังคับ bilingual)

---

### 5. test-script-generator-web (Playwright / Cypress / WDIO / Selenium-Java)

**ใช้เมื่อ:** สร้าง E2E web automation แบบเลือก framework ได้ — ใช้ pattern จาก `automation-starter-kit-playwright`

**Framework ที่รองรับ:**
- **Playwright + TypeScript** (primary) — ดู `frameworks/playwright-ts.md` + `examples/playwright-ts/`
- **Cypress + TypeScript** — `frameworks/cypress-ts.md`
- **WebdriverIO + TypeScript** — `frameworks/webdriverio-ts.md`
- **Selenium + Java + TestNG** — `frameworks/selenium-java.md`

**กฎเหล็ก 4 ข้อ (ใช้กับทุก framework):**
1. **POM** — page class + base page; test ไม่รู้จัก locator
2. **Advanced XPath** — ไม่ใช้ index (`[1]`, `[last()]`); ใช้ `data-test-id`, ARIA role, `normalize-space()`, relationship (`ancestor::`, `following-sibling::`), scope (dialog, row, section)
3. **Unique / Shared Locators** — pattern ที่ใช้ข้ามหน้า (menu, dialog, button-by-label, row-by-cell) → centralize ใน `locators/common.locators.ts`
4. **Text-as-Constants** — UI text ทุกตัวเก็บใน `labels/*.labels.ts` ห้าม hardcode ใน XPath/test

**ตัวอย่างคำสั่ง:**
```
สร้าง Playwright test จาก testcases_login_20260420.md
feature: login, prefix: AUTH, TC_IDs: AUTH_SC_001_TC_001..003
```
```
เขียน page object + test สำหรับหน้า Employee Management
- framework: Playwright + TS
- elements: search box (data-test-id=emp-search), add button, table row
```
```
convert TC-045 (checkout flow) เป็น Cypress test + page object
```

**สิ่งที่ Claude จะทำ:**
1. เช็ค framework จาก config file (`playwright.config.ts` / `cypress.config.ts` / `wdio.conf.ts` / `pom.xml`) — ถ้าไม่ชัด ถาม user
2. เช็ค asset ที่มีอยู่ (page class, shared locator, label constant, test data key) — ห้ามสร้างซ้ำ
3. สร้าง/แก้ไฟล์ตาม order: `labels/` → `locators/` → `pages/` → `fixtures/` → `data/` → `tests/`
4. Verify compile (`tsc --noEmit` / `mvn compile`) + `playwright test --list`

**Tip:**
- ถ้าทำงานใน `automation-starter-kit-playwright` โดยตรง → Claude จะอ่าน page ใกล้เคียง (เช่น `login.page.ts`) เพื่อ match style เป๊ะ
- ถ้าใช้ใน repo อื่น → อ้างอิง [`examples/playwright-ts/`](skills/test-script-generator-web/examples/playwright-ts/)
- ถ้า user มี test-case output จาก `test-case-writer` → feed ให้ skill นี้ต่อเพื่อแปลงเป็น script

---

## Workflow แนะนำสำหรับทีม

```
1. PM ส่ง PRD     →  /test-matrix-generator     → coverage matrix (เช็ค scope + gap เร็วๆ)
                  →  /test-case-writer          → test cases (review ในทีม)
2. ทดสอบเจอ bug  →  /bug-report-writer          → paste ลง Jira
3. TC approved    →  /test-script-generator      → Robot Framework (ทีม athm_automation)
                  →  /test-script-generator-web  → Playwright/Cypress/WDIO/Selenium (ทีมอื่น)
```

**เวลาเขียน TC ไม่ทัน:** ใช้ `/test-matrix-generator` อย่างเดียวก่อน ได้ CSV coverage/pairwise/platform ส่ง review ในทีม — ค่อยขยายเป็น full TC ใน sprint ถัดไป

---

## โครงสร้าง Repo
```
qa_ai_skill/
├── README.md
├── skills/
│   ├── test-case-writer/
│   │   ├── SKILL.md              # คำสั่งหลัก
│   │   ├── templates/            # Template TH/EN
│   │   └── references/           # Testing techniques reference
│   ├── test-matrix-generator/
│   │   ├── SKILL.md              # 3 matrix types (Coverage/Combination/Platform)
│   │   └── templates/            # CSV templates
│   ├── bug-report-writer/
│   │   ├── SKILL.md
│   │   └── templates/
│   ├── test-script-generator/
│   │   ├── SKILL.md              # Robot Framework + POM (athm_automation pattern)
│   │   └── examples/             # Reference ไฟล์ตัวอย่าง (page/feature/test/locator/i18n/config)
│   └── test-script-generator-web/
│       ├── SKILL.md              # Multi-framework (Playwright/Cypress/WDIO/Selenium-Java) + 4 rules
│       ├── references/           # advanced-xpath, pom-locator-dedupe
│       ├── frameworks/           # pattern per framework (TS/Java)
│       └── examples/playwright-ts/  # Working reference (labels/locators/pages/tests)
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
