*** Settings ***
Documentation    Example feature workflows (composes page keywords).

*** Keywords ***
User Opens Example Page And Fills Credentials
    [Documentation]    Open example page and fill username + password (without submit).
    [Arguments]    ${username}    ${password}
    example_page.Open Example Page
    example_page.Verify Example Page Should Be Displayed
    example_page.Input Username    ${username}
    example_page.Enter Password    ${password}

Admin Creates Record With Search Term
    [Documentation]    Full flow: open page, search, submit, verify success.
    [Arguments]    ${term}
    example_page.Open Example Page
    example_page.Search For Item    ${term}
    example_page.Submit Example Form
    example_page.Verify Success Popup Should Be Displayed
