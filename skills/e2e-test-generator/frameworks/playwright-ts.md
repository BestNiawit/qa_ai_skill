# Framework Pattern — Playwright + TypeScript (Primary)

Reference repo: `/Users/nirawit/Documents/GitHub/automation-starter-kit-playwright`
Working example: [`../examples/playwright-ts/`](../examples/playwright-ts/)

---

## Project Layout

```
<project>/
├── playwright.config.ts
├── package.json
├── tsconfig.json
├── .env                          ← TEST_PASSWORD, ENV, LANG
├── config/
│   └── environments.ts           ← env → baseUrl + timeout
├── labels/                       ← ★ text-as-constants
│   ├── common.labels.ts
│   ├── <feature>.labels.ts
│   └── index.ts                  ← bilingual switch (optional)
├── locators/                     ← ★ shared locator patterns
│   └── common.locators.ts
├── pages/                        ← Page Object Model
│   ├── base.page.ts
│   ├── login.page.ts
│   └── <feature>.page.ts
├── fixtures/
│   └── base.fixture.ts           ← inject all page objects
├── data/
│   ├── ui/testdata.ts
│   └── api/testdata.ts
├── tests/
│   ├── ui/<feature>/TC_<ID>.spec.ts
│   └── api/TC_<ID>.spec.ts
└── reporters/                    ← custom reporter (optional)
```

---

## Naming

| Entity | Pattern | Example |
|--------|---------|---------|
| Page class file | `<feature>.page.ts` | `announcement.page.ts` |
| Page class name | `<Feature>Page` | `AnnouncementPage` |
| Test file | `TC_<ID>.spec.ts` | `TC_SAV_SC_001.spec.ts` |
| Shared locator | lowerCamelCase fn | `buttonByLabel(label)` |
| Label constant | UPPER_CASE or grouped `as const` | `LABELS.save`, `ANNOUNCEMENT_LABELS.createHeader` |
| Test data key | `TC_<ID>` | `UI_TEST_DATA.TC_SAV_SC_001` |
| Fixture field | lowerCamelCase | `loginPage`, `announcementPage` |

---

## Page class — pattern

```ts
import { type Page, type TestInfo, type Locator } from '@playwright/test';
import { BasePage } from './base.page';
import { buttonByLabel, alertMessage } from '../locators/common.locators';
import { LABELS } from '../labels/common.labels';
import { ANNOUNCEMENT_LABELS } from '../labels/announcement.labels';

export class AnnouncementPage extends BasePage {
  // Shared-pattern locators (use shared fn from locators/common.locators.ts)
  readonly saveButton: Locator;
  readonly saveSuccessPopup: Locator;

  // Page-specific locators
  readonly createHeader: Locator;
  readonly professionalExperiencesTextarea: Locator;

  constructor(page: Page, testInfo?: TestInfo) {
    super(page, testInfo);

    this.saveButton       = page.locator(buttonByLabel(LABELS.save));
    this.saveSuccessPopup = page.locator(alertMessage(ANNOUNCEMENT_LABELS.saveSuccess));

    this.createHeader = page.locator(
      `//*[@role='heading' and normalize-space()='${ANNOUNCEMENT_LABELS.createHeader}']`
    );
    this.professionalExperiencesTextarea = page.locator(
      `//textarea[@placeholder='${ANNOUNCEMENT_LABELS.professionalExperiencesPlaceholder}']`
    );
  }

  // Dynamic / factory locator — method, ไม่ใช่ field
  getEmployeeTypeCheckbox(employeeType: string): Locator {
    return this.page.locator(
      `//label[@role='checkbox' and normalize-space()='${employeeType}']`
    );
  }

  // Action (no assertion)
  async waitForFormLoaded() {
    await this.createHeader.waitFor({ state: 'visible' });
    await this.captureStep('Announcement Form Loaded');
  }

  async fillProfessionalExperiences(text: string) {
    await this.professionalExperiencesTextarea.fill(text);
    await this.captureStep('Fill Professional Experiences');
  }

  async save() {
    await this.saveButton.waitFor({ state: 'visible' });
    await this.saveButton.click();
    await this.captureStep('Save');
  }

  // State query (optional — ถ้า test ต้อง check บ่อย)
  async isSaveSuccess(): Promise<boolean> {
    return this.saveSuccessPopup.isVisible();
  }
}
```

**Rules (Playwright-specific):**
- ใช้ `page.locator(xpath)` — ไม่ใช้ `$`, `$$`, `page.$()`
- Dynamic locator → method return `Locator`, ไม่ใช่ string
- ห้ามใช้ `.nth(n)`, `.first()`, `.last()` ถ้า locator ควร unique แล้ว
  - ถ้าจำเป็นต้องใช้ `.first()` (เช่น autocomplete) → comment เหตุผลใน code
- `waitFor({ state: 'visible' })` ก่อน click ถ้า element อาจ render ทีหลัง
- `actionTimeout` ใน `playwright.config.ts` เป็น guard rail — อย่าลดใน test
- `screenshot: 'only-on-failure'` + `video: 'retain-on-failure'` ใน config

---

## Test (spec) — pattern

```ts
/**
 * TC_SAV_SC_001 - Assessment Year Settings (PMS)
 */
import { test, expect } from '../../../fixtures/base.fixture';
import { UI_TEST_DATA } from '../../../data/ui/testdata';
import { ANNOUNCEMENT_LABELS } from '../../../labels/announcement.labels';

const data = UI_TEST_DATA.TC_ANNOUNCEMENT_001;

test.describe('TC_ANNOUNCEMENT_001 - Create announcement', () => {
  test.beforeEach(async ({ loginPage, homePage }) => {
    await loginPage.login(data.username, data.password);
    await homePage.waitForHomePage();
  });

  test('TC_01 - Save announcement with all required fields', async ({
    jobPositionPage, announcementPage,
  }) => {
    await jobPositionPage.navigateToJobPositionMenu();
    await jobPositionPage.clickCreateAnnouncementIcon(data.company);

    await announcementPage.waitForFormLoaded();
    await announcementPage.fillProfessionalExperiences(data.professionalExperiences);
    await announcementPage.fillYearOfExperience(data.yearsOfExperience);
    await announcementPage.save();

    await expect(announcementPage.saveSuccessPopup).toBeVisible();
    await expect(announcementPage.saveSuccessPopup)
      .toContainText(ANNOUNCEMENT_LABELS.saveSuccess);
  });
});
```

**Rules:**
- import เฉพาะ `test, expect` จาก `fixtures/base.fixture` — ไม่ใช่ `@playwright/test` ตรง
- test data key = TC ID
- assertion อยู่ที่ test เท่านั้น
- เรียก page method — ไม่อ่าน locator ใน test

---

## Fixture — pattern

```ts
// fixtures/base.fixture.ts
import { test as base } from '@playwright/test';
import { LoginPage } from '../pages/login.page';
import { HomePage } from '../pages/home.page';
import { AnnouncementPage } from '../pages/announcement.page';
// ... import page อื่นๆ

type PageObjects = {
  loginPage: LoginPage;
  homePage: HomePage;
  announcementPage: AnnouncementPage;
};

export const test = base.extend<PageObjects>({
  loginPage: async ({ page }, use, testInfo) => {
    await use(new LoginPage(page, testInfo));
  },
  homePage: async ({ page }, use, testInfo) => {
    await use(new HomePage(page, testInfo));
  },
  announcementPage: async ({ page }, use, testInfo) => {
    await use(new AnnouncementPage(page, testInfo));
  },
});

export { expect } from '@playwright/test';
```

- ทุก page object inject ผ่าน fixture — test เรียกผ่าน destructure
- `testInfo` ส่งเข้า constructor เพื่อ `captureStep()` ทำ PDF report / screenshot

---

## playwright.config.ts

```ts
import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';
dotenv.config();

const ENV = process.env.ENV || 'dev';
const envConfig: Record<string, { baseURL: string }> = {
  dev:  { baseURL: 'https://dev.example.com' },
  at:   { baseURL: 'https://dev.example.com' },
  prod: { baseURL: 'https://prod.example.com' },
};

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: process.env.CI ? 2 : 1,
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
  ],
  use: {
    baseURL: envConfig[ENV]?.baseURL ?? envConfig.dev.baseURL,
    headless: process.env.HEADLESS !== 'false',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
    actionTimeout: 20_000,
    navigationTimeout: 30_000,
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
});
```

---

## Commands

```bash
# Install
npm i -D @playwright/test @types/node dotenv typescript
npx playwright install chromium

# Run
npx playwright test                      # all
npx playwright test tests/ui             # UI only
ENV=at npx playwright test --headed      # AT env + headed
npx playwright test --grep TC_001        # single TC

# Debug
npx playwright test --debug
npx playwright codegen https://app.example.com   # record new flow

# Report
npx playwright show-report
```

---

## เมื่อ user ขอ generate Playwright script

1. **อ่าน reference repo** (ถ้า user อยู่ใน `automation-starter-kit-playwright`)
   - อ่าน `pages/base.page.ts` — เช็ค base utilities
   - อ่าน page ใกล้เคียงที่สุด — match style
   - อ่าน `fixtures/base.fixture.ts` — เพิ่ม page ใหม่
   - อ่าน `data/ui/testdata.ts` — เพิ่ม TC key

2. **เช็คก่อนสร้าง**:
   - [ ] page class มีอยู่แล้ว? → extend/add method
   - [ ] shared locator pattern มีอยู่แล้ว? → reuse
   - [ ] label constant มีอยู่แล้ว? → reuse
   - [ ] test data key มีอยู่แล้ว? → append

3. **สร้าง/แก้ไฟล์ตาม order**:
   1. `labels/<feature>.labels.ts` (ถ้ายังไม่มี)
   2. `locators/common.locators.ts` (เพิ่ม fn ใหม่ถ้ามี pattern ที่ใช้ซ้ำ)
   3. `pages/<feature>.page.ts`
   4. `fixtures/base.fixture.ts` (register page ใหม่)
   5. `data/ui/testdata.ts` (เพิ่ม TC key)
   6. `tests/ui/<feature>/TC_<ID>.spec.ts`

4. **Verify**:
   ```bash
   npx tsc --noEmit
   npx playwright test tests/ui/<feature> --list
   ```

---

## Checklist ก่อนส่ง

- [ ] Locator ทุกตัวผ่าน advanced XPath (no index, no hardcoded text)
- [ ] Shared pattern ย้ายเข้า `locators/common.locators.ts`
- [ ] Text literal ย้ายเข้า `labels/*.labels.ts`
- [ ] Page method ไม่มี `expect`
- [ ] Test import จาก `fixtures/base.fixture` เท่านั้น
- [ ] Test data อยู่ใน `data/ui/testdata.ts`
- [ ] `npx tsc --noEmit` ผ่าน
- [ ] `npx playwright test --list` เห็น test ใหม่
