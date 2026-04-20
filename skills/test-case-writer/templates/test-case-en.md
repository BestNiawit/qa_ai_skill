# Test Cases: <Feature Name>

| Meta | Value |
|------|-------|
| **Requirement Ref** | `<link / file path / version>` |
| **Created Date** | YYYY-MM-DD |
| **Author** | <author name> |
| **Reviewed By** | <reviewer name> |
| **Total Test Cases** | <count> |

---

## Summary

**Scope:**
- In scope: ...
- Out of scope: ...

**Assumptions:**
- ...

---

## TC-001: <short title describing what is tested>

| Field | Value |
|-------|-------|
| **Priority** | High / Medium / Low |
| **Technique** | ECP / BVA / Decision Table / State Transition / Use Case / Error Guessing |
| **Type** | Positive / Negative / Boundary / Edge |
| **Module** | <module/screen> |

**Precondition:**
- User logged in with role X
- Record Y exists in the system

**Test Data:**
| Field | Value |
|-------|-------|
| email | `valid@example.com` |
| password | `Pass1234!` |

**Steps:**
1. Navigate to ...
2. Enter ... in ... field
3. Click the ... button

**Expected Result:**
- System displays popup with text "..."
- Redirected to `/...`
- Record in DB table `...` has `status = 'active'`

---

## TC-002: <test case title>

(repeat pattern above)

---

## Coverage Matrix

| Requirement ID | Description | Test Case IDs |
|----------------|-------------|---------------|
| REQ-001 | User can log in with email + password | TC-001, TC-002, TC-003 |
| REQ-002 | System locks account after 5 failed logins | TC-004, TC-005 |
| REQ-003 | ... | TC-006 |

---

## Test Data Reference (shared datasets)

| Dataset | Description | Used By |
|---------|-------------|---------|
| valid_user | email + password passing validation | TC-001, TC-003 |
| locked_user | locked account | TC-005 |
