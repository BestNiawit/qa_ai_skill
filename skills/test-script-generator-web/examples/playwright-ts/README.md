# Playwright + TypeScript — Reference Example

ตัวอย่างโครงสร้าง Playwright + POM ตามกฎ 4 ข้อของ skill นี้ — ใช้เป็นต้นแบบเวลา generate test script

## โครงสร้าง
```
playwright-ts/
├── labels/                 ← ★ text-as-constants (grouped by feature)
│   ├── common.labels.ts
│   ├── login.labels.ts
│   ├── announcement.labels.ts
│   └── assessment-year.labels.ts
├── locators/               ← ★ shared XPath patterns (dedupe)
│   └── common.locators.ts
├── pages/                  ← Page Object Model
│   ├── base.page.ts
│   ├── login.page.ts
│   ├── home.page.ts
│   ├── assessment-year.page.ts
│   └── announcement.page.ts
├── fixtures/
│   └── base.fixture.ts     ← inject page objects
├── data/
│   └── testdata.ts         ← keyed by TC ID
└── tests/
    └── TC_SAV_SC_001.spec.ts
```

## สิ่งที่เห็นได้จาก example

### 1. POM — page ไม่มี assertion
ดู `pages/announcement.page.ts` — `save()` คลิก + `captureStep()` เท่านั้น
expectation อยู่ใน `tests/TC_SAV_SC_001.spec.ts`

### 2. Advanced XPath — no index
- `assessment-year.page.ts`: modal dropdown ใช้ `${activeDialog()}//*[@role='combobox'...]` แทน `[1]`
- `home.page.ts`: menu ใช้ `menuItem(label)` ที่ scope `//nav//a[...]` แทน `(//span[...])[last()]`
- ไม่มีเลข index หลัง predicate ใน pages/*

### 3. Shared locators — dedupe
- `menuItem()`, `buttonByLabel()`, `alertMessage()`, `activeDialog()` → ใช้ใน ≥2 page
- page-specific (เช่น `primeng-input-experienceYear`) → อยู่ใน page class

### 4. Text-as-constants
- ไม่มี `'บันทึก'`, `'เพิ่มรายการ'` hardcode — ทุกตัวมาจาก `labels/*`
- XPath ใช้ template literal `${LABELS.x}` interpolation

## วิธีเอาไปใช้ใน repo จริง

1. คัดลอก `labels/`, `locators/` เข้า project — ปรับ text ตาม UI จริง
2. คัดลอก `pages/base.page.ts` เป็น base
3. เขียน page ใหม่ตาม pattern ของ `login.page.ts` / `announcement.page.ts`
4. เพิ่ม page เข้า `fixtures/base.fixture.ts`
5. เขียน test ใน `tests/` — import จาก `fixtures/base.fixture` เท่านั้น

## Verify

```bash
npx tsc --noEmit
npx playwright test --list
```
