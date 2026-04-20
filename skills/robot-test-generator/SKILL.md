---
name: robot-test-generator
description: สร้าง Robot Framework automation test + Page Object + Locator + translation ตาม pattern ของทีม athm_automation (3-tier POM, ui_keywords wrapper, translation YAML interpolation, robocop-clean). Trigger เมื่อ user ขอเขียน Robot Framework automation, e2e test, page object, locator, "convert test case to Robot", "generate Robot script", "เขียน robot test", "สร้าง page object robot".
---

# Test Script Generator (Robot Framework — athm_automation pattern)

## Framework ที่ใช้
- **Robot Framework 6.x** + **SeleniumLibrary 6.1.2**
- **RequestsLibrary** สำหรับ API test
- **robocop 3.2.1** (linter) + **robotidy 4.14.0** (formatter)
- **pabot 2.16.0** (parallel execution)
- Python 3.12

## Canonical Reference Repo
pattern ต้นทางอยู่ที่ `/Users/nirawit/Documents/GitHub/athm_automation`
**ก่อนเขียนโค้ดใหม่:** ถ้า user ทำงานใน repo นั้น ให้อ่านไฟล์ที่ใกล้เคียงที่สุด (เช่น generate `assessment_year_page.robot` → อ่าน `login_page.robot` ก่อน) เพื่อ match style ให้เป๊ะ

ถ้าไม่ได้อยู่ใน repo นั้น → ใช้ไฟล์ใน `examples/` ของ skill นี้เป็น reference

---

## สถาปัตยกรรม — 3-Tier POM

```
Test Case (.robot)
  └── calls → Feature Keyword (keywords/ui/feature/*.robot)
                └── calls → Page Keyword (keywords/ui/page/*.robot)
                              └── uses → Locator (resources/locators/*.robot)
                              └── calls → ui_keywords.* wrapper (keywords/ui/common/)
```

**กฎเหล็ก:**
- Test case **เรียก feature keyword** เป็นหลัก, page keyword เฉพาะตอนต้อง verify ตรงๆ
- Page keyword **ห้ามมี assertion** (เฉพาะ interact + wait)
- Locator **ห้าม inline** ใน test หรือ page — ต้องอยู่ใน `resources/locators/*.robot`
- UI string **ห้าม hardcode** — ใช้ translation YAML interpolation
- การคลิก/พิมพ์ **ห้ามเรียก SeleniumLibrary ตรง** — ใช้ `ui_keywords.*` wrapper ทุกครั้ง

---

## Folder Structure

```
athm_automation/
├── testcases/ui/<feature>/TC_<PREFIX>_SC_<NUM>.robot
├── keywords/ui/
│   ├── page/<feature>_page.robot          ← Page object (interact + wait)
│   ├── feature/<feature>_keywords.robot   ← Business workflows
│   └── common/
│       ├── ui_keywords.robot              ← Input/Click/Wait wrappers
│       └── browser_keywords.robot         ← Browser session mgmt
├── resources/
│   ├── imports.robot                      ← Central imports
│   ├── locators/<feature>_locator.robot   ← All locators
│   ├── testdata/ui/testdata.yaml          ← Keyed by TC ID
│   └── translations/{en,th}/translations.yaml
└── Library/config_loader.py               ← Env config loader
```

---

## ขั้นตอนเมื่อ user ขอ generate

### Step 1: ระบุ scope
ถาม user ถ้ายังไม่ชัด:
- Feature อะไร? (ใช้เป็นชื่อ folder + prefix)
- Test case IDs อะไรบ้าง? (เช่น `PMS_SAV_SC_001_TC_001`)
- มี test case เอกสารอยู่แล้วมั้ย (ไฟล์ .md / excel)?
- Locator ของ element ที่จะทดสอบ? (ถ้าไม่มี ต้องถาม user + แนะนำใช้ `data-test-id`)

### Step 2: เช็ค asset ที่มีอยู่
ก่อนสร้างไฟล์ใหม่ **ต้องเช็ค**:
- [ ] Page object มีอยู่แล้วมั้ย? ถ้ามี → reuse, **ห้ามสร้างซ้ำ**
- [ ] Locator file มีอยู่แล้วมั้ย? ถ้ามี → เพิ่มใน file เดิม
- [ ] Feature keyword มีอยู่แล้วมั้ย? ถ้ามี → reuse
- [ ] Translation key ที่ต้องใช้มีมั้ย? ถ้าไม่มี → เพิ่มทั้ง `en/` และ `th/`
- [ ] Test data key มีมั้ย? ถ้าไม่มี → เพิ่มใน `testdata.yaml`

### Step 3: สร้างไฟล์ตาม pattern
ดู `examples/` และทำตามนี้เป๊ะ:
1. **Locator file** (`resources/locators/<feature>_locator.robot`)
2. **Page keyword** (`keywords/ui/page/<feature>_page.robot`)
3. **Feature keyword** ถ้าจำเป็น (`keywords/ui/feature/<feature>_keywords.robot`)
4. **Translation YAML** (`resources/translations/en/translations.yaml` + `th/`)
5. **Test data YAML** (`resources/testdata/ui/testdata.yaml`)
6. **Test case** (`testcases/ui/<feature>/TC_<PREFIX>_SC_<NUM>.robot`)
7. **Update imports.robot** ถ้ามี resource ใหม่

### Step 4: Lint ก่อนส่ง
หลัง generate **เสมอ**:
```bash
robocop --reports return_status --threshold W testcases keywords resources
```
ถ้ามี warning ให้แก้ก่อนจบงาน (ยกเว้น rule ที่ team disable อยู่แล้ว)

---

## Locator Pattern

### Naming
`${<PAGE>_<ELEMENT>_<TYPE>_LOCATOR}` — UPPER_SNAKE_CASE เสมอ

ตัวอย่าง:
```robot
${LOGIN_USERNAME_INPUT_LOCATOR}     xpath=//input[@data-test-id='primeng-input-name']
${LOGIN_SUBMIT_BUTTON_LOCATOR}      xpath=//button[.//span[normalize-space()='${login_page['submit_label']}']]
${TABLE_HEADER_YEAR_LOCATOR}        xpath=//th[normalize-space()='${assessment_year_page['column_year']}']
```

### Locator ranking (จากดีไปแย่)
1. **XPath + data-test-id** — `xpath=//input[@data-test-id='...']` (preferred)
2. **XPath + role/aria** — `xpath=//input[@role='searchbox']`
3. **XPath + normalize-space() + translation** — สำหรับ label ที่เป็น i18n
4. **XPath + class contains** — `xpath=//div[contains(@class,'p-dialog')]`
5. ❌ ห้ามใช้ index ตายตัว (`[1]`, `[2]`) ยกเว้นไม่มีทางอื่น — ถ้าต้องใช้ ให้ใช้ `[last()]`

### Dynamic locator — `{{placeholder}}`
```robot
${MENU_LOCATOR}    xpath=(//span[normalize-space()='{{menu}}'])[last()]
```
ใช้ตอน keyword:
```robot
${LOCATOR}=    ui_keywords.Replace String    ${MENU_LOCATOR}    {{menu}}    ${menu}
ui_keywords.Click Element When Visible    ${LOCATOR}
```

### Translation interpolation
**ห้าม hardcode label** — ใช้ key จาก `translations.yaml`:
```robot
# ❌ ผิด
${LOGIN_BUTTON_LOCATOR}    xpath=//button[normalize-space()='Login']

# ✅ ถูก
${LOGIN_BUTTON_LOCATOR}    xpath=//button[normalize-space()='${login_page['submit_label']}']
```
พร้อมเพิ่ม:
```yaml
# translations/en/translations.yaml
login_page:
  submit_label: "Login"

# translations/th/translations.yaml
login_page:
  submit_label: "เข้าสู่ระบบ"
```

---

## Wait & Interaction — ใช้ `ui_keywords.*` เท่านั้น

| ใช้เมื่อ | Keyword |
|----------|---------|
| พิมพ์ข้อความ | `ui_keywords.Input Text When Ready    ${locator}    ${text}` |
| พิมพ์ password | `ui_keywords.Input Password When Ready    ${locator}    ${password}` |
| คลิกปุ่ม | `ui_keywords.Click Button When Element Is Visible    ${locator}` |
| คลิก element ทั่วไป (auto-scroll + JS fallback) | `ui_keywords.Click Element When Visible    ${locator}` |
| รอ element ปรากฏ | `ui_keywords.Wait Until Element Is Ready    ${locator}    ${timeout}=10s` |

**ห้าม:**
- ❌ `SeleniumLibrary.Click Button` / `SeleniumLibrary.Input Text` (ไม่มี wait)
- ❌ `BuiltIn.Sleep` (ยกเว้นในตัว wrapper ภายใน `ui_keywords`)

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
    <feature>_page.Navigate To <Target Page>
    <feature>_page.Verify <Target Page> Should Be Displayed
```

**Rules:**
- Import **เพียง `resources/imports.robot`** — ไม่ใช้ Library/Resource อื่นตรงๆ
- Test name: `<TEST_ID_UPPER> <Thai description>`
- Tags บังคับ:
  - `regression` (ทุก test ที่รันใน CI)
  - `<feature>` — feature tag
  - `test_id:<ID>` — reference กลับไปที่ TC ต้นทาง
  - `positive` หรือ `negative`
- Test data: `${TC_<ID>['key']}` — มาจาก `testdata.yaml`
- เรียก feature keyword เป็นหลัก — page keyword เฉพาะ verify

---

## Page Keyword Pattern

```robot
*** Settings ***
Documentation    <Feature> page keywords.

*** Keywords ***
Open <Feature> Page
    [Documentation]    <what this does>
    <logic>

Input <Field>
    [Documentation]    <what this does>
    [Arguments]    ${value}
    ui_keywords.Input Text When Ready    ${<FEATURE>_<FIELD>_INPUT_LOCATOR}    ${value}

Verify <Something> Should Be Displayed
    [Documentation]    <what this verifies>
    ui_keywords.Wait Until Element Is Ready    ${<FEATURE>_<SOMETHING>_LOCATOR}
```

**Rules:**
- ทุก keyword ต้องมี `[Documentation]` (robocop บังคับ)
- Action keyword: verb-first (`Input`, `Click`, `Enter`, `Submit`, `Select`)
- Verify keyword: `Verify <X> Should Be <state>` (เช่น `Verify Table Should Be Displayed`)
- ใช้ `ui_keywords.*` wrapper **เท่านั้น** — ห้าม raw SeleniumLibrary
- ห้ามใส่ assertion แบบ `Should Be Equal` / `Should Contain` ที่ซับซ้อน — ย้ายไปไว้ feature keyword ถ้าจำเป็น

---

## Feature Keyword Pattern

ใช้เมื่อมี workflow หลายขั้น reusable:

```robot
*** Settings ***
Documentation    <Feature> business workflows.

*** Keywords ***
User Opens AT Login And Fills Credentials
    [Documentation]    Navigate to login + fill credentials (without submit).
    [Arguments]    ${username}    ${password}
    login_page.Open Login Page
    login_page.Username Field Should Be Visible
    login_page.Fill AT Credentials    ${username}    ${password}
```

**หลัก:**
- ชื่อเหมือน user story (เริ่มด้วย `User ...`, `Admin ...`)
- Compose page keywords — **ไม่เรียก SeleniumLibrary หรือ locator ตรง**
- เหมาะกับ flow ที่ reuse บ่อย เช่น login, create data fixture

---

## Test Data Pattern

```yaml
# resources/testdata/ui/testdata.yaml
TC_SAV_SC_001:
  username: "superayodia"
  password: "[REDACTED_IN_REPO]"
  assessment_year_valid: "2027"
  assessment_year_text: "สวัสดี"
  success_popup_text: "บันทึกสำเร็จ"
```

**Rules:**
- Key หลัก = TC ID (เช่น `TC_SAV_SC_001`)
- Nested keys = snake_case
- ใช้ใน test: `${TC_SAV_SC_001['username']}`
- **ห้าม commit** password จริง — ใช้ placeholder + load จาก env var ถ้าต้องใช้จริง

---

## Robocop — ต้อง clean

Config อยู่ที่ `.robocop`:
```
--reports
return_status
--threshold
W
testcases
keywords
resources
```

**Disable เฉพาะจุด** เมื่อจำเป็น (ใส่ในหัวไฟล์):
```robot
# robocop: disable=line-too-long,empty-lines-between-sections
```
เหตุผลที่ยอมรับ: locator file มี xpath ยาว, ui_keywords มี retry logic ซับซ้อน

**ห้าม disable rule ใน test case / feature keyword** โดยไม่มีเหตุผลชัด

---

## Environment & CI

**เรียก test:**
```bash
robot -d testresult -v ENV:dev -v LANG:en ./testcases/ui
```
- `ENV`: `dev` / `ci` / `prod` / `at` (ดู `config/environments/*.yaml`)
- `LANG`: `en` / `th`

**CI (GitLab)** รัน 3 stages:
1. `lint_robot` — robocop
2. `regression_ui` — Pabot 3 processes, tag `regression`
3. `notify` — Discord

---

## Naming Conventions

| Entity | Pattern | ตัวอย่าง |
|--------|---------|----------|
| Test file | `TC_<PREFIX>_SC_<NUM>.robot` | `TC_SAV_SC_001.robot` |
| Page file | `<feature>_page.robot` | `login_page.robot` |
| Feature kw file | `<feature>_keywords.robot` | `authentication_keywords.robot` |
| Locator file | `<feature>_locator.robot` | `login_locator.robot` |
| Test case name | `<ID> <Thai desc>` | `PMS_SAV_SC_001_TC_001 ตรวจสอบ...` |
| Keyword name | Title Case verb-first | `Input Username`, `Verify Table Should Be Displayed` |
| Variable | `${UPPER_SNAKE_CASE}` | `${LOGIN_USERNAME_INPUT_LOCATOR}` |
| Test data key | camelCase หรือ snake_case | `assessment_year_valid` |
| Translation key | `nested.lowercase` | `login_page.submit_label` |

---

## Quality Checklist (ก่อนจบงาน)
- [ ] Locator อยู่ใน `resources/locators/<feature>_locator.robot` (ไม่ inline)
- [ ] UI string ใช้ translation YAML (ไม่ hardcode)
- [ ] Page keyword ใช้ `ui_keywords.*` wrapper ทุกตัว (ไม่มี raw SeleniumLibrary)
- [ ] Page keyword ไม่มี assertion ซับซ้อน (เฉพาะ wait)
- [ ] ทุก keyword มี `[Documentation]`
- [ ] Test case import `imports.robot` เท่านั้น
- [ ] Tags ครบ: `regression`, `<feature>`, `test_id:<ID>`, `positive/negative`
- [ ] Test data อยู่ใน `testdata.yaml` (ไม่ hardcode ใน test)
- [ ] `robocop --threshold W` ผ่านไม่มี warning/error
- [ ] ชื่อไฟล์/variable/keyword ตาม convention

---

## ข้อห้าม (สำคัญ)
- ❌ **ห้าม** เขียน locator ตรงใน test หรือ page keyword
- ❌ **ห้าม** hardcode UI text ภาษาใดภาษาหนึ่ง
- ❌ **ห้าม** เรียก SeleniumLibrary ตรงใน page keyword (ใช้ `ui_keywords.*`)
- ❌ **ห้าม** ใส่ assertion ใน page keyword (ย้ายไป feature keyword)
- ❌ **ห้าม** สร้าง page object ซ้ำ — เช็ค `keywords/ui/page/` ก่อน
- ❌ **ห้าม** ใช้ `Sleep` ใน test/page (เฉพาะภายใน `ui_keywords.*` เท่านั้น)
- ❌ **ห้าม** commit password/PII จริง — ใช้ placeholder

---

## ไฟล์อ้างอิง
- `examples/testcases/TC_EXAMPLE_SC_001.robot` — test case เต็ม
- `examples/keywords/page/example_page.robot` — page object
- `examples/keywords/feature/example_keywords.robot` — feature workflow
- `examples/keywords/common/ui_keywords.robot` — snippet จาก wrapper
- `examples/resources/locators/example_locator.robot` — locator file
- `examples/resources/imports.robot` — central imports
- `examples/resources/testdata/testdata.yaml` — test data
- `examples/resources/translations/{en,th}/translations.yaml` — i18n
- `examples/config/dev.yaml` — environment config
- `examples/.robocop` — linter config
