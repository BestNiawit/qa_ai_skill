---
name: requirement-analyzer
description: วิเคราะห์ BRD/PRD/SRS/user story ดิบ → ประเมินความพร้อมสำหรับ AI (Readiness Score) + แปลงเป็น Normalized Requirement Template + สร้าง PM/BA Confirmation Doc ส่ง review ก่อนเขียน test case — ป้องกัน garbage-in/garbage-out และ rework รอบใหญ่ตอน PM บอก "เข้าใจผิด". Trigger เมื่อ user ส่ง BRD/PRD/SRS/user story แล้วขอให้ "วิเคราะห์ requirement", "เช็ค BRD พร้อมทำ test case ไหม", "แปลง requirement เป็น template", "ส่ง PM review ก่อน", "requirement readiness", "analyze requirement", "normalize requirement", "pre-TC review". Pre-SDP §5.3.1 (ก่อน Process 2 SIT Test Case).
---

# Requirement Analyzer

> **คำย่อ (BRD / PRD / SRS / FR / AC / TC / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

แปลง BRD/PRD/SRS/user story ดิบ → artifact 3 ชิ้นที่พร้อม **ส่ง PM/BA review และ feed ต่อไป `test-case-writer`**:

1. **Readiness Score Card** — ประเมิน "BRD พร้อมให้ AI ทำ TC หรือยัง?" ตาม 8 criteria — ได้ Ready / Needs-clarification / Not-ready
2. **Normalized Requirement Template** — โครงสร้างกลาง (FR ID, Actor, Precondition, Main Flow, Alt Flow, Business Rules, Acceptance Criteria, Data, NFR, Out-of-scope) ที่ `test-case-writer` ดูดไปใช้ได้ทันที
3. **PM/BA Confirmation Doc** — "นี่คือสิ่งที่ QA เข้าใจจาก BRD — กรุณา confirm / แก้ไข" + list **Open Questions** สำหรับ meeting หรือ async review

**ทำไมถึงสำคัญ:** ถ้า BRD กำกวม → AI เขียน TC จากสมมุติฐานผิด → PM review TC รอบใหญ่ → rework 2-3 วัน
ใช้ skill นี้ก่อน 30 นาที ตัด rework ได้ 2 วัน (net positive สำหรับทุก module ที่ requirement > 10 FR)

**Effort savings:** ~30-40% เทียบกับ QC ไล่ตีความ BRD + นั่งประชุม PM เอง (จาก 1 วัน/module → 3-4 ชม.)

**Key rules:**
- ห้ามเติมข้อมูลที่ไม่มีใน BRD — ถ้าขาด ให้ไปอยู่ใน **Open Questions** เท่านั้น
- Normalized Template ต้อง map 1-1 กับ BRD (มี `Source:` pointer — paragraph/page/user story ID)
- Readiness Score **ต้อง block** การเขียน TC ถ้าผล = Not-ready (ยกเว้น user override ชัดเจน)
- ทุก assumption ที่ AI ใช้ต้องเขียนเป็น "Assumption:" ใน Confirmation Doc ให้ PM confirm

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** Pre-§5.3.1 — เป็น **gate ก่อน Process 2 (SIT Test Case)** — ไม่ได้อยู่ในตาราง SDP 12 AI-Assisted Processes เดิม แต่ป้องกันปัญหา upstream ให้ทุก process ถัดไป

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| ได้ BRD/PRD/SRS มา แต่ไม่แน่ใจว่า "พร้อมทำ TC ไหม" | **`requirement-analyzer`** (skill นี้) |
| BRD เขียนโดย PM/BA ที่ไม่ใช่ technical background | **`requirement-analyzer`** — ช่วย normalize |
| BRD ยาวหลาย page/หลาย user story กระจัดกระจาย | **`requirement-analyzer`** — รวมเป็นโครงเดียว |
| Client ส่ง BRD ภาษาธุรกิจ อยากเช็คกับ PM ก่อนเริ่มทำงาน | **`requirement-analyzer`** — สร้าง Confirmation Doc |
| BRD ชัดแล้ว + มี Acceptance Criteria ครบ | ข้าม skill นี้ → ไป `test-case-writer` เลย |
| มี TC แล้ว อยาก review quality | `test-case-reviewer` |
| อยาก coverage matrix ก่อน (เร็ว) | `test-matrix-generator` |

**Chain position:**
```
BRD/PRD/SRS → requirement-analyzer → [PM/BA confirm] → test-plan-writer
                                                     → test-matrix-generator
                                                     → test-case-writer
```

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| BRD / PRD / SRS / User Story file | ✅ | path ของไฟล์ (Markdown, txt, PDF, DOCX converted) |
| Module ID + Module Title | ✅ | เช่น `PMS_LOG` + "Login" — ใช้ตั้งชื่อ output |
| Project code | ⚠️ | เช่น `KMUTNB`, `PEA` — ใช้ prefix FR ID ถ้า BRD ไม่มี |
| ภาษา output: TH / EN | ✅ | default = ภาษาเดียวกับ BRD |
| Mode: `sit` / `uat` / `both` | — | default = `both` — ถ้า `uat` จะเน้น business language + role flow |
| `project-context.md` | ⚠️ | Glossary, Business Rules, Environment (skill อ่านประกอบ) |
| Existing TC / Plan (ถ้ามี) | — | ถ้าเป็น change request ใส่มาช่วยเปรียบเทียบ scope |

**ถ้า input ไม่ครบ → ถามก่อน:**
- Module ID/Title คืออะไร?
- ภาษา output?
- เป็น new feature หรือ change request?
- มี target audience ของ Confirmation Doc ไหม (PM คนเดียว / BA + PM / client)?

---

## 4. Outputs — สิ่งที่ได้

**3 ไฟล์ (บังคับ) + 1 optional:**

| # | File | Template | เพื่ออะไร |
|---|------|----------|-----------|
| 1 | Readiness Score Card | [`templates/readiness-score-th.md`](templates/readiness-score-th.md) | Gate ตัดสินใจ: ไป TC ต่อได้ หรือต้อง clarify ก่อน |
| 2 | Normalized Requirement Template | [`templates/normalized-requirement-th.md`](templates/normalized-requirement-th.md) | Feed เข้า `test-case-writer` |
| 3 | PM/BA Confirmation Doc | [`templates/pm-confirmation-th.md`](templates/pm-confirmation-th.md) | ส่งให้ PM/BA review ก่อนเริ่มทำ TC |
| 4 | (optional) Combined report | — | รวม 3 ไฟล์ไว้ด้วยกันใน 1 ไฟล์ markdown |

**File naming:**
- `readiness_score_<module_id>_<YYYYMMDD>.md`
- `normalized_req_<module_id>_<YYYYMMDD>.md`
- `pm_confirmation_<module_id>_<YYYYMMDD>.md`

**ตัวอย่าง Readiness Score Card (ย่อ):**
```markdown
# Readiness Score: PMS_LOG (Login)
Overall: **Needs-clarification** (Score 6/8)

| # | Criterion | Status | Note |
|---|-----------|:------:|------|
| 1 | Actor/Role ชัดเจน                   | ✅ | User, Admin |
| 2 | Main Flow มี step                    | ✅ | 5 steps ใน §2.1 |
| 3 | Alt Flow / Error Handling ระบุ       | ⚠️ | มีแค่ "invalid cred" ไม่มี lockout logic |
| 4 | Acceptance Criteria (AC) วัดได้       | ❌ | เขียนแค่ "login สำเร็จ" — ไม่มี criteria |
| 5 | Business Rules ครบ                   | ✅ | password policy, session timeout ระบุ |
| 6 | Data / Input format ชัด              | ✅ | email + password (≥8 char) |
| 7 | NFR (perf / security) ระบุ           | ⚠️ | security ไม่ระบุ (HTTPS, brute force) |
| 8 | Out-of-scope ระบุ                    | ❌ | ไม่มี — อาจเข้าใจผิด SSO included |
```

**ตัวอย่าง Normalized Requirement (ย่อ):**
```markdown
## FR_PMS_LOG_01 — Login ด้วย email + password
**Source:** BRD §2.1 (page 3)
**Actor:** End User
**Precondition:** มี account ที่ activate แล้ว
**Main Flow:**
  1. User เปิดหน้า Login
  2. กรอก email + password
  3. กด "Login"
  4. ระบบ validate → redirect dashboard
**Alt Flow / Error:**
  - invalid cred → "Email or password ไม่ถูกต้อง"
  - [Assumption: account lockout หลัง fail 5 ครั้ง — ไม่มีใน BRD]  ← ใน Confirmation Doc
**Acceptance Criteria:**
  - [Assumption: Login ต้อง < 3 วินาที]
  - [Assumption: Session timeout 30 นาที idle]
**Business Rules:** Password ≥ 8 ตัว (BRD §2.3)
**Data:** email (string), password (string, masked)
**NFR:** [TBD — ถาม PM]
**Out-of-scope:** [TBD — ถาม PM: SSO / Social Login?]
```

**ตัวอย่าง PM/BA Confirmation Doc (ย่อ):**
```markdown
# สิ่งที่ QA เข้าใจจาก BRD — ขอ Confirm ก่อนเขียน TC
**Module:** PMS_LOG — Login
**Reviewer:** คุณ <PM name>
**Deadline for feedback:** 2026-04-24

## ✅ สิ่งที่ชัดเจนแล้ว
- Login ด้วย email + password (FR_PMS_LOG_01)
- Password policy ≥ 8 ตัว (FR_PMS_LOG_03)

## ❓ Open Questions (ต้อง confirm)
1. **Lockout policy:** ถ้า fail > N ครั้ง — lock account? N=? unlock ยังไง?
2. **Session timeout:** กี่นาที idle → kick out?
3. **SSO / Social Login:** included ใน scope sprint นี้?
4. **NFR — Login response time:** ต้อง < กี่วินาที?
5. **NFR — Security:** require HTTPS? brute-force protection?

## 🔍 Assumptions ที่ QA ใช้ไปก่อน (confirm หรือแก้)
- [A1] Login response < 3s (industry standard)
- [A2] Session timeout = 30 min (common default)
- [A3] No SSO in sprint 1

**ถ้า Assumption ข้อไหนผิด → บอก QA ก่อน 2026-04-24 เพื่อปรับก่อนเขียน TC**
```

---

## 5. Process — ขั้นตอน

### Step 1: Read Input
1. อ่าน BRD/PRD/SRS ทั้งหมด — ห้ามสรุปจาก executive summary อย่างเดียว
2. อ่าน `project-context.md` (Glossary, Business Rules)
3. ถ้าเป็น change request — อ่าน existing TC/spec ด้วย

### Step 2: Ask User (ถ้า input ไม่ครบ)
- Module ID/Title, ภาษา output, Mode (sit/uat/both), target audience ของ Confirmation Doc

### Step 3: Readiness Scoring (8 Criteria)

| # | Criterion | Pass Condition |
|---|-----------|----------------|
| 1 | **Actor/Role** ชัดเจน | มี role name + permission description |
| 2 | **Main Flow** มี step | Happy path 3+ steps นับเป็นข้อได้ |
| 3 | **Alt Flow / Error Handling** | ระบุ error case + expected behavior |
| 4 | **Acceptance Criteria** วัดได้ | Measurable (ไม่ใช่ "ทำงานถูกต้อง") |
| 5 | **Business Rules** ครบ | Formula, constraint, validation rule ระบุ |
| 6 | **Data / Input format** | Field name, type, length, required/optional |
| 7 | **NFR** (perf/security/compat) | อย่างน้อย p95/error rate/HTTPS ระบุบางส่วน |
| 8 | **Out-of-scope** ระบุ | ชัดเจนว่าอะไรไม่ทำ (กัน scope creep) |

**Scoring:**
- **Ready (7-8):** ไป `test-case-writer` ได้เลย
- **Needs-clarification (4-6):** ต้องได้ confirm จาก PM ก่อน
- **Not-ready (0-3):** ต้องให้ PM/BA เขียนเพิ่มก่อน — ห้ามเริ่ม TC

### Step 4: Normalize Requirement
- แตกเป็น FR IDs: `FR_<MODULE>_<NUM>` (ถ้า BRD ไม่ได้ numbered)
- ทุก FR ต้องมีทุก field: Actor / Precondition / Main Flow / Alt Flow / AC / Business Rules / Data / NFR / Out-of-scope
- **ช่องที่ไม่มีใน BRD:** ใส่ `[Assumption: ...]` หรือ `[TBD — ถาม PM]` — **ห้ามปล่อยว่าง ห้ามแต่งเอง**
- ทุก FR ต้องมี `**Source:**` pointer (section/page/user story ID) — เพื่อ traceability กลับ BRD

### Step 5: Confirmation Doc
- **Section 1** — สิ่งที่ชัดแล้ว (bullet list, FR ID + สรุป 1 บรรทัด)
- **Section 2** — Open Questions (เรียงความสำคัญ, numbered)
- **Section 3** — Assumptions ที่ QA ใช้ (A1, A2, ... — ให้ PM confirm/reject ทีละข้อ)
- **Deadline for feedback** — set 2-3 วันทำการ (ให้ทีม QA เริ่มทำงานต่อได้)

### Step 6: Save + Summary
แจ้ง user:
- Overall Readiness Score + ตัดสินใจ (Ready/Needs/Not-ready)
- จำนวน FR ที่ normalize ได้ + จำนวน Open Questions
- Gap highlights (criterion ที่ Fail/Warn สำคัญสุด)
- **Recommended next step:**
  - Ready → `test-plan-writer` + `test-case-writer`
  - Needs-clarification → ส่ง Confirmation Doc ให้ PM ก่อน
  - Not-ready → ประชุม requirement clarification กับ PM/BA

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Readiness Score Card
- [ ] 8 criteria ประเมินครบ (ไม่ข้าม)
- [ ] Status (✅/⚠️/❌) พร้อม note ระบุที่มา (section/quote)
- [ ] Overall Score คำนวณถูก (1 pt per ✅, 0.5 per ⚠️, 0 per ❌)
- [ ] Recommended next step ชัดเจน

### Normalized Requirement
- [ ] ทุก FR มี unique ID + `**Source:**` pointer
- [ ] ครบ 9 fields ทุก FR (ไม่ปล่อยว่าง)
- [ ] ช่องที่ไม่มีใน BRD = `[Assumption: ...]` หรือ `[TBD]` — ไม่ใช่การเดา
- [ ] Map ครบทุก requirement ใน BRD (coverage 100%)
- [ ] ไม่มี FR ที่ไม่ได้อ้าง BRD (ห้ามแต่งเอง)

### PM/BA Confirmation Doc
- [ ] มี Module + Reviewer + Deadline
- [ ] Open Questions numbered + เรียงตามความสำคัญ
- [ ] Assumptions มี ID (A1, A2, ...) เพื่อ confirm ทีละข้อ
- [ ] ภาษา = ภาษาที่ PM/BA เข้าใจ (ไม่ technical เกิน)

### Red Flags (Reject ทันที)
- ❌ Normalize โดยแต่ง Acceptance Criteria ที่ไม่มีใน BRD (ห้าม assume เงียบๆ)
- ❌ Readiness Score = Ready แต่มี Open Questions > 3 ข้อ (inconsistent)
- ❌ FR ไม่มี Source pointer (traceability เสีย)
- ❌ ภาษา Confirmation Doc เป็น technical jargon ที่ PM อ่านไม่รู้เรื่อง

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI ชอบ **เติม Acceptance Criteria** จาก common sense — ต้องใส่เป็น `[Assumption]` เสมอ
- ❌ AI ชอบ **ข้าม Out-of-scope** (มองไม่เห็นว่าสำคัญ) — ต้อง flag เป็น Open Question ถ้าไม่มีใน BRD
- ❌ AI ชอบ **ตีความ "user"** เป็น single role — ถ้า BRD มี multi-role ต้องแยกชัด
- ❌ AI ชอบ **รวม FR หลายข้อเป็นข้อเดียว** — ถ้า BRD มี 2 behaviour ในประโยคเดียว ให้แยกเป็น 2 FR

**ข้อห้าม:**
- ❌ แต่ง FR ที่ไม่มีใน BRD
- ❌ แปลงภาษา business → technical โดยไม่ระบุว่าเป็น interpretation
- ❌ Confirmation Doc ที่ไม่มี Assumption block (ทำให้ PM review ไม่รู้ว่า QA สมมุติอะไรไว้)
- ❌ ปล่อย Readiness Score = Ready ถ้ามี criterion ใด Fail

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream (feed เข้า):**
- ไม่มี — skill นี้เป็น entry point ของ workflow ใหม่ (BRD → QA world)

**Downstream (รับต่อ):**
- `test-plan-writer` — อ่าน Normalized Requirement → วางแผน scope + schedule
- `test-matrix-generator` — ใช้ FR IDs → coverage matrix
- `test-case-writer` — อ่าน Normalized Requirement → เขียน SIT/UAT TC (coverage 100% ต่อ FR)
- `test-case-reviewer` — ใช้ Normalized Requirement เป็น "spec of truth" ตอน review TC

**Workflow ตัวอย่าง:**
```
BRD/PRD (จาก PM/BA)
    ↓
requirement-analyzer
    ├→ Readiness Score Card → ถ้า Not-ready: หยุด + แจ้ง PM
    ├→ Normalized Requirement (FR IDs + 9 fields)
    └→ PM Confirmation Doc
         ↓
    [PM/BA review + confirm Open Questions]
         ↓
  [Update Normalized Requirement ตาม PM feedback]
         ↓
test-plan-writer  +  test-case-writer  +  test-matrix-generator
         ↓
    ... (SIT / UAT flow ปกติ)
```

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md) — AI usage guardrails
- [`references/brd-readiness-guide.md`](../../references/brd-readiness-guide.md) — **1-page guide สำหรับ PM/BA: "เขียน BRD แบบไหนพร้อมให้ AI ทำ TC"** (cross-link — ส่งให้ PM อ่านก่อนเขียน BRD รอบหน้า)
- [`references/qa-standards.md`](../../references/qa-standards.md) — Severity/Priority/Sizing scales
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md) — SDP Process mapping
- External: IEEE 830 (SRS), ISO/IEC/IEEE 29148:2018 (Requirements Engineering), INVEST criteria (User Story quality)
