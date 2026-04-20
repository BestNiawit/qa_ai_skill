*** Settings ***
Documentation       Example test suite — smoke login + navigate to settings menu.
Resource            ${CURDIR}/../resources/imports.robot
Test Setup          browser_keywords.Open Browser Session
Test Teardown       BuiltIn.Run Keywords
...                 browser_keywords.Capture Screenshot On Failure
...                 AND    browser_keywords.Close Browser Session

*** Test Cases ***
EXAMPLE_SC_001_TC_001 ตรวจสอบการ login ด้วย credential ที่ถูกต้อง
    [Tags]    regression    example    test_id:EXAMPLE_SC_001_TC_001    positive
    [Documentation]    Admin login ด้วย credential ที่ถูกต้อง ระบบนำไปหน้า home และแสดง welcome message
    example_keywords.User Opens Example Page And Fills Credentials
    ...    ${TC_EXAMPLE_SC_001['username']}
    ...    ${TC_EXAMPLE_SC_001['password']}
    example_page.Submit Example Form
    example_page.Verify Success Popup Should Be Displayed

EXAMPLE_SC_001_TC_002 ตรวจสอบการ login ด้วย password ผิด
    [Tags]    regression    example    test_id:EXAMPLE_SC_001_TC_002    negative
    [Documentation]    Admin login ด้วย password ผิด ระบบต้องไม่ยอมให้เข้าและแสดง error
    example_keywords.User Opens Example Page And Fills Credentials
    ...    ${TC_EXAMPLE_SC_001['username']}
    ...    ${TC_EXAMPLE_SC_001['password_invalid']}
    example_page.Submit Example Form
    example_page.Verify Example Page Should Be Displayed
