# Sprint Plan Styling Guide (Google Sheets / Excel)

> CSV เก็บได้แค่ข้อมูล — styling (สี/ตัวหนา/merge cells) ต้อง apply ใน Google Sheets หรือ Excel เอง
> guide นี้คือวิธี format `sprint-plan-th.csv` ให้หน้าตาเหมือน PEA-CMP Sprint Plan reference

---

## 1. เปิดไฟล์ CSV

**Google Sheets:** File → Import → Upload `sprint-plan-th.csv` → Replace current sheet
**Excel:** Data → From Text/CSV → เลือก UTF-8 (รองรับภาษาไทย)

---

## 2. Merge Cells (จำเป็น)

| Range | Action |
|-------|--------|
| B2:J2 | Merge — "TEST PLAN" heading |
| E8:F8 | Merge — "Expected Date" |
| G8:H8 | Merge — "Actual Date" |
| K8:? | Merge — "<Month YYYY>" header (ให้ครอบทุกวันของเดือน) |
| K9:Q9 | Merge — "W1" (กลุ่มตาม week) |
| R9:X9 | Merge — "W2" ฯลฯ |

---

## 3. Column Widths (แนะนำ)

| Column | Width |
|--------|-------|
| A | 20 px (visual offset) |
| B (Task ID) | 110 px |
| C (Task Name) | 400 px |
| D (Task Owner) | 90 px |
| E-H (Dates) | 100 px each |
| I (Status) | 110 px |
| J (Remark) | 240 px |
| K-AN (Gantt days) | 22 px each |

---

## 4. Colors (เลียนแบบ PEA-CMP)

### 4.1 Header Block (Row 2-7)
- **"TEST PLAN"** heading: font 24pt, bold, dark gray `#3C3C3C`
- Field labels (PROJECT NAME, PROJECT MANAGER, ...): bold, italic, `#6B6B6B`

### 4.2 Table Header (Row 8-11)
- Background: `#E8E4E8` (light purple-gray)
- Font: bold, center-aligned
- Border: all sides `#CCCCCC`

### 4.3 Sprint Parent Row (S01, S02, ...)
- Background: **`#8B5A8C`** (PEA-CMP purple)
- Font: white, bold

### 4.4 Task Rows (S01-T01, S01-T02, ...)
- Background: `#FFFFFF`
- Font: bold black

### 4.5 Sub-task Rows (lines เริ่มด้วย "-")
- Background: `#FFFFFF`
- Font: regular, indent 2 spaces

### 4.6 "งานล่าช้ากว่า Plan" Row
- Background: **`#F4CCCC`** (light pink)
- Font: bold red

### 4.7 Weekend Columns (S, S)
- Background: `#F3F3F3` (light gray)

### 4.8 Status Chips (Column I)

| Status | Background | Font |
|--------|-----------|------|
| Todo | `#DDDDDD` gray | black |
| In-progress | `#FFE599` yellow | black |
| Done | `#B6D7A8` green | black |
| Passed | `#6AA84F` dark green | white |
| Failed / Blocked | `#E06666` red | white |

> ใช้ **Conditional Formatting** — Format → Conditional formatting → Custom formula
> เช่น `=$I12="Passed"` → apply สีเขียว

---

## 5. Gantt Cells (Column K onwards)

วิธี mark planned day:

### Option A — ใช้ "x" แล้ว conditional-format เป็นสี
- Cell value = `x`
- Conditional: `=K12="x"` → background `#8B5A8C` + font transparent

### Option B — ใช้ Gantt Formula (auto highlight ตาม Start/End)
ใส่สูตรใน cell K12 (Apr 1):
```
=IF(AND(K$11>=DAY($E12), K$11<=DAY($F12)), "●", "")
```
(สมมติ row 11 = day number, col E = start, col F = end — ปรับ row index ตามจริง)

ประโยชน์: แก้ Start/End date → Gantt อัปเดตอัตโนมัติ

---

## 6. Freeze Panes

- **View → Freeze → 11 rows** (freeze header)
- **View → Freeze → 10 columns** (freeze Task info)

---

## 7. Print Setup

- Orientation: **Landscape**
- Paper: **A3** (Gantt 30 columns กว้าง)
- Scale: Fit to width
- Repeat rows 8-11 on every page

---

## 8. Shortcut — Google Sheets Apps Script

ถ้าอยาก auto-apply styling ทุกครั้ง ใช้ Apps Script:

```javascript
function applyPEAStyling() {
  const sheet = SpreadsheetApp.getActiveSheet();

  // Sprint parent rows (Task ID เริ่มด้วย S + 2 digit, ไม่มี -T)
  const taskIds = sheet.getRange("B:B").getValues();
  taskIds.forEach((row, i) => {
    const id = row[0];
    if (/^S\d{2}$/.test(id)) {
      sheet.getRange(i + 1, 2, 1, 10).setBackground("#8B5A8C").setFontColor("white").setFontWeight("bold");
    }
  });

  // Status chips
  const range = sheet.getRange("I12:I100");
  const rules = [
    {text: "Passed", bg: "#6AA84F", fg: "white"},
    {text: "Done", bg: "#B6D7A8", fg: "black"},
    {text: "In-progress", bg: "#FFE599", fg: "black"},
    {text: "Todo", bg: "#DDDDDD", fg: "black"},
    {text: "Failed", bg: "#E06666", fg: "white"},
    {text: "Blocked", bg: "#E06666", fg: "white"},
  ];
  // ...apply conditional rules
}
```

---

## Reference

- PEA-CMP Test Plan V4 (ต้นแบบ styling)
- qa-standards §1-§2 (Severity/Priority scale สำหรับ status chips)
