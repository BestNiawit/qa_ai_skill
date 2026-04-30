# Sample Pack — Leave Management (E2E)

> **วัตถุประสงค์:** ตัวอย่าง output ของทุก skill ที่ทำต่อกันเป็น chain เดียว — ใช้เป็น reference ก่อนทีมจะลองรัน skill จริง
>
> **Module:** Leave Management (PEA) — ระบบยื่นคำขอลาสำหรับพนักงาน
> **Mock data only** — ห้ามใช้ใน production · ทุก credential เป็น `[REDACTED]`

---

## ⚠ ไฟล์ตัวอย่างไม่ได้อยู่บน git

`README.md` (ไฟล์นี้) เป็น **pointer doc** — ไฟล์ตัวอย่างจริง (.md / .csv / .typ / .pdf) ไม่ได้ commit เข้า repo เพราะเป็น mock output ที่ regenerate ได้

**วิธีเอาไฟล์:**
- ติดต่อ QA Lead → ขอ Drive link sample pack `leave-management` (รวม PDF 6 ไฟล์ + markdown source)
- หรือ regenerate ใหม่: รัน skills ใน Claude Code ตามลำดับด้านล่าง — output จริงจาก AI จะ structure เหมือนใน sample

---

## 📦 ไฟล์ใน Pack ทั้งหมด

### 📄 PDF (Typst — สำหรับ Exec / Stakeholder) — 6 ไฟล์

| # | ชื่อ | จาก Skill | Audience |
|:-:|------|-----------|----------|
| 02 | SIT Plan | test-plan-writer | PM + Dev Lead |
| 04 | Peer Review | test-case-reviewer | QA Peer / Lead |
| 05 | Bug Report | bug-report-writer | Dev / Triage |
| 06 | ⭐ SIT Report | test-report-writer (sit) | **Exec / PM** |
| 08 | ⭐ UAT Report | test-report-writer (uat) | **Exec / End User / Director** |
| 11 | ⭐ Perf Report | test-report-writer (perf) + perf-result-analyzer | **Exec / Architect / DBA** |

### 📝 Markdown / CSV (รายละเอียดเทคนิค) — 6 ไฟล์ + 1 CSV

| # | ไฟล์ | จาก Skill | คำอธิบาย |
|:-:|------|-----------|----------|
| **00** | `00_brd_leave_input.md` | *(External — จาก PM)* | BRD ดิบ — เป็น **Input** ของ chain |
| **01** | `01_requirement_analysis.md` | requirement-analyzer | Readiness Score + Normalized Req + PM Confirmation |
| **02** | `02_sit_plan.md` | test-plan-writer (sit) | SIT Test Plan (14 sections + Schedule) |
| **03** | `03_sit_testcases.csv` | test-case-writer (sit) | SIT Test Cases 23-col + Sizing Summary |
| **04** | `04_peer_review.md` | test-case-reviewer | Peer Review Report |
| **05** | `05_bug_report.md` | bug-report-writer | ตัวอย่าง bug 1 ตัว |

### 🛠 Typst Source — 6 `.typ` + `build.sh`

ใน `typst/` — ใช้สร้าง PDF ใหม่จาก Typst template + Ayodia branding

---

## 🏗 วิธี Rebuild PDF (ถ้ามีไฟล์ source แล้ว)

ต้องติดตั้ง Typst ก่อน:

```bash
brew install typst   # macOS
```

แล้วรัน:

```bash
cd docs/samples/leave-management/typst
./build.sh
```

จะได้ PDF 6 ไฟล์ใน `typst/` — ใช้ Sarabun font (TH) + Ayodia branding ผ่าน `references/typst-templates/lib.typ`

---

## สมมุติฐานของ sample นี้

- **Project:** PEA (การไฟฟ้าส่วนภูมิภาค)
- **Module:** Leave Management — ยื่น/อนุมัติคำขอลา + ดู balance
- **Sprint:** 2026-S08 (2026-04-20 ถึง 2026-05-01)
- **Team:** QA Lead 1 + Tester 2
- **Stakeholder:** PM = คุณสมศรี (mock), BA = คุณวิชัย (mock)
- **Environment:** SIT = `https://sit-pea.example.com` · UAT = `https://uat-pea.example.com`

## วิธีใช้ pack นี้

- **Demo ผู้บริหาร:** เปิด PDF #06 (SIT Report) + #11 (Perf Report) — exec สนใจ Go/No-Go + Savings
- **Onboarding QA ใหม่:** อ่าน 00 → 11 ตามลำดับ ครั้งเดียวเข้าใจ flow ทั้งหมด
- **อ้างอิงตอนใช้ skill จริง:** เปิดไฟล์ที่ตรงกับ skill ที่กำลังใช้ ดู structure ก่อนเริ่ม prompt

---

> ⚠ **Mock disclaimer:** ตัวเลข defect / savings / timing ใน sample เป็นค่าสมมุติเพื่อ demo ไม่ใช่ผลจริงจากโปรเจคใด ๆ — เมื่อใช้จริง AI จะ generate จาก data ของทีม
