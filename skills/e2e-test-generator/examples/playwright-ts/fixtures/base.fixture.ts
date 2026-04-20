import { test as base } from '@playwright/test';
import { LoginPage } from '../pages/login.page';
import { HomePage } from '../pages/home.page';
import { AssessmentYearPage } from '../pages/assessment-year.page';
import { AnnouncementPage } from '../pages/announcement.page';

type PageObjects = {
  loginPage: LoginPage;
  homePage: HomePage;
  assessmentYearPage: AssessmentYearPage;
  announcementPage: AnnouncementPage;
};

export const test = base.extend<PageObjects>({
  loginPage: async ({ page }, use, testInfo) => {
    await use(new LoginPage(page, testInfo));
  },
  homePage: async ({ page }, use, testInfo) => {
    await use(new HomePage(page, testInfo));
  },
  assessmentYearPage: async ({ page }, use, testInfo) => {
    await use(new AssessmentYearPage(page, testInfo));
  },
  announcementPage: async ({ page }, use, testInfo) => {
    await use(new AnnouncementPage(page, testInfo));
  },
});

export { expect } from '@playwright/test';
