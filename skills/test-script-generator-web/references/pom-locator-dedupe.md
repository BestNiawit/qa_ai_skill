# Page Object Model + Locator Dedupe + Text-as-Constants

> 3 กฎที่ทำให้ code reuse ได้จริง + flaky น้อย + i18n-ready

---

## 1. Page Object Model — ตำแหน่งของ layer

```
┌─────────────────────────────────────────────┐
│  Test / Spec                                 │  ← assertion + scenario
│    - import { test, expect } from fixtures   │
│    - test('should login', async ({page}) =>  │
│        await loginPage.login(u, p)           │
│        await expect(...).toBeVisible()       │
└───────────────┬─────────────────────────────┘
                │ uses
┌───────────────▼─────────────────────────────┐
│  Page Object                                 │  ← action + state query
│    class LoginPage extends BasePage          │
│      readonly usernameInput: Locator         │
│      async login(u, p) { ... }               │
└────┬──────────────────┬─────────────────────┘
     │ uses             │ uses
┌────▼─────────┐   ┌────▼─────────┐
│  Locators    │   │  Labels      │  ← constants
│   common.    │   │   th.labels  │
│   +page-spec │   │   en.labels  │
└──────────────┘   └──────────────┘
```

### Rules

**Page class:**
- extends `BasePage` เสมอ (common utilities: waits, screenshots, navigation helpers)
- constructor รับ driver/page + declare locator field `readonly`
- method ชื่อ verb-first: `login()`, `searchByName()`, `openAddModal()`
- method ไม่ return assertion — return ค่า หรือ void
- state query method ขึ้นต้น `is`/`get`: `isErrorVisible()`, `getRowCount()`, `getCellText()`

**Base page:**
- shared utilities: `captureStep()`, `waitForLoading()`, `scrollIntoView()`
- ไม่มี locator specific กับ page ใด

**Test:**
- ไม่รู้จัก locator — รู้จักแค่ page object method
- assertion อยู่ที่นี่เท่านั้น
- test data มาจาก `data/`

---

## 2. Locator Dedupe — ทำยังไง

### A. ตัดสินใจว่า shared หรือ page-specific

**Page-specific** (อยู่ใน page class):
- element ที่มีเฉพาะใน page นั้น
  - login username input
  - announcement form textarea
  - assessment year dropdown

**Shared** (อยู่ใน `locators/common.locators.ts`):
- pattern ที่ใช้ซ้ำ ≥ 2 page
  - menu navigation
  - dialog/modal container
  - button by label
  - row by cell content
  - dropdown option
  - toast/alert message

### B. Shared locators file

```ts
// locators/common.locators.ts
import { LABELS } from '../labels/th.labels';

/**
 * Navigation menu item — ใช้ใน home, sidebar, breadcrumb
 */
export const menuItem = (label: string): string =>
  `//nav//a[.//span[normalize-space()='${label}']]`;

/**
 * Dialog/modal by title — ใช้ทุก page ที่มี confirm/add/edit modal
 */
export const dialogByTitle = (title: string): string =>
  `//*[@role='dialog' and .//*[self::h1 or self::h2 or self::h3][normalize-space()='${title}']]`;

export const dialog = (): string =>
  `//*[@role='dialog' and @aria-modal='true']`;

/**
 * Button by visible label (support wrap ใน span)
 */
export const buttonByLabel = (label: string): string =>
  `//button[normalize-space()='${label}'] | //button[.//*[normalize-space()='${label}']]`;

/**
 * Table row by cell content — ใช้ทุก listing page
 */
export const tableRowByCell = (cellText: string): string =>
  `//tbody//tr[.//td[normalize-space()='${cellText}']]`;

/**
 * Dropdown option by aria-label หรือ visible text
 */
export const dropdownOption = (label: string): string =>
  `//li[@role='option' and @aria-label='${label}'] | //*[@role='listbox']//*[normalize-space()='${label}']`;

/**
 * Toast / alert message (SweetAlert / PrimeNG toast / etc.)
 */
export const alertMessage = (text: string): string =>
  `//*[@role='alert' and contains(normalize-space(),'${text}')] | //div[contains(@class,'swal2-popup')]//*[normalize-space()='${text}']`;
```

### C. ใช้ใน page class

```ts
// pages/announcement.page.ts
import { buttonByLabel, dialog, alertMessage } from '../locators/common.locators';
import { LABELS } from '../labels/th.labels';
import { ANNOUNCEMENT_LABELS } from '../labels/announcement.labels';

export class AnnouncementPage extends BasePage {
  readonly saveButton: Locator;
  readonly saveSuccessPopup: Locator;
  readonly professionalExperiencesTextarea: Locator;

  constructor(page: Page, testInfo?: TestInfo) {
    super(page, testInfo);

    // shared pattern
    this.saveButton        = page.locator(buttonByLabel(LABELS.save));
    this.saveSuccessPopup  = page.locator(alertMessage(ANNOUNCEMENT_LABELS.saveSuccess));

    // page-specific
    this.professionalExperiencesTextarea = page.locator(
      `//textarea[@placeholder='${ANNOUNCEMENT_LABELS.professionalExperiencesPlaceholder}']`
    );
  }

  async save() {
    await this.saveButton.waitFor({ state: 'visible' });
    await this.saveButton.click();
    await this.captureStep('Save');
  }
}
```

### D. อย่าลืม: shared locator ต้องรับ text เป็น parameter

- ✅ `menuItem(label)` — receive text, caller pass constant
- ❌ `const menuSettingsLocator = "//nav//a[.//span[normalize-space()='ตั้งค่า']]"` — ฝัง text, กลับไปผิด rule text-as-const

---

## 3. Text-as-Constants

### A. โครงสร้าง label files

```
labels/
├── common.labels.ts          ← ปุ่ม/menu/label ที่ใช้ทั้งระบบ
├── th.labels.ts              ← รวม export (ถ้า single language)
├── en.labels.ts
├── login.labels.ts           ← feature-specific
├── announcement.labels.ts
├── assessment-year.labels.ts
└── job-position.labels.ts
```

### B. Example — common labels

```ts
// labels/common.labels.ts
export const LABELS = {
  // Generic actions
  save: 'บันทึก',
  cancel: 'ยกเลิก',
  confirm: 'ยืนยัน',
  delete: 'ลบ',
  edit: 'แก้ไข',
  add: 'เพิ่ม',
  addItem: 'เพิ่มรายการ',
  search: 'ค้นหา',
  next: 'ถัดไป',
  previous: 'ย้อนกลับ',
  submit: 'ส่ง',

  // Navigation
  settings: 'ตั้งค่า',

  // Common messages
  loginSubmit: 'เข้าสู่ระบบ',
} as const;

export type LabelKey = keyof typeof LABELS;
```

### C. Example — page-specific labels

```ts
// labels/announcement.labels.ts
export const ANNOUNCEMENT_LABELS = {
  // Form title
  createHeader: 'เพิ่มประกาศ',

  // Field placeholders
  professionalExperiencesPlaceholder: 'กรอกรายละเอียดประสบการณ์ทำงาน',
  languageDescriptionPlaceholder: 'คุณสมบัติภาษา',

  // Success/error
  saveSuccess: 'บันทึกข้อมูลสำเร็จ',
  saveFailed: 'บันทึกไม่สำเร็จ',
} as const;
```

### D. Example — bilingual setup (ถ้ารองรับ)

```ts
// labels/index.ts
import { TH_LABELS } from './th.labels';
import { EN_LABELS } from './en.labels';

const LANG = process.env.LANG ?? 'th';
export const LABELS = LANG === 'en' ? EN_LABELS : TH_LABELS;
```

**Rules:**
- `as const` เสมอ → type-safe key
- กลุ่มตาม feature — ไม่ใช่ flat dict ใหญ่
- test assertion text → เก็บด้วย (เช่น `saveSuccess: 'บันทึกสำเร็จ'`)
- regex / placeholder / error → constant
- URL / path → แยกไฟล์ `routes.ts` ไม่ใช่ labels

---

## 4. Test Data — แยกจาก Labels

```ts
// data/ui/testdata.ts
export const UI_TEST_DATA = {
  TC_LOGIN_001: {
    username: 'superayodia',
    password: process.env.TEST_PASSWORD ?? '[REDACTED]',
  },
  TC_ANNOUNCEMENT_001: {
    username: 'superayodia',
    password: process.env.TEST_PASSWORD ?? '[REDACTED]',
    professionalExperiences: 'Experienced in cross-functional teams...',
    yearsOfExperience: '5',
    languageDescription: 'พูด อ่าน เขียน ภาษาอังกฤษได้ดี',
  },
} as const;
```

- key หลัก = TC ID
- **ห้ามใส่ password จริง** ใน repo — ใช้ env var
- ข้อมูลที่ใช้ test (email, phone, address) — random หรือ fixture ดีกว่า hardcode
- label (ปุ่ม, ข้อความ) → ไปที่ `labels/` ไม่ใช่ test data

---

## 5. Anti-patterns (ต้องหลีกเลี่ยง)

### ❌ Locator ซ้ำข้าม page
```ts
// pages/home.page.ts
this.menu = page.locator(`(//span[normalize-space()='${name}'])[last()]`);

// pages/job-position.page.ts
this.menu = page.locator(`(//span[normalize-space()='${name}'])[last()]`);
```
→ centralize เข้า `locators/common.locators.ts` + อย่าใช้ `[last()]`

### ❌ Text ฝังใน XPath
```ts
this.saveButton = page.locator("//button[normalize-space()='บันทึก']");
```
→ `buttonByLabel(LABELS.save)`

### ❌ Page-specific function ใน shared file
```ts
// locators/common.locators.ts
export const professionalExperiencesTextarea = ...   // ผิด — ใช้เฉพาะ announcement page
```
→ ย้ายไป `pages/announcement.page.ts` readonly field

### ❌ Assertion ใน page method
```ts
async save() {
  await this.saveButton.click();
  await expect(this.successPopup).toBeVisible();   // ← assertion ใน page = test รู้ action สำเร็จยังไงยาก
}
```
→ แยก:
```ts
async save() { await this.saveButton.click(); }
async isSaveSuccess(): Promise<boolean> { return this.successPopup.isVisible(); }
// test:
await page.save();
await expect(page.successPopup).toBeVisible();
```

### ❌ Factory method ที่ไม่ใช่ factory
```ts
getSaveButton() { return this.saveButton; }   // ← just expose field แทน
```
→ ใช้ factory เฉพาะตอนรับ parameter: `getRowByName(name)` ถูก

### ❌ Index ที่ซ่อนใน Playwright/Selenium code
```ts
await page.locator("//button[@aria-label='edit']").nth(2).click();   // ❌
await driver.findElements(...).get(1).click();                        // ❌
```
→ locator ต้องได้ 1 element จาก XPath ตั้งแต่แรก — ถ้าไม่ได้ แปลว่า scope ไม่พอ
