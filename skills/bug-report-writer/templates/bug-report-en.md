# [<Module>] <Action> causes <Symptom> when <Condition>

## Summary
<1-2 sentence summary of the issue>

## Environment
| Item | Value |
|------|-------|
| **App / Build** | <app name> v<version> (build #<num>) |
| **Environment** | Production / Staging / Dev / Local |
| **OS** | macOS 14.5 / Windows 11 / iOS 17.2 / Android 14 |
| **Browser** | Chrome 130.0.6723.92 / Safari 17.5 |
| **Device** | iPhone 15 Pro / Desktop / Galaxy S23 |
| **Network** | WiFi / 4G / Slow 3G |
| **URL** | https://... |
| **Tested At** | YYYY-MM-DD HH:mm (timezone) |

## Severity / Priority
> Follow qa-standards.md — **do NOT use Blocker/Trivial** (map → S1/S4)
- **Severity:** S1 Critical / S2 Major / S3 Minor / S4 Cosmetic
- **Priority:** P0 / P1 / P2 / P3
- **Frequency:** Always (100%) / Sometimes (X/10) / Once

## Precondition
- Logged in as `<role>` user
- Record ... exists in the system

## Test Data
| Field | Value |
|-------|-------|
| email | `test@example.com` |
| password | `[REDACTED]` |
| ... | ... |

## Steps to Reproduce
1. Navigate to ...
2. Enter ... in ... field
3. Click ... ← **bug occurs here**

## Expected Result
- ...

## Actual Result
- ...
- (paste exact error message if any)

```
Error: <paste exact error message>
```

## Attachments
- 📸 Screenshot: `<filename or link>`
- 🎥 Screen recording: `<link>`
- 📋 Console / Network log: `<link>`
- 📄 HAR file: `<link>`

## Workaround (if any)
- User can ... as a temporary workaround

## Additional Notes
- First seen in build #...
- Likely regression from ticket #...
- Reproducible only when <condition>
