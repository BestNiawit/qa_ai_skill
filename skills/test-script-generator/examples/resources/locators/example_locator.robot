# robocop: disable=line-too-long,empty-lines-between-sections
*** Settings ***
Documentation    Example page locators.

*** Variables ***
${EXAMPLE_USERNAME_INPUT_LOCATOR}       xpath=//input[@data-test-id='primeng-input-name']
${EXAMPLE_PASSWORD_INPUT_LOCATOR}       xpath=//input[@data-test-id='primeng-input-password']
${EXAMPLE_SUBMIT_BUTTON_LOCATOR}        xpath=//button[.//span[normalize-space()='${example_page['submit_label']}']]
${EXAMPLE_SEARCH_INPUT_LOCATOR}         xpath=//input[@role='searchbox']
${EXAMPLE_DIALOG_CONTAINER_LOCATOR}     xpath=//div[contains(@class,'p-dialog')]
${EXAMPLE_TABLE_ROW_LOCATOR}            xpath=(//table//tr)[last()]
${EXAMPLE_MENU_LOCATOR}                 xpath=(//span[normalize-space()='{{menu}}'])[last()]
${EXAMPLE_SUCCESS_POPUP_LOCATOR}        xpath=//div[contains(@class,'p-toast-message-success')]//div[normalize-space()='${example_page['success_popup_text']}']
