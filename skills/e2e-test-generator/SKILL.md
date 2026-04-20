---
name: e2e-test-generator
description: สร้าง E2E web automation test ตาม Page Object Model + advanced XPath (ไม่ใช้ index) + unique/shared locators + text-as-constants — เลือก framework ได้ (Playwright+TS, Cypress+TS, WebdriverIO+TS, Selenium+Java). Trigger เมื่อ user ขอเขียน E2E/web automation, Playwright test, Cypress test, WebdriverIO test, Selenium test, page object, "convert test case to Playwright/Cypress/WDIO/Selenium", "generate web automation", "เขียน playwright test", "สร้าง page object playwright", "e2e automation".
---

# Test Script Generator (Web E2E — Multi-Framework)

สร้าง E2E web automation script ตาม 4 กฎเหล็กที่ใช้กับทุก framework:

1. **Page Object Model** — Page class + Base page + test คุย page ไม่คุย DOM
2. **Advanced XPath** — ไม่ใช้ index (`[1]`, `[2]`, `[last()]`) ยกเว้นจำเป็นจริงๆ พร้อมเหตุผล
3. **Unique / Shared Locators** — locator ต้อง resolve 1 element; pattern ที่ใช้ซ้ำข้าม page ต้อง centralize
4. **Text-as-Constants** — UI string ทุกตัวเก็บเป็น constant/i18n ห้าม hardcode ใน XPath หรือ test

---

## Framework ที่รองรับ

| Framework | Language | สถานะ | Reference |
|-----------|----------|-------|-----------|
| **Playwright** | TypeScript | ✅ Primary (flagship) | [`frameworks/playwright-ts.md`](frameworks/playwright-ts.md) + [`examples/playwright-ts/`](examples/playwright-ts/) |
| **Cypress** | TypeScript | ✅ Pattern defined | [`frameworks/cypress-ts.md`](frameworks/cypress-ts.md) |
| **WebdriverIO** | TypeScript | ✅ Pattern defined | [`frameworks/webdriverio-ts.md`](frameworks/webdriverio-ts.md) |
| **Selenium** | Java + TestNG | ✅ Pattern defined | [`frameworks/selenium-java.md`](frameworks/selenium-java.md) |

> ต้องการ Robot Framework? → ใช้ skill [`robot-test-generator`](../robot-test-generator/) (3-tier POM, ui_keywords, i18n YAML)
>
> ต้องการ performance test (k6)? → ใช้ skill [`perf-test-generator`](../perf-test-generator/) (smoke/load/stress, RPS/VUs models, per-endpoint thresholds)

---

## Canonical Reference Repo (Playwright)

pattern ต้นทางอยู่ที่ `/Users/nirawit/Documents/GitHub/automation-starter-kit-playwright`

**ก่อนเขียนโค้ดใหม่:** ถ้า user ทำงานใน repo Playwright นั้น อ่านไฟล์ที่ใกล้เคียงที่สุดก่อน (เช่น generate `employee.page.ts` → อ่าน `login.page.ts` + `job-position.page.ts` ก่อน) เพื่อ match style ให้เป๊ะ

ถ้าไม่ได้อยู่ใน repo นั้น → ใช้ไฟล์ใน [`examples/playwright-ts/`](examples/playwright-ts/) ของ skill นี้เป็น reference

---

## ขั้นตอนเมื่อ user ขอ generate

### Step 1: ระบุ framework + scope

ถาม user ถ้ายังไม่ชัด:
- **Framework อะไร?** (Playwright / Cypress / WebdriverIO / Selenium+Java)
  - ถ้า user อยู่ใน repo ที่มี `playwright.config.ts` → default = Playwright
  - ถ้ามี `cypress.config.ts` → default = Cypress
  - ถ้ามี `wdio.conf.ts` → default = WebdriverIO
  - ถ้ามี `pom.xml` + `testng.xml` → default = Selenium Java
- Feature / module ที่ทดสอบ?
- Test case IDs?
- มี test case doc อยู่แล้วมั้ย (ไฟล์ .md / excel / output จาก `test-case-writer`)?
- Locator ของ element (ถ้าไม่มี → แนะนำใช้ `data-test-id` / ARIA role)

### Step 2: เช็ค asset ที่มีอยู่ (**ห้ามสร้างซ้ำ**)

- [ ] Page object มีอยู่แล้ว? → reuse/extend
- [ ] Shared locator pattern มีอยู่แล้ว? → เพิ่มใน file เดิม
- [ ] Label / constant ที่จะใช้มีอยู่แล้ว? → reuse
- [ ] Test data key มีอยู่แล้ว? → เพิ่มใน object เดิม

### Step 3: generate ตาม pattern ของ framework ที่เลือก

→ เปิด `frameworks/<framework>.md` อ่าน **layout + naming + imports + example** แล้วทำตาม

### Step 4: Verify ก่อนส่ง

- Playwright: `npx playwright test --list` (ไม่รัน แต่เช็ค compile)
- TypeScript projects: `npx tsc --noEmit`
- Cypress: `npx cypress verify`
- WebdriverIO: `npx wdio config --help` (เช็ค TS resolve)
- Selenium Java: `mvn compile`

---

## กฎเหล็ก 4 ข้อ — รายละเอียด

### 1. Page Object Model

```
Test (.spec / .test / .java)
  └── ใช้ → Page Object (one class per screen/page)
              ├── extends → BasePage (common utilities)
              ├── ใช้ → Locator constants (shared + page-specific)
              └── ใช้ → Label constants (i18n-ready)
```

**Rules:**
- **1 page class = 1 logical screen/dialog** — ไม่ผูกหลาย screen เข้าด้วยกัน
- Page class มีแค่ **action + state query** — ไม่มี `expect`/assertion ใน page method (verify ใน test, หรือเป็น keyword `verifyXxx` ชัดเจน)
- Constructor รับ driver/page + declare locator เป็น readonly field
- Dynamic locator → factory method `getXxxByName(name)` — ไม่ใช่ field
- Locator field ใช้ pattern + constant เท่านั้น — ห้ามฝัง string ยาวใน method

ดูเต็มๆ: [`references/pom-principles.md`](references/pom-principles.md)

---

### 2. Advanced XPath (ไม่ใช้ index)

**ทองคำ (preferred):**
```xpath
//input[@data-test-id='username']
//button[@aria-label='Save']
//*[@role='dialog']//button[normalize-space()=$LABEL_SAVE]
```

**ใช้ relationship แทน index:**
```xpath
//label[normalize-space()=$LABEL_EMAIL]/following::input[1]   ← ❌ ยังใช้ index
//label[normalize-space()=$LABEL_EMAIL]/following-sibling::input   ← ✅ sibling ตรง
//tr[.//td[normalize-space()=$company_name]]//button[@aria-label=$LABEL_EDIT]   ← ✅ row-scoped
//fieldset[.//legend[normalize-space()=$LABEL_ADDRESS]]//input[@name='zipcode']   ← ✅ section-scoped
```

**Anti-patterns (ห้าม):**
| ❌ ห้าม | ✅ ใช้แทน |
|---------|---------|
| `(//button)[3]` | `//button[@data-test-id='submit']` หรือ `//button[normalize-space()=$LABEL_SUBMIT]` |
| `//table/tbody/tr[1]/td[2]` | `//tr[.//td[normalize-space()=$row_key]]//td[@data-col='name']` |
| `//div[@class='dialog']//button[last()]` | `//div[@role='dialog']//button[@data-test-id='confirm']` |
| `//span[text()='Save']` (ตรงตัว, fail ถ้ามี whitespace) | `//span[normalize-space()=$LABEL_SAVE]` |

**Index ที่ยอมรับได้** (พร้อมเหตุผลใน comment):
- list ที่ต้องเลือก "รายการแรก" จริงๆ (เช่น autocomplete first suggestion) → ใช้ `.first()` ใน code ไม่ใช่ `[1]` ใน XPath
- ตารางที่ต้อง assert "มีอย่างน้อย 1 row" → count locator + `.first()` ใน assertion

ดูเต็มๆ: [`references/advanced-xpath.md`](references/advanced-xpath.md)

---

### 3. Unique / Shared Locators (ลด flakiness)

**หลัก:**
- locator **1 ตัว ต้อง resolve 1 element** บน state ปกติ — ถ้ามีหลายตัว แปลว่า selector ไม่ unique → แก้
- pattern ที่ใช้ซ้ำข้าม ≥2 page → **centralize เข้า `locators/common.locators.ts`** (หรือเทียบเท่าใน framework อื่น)
- page-specific pattern → อยู่ใน page class (readonly field / factory)

**ตัวอย่าง shared locator:**
```ts
// locators/common.locators.ts
import { LABELS } from '../labels/th.labels';

export const dialogByTitle = (title: string) =>
  `//div[@role='dialog' and .//*[self::h1 or self::h2 or self::h3][normalize-space()='${title}']]`;

export const menuItem = (label: string) =>
  `//nav//a[.//span[normalize-space()='${label}']]`;

export const buttonByLabel = (label: string) =>
  `//button[.//*[normalize-space()='${label}']] | //button[normalize-space()='${label}']`;

export const tableRowByCell = (cellText: string) =>
  `//tbody//tr[.//td[normalize-space()='${cellText}']]`;
```

**Rules:**
- shared locator function รับ text เป็น parameter — caller ต้องส่ง constant (จาก `labels/`) เข้ามา
- ห้าม duplicate XPath pattern ใน page 2 ไฟล์ขึ้นไป
- ทุก dynamic locator ต้องเป็น function/arrow function (ไม่ใช่ template string ที่ปนกันใน page class)

ดูเต็มๆ: [`references/pom-locator-dedupe.md`](references/pom-locator-dedupe.md)

---

### 4. Text-as-Constants

**ห้ามฝัง literal UI text** ใน XPath หรือ test — เก็บเป็น constant:

```ts
// ❌ ผิด
page.locator("//button[normalize-space()='บันทึก']")

// ✅ ถูก
// labels/th.labels.ts
export const LABELS = {
  save: 'บันทึก',
  cancel: 'ยกเลิก',
  submitLogin: 'เข้าสู่ระบบ',
  // ... group by feature or page
} as const;

// page
import { LABELS } from '../labels/th.labels';
this.saveButton = page.locator(`//button[normalize-space()='${LABELS.save}']`);
```

**Rules:**
- label file แยกตามภาษา: `labels/th.labels.ts`, `labels/en.labels.ts` (ถ้ารองรับ bilingual)
- group ตาม feature/page — ไม่ใช่ flat dict ใหญ่เดียว
- test assertion text (เช่น success popup message) → ก็เก็บเป็น constant เหมือนกัน
- error message / regex / placeholder text → constant

---

## Quality Checklist (ก่อนจบงาน)

- [ ] Page class extends BasePage + constructor รับ driver/page
- [ ] Locator ทุกตัวใช้ advanced XPath — ไม่มี `[1]`, `[2]`, `[last()]` ยกเว้น comment อธิบาย
- [ ] Shared locator pattern อยู่ใน `locators/common.locators.ts` (ไม่ duplicate)
- [ ] UI text ทุก string อยู่ใน `labels/*.ts` (ไม่ hardcode)
- [ ] Page method ไม่มี assertion ซับซ้อน (action + wait + state query)
- [ ] Test data อยู่ใน `data/` (ไม่ hardcode ใน test)
- [ ] Test compile ผ่าน (`tsc --noEmit` / `mvn compile`)
- [ ] ชื่อไฟล์/class/method ตาม convention ของ framework
- [ ] ไม่มี duplicate page object (เช็คก่อนสร้าง)

---

## ข้อห้าม (ทุก framework)

- ❌ Locator ใน test/spec file — ต้องอยู่ใน page object หรือ shared locators
- ❌ Hardcode UI text ใน locator string หรือ assertion
- ❌ ใช้ XPath index (`[n]`, `[last()]`) โดยไม่มี comment เหตุผล
- ❌ Duplicate XPath pattern ข้าม page
- ❌ Assertion ใน page method (ยกเว้น state query method ชื่อ `isXxxVisible()`)
- ❌ `sleep()` / `waitForTimeout()` — ใช้ explicit wait ของ framework
- ❌ Selector ที่พึ่ง CSS class ของ UI framework (เช่น `.ng-dirty.ng-touched`) ถ้ามีทางเลี่ยง — ใช้ `data-test-id` / `role` / `aria-*`

---

## ไฟล์อ้างอิง

- [`references/advanced-xpath.md`](references/advanced-xpath.md) — XPath patterns, anti-patterns, cheat sheet
- [`references/pom-locator-dedupe.md`](references/pom-locator-dedupe.md) — POM + dedupe + text-as-const rules
- [`frameworks/playwright-ts.md`](frameworks/playwright-ts.md) — Playwright + TS pattern (primary)
- [`frameworks/cypress-ts.md`](frameworks/cypress-ts.md) — Cypress + TS pattern
- [`frameworks/webdriverio-ts.md`](frameworks/webdriverio-ts.md) — WebdriverIO + TS pattern
- [`frameworks/selenium-java.md`](frameworks/selenium-java.md) — Selenium + Java + TestNG pattern
- [`examples/playwright-ts/`](examples/playwright-ts/) — Minimal working example (follows all 4 rules)
