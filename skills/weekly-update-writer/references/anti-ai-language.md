# Anti-AI Language Guide — เขียนเมลให้เหมือนคนเขียน

> Checklist สำหรับ `weekly-update-writer` (และ skill เขียนเมลอื่น ๆ) — เพื่อไม่ให้ output ฟังเหมือน AI สรุปอัตโนมัติ

---

## 1. ห้ามใช้ใน Prose Paragraph

### 1.1 Em dash (—)
AI ชอบใช้ em dash มากเกินสัดส่วนที่คนไทยจะใช้ในเมลภาษาไทย

| ❌ AI style | ✅ คนเขียนจริง |
|-------------|----------------|
| "Test Automation rollout — align scope กับ PM ครบ 3 โปรเจค" | "Test Automation rollout: align scope กับ PM ครบ 3 โปรเจค" |
| "งานหลักยัง on track — มี 1 ประเด็น" | "งานหลักยัง on track มี 1 ประเด็น" |
| "3 initiatives — ยัง On track ทั้งหมด" | "3 initiatives ยัง On track ทั้งหมด" |

**ข้อยกเว้น (ใช้ได้):**
- ตัวคั่น range ตัวเลข: "1–2 sprint", "เวอร์ชัน 1.0–1.5"
- ใน table cell แทน "no data": `| Peer Review | — | — | 40% |`

### 1.2 Tilde (~) นำหน้าตัวเลข
AI ชอบ `~40%`, `~10 คน` — ภาษาพูดไทยไม่ได้ใช้สัญลักษณ์นี้

| ❌ | ✅ |
|----|----|
| "ลด effort ได้ ~40%" | "ลดเวลาทำงานได้ประมาณ 40%" |
| "น้อง ~4 คน adopt แล้ว" | "น้อง 4 คน adopt แล้ว" (ถ้ารู้จำนวนแน่) |
| "savings ~50-60%" | "savings ประมาณ 50-60%" |

### 1.3 Header ภาษา AI
Header แบบ "TL;DR", "Highlights", "Key Metrics" เป็น AI/tech writing style — ไม่ควรใช้ส่ง C-level ไทย

| ❌ AI header | ✅ คนเขียน |
|--------------|------------|
| `### TL;DR` | `สรุปสั้น ๆ` (หรือไม่ต้องมี header เลย) |
| `### Highlights & Wins` | `งานที่เดินในสัปดาห์นี้` |
| `### Key Metrics` | `ตัวเลขสำคัญ` |
| `### Asks / Decisions needed` | `สิ่งที่อยากขอ support` |
| `### Next Week Priorities` | `Plan สัปดาห์หน้า` |

### 1.4 Consultant / Corporate Speak
ศัพท์ pretentious ที่ AI/consulting deck ชอบใช้

| ❌ | ✅ |
|----|----|
| "early signal ลด effort ได้" | "ช่วงแรกที่ใช้ดูลดเวลาทำงานได้" |
| "leverage AI capability" | "เอา AI มาช่วย" |
| "align stakeholders" | "คุยกับทีมที่เกี่ยวข้อง" |
| "streamline process" | "จัด process ให้ลื่นขึ้น" |
| "drive value" | "สร้างผลลัพธ์" / "ช่วยทีมทำงานได้ดีขึ้น" |
| "synergy" | (ตัดทิ้งเลย) |
| "deep dive" (เป็น noun) | "คุยรายละเอียดเพิ่ม" |

### 1.5 Emoji เยอะเกิน
C-level email ไทยปกติใช้ emoji น้อยมาก

**Rule of thumb:**
- **C-level email:** ≤ 3 emoji ทั้งฉบับ (เช่น ✅ ❌ ⚠️ ใน status เท่านั้น)
- **Team email:** ใช้ได้ตามสบาย
- **ห้าม:** 🚀 💡 🎯 🎉 ใน C-level (ดูเป็น startup-pitch-deck)

### 1.6 Bold รัว ๆ
AI ชอบ **bold** ทุก noun ทุก 2-3 คำ

| ❌ | ✅ |
|----|----|
| "**Kick off** **Test Automation** กับ **3 โปรเจค** (**Athm**, **dtmu**, **OIE**)" | "Kick off Test Automation กับ 3 โปรเจค (Athm, dtmu, OIE)" |

**ใช้ bold เฉพาะ:**
- Section label จริง ๆ (Blocker, Ask, Critical)
- Keyword สำคัญที่ต้อง scan เจอ (ชื่อโปรเจค critical, วันสำคัญ)

### 1.7 "ค่ะ/ครับ" คู่กัน
AI ชอบใช้ "ค่ะ/ครับ" เพราะไม่รู้ gender ของ sender — ต้อง **ถามแล้วเลือกอย่างเดียว**

| ❌ | ✅ (ผู้ชาย) | ✅ (ผู้หญิง) |
|----|-------------|-------------|
| "ขอบคุณค่ะ/ครับ" | "ขอบคุณครับ" | "ขอบคุณค่ะ" |
| "รบกวนแจ้งได้เลยค่ะ/ครับ" | "รบกวนแจ้งได้เลยครับ" | "รบกวนแจ้งได้เลยค่ะ" |

---

## 2. โครงสร้างที่เกินพอดี

### 2.1 ทุกอย่างต้องเป็น Bullet
AI ชอบทำให้ทุก paragraph แตกเป็น bullet — เมลจริงควรมี prose paragraph คั่น

**ประมาณ:** bullet ≤ 60% ของเมล, ที่เหลือควรเป็น prose flow

**❌ Over-bulleted:**
```
งานที่เดินสัปดาห์นี้
- Test Automation
  - 3 โปรเจค
    - Athm
    - dtmu
    - OIE
- QA AI Skill
  - 11 ตัว
  - น้อง 4 คน adopt
```

**✅ Natural:**
```
สัปดาห์นี้ kick off Test Automation กับ 3 โปรเจค (Athm, dtmu, OIE) และปล่อย QA AI Skill 11 ตัว
ให้น้อง 4 คนเริ่มใช้จริงแล้ว
```

### 2.2 Section Header ทุก paragraph
AI ชอบใส่ header ทุก ๆ 2 บรรทัด — ทำให้เมลดูเหมือน specification document

**Rule:** เมล C-level ไม่ควรมี header เกิน 4-5 อัน

### 2.3 ตารางสำหรับข้อมูล 2 แถว
ถ้าข้อมูลมี 2-3 แถว ไม่ต้องทำเป็นตาราง — เขียน prose ได้

**❌ Overkill:**
```
| Blocker | Impact | Owner |
|---------|--------|-------|
| Timeline shift | Resource ไม่ทัน | CTO |
```

**✅ Natural prose:**
```
ช่วงนี้มีโปรเจคขยับ timeline โดยไม่แจ้ง QA ล่วงหน้า ทำให้ allocate resource ไม่ทัน
อยากขอให้ CTO ช่วยวาง process แจ้งล่วงหน้าครับ
```

---

## 3. Meta-Quality Checks

Run เร็ว ๆ ก่อนส่งเมล:

- [ ] เมลยาวไม่เกิน 1 หน้าจอ laptop (เหมือน C-level อ่าน ~30 วิ.)
- [ ] ลบ em dash ใน prose หมดแล้ว
- [ ] Speaker particle ตรงกับ gender sender (ไม่มี "ค่ะ/ครับ")
- [ ] Header ≤ 5 อัน, ไม่มี "TL;DR"
- [ ] Bullet ≤ 60% ของ content
- [ ] ไม่มี `~` นำหน้าตัวเลขใน prose
- [ ] Bold ≤ 5-10 จุดในเมลทั้งฉบับ
- [ ] Blocker ทุกข้อมี Ask + ผู้รับ ask
- [ ] Emoji ≤ 3 (C-level variant)

---

## 4. Rule of Thumb: "อ่านออกเสียงดู"

ทดสอบง่ายที่สุด — อ่านเมลออกเสียงเบา ๆ ถ้าฟังแล้ว:
- สะดุดทุก em dash → ต้องแก้
- เหมือน presentation slide ที่ copy มา → ต้อง rewrite เป็น prose
- ฟังเหมือน chatbot ตอบ → ปรับให้เป็นธรรมชาติ
- ฟังเหมือนคนคุยกับพี่ → ✅ ผ่าน
