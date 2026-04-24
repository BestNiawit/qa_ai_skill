# Data Type Categories — Taxonomy ต่อ Field Type

> **Skill ใช้ไฟล์นี้เพื่อ:** เลือก Category ขั้นต่ำที่ field ประเภทนั้นๆ ต้องเทส — กัน AI ลืม case สำคัญ (null, empty, unicode, boundary)
> **Source:** ISTQB ECP + BVA + OWASP input validation + จากประสบการณ์จริง

---

## Master Category List (14 categories)

| # | Category | คำอธิบาย |
|---|----------|---------|
| 1 | **Null** | ค่า `null` / missing key / ไม่ส่ง field |
| 2 | **Empty** | `""`, `[]`, `{}`, `0` (กรณี numeric "empty") |
| 3 | **Valid-typical** | ค่าทั่วไปที่ user ส่งจริง |
| 4 | **Boundary-min** | ค่า min ที่ valid ขั้นต่ำ |
| 5 | **Boundary-max** | ค่า max ที่ valid สูงสุด |
| 6 | **Below-min** | `min - 1` (ต้อง reject) |
| 7 | **Above-max** | `max + 1` (ต้อง reject) |
| 8 | **Wrong-type** | type ผิด (string เข้า number field, etc.) |
| 9 | **Unicode** | non-ASCII: Thai, CJK, emoji, RTL, combining char |
| 10 | **Whitespace** | leading/trailing/only-whitespace/tab/newline |
| 11 | **Special-char** | XSS, SQLi, path traversal, null-byte, quote, backslash |
| 12 | **Overflow** | ค่าที่ยาว/ใหญ่เกิน limit มาก (DoS protection) |
| 13 | **Format-invalid** | format ผิด (email ไม่มี @, date ไม่ valid) |
| 14 | **Precision** | ทศนิยมปัด, timezone, leap year, leap second |

---

## Category Selection Matrix ต่อ Field Type (บังคับ minimum)

**กฎ:** ทุก field ต้องเทสอย่างน้อย category ที่มี ✅ ในตาราง; category ที่มี ⚠️ ให้พิจารณาตาม scope

| Category \ Type | string | number | date | enum | boolean | file | email | password | phone | url |
|-----------------|:------:|:------:|:----:|:----:|:-------:|:----:|:-----:|:--------:|:-----:|:---:|
| Null            | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Empty           | ✅ | ⚠️ | ⚠️ | ⚠️ | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| Valid-typical   | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Boundary-min    | ✅ | ✅ | ✅ | — | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| Boundary-max    | ✅ | ✅ | ✅ | — | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| Below-min       | ✅ | ✅ | ✅ | — | — | ✅ | ⚠️ | ✅ | ⚠️ | ⚠️ |
| Above-max       | ✅ | ✅ | ✅ | — | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| Wrong-type      | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ |
| Unicode         | ✅ | — | — | — | — | ⚠️ | ✅ | ⚠️ | — | ✅ |
| Whitespace      | ✅ | — | — | — | — | — | ✅ | ✅ | ⚠️ | ✅ |
| Special-char    | ✅ | — | — | — | — | ✅ | ✅ | ✅ | ⚠️ | ✅ |
| Overflow        | ✅ | ✅ | — | — | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| Format-invalid  | — | — | ✅ | ✅ | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| Precision       | — | ✅ | ✅ | — | — | — | — | — | — | — |

**หมายเหตุ:**
- ✅ = บังคับเทส (skill auto-generate)
- ⚠️ = optional, เทสถ้า scope ครอบ
- — = ไม่ applicable (ไม่ต้องเทส)

---

## Test Value Library (ใช้เป็นแหล่งอ้างอิง)

### String — Unicode edge cases

| Case | ค่า | เทสอะไร |
|------|-----|--------|
| Thai | `"สวัสดี"` | รับภาษาไทย |
| Thai + วรรณยุกต์ | `"ก้อน"` | combining mark |
| CJK | `"日本語"` | Unicode 3-byte |
| Emoji | `"😀"` | surrogate pair (4-byte UTF-8) |
| Family emoji | `"👨‍👩‍👧"` | ZWJ sequence |
| RTL | `"محمد"` | right-to-left |
| Mixed direction | `"Hello مرحبا"` | bidi |
| NFC vs NFD | `"café"` (NFC) vs `"café"` (NFD) | normalization |
| Zero-width | `"a​b"` | invisible char |
| Null byte | `"John\x00hack"` | filter bypass |

### String — Whitespace edge cases

| Case | ค่า |
|------|-----|
| Leading | `"  John"` |
| Trailing | `"John  "` |
| Both | `"  John  "` |
| Only whitespace | `"   "` |
| Tab | `"\tJohn"` |
| Newline | `"John\nhack"` |
| Non-breaking space | `"John Smith"` |

### String — Special-char / Security

| Attack | ค่า |
|--------|-----|
| XSS basic | `"<script>alert(1)</script>"` |
| XSS img | `"<img src=x onerror=alert(1)>"` |
| SQL injection | `"'; DROP TABLE users;--"` |
| SQL union | `"' OR '1'='1"` |
| Path traversal | `"../../etc/passwd"` |
| Command injection | `"; rm -rf /"` |
| LDAP injection | `"*)(uid=*))(\|(uid=*"` |
| Template injection | `"{{7*7}}"` |
| Unicode bypass | `"＜script＞"` (fullwidth) |

### Number — Boundary + edge

| Case | ค่า |
|------|-----|
| Zero | `0` |
| Negative | `-1` |
| Min int32 | `-2147483648` |
| Max int32 | `2147483647` |
| Max int64 | `9223372036854775807` |
| Float precision | `0.1 + 0.2 === 0.3?` |
| Very small | `0.0000001` |
| Very large | `1e100` |
| Scientific | `"1e10"` ส่งเป็น string |
| Infinity | `Infinity`, `-Infinity` |
| NaN | `NaN` |
| Negative zero | `-0` |

### Date — Boundary + edge

| Case | ค่า |
|------|-----|
| Epoch zero | `1970-01-01` |
| Past | `1900-01-01` |
| Future | `2100-12-31` |
| Leap year | `2024-02-29` (valid), `2023-02-29` (invalid) |
| Leap second | `2016-12-31T23:59:60Z` |
| Timezone | `2026-04-24T00:00:00+07:00` vs `...+00:00` |
| DST boundary | `2026-03-08T02:30:00` (US DST spring forward) |
| ISO format mismatch | `"24/04/2026"` vs `"2026-04-24"` |
| Invalid | `"2026-02-30"`, `"2026-13-01"` |
| Far future | `9999-12-31` |

### File — Boundary + edge

| Case | ค่า |
|------|-----|
| 0 byte | empty file |
| 1 byte | tiny file |
| Max size | file ที่ max size ที่รับ |
| Max size + 1 | above limit |
| Wrong extension | `.exe` ตอนต้องการ `.jpg` |
| Wrong MIME | `.jpg` แต่ binary เป็น `.exe` (polyglot) |
| Malicious SVG | SVG with embedded script |
| Zip bomb | 42.zip |
| Unicode filename | `"รูปภาพ.jpg"` |
| Long filename | 255+ chars |
| Special chars filename | `"file<>:?.jpg"` |

### Email — Format edge

| Case | ค่า |
|------|-----|
| Valid simple | `user@example.com` |
| Valid subdomain | `user@mail.example.com` |
| Valid + | `user+tag@example.com` |
| Valid IDN | `สมชาย@example.com` (RFC 6531) |
| Max length | 254 char (RFC 5321) |
| Missing @ | `userexample.com` |
| Multiple @ | `user@@example.com` |
| No domain | `user@` |
| No local | `@example.com` |
| IP literal | `user@[192.168.1.1]` |
| Comment | `"user (comment)@example.com"` |

---

## Risk Priority Mapping (default)

ใช้เมื่อ skill เรียง Exec Order:

| Category | Default Risk | เหตุผล |
|----------|:------------:|--------|
| Null | Critical | Crash / NPE เจอบ่อยสุด |
| Empty | Critical | Validation ลืมเสมอ |
| Special-char (XSS/SQLi) | Critical | Security — ห้ามหลุด |
| Overflow | Critical | DoS risk |
| Wrong-type | High | API validation gap |
| Unicode | High | i18n regression |
| Whitespace | High | User-visible UX |
| Above-max | High | BVA standard |
| Boundary-max | Medium | มักเทสแล้ว |
| Boundary-min | Medium | มักเทสแล้ว |
| Format-invalid | Medium | Validation regex |
| Below-min | Medium | BVA standard |
| Precision | Low | Edge case |
| Valid-typical | Low | Happy path (cover by HP scenarios) |

**กฎสำคัญ:** Critical ต้องไม่เกิน 30% ของ row ทั้งหมด — ถ้าเกินแสดงว่า risk rating เฟ้อ ไม่มีประโยชน์

---

## References

- ISTQB Foundation Level — Chapter 4 (Test Techniques)
- ISO/IEC/IEEE 29119-4:2015 — Equivalence Partitioning + Boundary Value Analysis
- OWASP Input Validation Cheat Sheet
- OWASP Top 10 A03 — Injection
- RFC 5321 / RFC 6531 — Email format
- Unicode Standard Annex #15 — Normalization Forms
