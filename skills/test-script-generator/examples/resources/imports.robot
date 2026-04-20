*** Settings ***
Documentation    Central imports — every test case imports only this file.

Library          SeleniumLibrary
Library          String
Library          Collections
Library          RequestsLibrary
Library          ${CURDIR}/../../../Library/config_loader.py
Library          ${CURDIR}/../../../Library/test_flow_report_listener.py

Variables        ${CURDIR}/testdata/ui/testdata.yaml
Variables        ${CURDIR}/translations/${LANG}/translations.yaml

Resource         ${CURDIR}/variables.robot
Resource         ${CURDIR}/locators/session_variables.robot
Resource         ${CURDIR}/locators/example_locator.robot

Resource         ${CURDIR}/../keywords/ui/common/browser_keywords.robot
Resource         ${CURDIR}/../keywords/ui/common/ui_keywords.robot
Resource         ${CURDIR}/../keywords/ui/page/example_page.robot
Resource         ${CURDIR}/../keywords/ui/feature/example_keywords.robot

Suite Setup      Initialize Session Variables
