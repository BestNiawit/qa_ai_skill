---
name: bug-report-writer
description: สร้าง bug report ที่มีโครงสร้างมาตรฐาน พร้อมใช้ใน Jira/Linear/GitHub Issues — ครอบคลุม title, environment, steps to reproduce, expected vs actual, severity, priority, attachments. รองรับภาษาไทยและอังกฤษ. Trigger เมื่อ user รายงานปัญหา/bug ที่พบจากการทดสอบ และขอให้เขียนเป็น bug report, defect report, issue, "log a bug", "report defect". Maps to SDP §5 (ทดสอบ SIT/UAT → Jira Card).
---

# Bug Report Writer

> **คำย่อ (SIT / UAT / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

เขียน bug report ที่ developer อ่านแล้ว **reproduce ได้ทันที** ไม่ต้องถามกลับ

**Key rules:**
- Title = `[Module] Action → Symptom เมื่อ Condition`
- แยก Severity (impact) vs Priority (urgency) — ห้ามรวมกัน
- ใช้ Severity/Priority ตาม [qa-standards.md §1-§2](../../references/qa-standards.md) — **Critical/Major/Minor/Trivial + Critical/High/Medium/Low** (OneD TEST DEFINITION template)
- **Action Label** ระบุจาก Severity × Priority Matrix ([qa-standards §2.1](../../references/qa-standards.md#21-severity-priority-matrix-action-label)) — เช่น Blocker, Urgent, Standard High
- Steps reproduce เป็นข้อๆ มีเบอร์ + precondition ชัด
- Expected ≠ Actual ต้องเห็นต่างชัดเจน
- Attach: screenshot / log / HAR file

**Effort savings:** ลดเวลาเขียน bug + ลดรอบ "Dev ถามกลับ" (ไม่มีตัวเลขใน SDP §5.3.4 แต่เป็น defect quality improvement)

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5 Testing — "ทดสอบ SIT / UAT" → output = Jira Card (defect)

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| เจอ bug ระหว่าง test execution | **`bug-report-writer`** (skill นี้) |
| อยากรวม bug หลายตัวเป็น weekly defect summary | `test-report-writer` (SIT/UAT Report มี Defect Summary section) |
| Perf test fail threshold → defect | **`bug-report-writer`** + attach `perf-result-analyzer` output |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| ข้อมูล | Required | หมายเหตุ |
|-------|:--------:|----------|
| อาการที่พบ | ✅ | "เกิดอะไรขึ้น" |
| Steps to reproduce | ✅ | ทำตามแล้ว bug ขึ้นซ้ำได้ |
| Expected behavior | ✅ | ควรเป็นอย่างไร |
| Actual behavior | ✅ | เป็นอย่างไรจริง |
| Environment | ✅ | OS, browser/app version, device, network |
| URL/screen ที่เจอ | ✅ | ถ้าเป็น web/mobile |
| Severity | ✅ | impact ทางเทคนิค |
| Priority | ⚠️ | ความเร่งด่วน (อาจให้ PM ตัดสิน) |
| Frequency | ⚠️ | always / sometimes / once |
| Test data | ⚠️ | account, input ที่ใช้ |
| Attachments | ⚠️ | screenshot, video, log, HAR |
| Related TC ID / Ticket | ⚠️ | regression จาก ticket ไหน |
| ภาษา output | ✅ | TH / EN |

**ถ้าข้อมูลไม่ครบ → ถามก่อนเขียน** (อย่าเดา)

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown (พร้อม paste ลง Jira/Linear/GitHub Issues)

**Templates:**
- TH: [`templates/bug-report-th.md`](templates/bug-report-th.md)
- EN: [`templates/bug-report-en.md`](templates/bug-report-en.md)

**File naming:** `bug_<module>_<short-symptom>_<YYYYMMDD>.md`
ตัวอย่าง: `bug_checkout_coupon-freeze_20260420.md`

**Structure:**
```
Title: [Module] Action → Symptom เมื่อ Condition
---
Environment: OS, Browser, Version, URL
Severity: Critical / Major / Minor / Trivial  (ตาม qa-standards.md §2)
Priority: Critical / High / Medium / Low  (ตาม qa-standards.md §1)
Action Label: <จาก Severity × Priority matrix §2.1>  (e.g. Blocker, Urgent, Standard High)
Frequency: Always/Sometimes/Once
Related: TC-ID / Epic / Related ticket
---
## Steps to Reproduce
1. ...
2. ...
3. ... ← bug เกิดที่นี่

## Expected
...

## Actual
...

## Attachments
- screenshot-1.png
- network.har
- console.log
```

---

## 5. Process — ขั้นตอน

### Step 1: รวบรวมข้อมูล
ตรวจ 12 ข้อใน §3 ครบหรือยัง — ถ้าขาด **ถามก่อนเขียน**

### Step 2: ถามภาษา
TH หรือ EN

### Step 3: เขียน Title

**Pattern:** `[<Module>] <Action> ทำให้เกิด <Symptom> เมื่อ <Condition>`

✅ ดี:
- `[Login] กดปุ่ม Submit แล้วหน้าค้าง เมื่อ email มี whitespace นำหน้า`
- `[Checkout] ยอดรวมคำนวณผิด เมื่อใช้ coupon ซ้อนกัน 2 ใบ`

❌ แย่:
- `bug` / `ระบบพัง` / `ใช้ไม่ได้` (ไม่บอก module + symptom + condition)

### Step 4: แยก Severity vs Priority

**ห้ามรวมกัน** — สองอันนี้คนละเรื่อง (ดู [qa-standards.md §1-§2](../../references/qa-standards.md)):

| Severity (impact ทางเทคนิค) | Priority (ความเร่งด่วน) |
|---------------------------|-------------------------|
| **Critical** — ระบบพัง / feature หลักใช้ไม่ได้ / data corruption / security breach | **Critical** — แก้ทันทีวันนี้ block release |
| **Major** — feature สำคัญพัง มี workaround / integration fail | **High** — แก้ใน sprint นี้ |
| **Minor** — UI ผิดเล็กน้อย / validation ไม่ครบ / edge case | **Medium** — แก้ sprint หน้า |
| **Trivial** — typo / alignment / สีไม่ตรง / icon หาย | **Low** — แก้เมื่อมีเวลา |

**Mapping คำอื่น → new scale (legacy):**
- "Blocker" (Jira) → Severity Critical + Priority Critical = **Action Label: Blocker**
- "S1 / P0" (legacy) → Critical
- "Cosmetic" → Severity Trivial

**เพิ่ม Action Label จาก Matrix ([qa-standards §2.1](../../references/qa-standards.md#21-severity-priority-matrix-action-label))** — เช่น:
- Severity Critical × Priority Critical = **Blocker**
- Severity Major × Priority High = **Standard High**
- Severity Trivial × Priority Low = **Optional**

ตัวอย่าง: typo บนหน้า login (Severity Trivial) แต่ลูกค้าใหญ่บ่น → Priority Critical → Action Label = **Non-critical but Visible**

### Step 5: Steps to Reproduce ต้องชัด
- เป็นข้อๆ เรียงเลข
- เริ่มจาก state ที่รู้ (logged out, fresh DB)
- ระบุ test data ที่ใช้ (redact sensitive)
- highlight ขั้นที่ bug เกิด

✅ ดี:
```
Precondition: logged in as customer with empty cart
Steps:
1. Go to /products/SKU-12345
2. Click "Add to cart"
3. Click "Add to cart" อีกครั้งภายใน 1 วินาที ← bug เกิดที่นี่
```

❌ แย่: `กดปุ่ม add to cart แล้วพัง`

### Step 6: Expected vs Actual

แยก 2 หัวข้อชัดเจน:
- **Expected:** ระบบควรเพิ่ม quantity เป็น 2
- **Actual:** ระบบ add เป็น 2 record แยก, quantity 1 + 1

### Step 7: ใช้ Template + Save

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] Title มี module + symptom + condition
- [ ] Environment ครบ (OS, browser, version, URL)
- [ ] Steps reproduce ได้แน่นอน (ทำตามทีละข้อ)
- [ ] Expected ≠ Actual ระบุชัด
- [ ] Severity + Priority แยกกัน
- [ ] มี screenshot/log ถ้าเป็น UI/error
- [ ] ไม่ใช้คำกำกวม ("พัง", "ใช้ไม่ได้")

### Nice to Have
- [ ] Related TC ID / Epic ชี้กลับ test case
- [ ] Frequency ระบุ (always/sometimes/once)
- [ ] Browser console error / network log

### Red Flags (Reject)
- ❌ ไม่มี Steps to Reproduce
- ❌ รวม 2 bugs ใน 1 report
- ❌ มี password/PII จริง (ไม่ redact)

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจ **เดา steps** ถ้า user ให้ข้อมูลไม่ครบ → บังคับถามก่อน (§3)
- ❌ AI อาจ **รวม symptom + root cause** ใน title → แยกให้ชัด (Bug report บอก symptom, RCA ทำทีหลัง)

**ข้อห้าม:**
- ❌ เขียนถ้าข้อมูลไม่พอ — ต้องถาม user ก่อน
- ❌ ใส่ความเห็นส่วนตัว/ตำหนิ developer
- ❌ ใส่ข้อมูล sensitive (password จริง, PII) — ใช้ `[REDACTED]`
- ❌ รวม 2 bugs ใน 1 report — แยกแต่ละ defect

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream (feed เข้า):**
- `test-case-writer` — TC ที่ Test Result=Fail → feed Actual + screenshot เข้า skill นี้
- `perf-test-generator` + `perf-result-analyzer` — threshold fail → feed raw data + analysis เข้า skill นี้
- Execution result (Jira/Excel/screenshot) — manual input

**Downstream (รับต่อ):**
- Paste ลง Jira/Linear/GitHub Issues (ไม่ใช่ skill — แต่เป็น tool ปลายทาง)
- `test-report-writer` — bug list รวมไปใน SIT/UAT Report section "Defect Summary"

**Workflow ตัวอย่าง:**
```
test-case-writer → [execute] → TC fail
                                  └→ bug-report-writer → Jira Card
                                                           └→ test-report-writer (Defect Summary)
```

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- [`templates/bug-report-th.md`](templates/bug-report-th.md)
- [`templates/bug-report-en.md`](templates/bug-report-en.md)
- External: IEEE 1044 (Software Anomaly Classification)
