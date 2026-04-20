# Framework Pattern — Cypress + TypeScript

> ใช้กฎ 4 ข้อเดียวกับ Playwright (POM + advanced XPath + unique/shared locators + text-as-const)

---

## Project Layout

```
<project>/
├── cypress.config.ts
├── tsconfig.json
├── package.json
├── cypress/
│   ├── e2e/
│   │   └── <feature>/TC_<ID>.cy.ts
│   ├── support/
│   │   ├── commands.ts             ← custom cy.xpath, cy.login, etc.
│   │   └── e2e.ts
│   ├── fixtures/
│   │   └── <data>.json
│   └── pages/                      ← Page Object Model
│       ├── base.page.ts
│       ├── login.page.ts
│       └── <feature>.page.ts
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
npm i -D cypress @types/node typescript cypress-xpath
```

`cypress/support/e2e.ts`:
```ts
import 'cypress-xpath';
```

---

## Naming

| Entity | Pattern | Example |
|--------|---------|---------|
| Page class | `<Feature>Page` | `LoginPage` |
| Test file | `TC_<ID>.cy.ts` | `TC_LOGIN_001.cy.ts` |
| Custom command | `cy.<verb>` | `cy.loginAs(user)` |

---

## Page class — pattern

```ts
// cypress/pages/login.page.ts
import { buttonByLabel } from '../../locators/common.locators';
import { LABELS } from '../../labels/common.labels';
import { LOGIN_LABELS } from '../../labels/login.labels';

export class LoginPage {
  private readonly usernameInput  = "//input[@data-test-id='input-username']";
  private readonly passwordInput  = "//input[@data-test-id='input-password']";
  private readonly submitButton   = buttonByLabel(LABELS.loginSubmit);

  visit() {
    cy.visit('/login');
    return this;
  }

  fillUsername(username: string) {
    cy.xpath(this.usernameInput).clear().type(username);
    return this;
  }

  fillPassword(password: string) {
    cy.xpath(this.passwordInput).clear().type(password, { log: false });
    return this;
  }

  submit() {
    cy.xpath(this.submitButton).click();
    return this;
  }

  login(username: string, password: string) {
    return this.visit().fillUsername(username).fillPassword(password).submit();
  }
}
```

**Rules (Cypress-specific):**
- ใช้ `cy.xpath()` จาก `cypress-xpath` plugin
- method return `this` ให้ chainable (ไม่ใช่ Promise — Cypress auto-chain)
- ห้ามใช้ `cy.get(':nth-child(2)')` หรือ `cy.get('button').eq(0)` — ถ้า selector unique อยู่แล้วไม่ต้อง index
- ห้ามใช้ `cy.wait(1000)` — ใช้ `.should('be.visible')` หรือ `cy.intercept().then`
- passwords → `{ log: false }` กัน leak ใน video/screenshot

---

## Test — pattern

```ts
// cypress/e2e/login/TC_LOGIN_001.cy.ts
import { LoginPage } from '../../pages/login.page';
import { HomePage } from '../../pages/home.page';
import { UI_TEST_DATA } from '../../../data/testdata';
import { LOGIN_LABELS } from '../../../labels/login.labels';

const loginPage = new LoginPage();
const homePage = new HomePage();
const data = UI_TEST_DATA.TC_LOGIN_001;

describe('TC_LOGIN_001 - User Login', () => {
  it('TC_01 - Login with valid credentials', () => {
    loginPage.login(data.username, data.password);
    homePage.welcomeMessage().should('be.visible');
  });

  it('TC_02 - Reject invalid password', () => {
    loginPage.login(data.username, 'wrong-password');
    cy.xpath(`//*[@role='alert' and normalize-space()='${LOGIN_LABELS.invalidCredentials}']`)
      .should('be.visible');
  });
});
```

---

## Custom command (login via API shortcut)

```ts
// cypress/support/commands.ts
declare global {
  namespace Cypress {
    interface Chainable {
      loginAs(username: string, password: string): Chainable<void>;
    }
  }
}

Cypress.Commands.add('loginAs', (username: string, password: string) => {
  cy.request('POST', '/api/Identity/authenticate', {
    username, password, isInternal: false,
  }).then((resp) => {
    window.localStorage.setItem('token', resp.body.token);
  });
});
```

---

## cypress.config.ts

```ts
import { defineConfig } from 'cypress';

export default defineConfig({
  e2e: {
    baseUrl: process.env.BASE_URL ?? 'https://dev.example.com',
    supportFile: 'cypress/support/e2e.ts',
    specPattern: 'cypress/e2e/**/*.cy.ts',
    video: true,
    screenshotOnRunFailure: true,
    defaultCommandTimeout: 10_000,
    retries: { runMode: 1, openMode: 0 },
  },
});
```

---

## Commands

```bash
npx cypress open                      # UI
npx cypress run                       # headless
npx cypress run --spec "cypress/e2e/login/**"
```

---

## Notes

- Cypress มี limit เรื่อง **iframe** + **tab ใหม่** — ถ้า feature ต้องการ → แนะนำ Playwright
- `cy.xpath()` ใช้ได้แต่ Cypress **แนะนำ CSS selectors** — ถ้าเลี่ยง XPath ได้ให้ใช้ `data-test-id` + `cy.get('[data-test-id=...]')`
- **กฎ 4 ข้อยังใช้ครบ** — แค่ syntax ของ wait/chain ต่างจาก Playwright
