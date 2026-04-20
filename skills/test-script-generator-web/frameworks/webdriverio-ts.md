# Framework Pattern — WebdriverIO + TypeScript

> ใช้กฎ 4 ข้อเดียวกับ Playwright (POM + advanced XPath + unique/shared locators + text-as-const)

---

## Project Layout

```
<project>/
├── wdio.conf.ts
├── tsconfig.json
├── package.json
├── test/
│   ├── pageobjects/
│   │   ├── base.page.ts
│   │   ├── login.page.ts
│   │   └── <feature>.page.ts
│   └── specs/
│       └── <feature>/TC_<ID>.e2e.ts
├── labels/
│   ├── common.labels.ts
│   └── <feature>.labels.ts
├── locators/
│   └── common.locators.ts
└── data/
    └── testdata.ts
```

---

## Setup

```bash
npm init wdio@latest .
# เลือก: Mocha + TypeScript + chromedriver + allure (optional)
```

---

## Base Page

```ts
// test/pageobjects/base.page.ts
export abstract class BasePage {
  abstract get url(): string;

  async open() {
    await browser.url(this.url);
  }

  async captureStep(name: string) {
    // allure / custom reporter integration (optional)
  }
}
```

---

## Page class — pattern

```ts
// test/pageobjects/login.page.ts
import { BasePage } from './base.page';
import { buttonByLabel } from '../../locators/common.locators';
import { LABELS } from '../../labels/common.labels';

export class LoginPage extends BasePage {
  get url() { return '/login'; }

  get usernameInput()  { return $("//input[@data-test-id='input-username']"); }
  get passwordInput()  { return $("//input[@data-test-id='input-password']"); }
  get submitButton()   { return $(buttonByLabel(LABELS.loginSubmit)); }

  async login(username: string, password: string) {
    await this.open();
    await this.usernameInput.setValue(username);
    await this.passwordInput.setValue(password);
    await this.submitButton.click();
  }
}

export default new LoginPage();
```

**Rules (WDIO-specific):**
- getter return `$(...)` — resolve fresh ทุกครั้ง ไม่ cache (ลด stale element)
- export default instance (singleton) หรือ class + factory — consistent ทั้ง project
- ใช้ `.waitForDisplayed()` ก่อน `.click()` ถ้า element อาจ render ทีหลัง
- ห้าม `browser.pause(1000)` — ใช้ `waitForDisplayed`, `waitUntil`

---

## Test (spec) — pattern

```ts
// test/specs/login/TC_LOGIN_001.e2e.ts
import LoginPage from '../../pageobjects/login.page';
import HomePage from '../../pageobjects/home.page';
import { UI_TEST_DATA } from '../../../data/testdata';
import { LOGIN_LABELS } from '../../../labels/login.labels';

const data = UI_TEST_DATA.TC_LOGIN_001;

describe('TC_LOGIN_001 - User Login', () => {
  it('TC_01 - Login with valid credentials', async () => {
    await LoginPage.login(data.username, data.password);
    await expect(HomePage.welcomeMessage).toBeDisplayed();
  });
});
```

---

## wdio.conf.ts (เฉพาะส่วนสำคัญ)

```ts
export const config: WebdriverIO.Config = {
  specs: ['./test/specs/**/*.e2e.ts'],
  baseUrl: process.env.BASE_URL ?? 'https://dev.example.com',
  waitforTimeout: 15_000,
  connectionRetryCount: 2,
  services: ['chromedriver'],
  framework: 'mocha',
  reporters: ['spec', ['allure', { outputDir: 'allure-results' }]],
  mochaOpts: { ui: 'bdd', timeout: 60_000 },
  autoCompileOpts: {
    autoCompile: true,
    tsNodeOpts: { project: './tsconfig.json' },
  },
};
```

---

## Commands

```bash
npx wdio run ./wdio.conf.ts
npx wdio run ./wdio.conf.ts --spec test/specs/login/TC_LOGIN_001.e2e.ts
```

---

## Notes

- WDIO `$`/`$$` คล้าย jQuery — return fresh element ทุกครั้ง
- WDIO 8+ ใช้ async/await ตลอด — ห้าม mix sync/async
- Parallel: ใช้ `maxInstances` ใน config
- **กฎ 4 ข้อยังใช้ครบ** — locator เป็น XPath เหมือนเดิม, แค่ API call ต่าง
