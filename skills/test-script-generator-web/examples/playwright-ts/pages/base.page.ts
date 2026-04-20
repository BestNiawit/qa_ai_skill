import { type Page, type TestInfo } from '@playwright/test';

/**
 * BasePage — shared base class for all Page Objects.
 *
 * Provides `captureStep(name)` which attaches a screenshot to the current
 * test result. Downstream reporters (e.g. PDF) can pick them up via the
 * `step::` prefix.
 */
export class BasePage {
  readonly page: Page;
  private readonly _testInfo?: TestInfo;

  constructor(page: Page, testInfo?: TestInfo) {
    this.page = page;
    this._testInfo = testInfo;
  }

  async captureStep(stepName: string): Promise<void> {
    if (!this._testInfo) return;
    try {
      const screenshot = await this.page.screenshot({ fullPage: false });
      await this._testInfo.attach(`step::${stepName}`, {
        body: screenshot,
        contentType: 'image/png',
      });
    } catch {
      // Screenshot failures must not fail the test
    }
  }
}
