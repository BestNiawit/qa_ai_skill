"""
Generate 4 PNG images for EP4 (Inside a skill).
Style: matches EP2/EP3 (clean, light, Medium-friendly). No emojis. No em dashes.

Images
  1. img_anatomy.png            -- folder + frontmatter zoom + 8 sections
  2. img_lazy_load.png          -- 3-phase loading timeline
  3. img_filename_chain.png     -- skill A -> file -> user -> skill B (no API)
  4. img_3_layer_override.png   -- stacked layers: skill / standards / project
"""

from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

# Register Thai fonts so glyphs render.
for path in [
    "/System/Library/Fonts/Supplemental/SukhumvitSet.ttc",
    "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/cf0dc8d3b09f9ba379660e591e82566e2b557949.asset/AssetData/Sarabun.ttc",
]:
    try:
        font_manager.fontManager.addfont(path)
    except (RuntimeError, FileNotFoundError):
        pass

plt.rcParams["font.family"] = ["Sukhumvit Set", "Sarabun", "Helvetica", "DejaVu Sans"]
plt.rcParams["axes.unicode_minus"] = False

# ── Common style (synced with EP2/EP3) ────────────────────────
BG = "#ffffff"
INK = "#1a1a1a"
SUB = "#6b6b6b"
RED_BG = "#fdecea"
RED_LINE = "#e07a72"
GREEN_BG = "#e8f3ec"
GREEN_LINE = "#5a9a6e"
GRAY_BG = "#f5f5f4"
GRAY_LINE = "#c9c8c5"
YELLOW_BG = "#fff7ed"
YELLOW_LINE = "#d97706"
BLUE_BG = "#eff6ff"
BLUE_LINE = "#3b82f6"
PURPLE_BG = "#f5f3ff"
PURPLE_LINE = "#8b5cf6"
ACCENT = "#c2410c"
DARK_BG = "#1f2937"

OUT_DIR = Path(__file__).resolve().parent


def card(ax, x, y, w, h, fill, edge, lw=1.5, rounding=0.4):
    box = FancyBboxPatch(
        (x, y), w, h,
        boxstyle=f"round,pad=0.02,rounding_size={rounding}",
        linewidth=lw, edgecolor=edge, facecolor=fill,
    )
    ax.add_patch(box)


# ============================================================
# IMAGE 1: Anatomy (folder + frontmatter + 8 sections)
# ============================================================
fig, ax = plt.subplots(figsize=(13, 8), dpi=160)
ax.set_xlim(0, 26)
ax.set_ylim(0, 16)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(13, 15.2, "Anatomy ของ skill หนึ่งตัว: test-case-writer",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(13, 14.4, "SKILL.md เป็น brain. templates กับ references คือของที่ skill เลือกหยิบเฉพาะที่ต้องใช้.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# ── Left column: folder layout ──
card(ax, 0.5, 0.8, 8.4, 12.8, GRAY_BG, GRAY_LINE)
ax.text(4.7, 12.9, "FOLDER STRUCTURE", ha="center",
        fontsize=10, color=SUB, weight="bold")

folder_lines = [
    ("skills/test-case-writer/", INK, True, True),
    ("├── SKILL.md", INK, True, True),
    ("│         (372 lines · brain)", SUB, False, True),
    ("├── templates/", INK, True, True),
    ("│   ├── test-case-th.md", INK, False, True),
    ("│   ├── test-case-en.md", INK, False, True),
    ("│   ├── test-case.csv", INK, False, True),
    ("│   ├── uat-checklist-th.md", INK, False, True),
    ("│   └── uat-checklist-th.csv", INK, False, True),
    ("│", INK, False, True),
    ("└── references/", INK, True, True),
    ("    └── testing-techniques.md", INK, False, True),
    ("              (ECP, BVA, Decision Table)", SUB, False, True),
]
for i, (line, color, bold, mono) in enumerate(folder_lines):
    weight = "bold" if bold else "normal"
    family = "monospace" if mono else None
    kw = dict(ha="left", va="center", fontsize=10, color=color, weight=weight)
    if family:
        kw["family"] = family
    ax.text(0.9, 12.0 - i * 0.78, line, **kw)

# ── Middle: frontmatter zoom ──
card(ax, 9.4, 7.0, 16.0, 6.6, YELLOW_BG, YELLOW_LINE)
ax.text(17.4, 12.9, "FRONTMATTER (ทุก skill มีแค่ส่วนนี้ที่ Claude อ่านตอน session เริ่ม)",
        ha="center", fontsize=10, color=YELLOW_LINE, weight="bold")

# Mini code block
card(ax, 9.8, 7.4, 15.2, 5.0, "#ffffff", GRAY_LINE, lw=1.0, rounding=0.2)

fm_lines = [
    ("---", "#9ca3af"),
    ("name: test-case-writer", INK),
    ("description: เขียน test case จาก requirement document", INK),
    ("  (SRS/PRD/spec/user story) ให้ครอบคลุมและอ่านง่าย ...", INK),
    ("  Trigger เมื่อ user ส่ง requirement file/SRS/PRD/spec", ACCENT),
    ("  และขอให้เขียน test case, test scenario, SIT test case,", ACCENT),
    ('  UAT test case, UAT checklist, "write test cases", ...', ACCENT),
    ("  Maps to SDP §5.3.1 (Process 2, 6).", INK),
    ("---", "#9ca3af"),
]
for i, (line, color) in enumerate(fm_lines):
    # Use default (Thai-capable) font; YAML structure is shown via box+layout
    ax.text(10.1, 12.05 - i * 0.5, line, ha="left", va="center",
            fontsize=9, color=color)

# Highlight: trigger keywords
ax.annotate("trigger keywords\n(TH + EN รวม)", xy=(10.5, 9.6),
            xytext=(8.7, 5.3), fontsize=9, color=ACCENT, ha="center",
            arrowprops=dict(arrowstyle="->", color=ACCENT, lw=1, alpha=0.7))

# ── Right: 8 sections ──
card(ax, 9.4, 0.8, 16.0, 5.7, BLUE_BG, BLUE_LINE)
ax.text(17.4, 5.9, "8 SECTIONS มาตรฐาน · ลำดับ fix",
        ha="center", fontsize=10, color=BLUE_LINE, weight="bold")

sections = [
    "1. Purpose", "2. When to Use",
    "3. Inputs", "4. Outputs",
    "5. Process", "6. Quality Gate",
    "7. AI Guardrails", "8. Chain",
]
for i, s in enumerate(sections):
    col = i % 2
    row = i // 2
    x = 10.0 + col * 7.6
    y = 5.0 - row * 0.95
    card(ax, x, y - 0.35, 7.0, 0.7, "#ffffff", BLUE_LINE, lw=0.9, rounding=0.15)
    ax.text(x + 0.4, y, s, ha="left", va="center",
            fontsize=11, color=INK, weight="bold")

ax.text(17.4, 0.2,
        "ลำดับนี้มาจาก trial-and-error 12 → 5 → 8 ไม่ใช่จาก insight",
        ha="center", fontsize=9.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig(OUT_DIR / "img_anatomy.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_anatomy.png")


# ============================================================
# IMAGE 2: Lazy load (3-phase timeline)
# ============================================================
fig, ax = plt.subplots(figsize=(13, 7), dpi=160)
ax.set_xlim(0, 26)
ax.set_ylim(0, 14)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(13, 13.0, "เวลา skill ถูกโหลด เกิดอะไรขึ้นจริงๆ",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(13, 12.2,
        "Lazy loading. body ไม่อยู่ใน context จนกว่า trigger จะ match.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# 3 phase cards
phases = [
    {
        "x": 0.6, "color_bg": GRAY_BG, "color_line": GRAY_LINE,
        "label": "PHASE 1", "phase_color": SUB,
        "title": "Session เริ่ม",
        "loaded": "frontmatter ของทุก skill\n(name + description)",
        "size": "หลักพัน token รวม",
        "size_color": GREEN_LINE,
    },
    {
        "x": 9.0, "color_bg": YELLOW_BG, "color_line": YELLOW_LINE,
        "label": "PHASE 2", "phase_color": YELLOW_LINE,
        "title": "User พิมพ์ message",
        "loaded": 'Claude scan keyword ใน description\nเทียบ user intent → match?',
        "size": "ยังไม่โหลด body",
        "size_color": SUB,
    },
    {
        "x": 17.4, "color_bg": GREEN_BG, "color_line": GREEN_LINE,
        "label": "PHASE 3", "phase_color": GREEN_LINE,
        "title": "Skill ถูก trigger",
        "loaded": "body ของ skill ตัวที่ match\n+ template/reference (on-demand)",
        "size": "เพิ่งจะ ~1,000-3,000 token",
        "size_color": ACCENT,
    },
]

for p in phases:
    card(ax, p["x"], 2.0, 8.0, 9.0, p["color_bg"], p["color_line"])
    # Phase label pill
    card(ax, p["x"] + 0.4, 9.9, 1.7, 0.7, p["color_line"], p["color_line"],
         lw=0, rounding=0.15)
    ax.text(p["x"] + 1.25, 10.25, p["label"], ha="center", va="center",
            fontsize=8.5, color="#ffffff", weight="bold")
    # Title
    ax.text(p["x"] + 4.0, 9.0, p["title"], ha="center", va="center",
            fontsize=14, color=INK, weight="bold")
    # Loaded box
    card(ax, p["x"] + 0.4, 5.4, 7.2, 3.0, "#ffffff", p["color_line"],
         lw=1.0, rounding=0.2)
    ax.text(p["x"] + 4.0, 7.5, "อยู่ใน context:", ha="center",
            fontsize=10, color=SUB, weight="bold")
    for i, line in enumerate(p["loaded"].split("\n")):
        ax.text(p["x"] + 4.0, 6.85 - i * 0.55, line, ha="center",
                fontsize=10.5, color=INK)
    # Size annotation
    ax.text(p["x"] + 4.0, 4.5, p["size"], ha="center",
            fontsize=11, color=p["size_color"], weight="bold")
    ax.text(p["x"] + 4.0, 3.7, "(token cost)", ha="center",
            fontsize=9, color=SUB, style="italic")

# Arrows between phases
arrow_props = dict(arrowstyle="->", color=SUB, lw=1.5, mutation_scale=18)
for x in [8.7, 17.1]:
    ax.annotate("", xy=(x + 0.4, 6.5), xytext=(x, 6.5), arrowprops=arrow_props)

# Bottom note
ax.text(13, 1.0,
        "ระบบรับ skill ใหม่ได้เรื่อยๆ โดย context ไม่บวม. body ของ skill ที่ไม่ถูกใช้ ไม่กิน token เลย.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig(OUT_DIR / "img_lazy_load.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_lazy_load.png")


# ============================================================
# IMAGE 3: Chain via filename (no glue layer)
# ============================================================
fig, ax = plt.subplots(figsize=(13, 7), dpi=160)
ax.set_xlim(0, 26)
ax.set_ylim(0, 14)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(13, 13.0, "skill เชื่อมกันยังไง โดยที่ไม่มี API ระหว่าง skill",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(13, 12.2,
        "ไม่มี dispatch. ไม่มี state. filename เป็น message format. user เป็น orchestrator.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# Skill A box (left)
card(ax, 0.5, 5.0, 6.5, 4.5, BLUE_BG, BLUE_LINE)
ax.text(3.75, 8.7, "SKILL A", ha="center", fontsize=10,
        color=BLUE_LINE, weight="bold")
ax.text(3.75, 8.0, "test-case-writer", ha="center", fontsize=13,
        color=INK, weight="bold")
ax.text(3.75, 7.0, "input: SRS", ha="center", fontsize=10, color=SUB)
ax.text(3.75, 6.4, "output: TC file", ha="center", fontsize=10, color=SUB)
ax.text(3.75, 5.4, "(เขียนไฟล์ตาม naming\nconvention ตายตัว)",
        ha="center", fontsize=9, color=SUB, style="italic")

# File in middle
card(ax, 9.0, 5.4, 8.0, 3.7, YELLOW_BG, YELLOW_LINE)
ax.text(13.0, 8.4, "FILE (message)", ha="center", fontsize=10,
        color=YELLOW_LINE, weight="bold")
ax.text(13.0, 7.5,
        "testcases_sit_login\n_20260420.md",
        ha="center", fontsize=11.5, color=INK,
        family="monospace", weight="bold")
ax.text(13.0, 6.0, "filename = message format",
        ha="center", fontsize=9.5, color=SUB, style="italic")

# Skill B box (right)
card(ax, 19.0, 5.0, 6.5, 4.5, PURPLE_BG, PURPLE_LINE)
ax.text(22.25, 8.7, "SKILL B", ha="center", fontsize=10,
        color=PURPLE_LINE, weight="bold")
ax.text(22.25, 8.0, "test-case-reviewer", ha="center", fontsize=13,
        color=INK, weight="bold")
ax.text(22.25, 7.0, "input: TC file + SRS", ha="center", fontsize=10, color=SUB)
ax.text(22.25, 6.4, "output: review report", ha="center", fontsize=10, color=SUB)
ax.text(22.25, 5.4, "(อ่านไฟล์ที่ user อ้าง)",
        ha="center", fontsize=9, color=SUB, style="italic")

# Arrows
arrow_props_solid = dict(arrowstyle="->", color=GRAY_LINE, lw=1.8, mutation_scale=20)
ax.annotate("", xy=(8.9, 7.2), xytext=(7.05, 7.2), arrowprops=arrow_props_solid)
ax.annotate("", xy=(18.95, 7.2), xytext=(17.05, 7.2), arrowprops=arrow_props_solid)

# Labels above arrows
ax.text(7.95, 7.7, "writes", ha="center", fontsize=9.5, color=SUB)
ax.text(18.0, 7.7, "reads", ha="center", fontsize=9.5, color=SUB)

# User box at bottom (the orchestrator)
card(ax, 6.5, 1.5, 13.0, 2.6, "#ffffff", ACCENT, lw=2.0)
ax.text(13.0, 3.55, "USER (orchestrator)", ha="center", fontsize=10,
        color=ACCENT, weight="bold")
ax.text(13.0, 2.85,
        '@testcases_sit_login_20260420.md  review หน่อย เทียบ SRS',
        ha="center", fontsize=10.5, color=INK)
ax.text(13.0, 2.05, "user เป็นคนพิมพ์ chain เอง ไม่มี glue layer ที่ designed",
        ha="center", fontsize=9.5, color=SUB, style="italic")

# Curved arrow from file down to user, and from user to skill B
arrow_curve = FancyArrowPatch(
    (13.0, 5.4), (13.0, 4.1),
    arrowstyle="->", mutation_scale=18, color=ACCENT, lw=1.5, alpha=0.8,
)
ax.add_patch(arrow_curve)
ax.text(13.4, 4.75, "user pastes filename",
        ha="left", fontsize=9, color=ACCENT, style="italic")

# Bottom caption
ax.text(13, 0.5,
        "ผลพลอยได้ที่ไม่ได้ตั้งใจ: ระบบ debuggable. user เห็นทุก step. แก้ไฟล์ตรงๆ ได้ตอน chain พัง.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig(OUT_DIR / "img_filename_chain.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_filename_chain.png")


# ============================================================
# IMAGE 4: 3-layer override
# ============================================================
fig, ax = plt.subplots(figsize=(12, 8), dpi=160)
ax.set_xlim(0, 24)
ax.set_ylim(0, 16)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(12, 15.2, "3 layer ของ context: skill ตัวเดียวใช้ข้าม project ได้",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(12, 14.4,
        "skill อ่าน 3 layer รวมกันก่อน generate. แก้ที่ layer ไหน กระทบเท่าไหร่ ตอบได้ในวินาทีเดียว.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# Layer cards (stacked, top = highest priority / per-project)
layers = [
    {
        "y": 10.4, "h": 2.7,
        "color_bg": ACCENT, "color_line": ACCENT,
        "label": "LAYER 3", "title": "project-context.md",
        "scope": "per-project · ใน working directory",
        "owns": "Environment URL, NFR, Glossary, Business Rule เฉพาะลูกค้า",
    },
    {
        "y": 7.0, "h": 2.7,
        "color_bg": BLUE_LINE, "color_line": BLUE_LINE,
        "label": "LAYER 2", "title": "references/qa-standards.md",
        "scope": "team-shared · single source of truth",
        "owns": "Severity, Priority, Sizing, Buffer, KPI · บังคับทุก skill",
    },
    {
        "y": 3.6, "h": 2.7,
        "color_bg": GREEN_LINE, "color_line": GREEN_LINE,
        "label": "LAYER 1", "title": "SKILL.md",
        "scope": "universal · ใช้ข้าม project ได้ทุกตัว",
        "owns": "logic ของ skill (เขียน TC ยังไง) · ห้าม hardcode company",
    },
]

for layer in layers:
    card(ax, 1.5, layer["y"], 21.0, layer["h"],
         layer["color_bg"], layer["color_line"], lw=1.2)
    # Layer label pill
    card(ax, 1.9, layer["y"] + layer["h"] - 0.85, 1.7, 0.65,
         "#ffffff", layer["color_line"], lw=1.0, rounding=0.15)
    ax.text(2.75, layer["y"] + layer["h"] - 0.52, layer["label"],
            ha="center", va="center", fontsize=8.5,
            color=layer["color_line"], weight="bold")
    # Title
    ax.text(4.2, layer["y"] + layer["h"] - 0.55, layer["title"],
            ha="left", va="center", fontsize=14,
            color="#ffffff", weight="bold", family="monospace")
    # Scope
    ax.text(4.2, layer["y"] + layer["h"] - 1.4, layer["scope"],
            ha="left", va="center", fontsize=10,
            color="#ffffff", style="italic", alpha=0.95)
    # Owns
    ax.text(4.2, layer["y"] + 0.5, "owns: " + layer["owns"],
            ha="left", va="center", fontsize=10.5, color="#ffffff")

# Override arrow on left side
ax.annotate("", xy=(0.9, 11.7), xytext=(0.9, 4.5),
            arrowprops=dict(arrowstyle="->", color=SUB, lw=1.5))
ax.text(0.5, 8.0, "override", rotation=90, ha="center", va="center",
        fontsize=10, color=SUB, weight="bold")

# Right-side scope arrow (broader at bottom)
ax.text(23.5, 4.95, "ทั้งทีม\nใช้เหมือนกัน", rotation=0, ha="center", va="center",
        fontsize=9, color=GREEN_LINE, weight="bold")
ax.text(23.5, 8.35, "ทั้ง repo\nใช้เหมือนกัน", rotation=0, ha="center", va="center",
        fontsize=9, color=BLUE_LINE, weight="bold")
ax.text(23.5, 11.75, "เฉพาะ\nproject นี้", rotation=0, ha="center", va="center",
        fontsize=9, color=ACCENT, weight="bold")

# Bottom caption
ax.text(12, 1.6,
        "ทำไมไม่ใส่ทุกอย่างที่เดียว? ลองมาแล้ว. ทุกแบบ.",
        ha="center", fontsize=11, color=INK, weight="bold")
ax.text(12, 0.95,
        "ฝัง standard ใน skill → เปลี่ยน scale ทีต้องตามแก้ทุก skill. ไม่มีมาตรฐานกลาง → ต่างคนต่างกำหนด Severity.",
        ha="center", fontsize=9.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig(OUT_DIR / "img_3_layer_override.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_3_layer_override.png")

print("done.")
