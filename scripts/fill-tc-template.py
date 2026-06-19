#!/usr/bin/env python3
"""
Fill OneD central Test Case Excel template from test-case-writer CSV output.

Usage:
    python scripts/fill-tc-template.py --template <path-to-oned.xlsx>
    python scripts/fill-tc-template.py --template T.xlsx --source-csv my.csv --output out.xlsx

The OneD template xlsx ("Client Code-Project Code_Test Case_V.x.x.x_Description.xlsx")
is NOT shipped in this repo — ask TL / previous maintainer for the current copy.

The META and EXEC_DATA blocks below are PEA-LV demo data used by docs/samples/leave-management.
For a real project, edit those dicts (or fork this script) before running.

Strategy:
- openpyxl writes only cell VALUES (never modifies styles/fonts)
- After save, zipfile post-processing:
    * Restores original styles.xml (preserves Sarabun font perfectly)
    * Restores images, drawings, theme, comments (openpyxl drops them)
    * Manually sets `s="N"` on new scenario-header rows to match original's
      blue-bold style index (looked up from original sheet5 row 7)
    * Re-attaches `<drawing r:id="..."/>` references on each worksheet
"""
import argparse
import openpyxl
import csv
import re
import sys
import zipfile
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SOURCE_CSV = REPO_ROOT / "docs" / "samples" / "leave-management" / "03_sit_testcases.csv"
DEFAULT_OUTPUT = REPO_ROOT / "outputs" / "PEA-LV_Test_Case_V.1.0.0_Leave_Management.xlsx"

META = {
    "project_code": "PEA-LV",
    "project_name": "Leave Management — การไฟฟ้าส่วนภูมิภาค (PEA)",
    "project_full_th": "ระบบจัดการคำขอลาพนักงาน",
    "project_full_en": "Leave Management System",
    "pm": "คุณสมศรี",
    "owner": "คุณวิชัย",
    "role": "Employee, Manager",
    "version": "V.1.0.0",
    "date": "30/04/2026",
    "module_id": "M_LV",
    "module_title": "Leave Management",
    "author": "QA Lead — QA A",
    "reviewer": "QA C (Peer)",
    "change_desc": (
        "- Initial draft\n"
        "  - AI-generated 32 test cases (test-case-writer skill)\n"
        "  - Reviewed via test-case-reviewer\n"
        "  - All FR_LV_01-05 covered (100% traceability)\n"
        "  - Executed in SIT 2026-04-29"
    ),
}

# Realistic execution data (mock for sample) — keyed by TC ID
EXEC_DATA = {
    # TC_PEA_LV_017 → Failed because of bug PEA-LV-187 (matches sample bug_report.md)
    "TC_PEA_LV_017": {
        "actual": "Status เปลี่ยนเป็น Approved สำเร็จ แต่ balance ของพนักงานยังไม่หักทันที (ค้างที่ 10) จนกว่าจะ refresh หรือรอ ~30 วินาที — ขัดกับ Expected ที่ระบุว่าหักภายใน 1 วินาที (sync)",
        "result": "Failed",
        "qa": "QA B",
        "date": "29/04/2026",
        "defect": "PEA-LV-187",
    },
    # Blocked due to env issue (session timeout)
    "TC_PEA_LV_005": {
        "actual": "Test environment session timeout config ไม่ตรงกับที่ระบุ (set ไว้ 30 นาที) ไม่สามารถทดสอบ 15 นาที inactive ได้",
        "result": "Blocked",
        "qa": "QA B",
        "date": "29/04/2026",
        "defect": "",
    },
    # Passed with condition (UX nit)
    "TC_PEA_LV_009": {
        "actual": "Submit สำเร็จ + ไฟล์เก็บใน S3 + Status=Pending — แต่ preview ใบรับรองหลัง submit แสดงช้าประมาณ 2 วินาที",
        "result": "Passed with condition",
        "qa": "QA B",
        "date": "29/04/2026",
        "defect": "",
    },
    # No-run (low priority, deferred to next sprint)
    "TC_PEA_LV_032": {
        "actual": "",
        "result": "No-run",
        "qa": "",
        "date": "",
        "defect": "",
    },
}
# Default for all other TCs
DEFAULT_EXEC = {
    "actual": "ผลตรงตาม Expected Result ทุกข้อ",
    "result": "Passed",
    "qa": "QA B",
    "date": "29/04/2026",
    "defect": "",
}

COL_MAP = {
    0:  "A", 1:  "B", 2:  "C", 3:  "D", 4:  "E", 5:  "F",
    8:  "G", 9:  "H", 10: "I", 11: "J", 12: "K",
    14: "M", 15: "N", 16: "O", 17: "L", 18: "P",
    19: "Q", 20: "R", 21: "S", 22: "V",
}

DATA_START_ROW = 7
DATA_END_ROW = 128
NUM_COLS = 22

NS_MAIN = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"


def parse_args():
    p = argparse.ArgumentParser(
        description="Fill OneD central Test Case Excel template from test-case-writer CSV output.",
    )
    p.add_argument(
        "--template",
        required=True,
        type=Path,
        help="Path to OneD 'Client Code-Project Code_Test Case_V.x.x.x_Description.xlsx' template (ask TL — not shipped in this repo)",
    )
    p.add_argument(
        "--source-csv",
        type=Path,
        default=DEFAULT_SOURCE_CSV,
        help=f"Path to test-case-writer CSV output (default: {DEFAULT_SOURCE_CSV.relative_to(REPO_ROOT)})",
    )
    p.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT,
        help=f"Path to write filled xlsx (default: {DEFAULT_OUTPUT.relative_to(REPO_ROOT)})",
    )
    return p.parse_args()


def main():
    args = parse_args()
    template = args.template
    source_csv = args.source_csv
    output = args.output

    if not template.exists():
        sys.exit(f"ERROR: template not found: {template}")
    if not source_csv.exists():
        sys.exit(f"ERROR: source CSV not found: {source_csv}")

    print(f"Loading template: {template}")
    wb = openpyxl.load_workbook(template)

    cover = wb["Cover"]
    cover["D16"] = META["project_full_th"]
    cover["D18"] = f"({META['project_full_en']} : {META['project_code']})"
    cover["D20"] = f"บทบาทการใช้งานระบบ : {META['role']}"

    info = wb["Information"]
    info["D4"] = META["project_code"]
    info["D5"] = META["project_name"]
    info["D6"] = META["pm"]
    info["D7"] = META["owner"]
    info["B13"] = META["version"]
    info["C13"] = META["date"]
    info["D13"] = META["change_desc"]
    info["E13"] = META["author"]
    info["F13"] = META["reviewer"]

    tc = wb["TC_M_xxx"]
    tc["B2"] = META["module_id"]
    tc["B3"] = META["module_title"]

    # Parse CSV
    with open(source_csv, encoding="utf-8") as f:
        rows = list(csv.reader(f))
    header_idx = next((i for i, r in enumerate(rows) if r and r[0] == "TC ID*"), None)
    if header_idx is None:
        print("ERROR: cannot find 'TC ID*' header row in CSV")
        sys.exit(1)
    data_rows = rows[header_idx + 1:]

    # Clear values only (preserve cell styles from template)
    for r in range(DATA_START_ROW, DATA_END_ROW + 1):
        for c in range(1, NUM_COLS + 1):
            tc.cell(row=r, column=c).value = None

    # Write data — collect SC row positions for later XML patching
    out_row = DATA_START_ROW
    scenario_re = re.compile(r"^SC_\d+:")
    sc_rows = []
    tc_rows = []
    sc_count = tc_count = 0

    for row in data_rows:
        if not row or not row[0]:
            continue
        first = row[0].strip()
        if first.startswith("===="):
            break

        if scenario_re.match(first):
            tc[f"A{out_row}"] = first
            sc_rows.append(out_row)
            sc_count += 1
        else:
            tc_id = row[0].strip()
            ex = EXEC_DATA.get(tc_id, DEFAULT_EXEC)

            sizing = row[6] if len(row) > 6 else ""
            technique = row[7] if len(row) > 7 else ""
            automation = row[13] if len(row) > 13 else ""
            existing_labels = row[14] if len(row) > 14 else ""
            existing_remark = row[22] if len(row) > 22 else ""

            labels = existing_labels
            if automation:
                labels = (existing_labels + ", " if existing_labels else "") + f"automation:{automation.lower()}"

            extras = []
            if sizing:
                extras.append(f"Sizing: {sizing}")
            if technique:
                extras.append(f"Technique: {technique}")
            if existing_remark:
                extras.append(existing_remark)
            remark = " | ".join(extras)

            for csv_idx, col in COL_MAP.items():
                if csv_idx >= len(row):
                    continue
                val = row[csv_idx]
                if csv_idx == 14:
                    val = labels
                elif csv_idx == 17:
                    val = ex["actual"]   # Actual Result
                elif csv_idx == 18:
                    val = ex["result"]   # Test Result
                elif csv_idx == 19:
                    val = ex["qa"]   # Tested By
                elif csv_idx == 20:
                    val = ex["date"]     # Test Date
                elif csv_idx == 21:
                    val = ex["defect"]   # Defect ID
                elif csv_idx == 22:
                    val = remark
                if val:
                    tc[f"{col}{out_row}"] = val
            tc_rows.append(out_row)
            tc_count += 1

        out_row += 1

    print(f"Filled: {sc_count} scenario headers + {tc_count} test cases ({out_row - DATA_START_ROW} total rows)")

    # Rebuild dropdown ranges to match real TC rows (skip SC rows)
    rebuild_dropdowns(tc, tc_rows)

    # Save openpyxl version → temp, then post-process
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(suffix=".xlsx", delete=False) as tmp:
        TEMP = tmp.name
    wb.save(TEMP)
    merge_with_original(template, TEMP, output, sc_rows)
    Path(TEMP).unlink(missing_ok=True)

    print(f"Saved: {output}")
    print(f"Size: {output.stat().st_size / 1024:.1f} KB")


def rows_to_range(col, rows):
    """Compress row numbers into Excel range syntax: D[8,9,10,14] → 'D8:D10 D14'."""
    if not rows:
        return ""
    parts = []
    rows = sorted(set(rows))
    start = end = rows[0]
    for r in rows[1:]:
        if r == end + 1:
            end = r
        else:
            parts.append(f"{col}{start}:{col}{end}" if end > start else f"{col}{start}")
            start = end = r
    parts.append(f"{col}{start}:{col}{end}" if end > start else f"{col}{start}")
    return " ".join(parts)


def rebuild_dropdowns(ws, tc_rows):
    """Update each data validation's range to cover only TC rows (skip SC)."""
    if not tc_rows:
        return
    for dv in ws.data_validations.dataValidation:
        sqref_str = str(dv.sqref)
        if not sqref_str:
            continue
        first_range = sqref_str.split()[0]
        col_letter = "".join(ch for ch in first_range.split(":")[0] if ch.isalpha())
        new_range = rows_to_range(col_letter, tc_rows)
        if new_range:
            dv.sqref = new_range


# Worksheet → drawing/legacy XML to inject before </worksheet>
SHEET_TAIL_INJECTIONS = {
    "xl/worksheets/sheet1.xml": '<drawing r:id="rId1"/>',
    "xl/worksheets/sheet2.xml": '<drawing r:id="rId2"/><legacyDrawing r:id="rId3"/>',
    "xl/worksheets/sheet3.xml": '<drawing r:id="rId1"/>',
    "xl/worksheets/sheet4.xml": '<drawing r:id="rId1"/>',
    "xl/worksheets/sheet5.xml": '<drawing r:id="rId1"/>',
    "xl/worksheets/sheet6.xml": '<drawing r:id="rId1"/>',
    "xl/worksheets/sheet7.xml": '<drawing r:id="rId1"/>',
}


def find_sc_style_index(orig_sheet5_xml: str) -> str:
    """Read original sheet5 row 7 (the template's first SC header) → return its `s` attribute."""
    m = re.search(r'<c r="A7"\s+s="(\d+)"', orig_sheet5_xml)
    if m:
        return m.group(1)
    return ""


def patch_sc_rows(sheet5_xml: str, sc_rows: list, sc_style: str) -> str:
    """For each SC row position, set s="<sc_style>" on every cell in that row.

    Operates on sheet5.xml (TC_M_xxx). Cells exist as `<c r="A13"/>` etc.
    Adds the `s` attribute (or replaces if openpyxl wrote a different one).
    """
    if not sc_style or not sc_rows:
        return sheet5_xml
    for r in sc_rows:
        # Find all <c r="X{r}"/> elements (any column, this exact row)
        # Pattern: <c r="LETTERS{r}" possibly with attrs />
        pattern = re.compile(rf'<c r="([A-Z]+){r}"([^/>]*)(/?)>')

        def replace(m):
            col, attrs, slash = m.group(1), m.group(2), m.group(3)
            # Remove any existing s="..." then prepend our SC style
            attrs = re.sub(r'\s+s="\d+"', "", attrs)
            return f'<c r="{col}{r}" s="{sc_style}"{attrs}{slash}>'

        sheet5_xml = pattern.sub(replace, sheet5_xml)
    return sheet5_xml


def merge_with_original(orig_path, modified_path, output_path, sc_rows):
    """Combine openpyxl's modified xlsx with original to preserve everything.

    - Keep original's styles.xml + theme + media + drawings + comments + _rels
    - Keep openpyxl's worksheet XMLs (have new cell values), patched to:
        * include `<drawing r:id="..."/>` reference back
        * use original's SC header style index on new SC rows
    """
    # Read original sheet5 to find SC header style index
    with zipfile.ZipFile(orig_path) as z:
        orig_sheet5 = z.read("xl/worksheets/sheet5.xml").decode("utf-8")
    sc_style = find_sc_style_index(orig_sheet5)
    print(f"SC header style index from original: {sc_style!r}")

    use_from_modified = (
        "xl/worksheets/sheet",   # cell data (modified)
        "xl/sharedStrings.xml",
        "xl/workbook.xml",
    )
    # Notably: xl/styles.xml is NOT in this list → use ORIGINAL (preserves font exactly)

    with zipfile.ZipFile(orig_path) as zorig, \
         zipfile.ZipFile(modified_path) as zmod, \
         zipfile.ZipFile(output_path, "w", zipfile.ZIP_DEFLATED) as zout:

        orig_files = set(zorig.namelist())
        mod_files = set(zmod.namelist())
        all_files = orig_files | mod_files

        for f in sorted(all_files):
            from_modified = (
                f in mod_files
                and (f.startswith(use_from_modified) or f == "xl/workbook.xml")
            )

            if from_modified:
                content = zmod.read(f)
                # Patch worksheet XMLs
                if f in SHEET_TAIL_INJECTIONS:
                    text = content.decode("utf-8")
                    # Re-attach drawing reference
                    if "</worksheet>" in text and "<drawing " not in text:
                        text = text.replace(
                            "</worksheet>",
                            SHEET_TAIL_INJECTIONS[f] + "</worksheet>",
                        )
                    # Patch SC rows in TC_M_xxx (sheet5)
                    if f == "xl/worksheets/sheet5.xml" and sc_style:
                        text = patch_sc_rows(text, sc_rows, sc_style)
                    content = text.encode("utf-8")
                zout.writestr(f, content)
            elif f in orig_files:
                # Use original — includes styles.xml, theme, media, drawings, _rels
                zout.writestr(f, zorig.read(f))


if __name__ == "__main__":
    main()
