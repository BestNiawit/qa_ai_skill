import { type Page, type TestInfo, type Locator } from '@playwright/test';
import { BasePage } from './base.page';
import { buttonByLabel, alertMessage, checkboxByLabel } from '../locators/common.locators';
import { LABELS } from '../labels/common.labels';
import { ANNOUNCEMENT_LABELS as ANN } from '../labels/announcement.labels';

export class AnnouncementPage extends BasePage {
  // Page header
  readonly createHeader: Locator;

  // Form fields
  readonly professionalExperiencesTextarea: Locator;
  readonly yearOfExperienceInput: Locator;
  readonly languageDescriptionTextarea: Locator;

  // Actions + feedback (shared patterns)
  readonly saveButton: Locator;
  readonly saveSuccessPopup: Locator;

  constructor(page: Page, testInfo?: TestInfo) {
    super(page, testInfo);

    this.createHeader = page.locator(
      `//*[@role='heading' and normalize-space()='${ANN.createHeader}']`
    );

    this.professionalExperiencesTextarea = page.locator(
      `//textarea[@placeholder='${ANN.professionalExperiencesPlaceholder}']`
    );
    this.yearOfExperienceInput = page.locator(
      `//input[@data-test-id='primeng-input-experienceYear']`
    );
    this.languageDescriptionTextarea = page.locator(
      `//textarea[contains(@placeholder,'${ANN.languageDescriptionPlaceholderPartial}')]`
    );

    this.saveButton = page.locator(buttonByLabel(LABELS.save));
    this.saveSuccessPopup = page.locator(alertMessage(ANN.saveSuccess));
  }

  // Factory — employee type checkbox
  getEmployeeTypeCheckbox(employeeType: string): Locator {
    return this.page.locator(checkboxByLabel(employeeType));
  }

  async waitForFormLoaded() {
    await this.createHeader.waitFor({ state: 'visible' });
    await this.captureStep('Announcement Form Loaded');
  }

  async fillProfessionalExperiences(text: string) {
    await this.professionalExperiencesTextarea.fill(text);
    await this.captureStep('Fill Professional Experiences');
  }

  async fillYearOfExperience(years: string) {
    await this.yearOfExperienceInput.fill(years);
    await this.captureStep(`Fill Year of Experience: ${years}`);
  }

  async fillLanguageDescription(text: string) {
    await this.languageDescriptionTextarea.fill(text);
    await this.captureStep('Fill Language Description');
  }

  async selectEmployeeType(employeeType: string) {
    const checkbox = this.getEmployeeTypeCheckbox(employeeType);
    await checkbox.waitFor({ state: 'visible' });
    await checkbox.click();
    await this.captureStep(`Select Employee Type: ${employeeType}`);
  }

  async save() {
    await this.saveButton.waitFor({ state: 'visible' });
    await this.saveButton.click();
    await this.captureStep('Save');
  }
}
