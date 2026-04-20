*** Settings ***
Documentation    Example page keywords.

*** Keywords ***
Open Example Page
    [Documentation]    Open example page from current base URL.
    ${target_url}=    BuiltIn.Catenate    SEPARATOR=    ${SESSION_BASE_URL}    /example
    SeleniumLibrary.Go To    ${target_url}

Input Username
    [Documentation]    Input username into example form.
    [Arguments]    ${username}
    ui_keywords.Input Text When Ready    ${EXAMPLE_USERNAME_INPUT_LOCATOR}    ${username}

Enter Password
    [Documentation]    Input password into example form.
    [Arguments]    ${password}
    ui_keywords.Input Password When Ready    ${EXAMPLE_PASSWORD_INPUT_LOCATOR}    ${password}

Submit Example Form
    [Documentation]    Submit example form.
    ui_keywords.Click Button When Element Is Visible    ${EXAMPLE_SUBMIT_BUTTON_LOCATOR}

Search For Item
    [Documentation]    Type search term into search box.
    [Arguments]    ${term}
    ui_keywords.Input Text When Ready    ${EXAMPLE_SEARCH_INPUT_LOCATOR}    ${term}

Navigate To Menu
    [Documentation]    Click a menu item by its visible label (dynamic locator).
    [Arguments]    ${menu}
    ${locator}=    ui_keywords.Replace String    ${EXAMPLE_MENU_LOCATOR}    {{menu}}    ${menu}
    ui_keywords.Click Element When Visible    ${locator}

Verify Example Page Should Be Displayed
    [Documentation]    Verify example page is loaded and main input is visible.
    ui_keywords.Wait Until Element Is Ready    ${EXAMPLE_USERNAME_INPUT_LOCATOR}

Verify Success Popup Should Be Displayed
    [Documentation]    Verify success toast popup is shown.
    ui_keywords.Wait Until Element Is Ready    ${EXAMPLE_SUCCESS_POPUP_LOCATOR}
