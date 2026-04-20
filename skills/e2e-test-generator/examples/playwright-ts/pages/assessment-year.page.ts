import { type Page, type TestInfo, type Locator } from '@playwright/test';
import { BasePage } from './base.page';
import {
  menuItem,
  tableHeader,
  activeDialog,
  buttonByLabel,
  dropdownOption,
} from '../locators/common.locators';
import { LABELS } from '../labels/common.labels';
import { ASSESSMENT_YEAR_LABELS as AY } from '../labels/assessment-year.labels';

export class AssessmentYearPage extends BasePage {
  // Navigation
  readonly settingsMenuButton: Locator;
  readonly pageHeader: Locator;

  // Table headers
  readonly tableHeaderYear: Locator;
  readonly tableHeaderLastUpdated: Locator;
  readonly tableHeaderOperator: Locator;
  readonly tableHeaderAction: Locator;

  // Search
  readonly searchInput: Locator;

  // Modal
  readonly addButton: Locator;
  readonly modal: Locator;
  readonly modalJobGradeField: Locator;
  readonly modalKpiField: Locator;
  readonly modalCompetencyField: Locator;
  readonly modalIdpField: Locator;

  // Dropdown inside modal
  readonly assessmentYearDropdown: Locator;
  readonly assessmentYearSearchInput: Locator;
  readonly dropdownNoResults: Locator;

  constructor(page: Page, testInfo?: TestInfo) {
    super(page, testInfo);

    this.settingsMenuButton = page.locator(menuItem(AY.pageHeader));
    this.pageHeader = page.locator(
      `//*[@role='heading' and normalize-space()='${AY.pageHeader}']`
    );

    this.tableHeaderYear        = page.locator(tableHeader(AY.columnYear));
    this.tableHeaderLastUpdated = page.locator(tableHeader(AY.columnLastUpdated));
    this.tableHeaderOperator    = page.locator(tableHeader(AY.columnOperator));
    this.tableHeaderAction      = page.locator(tableHeader(AY.columnAction));

    this.searchInput = page.locator(
      `//input[@placeholder='${AY.searchPlaceholder}']`
    );

    this.addButton = page.locator(buttonByLabel(LABELS.addItem));

    // Modal uses shared activeDialog() scope — ไม่ใช้ class contains
    this.modal = page.locator(activeDialog());
    this.modalJobGradeField   = page.locator(`${activeDialog()}//th[normalize-space()='${AY.modalJobGrade}']`);
    this.modalKpiField        = page.locator(`${activeDialog()}//th[normalize-space()='${AY.modalKpi}']`);
    this.modalCompetencyField = page.locator(`${activeDialog()}//th[normalize-space()='${AY.modalCompetency}']`);
    this.modalIdpField        = page.locator(`${activeDialog()}//th[normalize-space()='${AY.modalIdp}']`);

    // Dropdown scoped within active dialog — no positional index
    this.assessmentYearDropdown = page.locator(
      `${activeDialog()}//*[@role='combobox' and @aria-haspopup='listbox']`
    );
    this.assessmentYearSearchInput = page.locator(`//input[@role='searchbox']`);
    this.dropdownNoResults = page.locator(
      `//li[@role='option' and normalize-space()='${AY.noResults}']`
    );
  }

  // Factory — row by year value (table row scoped by cell content)
  getAssessmentYearRow(year: string): Locator {
    return this.page.locator(
      `//tbody//tr[.//td[normalize-space()='${year}']]`
    );
  }

  // Factory — option by year
  getAssessmentYearOption(year: string): Locator {
    return this.page.locator(dropdownOption(year));
  }

  async navigateToSettings() {
    await this.settingsMenuButton.waitFor({ state: 'visible' });
    await this.settingsMenuButton.click();
    await this.pageHeader.waitFor({ state: 'visible' });
    await this.captureStep('Navigate to Settings');
  }

  async searchAssessmentYear(year: string) {
    await this.searchInput.fill(year);
    await this.captureStep(`Search: ${year}`);
  }

  async openAddModal() {
    await this.addButton.click();
    await this.modal.waitFor({ state: 'visible' });
    await this.captureStep('Open Add Modal');
  }

  async selectAssessmentYear(year: string) {
    await this.assessmentYearDropdown.click();
    await this.assessmentYearSearchInput.fill(year);
    const option = this.getAssessmentYearOption(year);
    await option.waitFor({ state: 'visible' });
    await option.click();
    await this.captureStep(`Select Assessment Year: ${year}`);
  }

  async typeIntoAssessmentYearSearch(value: string) {
    await this.assessmentYearDropdown.click();
    await this.assessmentYearSearchInput.fill(value);
    await this.captureStep(`Type in Search: ${value}`);
  }
}
