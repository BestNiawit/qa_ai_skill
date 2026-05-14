---
name: e2e-test-generator
description: สร้าง E2E web automation test ตาม Page Object Model + advanced XPath (ไม่ใช้ index) + unique/shared locators + text-as-constants — เลือก framework ได้ (Playwright+TS, Cypress+TS, WebdriverIO+TS, Selenium+Java). Trigger เมื่อ user ขอเขียน E2E/web automation, Playwright test, Cypress test, WebdriverIO test, Selenium test, page object, "convert test case to Playwright/Cypress/WDIO/Selenium", "generate web automation", "เขียน playwright test", "สร้าง page object playwright", "e2e automation". Maps to SDP §5 (ทดสอบ SIT → Automation candidate จาก TC.Automation=Yes).
---

# E2E Test Generator (Web — Multi-Framework)

> **คำย่อ (E2E / TC / POM / SIT / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

สร้าง E2E web automation script ตาม **4 กฎเหล็ก** ที่ใช้กับทุก framework:

1. **Page Object Model** — Page class + Base page + test คุย page ไม่คุย DOM
2. **Advanced XPath** — ไม่ใช้ index (`[1]`, `[last()]`) ยกเว้นจำเป็น + มีเหตุผล
3. **Unique / Shared Locators** — locator resolve 1 element; pattern ที่ใช้ซ้ำ centralize
4. **Text-as-Constants** — UI text ทุกตัวเก็บเป็น constant/i18n ห้าม hardcode

**Framework รองรับ:**

| Framework | Language | สถานะ | Reference |
|-----------|----------|-------|-----------|
| **Playwright** | TypeScript | ✅ Primary | [`frameworks/playwright-ts.md`](frameworks/playwright-ts.md) + [`examples/playwright-ts/`](examples/playwright-ts/) |
| **Cypress** | TypeScript | ✅ | [`frameworks/cypress-ts.md`](frameworks/cypress-ts.md) |
| **WebdriverIO** | TypeScript | ✅ | [`frameworks/webdriverio-ts.md`](frameworks/webdriverio-ts.md) |
| **Selenium** | Java + TestNG | ✅ | [`frameworks/selenium-java.md`](frameworks/selenium-java.md) |

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5 — ขยาย "ทดสอบ SIT" เป็น automation (TC.Automation=Yes)

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| Modern web (Playwright/Cypress/WDIO/Selenium) | **`e2e-test-generator`** (skill นี้) |
| Robot Framework (athm_automation pattern) | `robot-test-generator` |
| Performance (k6) | `perf-test-generator` |
| ยังไม่มี TC ต้นฉบับ | `test-case-writer` ก่อน |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Framework | ✅ | Playwright / Cypress / WDIO / Selenium-Java |
| Feature / Module | ✅ | scope ของ test |
| Test case doc | ✅ | path (จาก `test-case-writer` หรือ manual) |
| Test case IDs | ✅ | เช่น `TC_LOGIN_001..005` |
| Locator ของ element | ⚠️ | ถ้าไม่มี → แนะนำใช้ `data-test-id` / ARIA |
| `project-context.md` | ⚠️ | base URL, env, labels, test data schema |

**Auto-detect framework** จาก config file:
- `playwright.config.ts` → Playwright
- `cypress.config.ts` → Cypress
- `wdio.conf.ts` → WebdriverIO
- `pom.xml` + `testng.xml` → Selenium-Java

---

## 4. Outputs — สิ่งที่ได้

**Format:** TypeScript / Java source files ตาม framework

**Canonical Reference Repo (Playwright):** `automation-starter-kit-playwright` — ดู `project-context.md` key `reference_repo` หรือถาม TL / previous maintainer สำหรับ URL/path

**โครงสร้างไฟล์ (Playwright ตัวอย่าง):**
```
pages/
  └── <feature>.page.ts          ← Page Object
locators/
  └── common.locators.ts          ← Shared locator patterns
labels/
  ├── th.labels.ts                ← i18n TH
  └── en.labels.ts
data/
  └── <feature>.data.ts           ← Test data
tests/
  └── <feature>.spec.ts           ← Test spec
```

---

## 5. Process — ขั้นตอน

### Step 1: ระบุ framework + scope
- Framework? (auto-detect ถ้าเจอ config)
- Feature / TC IDs
- Locator (ถ้ามี)

### Step 2: เช็ค asset ที่มีอยู่ (**ห้ามสร้างซ้ำ**)
- [ ] Page object มีอยู่แล้ว? → reuse/extend
- [ ] Shared locator pattern มีอยู่แล้ว? → เพิ่มใน file เดิม
- [ ] Label/constant มีอยู่แล้ว? → reuse
- [ ] Test data key มีอยู่แล้ว? → เพิ่มใน object เดิม

**Best practice:** อ่านไฟล์ที่ใกล้เคียงที่สุดก่อน (เช่น generate `employee.page.ts` → อ่าน `login.page.ts` + `job-position.page.ts` ก่อน) เพื่อ match style เป๊ะ

### Step 3: Generate ตาม pattern ของ framework
→ เปิด `frameworks/<framework>.md` อ่าน layout + naming + imports + example แล้วทำตาม

### Step 4: Verify
- Playwright: `npx playwright test --list` (compile check)
- TS projects: `npx tsc --noEmit`
- Cypress: `npx cypress verify`
- WebdriverIO: `npx wdio config --help`
- Selenium Java: `mvn compile`

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] Page class extends BasePage + constructor รับ driver/page
- [ ] Locator ทุกตัวใช้ advanced XPath — ไม่มี `[1]`, `[2]`, `[last()]` ยกเว้น comment
- [ ] Shared locator pattern อยู่ใน `locators/common.locators.ts` (ไม่ duplicate)
- [ ] UI text ทุก string อยู่ใน `labels/*.ts` (ไม่ hardcode)
- [ ] Page method ไม่มี assertion ซับซ้อน (action + wait + state query)
- [ ] Test data อยู่ใน `data/` (ไม่ hardcode ใน test)
- [ ] Test compile ผ่าน (`tsc --noEmit` / `mvn compile`)
- [ ] ชื่อไฟล์/class/method ตาม convention

### Red Flags (Reject)
- ❌ Locator ใน test/spec file — ต้องอยู่ใน page object
- ❌ Hardcode UI text ใน locator หรือ assertion
- ❌ XPath index `[n]` โดยไม่มี comment
- ❌ `sleep()` / `waitForTimeout()` — ใช้ explicit wait
- ❌ Duplicate XPath pattern ข้าม page

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจ **สร้าง locator มั่ว** ถ้าไม่มี HTML จริง → ถาม user ให้ paste HTML snippet หรือใช้ `data-test-id`
- ❌ AI อาจ **duplicate page object** ถ้าไม่ check ก่อน → Step 2 บังคับ check asset
- ❌ AI อาจใช้ **framework feature version เก่า** → ระบุ version ใน project-context

**ข้อห้าม:**
- ❌ Assertion ใน page method (ยกเว้น state query `isXxxVisible()`)
- ❌ Selector พึ่ง CSS class ของ UI framework (`.ng-dirty.ng-touched`) ถ้ามีทางเลี่ยง → ใช้ `data-test-id`/`role`/`aria-*`

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `test-case-writer` — TC.Automation=Yes/Candidate → feed เข้า skill นี้
- `test-case-reviewer` — TC approved → automate

**Downstream:**
- `bug-report-writer` — test fail → defect
- CI (GitLab/GitHub Actions) — run test + report

**Workflow ตัวอย่าง:**
```
test-case-writer → [TC.Automation=Yes] → e2e-test-generator → [CI run]
                                                                 └→ fail → bug-report-writer
```

---

## 4 กฎเหล็ก — รายละเอียด

### 1. Page Object Model
```
Test (.spec / .test / .java)
  └── ใช้ → Page Object (one class per screen)
              ├── extends → BasePage
              ├── ใช้ → Locator constants
              └── ใช้ → Label constants (i18n)
```

- **1 page = 1 screen** — ไม่ผูกหลาย screen
- Page มีแค่ **action + state query** — ไม่มี `expect` ใน page method
- Constructor รับ driver/page + declare locator เป็น readonly field
- Dynamic locator → factory method `getXxxByName(name)` ไม่ใช่ field

### 2. Advanced XPath (ไม่ใช้ index)

**ทองคำ:**
```xpath
//input[@data-test-id='username']
//button[@aria-label='Save']
//*[@role='dialog']//button[normalize-space()=$LABEL_SAVE]
```

**ใช้ relationship แทน index:**
```xpath
//label[normalize-space()=$LABEL_EMAIL]/following-sibling::input         ← ✅ sibling
//tr[.//td[normalize-space()=$row_key]]//button[@aria-label=$LABEL_EDIT]  ← ✅ row-scoped
//fieldset[.//legend[normalize-space()=$LABEL_ADDRESS]]//input[@name='zipcode']  ← ✅ section-scoped
```

**Anti-patterns:**
| ❌ ห้าม | ✅ ใช้แทน |
|---------|---------|
| `(//button)[3]` | `//button[@data-test-id='submit']` |
| `//tr[1]/td[2]` | `//tr[.//td[normalize-space()=$row_key]]//td[@data-col='name']` |
| `//span[text()='Save']` | `//span[normalize-space()=$LABEL_SAVE]` |

ดูเต็ม: [`references/advanced-xpath.md`](references/advanced-xpath.md)

### 3. Unique / Shared Locators
- locator 1 ตัว = resolve 1 element
- ใช้ซ้ำ ≥2 page → centralize `locators/common.locators.ts`

ตัวอย่าง:
```ts
export const dialogByTitle = (title: string) =>
  `//div[@role='dialog' and .//*[self::h1 or self::h2 or self::h3][normalize-space()='${title}']]`;

export const buttonByLabel = (label: string) =>
  `//button[.//*[normalize-space()='${label}']] | //button[normalize-space()='${label}']`;
```

ดูเต็ม: [`references/pom-locator-dedupe.md`](references/pom-locator-dedupe.md)

### 4. Text-as-Constants
```ts
// ❌ ผิด
page.locator("//button[normalize-space()='บันทึก']")

// ✅ ถูก
// labels/th.labels.ts
export const LABELS = { save: 'บันทึก', cancel: 'ยกเลิก' } as const;

// page
this.saveButton = page.locator(`//button[normalize-space()='${LABELS.save}']`);
```

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- [`references/advanced-xpath.md`](references/advanced-xpath.md)
- [`references/pom-locator-dedupe.md`](references/pom-locator-dedupe.md)
- [`frameworks/playwright-ts.md`](frameworks/playwright-ts.md) — Playwright pattern (primary)
- [`frameworks/cypress-ts.md`](frameworks/cypress-ts.md)
- [`frameworks/webdriverio-ts.md`](frameworks/webdriverio-ts.md)
- [`frameworks/selenium-java.md`](frameworks/selenium-java.md)
- [`examples/playwright-ts/`](examples/playwright-ts/) — Working example
