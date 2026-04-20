---
name: robot-test-generator
description: สร้าง Robot Framework automation test + Page Object + Locator + translation ตาม pattern ของทีม athm_automation (3-tier POM, ui_keywords wrapper, translation YAML interpolation, robocop-clean). Trigger เมื่อ user ขอเขียน Robot Framework automation, e2e test, page object, locator, "convert test case to Robot", "generate Robot script", "เขียน robot test", "สร้าง page object robot". Maps to SDP §5 (ทดสอบ SIT → Robot automation จาก TC.Automation=Yes).
---

# Robot Test Generator (athm_automation pattern)

## 1. Purpose — เป้าหมาย

สร้าง Robot Framework automation ตาม pattern ทีม athm_automation:
- **3-tier POM** — Test → Feature keyword → Page keyword → Locator
- **ui_keywords wrapper** — ห้ามเรียก SeleniumLibrary ตรง
- **Translation YAML** — UI text ใช้ i18n, ห้าม hardcode
- **robocop clean** — ทุก file ผ่าน `--threshold W`

**Framework:** Robot Framework 6.x + SeleniumLibrary 6.1.2 + RequestsLibrary + robocop 3.2.1 + robotidy 4.14.0 + pabot 2.16.0 + Python 3.12

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5 — ขยาย "ทดสอบ SIT" เป็น automation (TC.Automation=Yes)

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| Robot Framework (athm_automation pattern) | **`robot-test-generator`** (skill นี้) |
| Playwright/Cypress/WDIO/Selenium-Java | `e2e-test-generator` |
| Performance (k6) | `perf-test-generator` |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Feature name | ✅ | ใช้เป็นชื่อ folder + prefix |
| Test case IDs | ✅ | เช่น `PMS_SAV_SC_001_TC_001` |
| Test case doc | ✅ | path (จาก `test-case-writer` หรือ manual) |
| Locator ของ element | ⚠️ | ถ้าไม่มี → แนะนำใช้ `data-test-id` |
| `project-context.md` | ⚠️ | base URL, env, translation schema |

**Canonical Reference Repo:** `/Users/nirawit/Documents/GitHub/athm_automation`

Best practice: ถ้าอยู่ใน repo นั้น ให้อ่านไฟล์ใกล้เคียง (เช่น `login_page.robot` ก่อน generate `assessment_year_page.robot`)

---

## 4. Outputs — สิ่งที่ได้

**Folder Structure:**
```
athm_automation/
├── testcases/ui/<feature>/TC_<PREFIX>_SC_<NUM>.robot
├── keywords/ui/
│   ├── page/<feature>_page.robot          ← Page object
│   ├── feature/<feature>_keywords.robot   ← Business workflows
│   └── common/
│       ├── ui_keywords.robot              ← Input/Click/Wait wrappers
│       └── browser_keywords.robot
├── resources/
│   ├── imports.robot                      ← Central imports
│   ├── locators/<feature>_locator.robot
│   ├── testdata/ui/testdata.yaml
│   └── translations/{en,th}/translations.yaml
└── Library/config_loader.py
```

**Naming Conventions:**

| Entity | Pattern | ตัวอย่าง |
|--------|---------|----------|
| Test file | `TC_<PREFIX>_SC_<NUM>.robot` | `TC_SAV_SC_001.robot` |
| Page file | `<feature>_page.robot` | `login_page.robot` |
| Feature kw | `<feature>_keywords.robot` | `authentication_keywords.robot` |
| Locator file | `<feature>_locator.robot` | `login_locator.robot` |
| Variable | `${UPPER_SNAKE_CASE}` | `${LOGIN_USERNAME_INPUT_LOCATOR}` |
| Translation key | `nested.lowercase` | `login_page.submit_label` |

---

## 5. Process — ขั้นตอน

### Step 1: ระบุ scope
- Feature + prefix
- TC IDs
- Locator (ถ้ามี)

### Step 2: เช็ค asset
- [ ] Page object มีอยู่แล้ว? → reuse
- [ ] Locator file มีอยู่แล้ว? → append
- [ ] Feature keyword มีอยู่แล้ว? → reuse
- [ ] Translation key มีมั้ย? → ไม่มีต้องเพิ่มทั้ง `en/` + `th/`
- [ ] Test data key มีมั้ย? → ไม่มีต้องเพิ่มใน `testdata.yaml`

### Step 3: สร้างไฟล์ตาม order
1. **Locator file** — `resources/locators/<feature>_locator.robot`
2. **Page keyword** — `keywords/ui/page/<feature>_page.robot`
3. **Feature keyword** (ถ้าจำเป็น) — `keywords/ui/feature/<feature>_keywords.robot`
4. **Translation YAML** — `resources/translations/{en,th}/translations.yaml`
5. **Test data YAML** — `resources/testdata/ui/testdata.yaml`
6. **Test case** — `testcases/ui/<feature>/TC_<PREFIX>_SC_<NUM>.robot`
7. **Update imports.robot** ถ้ามี resource ใหม่

### Step 4: Lint
```bash
robocop --reports return_status --threshold W testcases keywords resources
```
ถ้ามี warning → แก้ก่อนจบงาน

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] Locator อยู่ใน `resources/locators/<feature>_locator.robot` (ไม่ inline)
- [ ] UI string ใช้ translation YAML (ไม่ hardcode)
- [ ] Page keyword ใช้ `ui_keywords.*` wrapper (ไม่มี raw SeleniumLibrary)
- [ ] Page keyword ไม่มี assertion ซับซ้อน (เฉพาะ wait)
- [ ] ทุก keyword มี `[Documentation]`
- [ ] Test case import `imports.robot` เท่านั้น
- [ ] Tags ครบ: `regression`, `<feature>`, `test_id:<ID>`, `positive/negative`
- [ ] Test data อยู่ใน `testdata.yaml` (ไม่ hardcode)
- [ ] `robocop --threshold W` ผ่านไม่มี warning
- [ ] ชื่อไฟล์/variable/keyword ตาม convention

### Red Flags (Reject)
- ❌ Locator hardcode ใน test/page
- ❌ UI text ใส่ตรงๆ ภาษาเดียว (ไม่ผ่าน i18n)
- ❌ เรียก SeleniumLibrary ตรง (ไม่ผ่าน ui_keywords wrapper)
- ❌ `Sleep` ใน test/page (ยกเว้นใน ui_keywords wrapper)

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจ **สร้าง page ซ้ำ** ถ้าไม่ check → Step 2 บังคับ
- ❌ AI อาจใช้ **raw Selenium** ถ้าไม่รู้จัก `ui_keywords` → ย้ำ rule นี้
- ❌ AI อาจ **hardcode UI text** → บังคับ i18n YAML ทุกครั้ง

**ข้อห้าม:**
- ❌ Assertion ใน page keyword (ย้ายไป feature keyword)
- ❌ `Sleep` ใน test/page
- ❌ commit password/PII จริง — ใช้ placeholder

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `test-case-writer` — TC.Automation=Yes/Candidate → feed เข้า skill นี้
- `test-case-reviewer` — TC approved → automate

**Downstream:**
- `bug-report-writer` — test fail → defect
- CI (GitLab) — Pabot parallel + Discord notify

**Workflow ตัวอย่าง:**
```
test-case-writer → [TC.Automation=Yes] → robot-test-generator → robocop → Pabot → Discord
```

---

## 3-Tier POM สรุป

```
Test Case (.robot)
  └── calls → Feature Keyword (keywords/ui/feature/*.robot)
                └── calls → Page Keyword (keywords/ui/page/*.robot)
                              └── uses → Locator (resources/locators/*.robot)
                              └── calls → ui_keywords.* wrapper
```

**กฎเหล็ก:**
- Test case เรียก feature keyword เป็นหลัก, page keyword เฉพาะ verify
- Page keyword ห้ามมี assertion (เฉพาะ interact + wait)
- Locator ห้าม inline ใน test หรือ page
- UI string ห้าม hardcode → translation YAML
- การคลิก/พิมพ์ห้ามเรียก SeleniumLibrary ตรง → `ui_keywords.*`

---

## Locator Pattern

### Naming
`${<PAGE>_<ELEMENT>_<TYPE>_LOCATOR}` — UPPER_SNAKE_CASE

```robot
${LOGIN_USERNAME_INPUT_LOCATOR}     xpath=//input[@data-test-id='primeng-input-name']
${LOGIN_SUBMIT_BUTTON_LOCATOR}      xpath=//button[.//span[normalize-space()='${login_page['submit_label']}']]
```

### Ranking (ดี → แย่)
1. XPath + `data-test-id` (preferred)
2. XPath + role/aria
3. XPath + `normalize-space()` + translation
4. XPath + `contains(@class, ...)`
5. ❌ Index ตายตัว (`[1]`, `[2]`) — ใช้ `[last()]` ถ้าจำเป็น

### Dynamic — `{{placeholder}}`
```robot
${MENU_LOCATOR}    xpath=(//span[normalize-space()='{{menu}}'])[last()]
```

### Translation interpolation
```robot
# ❌ ผิด
${LOGIN_BUTTON_LOCATOR}    xpath=//button[normalize-space()='Login']

# ✅ ถูก
${LOGIN_BUTTON_LOCATOR}    xpath=//button[normalize-space()='${login_page['submit_label']}']
```

`translations/en/translations.yaml`:
```yaml
login_page:
  submit_label: "Login"
```

---

## Wait & Interaction — ใช้ `ui_keywords.*`

| ใช้เมื่อ | Keyword |
|----------|---------|
| พิมพ์ข้อความ | `ui_keywords.Input Text When Ready    ${locator}    ${text}` |
| พิมพ์ password | `ui_keywords.Input Password When Ready    ${locator}    ${password}` |
| คลิกปุ่ม | `ui_keywords.Click Button When Element Is Visible    ${locator}` |
| คลิก element | `ui_keywords.Click Element When Visible    ${locator}` |
| รอ element | `ui_keywords.Wait Until Element Is Ready    ${locator}    ${timeout}=10s` |

**ห้าม:**
- ❌ `SeleniumLibrary.Click Button` / `SeleniumLibrary.Input Text`
- ❌ `BuiltIn.Sleep` (ยกเว้นใน wrapper)

---

## Test Case Pattern

```robot
*** Settings ***
Documentation       Test suite for <feature>.
Resource            ${CURDIR}/../../../resources/imports.robot
Test Setup          browser_keywords.Open Browser Session
Test Teardown       BuiltIn.Run Keywords
...                 browser_keywords.Capture Screenshot On Failure
...                 AND    browser_keywords.Close Browser Session

*** Test Cases ***
PMS_SAV_SC_001_TC_001 <Thai description>
    [Tags]    regression    <feature-tag>    test_id:PMS_SAV_SC_001_TC_001    positive
    [Documentation]    <Actor> <action> และผลลัพธ์ที่คาดหวัง
    authentication_keywords.User Opens AT Login And Fills Credentials
    ...    ${TC_SAV_SC_001['username']}
    ...    ${TC_SAV_SC_001['password']}
    login_page.Submit Login Form
    home_page.Verify Home Page Welcome Message Should Be Displayed
```

**Rules:**
- Import `imports.robot` เท่านั้น
- Test name: `<TEST_ID_UPPER> <Thai description>`
- Tags บังคับ: `regression`, `<feature>`, `test_id:<ID>`, `positive/negative`
- Test data: `${TC_<ID>['key']}` จาก `testdata.yaml`

---

## Test Data Pattern

```yaml
# resources/testdata/ui/testdata.yaml
TC_SAV_SC_001:
  username: "superayodia"
  password: "[REDACTED_IN_REPO]"
  assessment_year_valid: "2027"
  success_popup_text: "บันทึกสำเร็จ"
```

**Rules:**
- Key หลัก = TC ID
- Nested keys = snake_case
- **ห้าม commit** password จริง — placeholder + load จาก env var

---

## Environment & CI

```bash
robot -d testresult -v ENV:dev -v LANG:en ./testcases/ui
```

- `ENV`: `dev` / `ci` / `prod` / `at`
- `LANG`: `en` / `th`

**CI (GitLab) 3 stages:**
1. `lint_robot` — robocop
2. `regression_ui` — Pabot 3 processes, tag `regression`
3. `notify` — Discord

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- `examples/` — working examples (testcases, keywords, resources)
- External: athm_automation repo (canonical pattern)
