# Snippet — ย่อจาก keywords/ui/common/ui_keywords.robot ใน athm_automation
# ใช้เป็น reference ตอน generate page keywords — อย่าเรียก SeleniumLibrary ตรง ใช้ wrapper เหล่านี้เท่านั้น
# robocop: disable=too-many-calls-in-keyword

*** Settings ***
Documentation    Shared UI interaction wrappers (wait + retry + JS fallback).

*** Keywords ***
Wait Until Element Is Ready
    [Documentation]    Wait until element is visible.
    [Arguments]    ${locator}    ${timeout}=10s
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}    ${timeout}

Input Text When Ready
    [Documentation]    Wait for element, clear, then input text.
    [Arguments]    ${locator}    ${text}    ${timeout}=10s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    SeleniumLibrary.Clear Element Text    ${locator}
    SeleniumLibrary.Input Text    ${locator}    ${text}

Input Password When Ready
    [Documentation]    Wait for element, clear, then input password.
    [Arguments]    ${locator}    ${password}    ${timeout}=10s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    SeleniumLibrary.Clear Element Text    ${locator}
    SeleniumLibrary.Input Password    ${locator}    ${password}

Click Button When Element Is Visible
    [Documentation]    Wait until button is visible, then click.
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    SeleniumLibrary.Click Button    ${locator}

Click Element When Visible
    [Documentation]    Click element with scroll + JS fallback retry.
    [Arguments]    ${locator}    ${timeout}=10s
    ${found}=    BuiltIn.Set Variable    ${False}
    FOR    ${i}    IN RANGE    5
        ${is_visible}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Element Should Be Visible    ${locator}
        IF    ${is_visible}
            ${found}=    BuiltIn.Set Variable    ${True}
            BREAK
        END
        SeleniumLibrary.Execute JavaScript    window.scrollBy(0, 500)
        BuiltIn.Sleep    0.2s
    END
    IF    not ${found}
        SeleniumLibrary.Execute JavaScript    arguments[0].scrollIntoView(true);    ARGUMENTS    ${locator}
    END
    SeleniumLibrary.Click Element    ${locator}

Replace String
    [Documentation]    Replace placeholder in locator template.
    [Arguments]    ${source}    ${placeholder}    ${value}
    ${result}=    String.Replace String    ${source}    ${placeholder}    ${value}
    RETURN    ${result}
