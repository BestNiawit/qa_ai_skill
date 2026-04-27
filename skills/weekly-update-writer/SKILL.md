---
name: weekly-update-writer
description: เขียน Weekly Update email จาก QA Lead Weekly Review (markdown หรือ note) ออกมาเป็น email ภาษาธรรมชาติแบบคนเขียนจริง ไม่ใช่ AI-speak — รองรับ audience (C-level / Manager / Team / Cross-functional) และ tone (formal / semi-formal / friendly) ครอบคลุม Progress, AI Effort Savings KPI, Blockers with Asks, Next-week Plan. Trigger เมื่อ user ขอ weekly update, weekly review email, status email, weekly summary, "เขียนเมล weekly", "สรุป weekly update", "weekly email C-level", "QA weekly report email".
---

# Weekly Update Writer

> **คำย่อ (SIT / UAT / TC / KPI / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

Distill QA Lead Weekly Review (full markdown/note) → concise email ที่เขียนเป็น prose ธรรมชาติแบบคนเขียนเมลจริง ไม่มีกลิ่น AI

**Key rules:**
- Output ต้อง **อ่านแล้วเหมือนคนเขียน** ไม่ใช่ AI สรุป (ดู §7 + [`references/anti-ai-language.md`](references/anti-ai-language.md))
- Audience-aware — C-level เน้นผลลัพธ์ + asks, Manager เน้น progress + blockers, Team เน้นรายละเอียดงาน
- ต้องเก็บ AI Effort Savings KPI (SDP §5.3.4) ไว้ในเมลถ้า input มี — นี่คือ KPI ทีม
- Blocker ทุกข้อต้องมี **Ask + ผู้รับ ask** ชัดเจน (ไม่ใช่บ่นลอย ๆ)
- ใช้ speaker particle ตาม gender ของผู้เขียน (ครับ / ค่ะ) — ถ้าไม่รู้ต้องถาม

**Effort savings:**
~70% (SDP §5.3.4 pattern) — จาก 1-2 ชม. draft manual → 20-30 นาที (AI draft + user review)

---

## 2. When to Use — เมื่อไหร่ใช้

**Use case:** QA Lead ต้องส่ง weekly update หลังจบสัปดาห์ ให้ C-level / Manager / Cross-functional ทราบสถานะ

| สถานการณ์ | ใช้ skill นี้ |
|-----------|:-------------:|
| QA Lead มี Weekly Review .md อยู่แล้ว ต้อง distill เป็น email | ✅ |
| อยากได้เมล weekly สำหรับส่ง CTO / C-level | ✅ |
| อยากได้ team update / cross-functional update | ✅ |
| SIT/UAT Report per-release | ❌ ใช้ [`test-report-writer`](../test-report-writer/) แทน |
| Status update per-sprint (engineering-wide) | ❌ ใช้ PM ทำ — skill นี้ QA-focused |

**Related skills comparison:**

| Skill | Scope | Audience | Frequency |
|-------|-------|----------|-----------|
| `weekly-update-writer` (this) | QA team status + initiatives | C-level / Manager / Team | Weekly |
| `test-report-writer` | จบ SIT/UAT/Perf 1 รอบ | TL / PM / User | Per release |
| `bug-report-writer` | 1 defect | Dev / PM | Per bug |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Weekly Review content | ✅ | .md file / bullet notes / verbal summary |
| Audience | ✅ | C-level / Manager / Team / Cross-functional |
| Tone | ✅ | formal / semi-formal / friendly |
| Language | ✅ | TH / TH+EN (technical terms) / EN |
| Speaker particle | ✅ | ครับ / ค่ะ — ถาม user ถ้าไม่ชัด |
| Sender name | ✅ | ใช้ใน signature |
| Recipient name | ⚠️ | ถ้ามี ใส่ใน greeting; ถ้าไม่มี ใช้ `[ชื่อผู้บริหาร]` placeholder |
| AI Effort Savings data | ⚠️ | ถ้ามี ใส่ตาราง KPI — ถ้าไม่มี ข้ามไป |
| `project-context.md` | ⚠️ | override ค่า default (speaker particle, org tone) |

**Weekly Review structure ที่ skill เข้าใจได้:**
- TL;DR / Progress / Blockers / Next week / Asks (ตาม QA Lead Weekly Review template)
- หรือ bullet notes ทั่วไป — AI จะ extract section เอง แต่อาจต้องถาม clarification

**ต้องถาม user ถ้า input ไม่ครบ:**
1. Audience เป็นใคร (C-level vs Manager vs Team)?
2. Tone ไหน (formal / semi-formal / friendly)?
3. ใช้ ครับ หรือ ค่ะ?
4. มี AI Effort Savings data ที่อยากโชว์ไหม?

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown (render เป็นเมลได้ทันที — paste ลง Outlook/Gmail)

**Templates:**
- C-level: [`templates/c-level-th.md`](templates/c-level-th.md)
- Manager: [`templates/manager-th.md`](templates/manager-th.md)
- Team: [`templates/team-th.md`](templates/team-th.md)

**File naming:** `weekly_update_<audience>_<YYYY-MM-DD>.md`

**Structure (C-level variant):**
```
Subject: QA Weekly Update — <date>

เรียน <recipient>

<paragraph 1: hook — สัปดาห์นี้งานเดินไปแค่ไหน + มี ask ไหม>

สรุปสั้น ๆ
<prose 2-4 บรรทัด — Kick off / rollout อะไร + next week focus>

งานที่เดินในสัปดาห์นี้
- <initiative 1>: <1 บรรทัด status>
- <initiative 2>: <1 บรรทัด status>
- <initiative 3>: <1 บรรทัด status>

<paragraph: AI Effort Savings context — ถ้ามี>
<table: Artifact | Manual | AI-Assisted | Savings>

Blocker ที่อยากขอ support จาก <ผู้รับ ask>
<prose describing blocker + ask>

Plan สัปดาห์หน้า
1. Critical <งาน>
2. High <งาน>
3. Medium <งาน>

ขอบคุณ<particle>
<sender name>
```

**Variants:**
- **Manager:** + section "Team health" (น้องในทีม, resource allocation)
- **Team:** + section "กำลังแบ่งงาน", ไม่ต้อง Asks ถึง C-level
- **Cross-functional:** + explicit "ต้องการจาก Dev/PM อะไร"

---

## 5. Process — ขั้นตอน

### Step 1: Read Input
1. Read Weekly Review markdown / notes
2. Extract sections: Progress, Blockers, Plan, Asks, KPI/Metrics

### Step 2: Ask User (ถ้าขาด)
ใช้ AskUserQuestion ถามพร้อมกัน:
- Audience?
- Tone?
- Speaker particle (ครับ / ค่ะ)?
- Language preference?

### Step 3: Content Mapping
Map section ของ input → section ของ email ตาม audience:

| Input Section | C-level | Manager | Team |
|---------------|:-------:|:-------:|:----:|
| TL;DR | ✅ สั้น | ✅ | ⚠️ ข้ามได้ |
| Initiative Progress | ✅ เน้นผลลัพธ์ | ✅ เน้น status | ✅ เน้นงาน |
| Initiative detail (ใครทำอะไร) | ⚠️ 1-2 บรรทัด | ✅ เต็ม | ✅ เต็ม |
| AI Effort Savings KPI | ✅ บังคับ | ✅ | ⚠️ optional |
| Blockers | ✅ + Ask | ✅ + Ask | ⚠️ ขึ้นกับเคส |
| Plan next week | ✅ Critical/High/Medium | ✅ | ✅ |
| Asks / Decisions | ✅ บังคับ | ✅ | ❌ |

### Step 4: Draft ด้วย Anti-AI Language Rules (สำคัญ!)
อ้าง [`references/anti-ai-language.md`](references/anti-ai-language.md) — หลัก ๆ:

**ห้ามใช้ใน prose:**
- Em dash (—) → ใช้ comma, จุด, หรือคำว่า "คือ" / "ได้แก่"
- `~` (tilde) เป็น prefix เลข → ใช้ "ประมาณ"
- Header แบบ "TL;DR", "Highlights", "Key Metrics" → ใช้ไทยว่า "สรุปสั้น ๆ", "งานที่เดินในสัปดาห์นี้"
- "early signal", "alignment", "stakeholder sync" (consultant-speak) → แปลเป็นภาษาพูด
- Emoji เยอะเกิน (🚀 ✅ 🔴) — C-level อาจไม่ชอบ ใช้แค่ ✅ / ❌ / ⚠️ ใน Quality Gate เท่านั้น
- Bold ทุก 2-3 คำ → ใช้เท่าที่จำเป็น
- "ค่ะ/ครับ" เวอร์ชันรวมกัน → เลือกอย่างใดอย่างหนึ่งตาม gender ของ sender

**ใช้ได้ (ปกติในที่ทำงาน):**
- Kick off, rollout, align, adopt, calibrate, allocate, baseline, on track, blocker
- Critical / High / Medium
- Framework / repo / pipeline / stack / coverage

### Step 5: Consistency Check
- จำนวน initiative ใน TL;DR = จำนวนใน Highlights
- Blocker ทุกข้อมี ask + ผู้รับ ask
- Speaker particle ตรงกับ gender ที่ user ระบุ
- ถ้าอ้าง SDP §X — เลข section ตรงกับ input

### Step 6: Save + Summary
- Save `.md` file
- แสดง preview
- ถามว่าอยาก copy เป็น plain text / ส่งเป็น .docx ต่อไหม

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] Subject line ระบุ week ชัด (e.g. "QA Weekly Update — 23 Apr 2026")
- [ ] เปิดด้วย hook 1 ประโยคสรุปภาพรวม
- [ ] มี "งานที่เดินในสัปดาห์นี้" พร้อม status per initiative
- [ ] Blocker ทุกข้อ มี Ask + ผู้รับ ask
- [ ] Plan สัปดาห์หน้า จัด priority (Critical/High/Medium)
- [ ] Speaker particle ถูกต้อง (ครับ หรือ ค่ะ เลือกอย่างเดียว)
- [ ] Signature มีชื่อ + role
- [ ] ถ้ามี AI Effort Savings → ใส่ตาราง KPI

### Nice to Have
- [ ] Consistency: จำนวน initiative ใน TL;DR = Highlights
- [ ] Blocker link ไปยัง Jira ticket / doc ที่เกี่ยวข้อง
- [ ] Call to action ชัด (เช่น "ขอ reply ภายใน ศุกร์")

### Red Flags (Reject)
- ❌ มี em dash (—) ใน prose paragraph
- ❌ Header เป็น "TL;DR" / "Highlights" (AI-speak)
- ❌ มี "ค่ะ/ครับ" คู่กัน (AI ขี้เกียจเลือก)
- ❌ Blocker ลอย ๆ ไม่มี Ask
- ❌ "Recommendation: On track" โดยไม่มี evidence
- ❌ Bullet รัว ๆ เกิน 70% ของเมล (ควรมี prose paragraph คั่น)
- ❌ ใส่ข้อมูล sensitive (PII, internal IP, employee salary)

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`../../references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**

**Anti-AI Language (critical):** อ่าน [`references/anti-ai-language.md`](references/anti-ai-language.md) ก่อน draft

**สิ่งที่ AI ทำพลาดบ่อย:**
- ⚠️ ใส่ em dash (—) เยอะเกินจริง — คนไทยไม่ค่อยใช้ในเมล
- ⚠️ Over-structure — ทำทุกอย่างเป็น bullet list แม้ 2 ข้อก็ทำเป็น table
- ⚠️ Consultant-speak ("leverage", "synergy", "align stakeholders") — ภาษา pretentious
- ⚠️ ใส่ "ค่ะ/ครับ" แทนที่จะเลือก — ต้องถาม sender gender
- ⚠️ Hallucinate ตัวเลข KPI — ถ้า input ไม่มี ห้ามคิดเอง
- ⚠️ เขียน C-level version แต่ใส่ detail ระดับ team — ผิด audience

**ข้อห้าม:**
- ❌ อย่ารวมข้อมูลจากหลาย week เข้า email เดียวโดยไม่บอก
- ❌ อย่าใช้ emoji เกิน 3 ตัวใน C-level email
- ❌ อย่าเขียน Asks ลอย — ต้อง tag ผู้รับ ask ชัด
- ❌ อย่า paraphrase blocker แบบอ่อนลง (ถ้า user เขียนว่า "กระทบคุณภาพ" ห้ามเปลี่ยนเป็น "อาจมี impact")

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream (feed เข้า):**
- QA Lead Weekly Review markdown (manual, ไม่มี skill generate)
- [`test-report-writer`](../test-report-writer/) — SIT/UAT report summary → นำมาใส่ Highlights ได้
- [`bug-report-writer`](../bug-report-writer/) — count of critical bugs → ใส่ใน Blockers ได้

**Downstream (รับต่อ):**
- Email client (Outlook / Gmail) — paste markdown
- [Manual: docx export] — ถ้าต้องส่ง formal

**Workflow ตัวอย่าง:**
```
[QA Lead writes Weekly Review .md ใน Notion/Obsidian]
                ↓
        weekly-update-writer (audience=c-level, tone=semi-formal)
                ↓
        [Review + manual edit]
                ↓
        [Send to C-level]
                ↓
        [Feedback loop: ปรับ tone / detail ครั้งหน้า]
```

**Chain with test-report-writer:**
```
test-report-writer (SIT Report) ──┐
bug-report-writer (critical bugs)─┼→ input signals สำหรับ
[manual weekly notes] ────────────┘    weekly-update-writer
                                          ↓
                                   weekly email to C-level
```

---

## References
- [`references/anti-ai-language.md`](references/anti-ai-language.md) — guideline หลีกเลี่ยงภาษา AI
- [`../../references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`../../references/sdp-mapping.md`](../../references/sdp-mapping.md)
- `templates/` — c-level / manager / team
- `examples/` — ตัวอย่าง input → output จริง
