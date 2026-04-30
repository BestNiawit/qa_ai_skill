# Examples — weekly-update-writer

ตัวอย่าง input → output จริง เพื่อเทรน skill และใช้อ้างอิง

---

## Example 1: C-level email จาก QA Lead Weekly Review

### Input

**File:** `QA Lead Weekly Review — Week of [2026-Apr-23].md`

```markdown
# QA Lead Weekly Review — Week of [2026-Apr-23]

## 1. TL;DR
- Progress:
  - Test Automation rollout: Athm, dtmu, OIE ISingleForm
  - QA AI Skill: 14 skill สำหรับเริ่มงาน
  - Automation starter kit (Robot, Playwright, K6)
  - คุยกับ PM ของ 3 โปรเจค
- Blocker: Timeline ขยับโดยไม่แจ้ง tester ล่วงหน้า
- สัปดาห์หน้า: Athm มจพ

## 2. Initiative Progress
| Initiative | Status | This week | Next step |
|-----------|--------|-----------|-----------|
| Test Automation rollout | 🟢 | คุยกับ PM | Booking time |
| QA AI skill | 🟢 | น้อง 4 คน adopt | ให้ใช้จริงจัง |
| Measurement framework | 🟢 | Align metric | Review |
| Automation starter kit | 🟢 | เตรียม 3 stack | Rollout |

## 3. Blockers
- Timeline shift → จัด resource ไม่ทัน → Need CTO help

## 4. Plan สัปดาห์หน้า
- Critical: Athm มจพ
- High: Booking time น้อง automation
- Medium: AI process guideline
```

**User input to skill:**
- Audience: C-level
- Tone: semi-formal
- Speaker: ผู้ชาย (ใช้ ครับ)
- Language: TH + EN technical terms
- AI Effort Savings: ใส่ (มาจาก SDP §5.3.4)

### Expected Output

```
Subject: QA Weekly Update — 23 Apr 2026

เรียน คุณ [ชื่อผู้บริหาร]

สรุป QA weekly update สัปดาห์นี้ครับ งานหลักยัง on track ทั้งหมด มี 1 ประเด็นอยากขอ
support จากพี่ชายด้านล่างครับ

สรุปสั้น ๆ
สัปดาห์นี้ kick off Test Automation กับ 3 โปรเจค (Athm, dtmu, OIE ISingleForm),
ปล่อย QA AI Skill 14 ตัวให้น้อง ๆ เริ่มใช้จริง, และเตรียม Automation starter kit
(Robot / Playwright / K6) โดยเริ่มเอาน้อง ๆ เข้ามาใน repo แล้ว สัปดาห์หน้าผมจะ
โฟกัส Athm มจพ automation เป็น Critical โดยเบสลงไปทำเองในส่วน test case กับ test matrix
ส่วนเรื่อง executor ถ้าไม่ทันจะรีบแจ้งพี่ชายครับ

งานที่เดินในสัปดาห์นี้
- Test Automation rollout: align scope กับ PM ครบ 3 โปรเจค repo พร้อมใช้งานแล้ว
  (ATHM_Automation, dtmu-haos-automation, OIE ISingleForm)
- QA AI Skill: น้อง 4 คนเริ่ม adopt แล้ว ได้แก่ มาย (test-matrix-generator),
  มะเดี่ยว (Test plan), ไบร์ท และ ไอซ์ (Test automation generator) ช่วงแรกที่ใช้ดู
  ลดเวลาทำงานได้ประมาณ 40% โดยเฉพาะตอน create test case
- Automation starter kit: Robot / Playwright / K6 ครบ พร้อม rollout

หลังจากเอา AI เข้ามาใช้ เลยตั้ง KPI วัด AI Effort Savings ไว้ตาม SDP §5.3.4
ตัวเลขด้านล่างเป็น default baseline ก่อน ทีมจะเก็บจริงอีก 1–2 sprint แรก
เพื่อ calibrate ครับ

| Artifact                | Manual | AI-Assisted | Savings |
|-------------------------|--------|-------------|---------|
| SIT Plan                | 8 hr   | 4 hr        | 50%     |
| SIT Test Case (~20 req) | 24 hr  | 12 hr       | 50%     |
| Peer Review             | —      | —           | 40%     |
| SIT Report              | 4 hr   | 1.5 hr      | 62%     |
| UAT Plan                | 8 hr   | 4 hr        | 50%     |
| UAT Test Case           | 16 hr  | 8 hr        | 50%     |

Blocker ที่อยากขอ support จากพี่ชาย
ช่วงนี้มีโปรเจคขยับ timeline โดยไม่แจ้ง QA ล่วงหน้า (หรือแจ้งกระชั้นมาก) ทำให้
allocate resource ไม่ทัน กระทบคุณภาพ test และ release อยากขอให้ช่วยวาง process
ให้ PM กับ Dev แจ้งการขยับ timeline ล่วงหน้าอย่างเป็นทางการครับ

Plan สัปดาห์หน้า
1. Critical Athm มจพ automation
2. High Booking time ให้น้องทำ Automation (dtmu, Athm, OIE)
3. Medium กำหนด AI process guideline (Input / Process / Output)

ขอบคุณครับ
นิรวิทย์ เทพสวัสดิ์
QA Lead
```

### Key Takeaways

**สิ่งที่ skill ทำถูก:**
- ใช้ "ครับ" อย่างเดียว (ไม่ใช่ "ค่ะ/ครับ")
- ไม่มี em dash ใน prose paragraph (มีแค่ใน table cell)
- Header ภาษาไทย ("สรุปสั้น ๆ", "งานที่เดินในสัปดาห์นี้") ไม่ใช่ "TL;DR" / "Highlights"
- "ลดเวลาทำงานได้ประมาณ 40%" ไม่ใช่ "~40%"
- Blocker prose paragraph + Ask ชัดเจน (ไม่ทำเป็น bullet เพราะมี 1 เรื่อง)
- ไม่มี emoji ใน body (C-level)

**สิ่งที่ต้อง review manually:**
- ชื่อผู้รับ ([ชื่อผู้บริหาร]) → เปลี่ยนเป็น "พี่ชาย" / "คุณ XXX" ตามจริง
- ตัวเลข KPI → ถ้าทีมเก็บจริงแล้ว override ด้วยตัวเลขจริง

---

## Example 2: Team variant (future example placeholder)

*เพิ่มในอนาคตเมื่อมี use case team update*

---

## Iteration History

ตัวอย่าง 1 ผ่านการ iterate 3 รอบ:
1. **v1:** AI draft แบบ structured มากเกิน — มี "TL;DR", "Highlights", emoji เยอะ, "ค่ะ/ครับ"
2. **v2:** User ระบุ "ใช้เป็นครับ, กระชับกว่านี้" — ปรับ speaker particle + บีบ content
3. **v3:** User ระบุ "ไม่เอาภาษา AI" — rewrite เป็น prose ธรรมชาติ ตัด em dash, ตัด consultant-speak

→ Lesson: ถามรอบเดียวให้ครบ (audience / tone / particle / anti-AI preference) กันต้อง iterate หลายรอบ
