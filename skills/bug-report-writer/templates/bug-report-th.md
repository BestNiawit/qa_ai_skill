# [<Module>] <Action> ทำให้เกิด <Symptom> เมื่อ <Condition>

## Summary
<สรุปปัญหา 1-2 ประโยค>

## Environment
| Item | Value |
|------|-------|
| **App / Build** | <ชื่อ app> v<version> (build #<num>) |
| **Environment** | Production / Staging / Dev / Local |
| **OS** | macOS 14.5 / Windows 11 / iOS 17.2 / Android 14 |
| **Browser** | Chrome 130.0.6723.92 / Safari 17.5 |
| **Device** | iPhone 15 Pro / Desktop / Galaxy S23 |
| **Network** | WiFi / 4G / Slow 3G |
| **URL** | https://... |
| **Tested Date/Time** | YYYY-MM-DD HH:mm (timezone) |

## Severity / Priority
> ตาม qa-standards.md §1-§2 (อ้างอิง Ayodia TEST DEFINITION template)

- **Severity:** Critical / Major / Minor / Trivial
- **Priority:** Critical / High / Medium / Low
- **Action Label:** <จาก Severity × Priority matrix §2.1 — Blocker / Urgent / Standard High / ...>
- **Frequency:** Always (100%) / Sometimes (X/10) / Once

## Precondition
- ผู้ใช้ login ด้วย account `<role>`
- มีข้อมูล ... ในระบบ

## Test Data
| Field | Value |
|-------|-------|
| email | `test@example.com` |
| password | `[REDACTED]` |
| ... | ... |

## Steps to Reproduce
1. ไปที่ ...
2. กรอก ... ในช่อง ...
3. กดปุ่ม ... ← **bug เกิดที่นี่**

## Expected Result
- ...

## Actual Result
- ...
- (ถ้ามี error message ให้ paste แบบ verbatim)

```
Error: <paste exact error message>
```

## Attachments
- 📸 Screenshot: `<filename or link>`
- 🎥 Screen recording: `<link>`
- 📋 Console log / Network log: `<link>`
- 📄 HAR file: `<link>`

## Workaround (ถ้ามี)
- ผู้ใช้สามารถ ... เพื่อหลีกเลี่ยงปัญหาชั่วคราว

## Additional Notes
- เริ่มเจอตั้งแต่ build #...
- น่าจะ regression จาก ticket #...
- ทดสอบแล้วเกิดเฉพาะใน <condition>
