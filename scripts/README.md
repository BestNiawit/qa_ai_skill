# scripts/

Utility scripts ของ qa_ai_skill repo

---

## `validate_skills.py`

ตรวจ structure + consistency ของ skills ใน repo — รันก่อน commit หรือใน CI

**ตรวจอะไรบ้าง:**
- Frontmatter `name` + `description` ครบ + `name` ตรงกับชื่อ folder + unique
- ทุก SKILL.md มี 8 sections ตามลำดับ (Purpose / When to Use / Inputs / Outputs / Process / Quality Gate / AI Guardrails / Chain)
- Link ไป `references/ai-guardrails.md` มีอยู่
- ไม่มี deprecated severity/priority code (P0-P3, Sev1-4) นอก `qa-standards.md`
- Relative markdown links ใน `skills/` + `docs/` + `references/` resolve ได้

**วิธีรัน:**
```bash
python3 scripts/validate_skills.py
```

Exit 0 = pass · Exit 1 = พบ error · Warnings ไม่ fail build

---

## `fill-tc-template.py`

แปลง CSV ของ `test-case-writer` output → OneD central Test Case Excel template (.xlsx) โดยรักษา style/font/drawing ของ template ไว้ครบ

**Input:**
- OneD template xlsx (`Client Code-Project Code_Test Case_V.x.x.x_Description.xlsx`) — **ไม่ shipped ใน repo นี้** ขอจาก TL / previous maintainer
- CSV จาก `test-case-writer` (default: `docs/samples/leave-management/03_sit_testcases.csv`)

**Output:**
- xlsx ที่เติม TC + dropdown + drawing + style ครบ (default: `outputs/PEA-LV_Test_Case_V.1.0.0_Leave_Management.xlsx`)

**วิธีรัน:**
```bash
# ใช้ default (PEA-LV demo CSV + output ใน repo)
python3 scripts/fill-tc-template.py --template /path/to/oned-template.xlsx

# Custom CSV + output
python3 scripts/fill-tc-template.py \
  --template /path/to/oned-template.xlsx \
  --source-csv my-project/sit-tc.csv \
  --output my-project/sit-tc.xlsx
```

`--help` ดูทุก option

**ข้อจำกัด:**
- META + EXEC_DATA ใน script เป็น PEA-LV demo data — แก้ inline หรือ fork ก่อนใช้กับโปรเจคอื่น
- รองรับ template version ปัจจุบันเท่านั้น (ถ้า OneD update template → script อาจต้องปรับ cell mapping)

**Dependencies:**
```bash
pip install openpyxl
```
