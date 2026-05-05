// ================================================================
// report.typ — Test Matrix Report (caller template)
// ================================================================
// วิธีใช้:
//   1. แก้ค่าใน `data` ด้านล่างให้ตรงกับโปรเจกต์จริง
//   2. compile:  typst compile report.typ <output>.pdf
//   ตัวอย่าง:    typst compile report.typ ../outputs/matrix/report.pdf
// ================================================================

#import "report-style.typ": *

#show: report.with(
  project: "ระบบเข้าสู่ระบบ (Login Module)",
  document-title: "Test Matrix Report",
  customer: "บริษัท ตัวอย่าง จำกัด",
  version: "1.0",
  date: "5 พฤษภาคม 2569",
  author: "Ayodia QA Team",
  logo: "../assets/ayodia-logo.png",

  summary: (
    total-requirements: 6,
    total-scenarios: 12,
    coverage-percent: 100,
    pass: 9,
    fail: 1,
    pending: 2,
  ),

  scope-in: (
    "การเข้าสู่ระบบด้วย username + password",
    "การเข้าสู่ระบบด้วย OTP ทาง SMS",
    "การล็อกบัญชีเมื่อกรอกรหัสผิดเกิน 5 ครั้ง",
    "การ reset password ผ่าน email",
  ),
  scope-out: (
    "Single Sign-On (SSO) ผ่าน Google / Facebook",
    "Biometric authentication (Face ID / Touch ID)",
    "การจัดการ session ระยะยาว (Remember me)",
  ),

  test-types: (
    (name: "Positive", desc: "การทำงานปกติตาม happy path", count: 4),
    (name: "Negative", desc: "ใส่ข้อมูลผิดรูปแบบ / ไม่ครบ", count: 4),
    (name: "Boundary", desc: "ค่าขอบเขต (min/max length, special char)", count: 2),
    (name: "Security", desc: "SQL injection, XSS, brute force", count: 2),
  ),

  coverage: (
    scenarios: ("SCN-01", "SCN-02", "SCN-03", "SCN-04", "SCN-05", "SCN-06"),
    rows: (
      (
        id: "REQ-01",
        desc: "ผู้ใช้สามารถ login ด้วย username + password ได้",
        scenarios: (
          "SCN-01": "PASS", "SCN-02": "PASS", "SCN-03": "-",
          "SCN-04": "-", "SCN-05": "-", "SCN-06": "-",
        ),
      ),
      (
        id: "REQ-02",
        desc: "ระบบต้องแสดงข้อความ error เมื่อรหัสผิด",
        scenarios: (
          "SCN-01": "-", "SCN-02": "-", "SCN-03": "PASS",
          "SCN-04": "FAIL", "SCN-05": "-", "SCN-06": "-",
        ),
      ),
      (
        id: "REQ-03",
        desc: "ล็อกบัญชีเมื่อกรอกรหัสผิดเกิน 5 ครั้ง",
        scenarios: (
          "SCN-01": "-", "SCN-02": "-", "SCN-03": "-",
          "SCN-04": "-", "SCN-05": "PASS", "SCN-06": "-",
        ),
      ),
      (
        id: "REQ-04",
        desc: "ผู้ใช้สามารถขอ OTP ทาง SMS ได้",
        scenarios: (
          "SCN-01": "-", "SCN-02": "-", "SCN-03": "-",
          "SCN-04": "-", "SCN-05": "-", "SCN-06": "PENDING",
        ),
      ),
      (
        id: "REQ-05",
        desc: "ระบบต้องป้องกัน SQL injection ในช่อง username",
        scenarios: (
          "SCN-01": "-", "SCN-02": "PASS", "SCN-03": "-",
          "SCN-04": "-", "SCN-05": "-", "SCN-06": "-",
        ),
      ),
      (
        id: "REQ-06",
        desc: "Reset password ผ่าน email ภายใน 30 นาที",
        scenarios: (
          "SCN-01": "-", "SCN-02": "-", "SCN-03": "-",
          "SCN-04": "-", "SCN-05": "-", "SCN-06": "PENDING",
        ),
      ),
    ),
  ),

  combination: (
    cols: ("Username", "Password", "Captcha", "Expected Result"),
    rows: (
      ("valid", "valid", "valid", "Login สำเร็จ"),
      ("valid", "invalid", "valid", "Error: รหัสผ่านผิด"),
      ("invalid", "valid", "valid", "Error: ไม่พบบัญชี"),
      ("valid", "valid", "invalid", "Error: Captcha ไม่ถูกต้อง"),
      ("empty", "valid", "valid", "Error: กรุณากรอก username"),
      ("valid", "empty", "valid", "Error: กรุณากรอกรหัสผ่าน"),
      ("SQL injection", "valid", "valid", "Error + log security event"),
    ),
  ),

  platform: (
    platforms: ("Chrome 120", "Safari 17", "Firefox 121", "Edge 120", "iOS 17", "Android 14"),
    rows: (
      (
        feature: "Login form rendering",
        results: (
          "Chrome 120": "PASS", "Safari 17": "PASS", "Firefox 121": "PASS",
          "Edge 120": "PASS", "iOS 17": "PASS", "Android 14": "PASS",
        ),
      ),
      (
        feature: "OTP SMS receive",
        results: (
          "Chrome 120": "N/A", "Safari 17": "N/A", "Firefox 121": "N/A",
          "Edge 120": "N/A", "iOS 17": "PASS", "Android 14": "PENDING",
        ),
      ),
      (
        feature: "Captcha display",
        results: (
          "Chrome 120": "PASS", "Safari 17": "PASS", "Firefox 121": "PASS",
          "Edge 120": "PASS", "iOS 17": "PASS", "Android 14": "FAIL",
        ),
      ),
      (
        feature: "Reset password email link",
        results: (
          "Chrome 120": "PASS", "Safari 17": "PASS", "Firefox 121": "PASS",
          "Edge 120": "PASS", "iOS 17": "PASS", "Android 14": "PASS",
        ),
      ),
    ),
  ),

  notes: [
    *ข้อสังเกตจากการทดสอบ:*
    - SCN-04 (กรอกรหัสผิดแล้วยังเข้าได้) — เป็น defect ระดับ *Critical* — ดู bug DEF-1024
    - REQ-04 และ REQ-06 ยังอยู่ในสถานะ *PENDING* รอ environment SMS gateway พร้อมใช้
    - Captcha บน Android 14 ไม่แสดงผลใน WebView — ต้องตรวจสอบ library version

    *ขั้นตอนถัดไป:*
    + แก้ defect DEF-1024 และ retest SCN-04
    + รอ SMS gateway → ทดสอบ REQ-04, REQ-06
    + ตรวจสอบ Captcha Android 14 → DEF-1031
  ],
)
