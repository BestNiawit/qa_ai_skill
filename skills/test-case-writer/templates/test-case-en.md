# Test Cases: <Module Title>

| Module ID | <MODULE_ID> |
|-----------|-------------|
| **Module Title** | <Module Title> |
| **Requirement Ref** | `<link / file path / version>` |
| **Created Date** | YYYY-MM-DD |
| **Author** | <author name> |
| **Reviewed By** | <reviewer name> |
| **Total Test Cases** | <count> |

---

## Scope & Assumptions

**Scope:**
- In scope: ...
- Out of scope: ...

**Assumptions:**
- ...

---

## Test Cases

> **How to read**: Rows labeled `SC_xxx: ...` are scenario groups (section headers). Individual test cases follow below them.

| TC ID* | Test Case Description* | Role* | Pos/Neg* | Priority* | Severity | Test Sizing | Technique | Pre-Requisite | Test Step* | Test Data | Expected Result* | Ref FR ID | Automation | Labels | Environment | Sprint | Actual Result* | Test Result | Tested By | Test Date | Defect ID (Jira) | Remark |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **SC_001: User login with username + password** |||||||||||||||||||||||
| TC_PMS_LOG_001 | Successful login with valid credentials | End User | Positive | P1 | S2 | S | Use Case | Active account exists | 1. Navigate to `/login`<br>2. Enter username<br>3. Enter password<br>4. Click "Sign in" | username=`superayodia`<br>password=`[REDACTED]` | 1. Redirect to `/home`<br>2. Shows welcome message<br>3. Token saved in localStorage | FR_PMS_LOG_01 | Yes | smoke, regression | dev | 2026-S08 | | | | | | |
| TC_PMS_LOG_002 | Login fails with wrong password | End User | Negative | P1 | S2 | S | Error Guessing | Active account exists | 1. Navigate to `/login`<br>2. Enter valid username<br>3. Enter wrong password<br>4. Click "Sign in" | username=`superayodia`<br>password=`wrong-pw` | 1. Error message "Invalid username or password"<br>2. Stays on login page | FR_PMS_LOG_02 | Yes | regression | dev | 2026-S08 | | | | | | |
| TC_PMS_LOG_003 | Account locked after 5 failed login attempts | End User | Negative | P0 | S1 | M | Decision Table | Account is not locked | 1. Enter wrong password 5 times<br>2. Try 6th time with correct password | username=`locked_test`<br>password=`Wrong!@#` | 1. 6th attempt shows "Account locked. Contact admin"<br>2. DB field `is_locked = true` | FR_PMS_LOG_03 | Candidate | regression, security | dev | 2026-S08 | | | | | | |
| **SC_002: Input validation** |||||||||||||||||||||||
| TC_PMS_LOG_004 | Empty username disables login button | End User | Negative | P2 | S3 | S | BVA | On login page | 1. Navigate to `/login`<br>2. Leave username empty<br>3. Enter password | password=`any` | "Sign in" button is disabled | FR_PMS_LOG_04 | Yes | regression | dev | 2026-S08 | | | | | | |

---

## Coverage Matrix

| Requirement ID | Description | Test Case IDs |
|----------------|-------------|---------------|
| FR_PMS_LOG_01 | Login with email + password | TC_PMS_LOG_001 |
| FR_PMS_LOG_02 | Show error on invalid credentials | TC_PMS_LOG_002 |
| FR_PMS_LOG_03 | Lock account after 5 failures | TC_PMS_LOG_003 |
| FR_PMS_LOG_04 | Disable login button on incomplete input | TC_PMS_LOG_004 |

---

## Field Reference

| Field | Values / Description |
|-------|----------------------|
| **TC ID** | `TC_<MODULE_ID>_<NUM>`, running sequence — e.g. `TC_PMS_LOG_001` |
| **Role** | User role under test (End User / Admin / Super Admin / Guest) |
| **Pos/Neg** | Positive / Negative / Boundary / Edge |
| **Priority** | `P0` (critical blocker) / `P1` (high) / `P2` (medium) / `P3` (low) — or High/Med/Low |
| **Severity** | `S1` Critical / `S2` Major / `S3` Minor / `S4` Cosmetic |
| **Test Sizing** | `S` (< 15 min, 1–3 steps) / `M` (15–30 min, 4–8 steps) / `L` (30–60 min, 9–15 steps) / `XL` (> 1 hr, E2E with setup) |
| **Technique** | `ECP` / `BVA` / `Decision Table` / `State Transition` / `Use Case` / `Error Guessing` (see `references/testing-techniques.md`) |
| **Automation** | `Yes` (automated) / `No` (manual only) / `Candidate` (should be automated) / `N/A` (visual/UX only) |
| **Labels** | Comma-separated tags — e.g. `smoke, regression, security, @mobile` |
| **Environment** | `dev` / `sit` / `uat` / `staging` / `prod` |
| **Sprint** | `<year>-S<num>` e.g. `2026-S08` |
| **Test Result** | `Pass` / `Fail` / `Blocked` / `Skipped` / `Not Run` |
| **Defect ID** | Jira/Linear ticket e.g. `PMS-1234` if failed |

---

## Test Data Reference (shared datasets)

| Dataset | Description | Used By |
|---------|-------------|---------|
| valid_user | username + password that passes validation | TC_PMS_LOG_001, TC_PMS_LOG_004 |
| locked_user | locked account | TC_PMS_LOG_003 |
