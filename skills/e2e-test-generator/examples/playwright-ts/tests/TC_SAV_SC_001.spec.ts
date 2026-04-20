/**
 * TC_SAV_SC_001 - Assessment Year Settings
 *
 * Demonstrates:
 *   - Page Object Model
 *   - Advanced XPath (no index, label-scoped, dialog-scoped)
 *   - Shared locators (menu, dialog, dropdown option)
 *   - Text-as-constants (LABELS + ASSESSMENT_YEAR_LABELS)
 */
import { test, expect } from '../fixtures/base.fixture';
import { UI_TEST_DATA } from '../data/testdata';
import { ASSESSMENT_YEAR_LABELS as AY } from '../labels/assessment-year.labels';

const data = UI_TEST_DATA.TC_SAV_SC_001;

test.describe('TC_SAV_SC_001 - Assessment Year Settings', () => {
  test.beforeEach(async ({ loginPage, homePage }) => {
    await loginPage.login(data.username, data.password);
    await homePage.waitForHomePage();
  });

  test('TC_01 - Access settings and see table headers', async ({
    homePage, assessmentYearPage,
  }) => {
    await homePage.navigateToPmsMenu();
    await assessmentYearPage.navigateToSettings();

    await expect(assessmentYearPage.pageHeader).toBeVisible();
    await expect(assessmentYearPage.tableHeaderYear).toBeVisible();
    await expect(assessmentYearPage.tableHeaderLastUpdated).toBeVisible();
    await expect(assessmentYearPage.tableHeaderOperator).toBeVisible();
    await expect(assessmentYearPage.tableHeaderAction).toBeVisible();
  });

  test('TC_02 - Search finds matching year', async ({
    homePage, assessmentYearPage,
  }) => {
    await homePage.navigateToPmsMenu();
    await assessmentYearPage.navigateToSettings();
    await assessmentYearPage.searchAssessmentYear(data.assessmentYearValid);

    const row = assessmentYearPage.getAssessmentYearRow(data.assessmentYearValid);
    await expect(row).toBeVisible();
  });

  test('TC_05 - Reject text input in dropdown', async ({
    homePage, assessmentYearPage,
  }) => {
    await homePage.navigateToPmsMenu();
    await assessmentYearPage.navigateToSettings();
    await assessmentYearPage.openAddModal();
    await assessmentYearPage.typeIntoAssessmentYearSearch(data.assessmentYearText);

    await expect(assessmentYearPage.dropdownNoResults).toBeVisible();
    await expect(assessmentYearPage.dropdownNoResults)
      .toContainText(AY.noResults);
  });
});
