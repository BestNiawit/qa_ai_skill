import { type Page, type TestInfo, type Locator } from '@playwright/test';
import { BasePage } from './base.page';
import { buttonByLabel } from '../locators/common.locators';
import { LABELS } from '../labels/common.labels';

export class LoginPage extends BasePage {
  readonly usernameInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;

  constructor(page: Page, testInfo?: TestInfo) {
    super(page, testInfo);

    // Page-specific (unique data-test-id)
    this.usernameInput = page.locator("//input[@data-test-id='primeng-input-name']");
    this.passwordInput = page.locator("//input[@data-test-id='primeng-input-password']");

    // Shared pattern + label constant
    this.submitButton = page.locator(buttonByLabel(LABELS.loginSubmit));
  }

  async goto() {
    await this.page.goto('/#/login');
  }

  async login(username: string, password: string) {
    await this.goto();
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
    await this.captureStep('Login');
  }
}
