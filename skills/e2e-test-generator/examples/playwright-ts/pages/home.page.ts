import { type Page, type TestInfo, type Locator } from '@playwright/test';
import { BasePage } from './base.page';
import { menuItem } from '../locators/common.locators';
import { LABELS } from '../labels/common.labels';
import { LOGIN_LABELS } from '../labels/login.labels';

export class HomePage extends BasePage {
  readonly welcomeMessage: Locator;
  readonly pmsMenuButton: Locator;

  constructor(page: Page, testInfo?: TestInfo) {
    super(page, testInfo);

    this.welcomeMessage = page.locator(
      `//*[normalize-space()='${LOGIN_LABELS.welcomeMessage}']`
    );
    this.pmsMenuButton = page.locator(menuItem(LABELS.pmsSystem));
  }

  // Factory — dynamic menu (scoped to nav via shared locator)
  getMenuItem(label: string): Locator {
    return this.page.locator(menuItem(label));
  }

  async waitForHomePage() {
    await this.welcomeMessage.waitFor({ state: 'visible' });
    await this.captureStep('Home Page');
  }

  async navigateToPmsMenu() {
    await this.pmsMenuButton.waitFor({ state: 'visible' });
    await this.pmsMenuButton.click();
    await this.captureStep('Navigate to PMS Menu');
  }

  async navigateToMenu(label: string) {
    const menu = this.getMenuItem(label);
    await menu.waitFor({ state: 'visible' });
    await menu.click();
    await this.captureStep(`Navigate to ${label}`);
  }
}
