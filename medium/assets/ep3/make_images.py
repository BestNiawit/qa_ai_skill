"""
Generate 3 PNG images for EP3.
Style: matches EP2 (clean, light, Medium-friendly). No emojis. No em dashes.
"""

import os
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.patches import FancyBboxPatch
import numpy as np

# Register a Thai-capable font so Thai glyphs render correctly.
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

# ── Common style (synced with EP2) ────────────────────────────
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
ACCENT = "#c2410c"

OUT_DIR = Path(__file__).resolve().parent


def card(ax, x, y, w, h, fill, edge, lw=1.5):
    box = FancyBboxPatch(
        (x, y), w, h,
        boxstyle="round,pad=0.02,rounding_size=0.4",
        linewidth=lw, edgecolor=edge, facecolor=fill,
    )
    ax.add_patch(box)


# ============================================================
# IMAGE 1: Skill graveyard (4 ideas we threw away)
# ============================================================
fig, ax = plt.subplots(figsize=(12, 7.5), dpi=160)
ax.set_xlim(0, 24)
ax.set_ylim(0, 15)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(12, 14.2, "Skills we tried, then threw away",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(12, 13.4, "Not because the AI was bad. Because the output had nowhere to go.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# 2x2 grid of cards
cards = [
    {
        "x": 0.8, "y": 7.2, "w": 11.0, "h": 5.4,
        "title": "Test Data Fixture Generator",
        "tag": "no business rule",
        "desc": [
            "Idea: AI ดู schema ของ form แล้วสร้าง JSON dummy",
            "ครบทุก data type ให้เลย.",
            "",
            "Reality: dummy ดูถูก format แต่ไม่ตรง business",
            "rule เฉพาะ project (เช่น เลขบัญชีต้องขึ้นต้นด้วย 0).",
            "Tester ต้องไล่แก้ทุกตัว ช้ากว่าเขียนเอง.",
        ],
    },
    {
        "x": 12.2, "y": 7.2, "w": 11.0, "h": 5.4,
        "title": "Slack Thread Summarizer",
        "tag": "out of scope",
        "desc": [
            "Idea: Sum thread ของ sprint แล้วหา bug pattern.",
            "",
            "Reality: ไม่ใช่หน้าที่ของ QA tooling.",
            "ทิ้งก่อนเริ่มเขียน SKILL.md ด้วยซ้ำ.",
            "บทเรียน: ไม่ใช่ทุกอย่างที่ทำได้ ต้องเอามาทำ.",
        ],
    },
    {
        "x": 0.8, "y": 1.2, "w": 11.0, "h": 5.4,
        "title": "API Contract Test from Swagger",
        "tag": "overlap",
        "desc": [
            "Idea: อ่าน swagger.json แล้ว generate",
            "contract test cases อัตโนมัติ.",
            "",
            "Reality: ทับ scope กับ test-case-writer ที่",
            "อ่าน API spec ได้อยู่แล้ว.",
            "ทิ้ง: รวมเข้าตัวเดิมดีกว่า.",
        ],
    },
    {
        "x": 12.2, "y": 1.2, "w": 11.0, "h": 5.4,
        "title": "Regression Risk Predictor",
        "tag": "no data",
        "desc": [
            "Idea: AI ทำนายว่า feature ไหนเสี่ยง regress",
            "ตอนใกล้ release.",
            "",
            "Reality: ต้องการ data จริง (defect history,",
            "code churn, test coverage ต่อ module) ที่",
            "ทีมยังไม่ได้เก็บ.",
        ],
    },
]

for c in cards:
    card(ax, c["x"], c["y"], c["w"], c["h"], RED_BG, RED_LINE)
    # Title
    ax.text(c["x"] + 0.5, c["y"] + c["h"] - 0.6, c["title"],
            ha="left", va="center", fontsize=12.5, color=INK, weight="bold")
    # Tag pill (right-aligned)
    tag_w = 0.13 * len(c["tag"]) + 0.55
    pill_x = c["x"] + c["w"] - tag_w - 0.4
    ax.add_patch(FancyBboxPatch(
        (pill_x, c["y"] + c["h"] - 0.85), tag_w, 0.5,
        boxstyle="round,pad=0.0,rounding_size=0.15",
        linewidth=0, facecolor=RED_LINE,
    ))
    ax.text(pill_x + tag_w / 2, c["y"] + c["h"] - 0.6, c["tag"],
            ha="center", va="center", fontsize=8.5, color="#ffffff", weight="bold")
    # Desc lines
    for i, line in enumerate(c["desc"]):
        ax.text(c["x"] + 0.5, c["y"] + c["h"] - 1.5 - i * 0.55, line,
                ha="left", va="center", fontsize=9.5, color=INK)

# Footer caption
ax.text(12, 0.45,
        "Pattern: AI was fine. The bottleneck was always the human review step.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig(OUT_DIR / "img_skill_graveyard.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_skill_graveyard.png")


# ============================================================
# IMAGE 2: data-type-matrix-generator timeline (4 days)
# ============================================================
fig, ax = plt.subplots(figsize=(13, 6), dpi=160)
ax.set_xlim(0, 26)
ax.set_ylim(0, 12)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(13, 11.0, "data-type-matrix-generator: the skill that almost did not exist",
        ha="center", fontsize=16, color=INK, weight="bold")
ax.text(13, 10.2, "Decided not to build it on Day 1. Built it anyway on Day 4.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# Timeline axis
ax.plot([1.5, 24.5], [5, 5], color=GRAY_LINE, linewidth=2, zorder=1)

# Day markers
days = [
    {"x": 3.5,  "label": "Day 1",  "date": "20 เม.ย.",
     "color": GRAY_LINE, "filled": False},
    {"x": 10.0, "label": "Day 2",  "date": "21 เม.ย.",
     "color": YELLOW_LINE, "filled": True},
    {"x": 16.5, "label": "Day 3",  "date": "22 เม.ย.",
     "color": YELLOW_LINE, "filled": True},
    {"x": 23.0, "label": "Day 4",  "date": "24 เม.ย.",
     "color": GREEN_LINE, "filled": True},
]

for d in days:
    facec = d["color"] if d["filled"] else "#ffffff"
    ax.scatter([d["x"]], [5], s=320, edgecolors=d["color"],
               facecolors=facec, zorder=3, linewidths=2.2)
    ax.text(d["x"], 4.0, d["label"], ha="center", va="center",
            fontsize=11, color=INK, weight="bold")
    ax.text(d["x"], 3.4, d["date"], ha="center", va="center",
            fontsize=9, color=SUB)

# Event boxes ABOVE the line
events_top = [
    {"x": 3.5, "title": "ตกลงไม่ทำ",
     "body": "first batch 10 skills เสร็จ.\ntest-case-writer cover\nboundary value อยู่แล้ว.",
     "color_bg": GRAY_BG, "color_edge": GRAY_LINE, "color_title": SUB},
    {"x": 13.25, "title": "เริ่มเจอ gap",
     "body": "TC ที่ generate ขาดเคส:\nTHB rounding, null vs empty,\ntimezone field. ซ้ำๆ.",
     "color_bg": YELLOW_BG, "color_edge": YELLOW_LINE, "color_title": YELLOW_LINE},
    {"x": 23.0, "title": "Pivot. สร้าง.",
     "body": "data-type-matrix-generator\nเข้าระบบ. กลายเป็น defensive\nfallback ตอน req ไม่ชัด.",
     "color_bg": GREEN_BG, "color_edge": GREEN_LINE, "color_title": GREEN_LINE},
]

for e in events_top:
    box_w, box_h = 5.0, 3.5
    box_x = e["x"] - box_w / 2
    box_y = 6.0
    card(ax, box_x, box_y, box_w, box_h, e["color_bg"], e["color_edge"], lw=1.2)
    # Connector
    ax.plot([e["x"], e["x"]], [5.18, box_y], color=e["color_edge"],
            linewidth=1.2, zorder=2)
    ax.text(e["x"], box_y + box_h - 0.6, e["title"], ha="center",
            fontsize=11, color=e["color_title"], weight="bold")
    for i, line in enumerate(e["body"].split("\n")):
        ax.text(e["x"], box_y + box_h - 1.3 - i * 0.55, line,
                ha="center", fontsize=9.2, color=INK)

# Mid-debate marker
ax.text(13.25, 2.4, "ระหว่างทาง: ทีมเถียงกัน ~2 ชม. ใน Slack",
        ha="center", fontsize=10, color=ACCENT, style="italic")
ax.text(13.25, 1.7, "scope-creep หรือ gap จริง?",
        ha="center", fontsize=10, color=ACCENT, style="italic")

# Footer
ax.text(13, 0.45,
        "บทเรียน: trust the gap, ไม่ใช่ trust the tool list ที่วางไว้แต่แรก.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig(OUT_DIR / "img_dtm_timeline.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_dtm_timeline.png")


# ============================================================
# IMAGE 3: AI estimate vs actual hours (scatter, no correlation)
# ============================================================
fig, ax = plt.subplots(figsize=(11, 7.5), dpi=160)
fig.patch.set_facecolor(BG)

ax.set_facecolor("#ffffff")
ax.set_xlabel("AI estimate (hours)", fontsize=11, color=INK)
ax.set_ylabel("Actual hours", fontsize=11, color=INK)
ax.set_title("AI estimate vs reality (12 sprints)",
             fontsize=15, color=INK, weight="bold", pad=16)

# Reference y = x line (perfect prediction)
xs = np.linspace(0, 35, 50)
ax.plot(xs, xs, color=GREEN_LINE, linewidth=1.6, linestyle="--",
        label="perfect prediction (y = x)", zorder=2)

# 12 deliberately uncorrelated points
rng = np.random.default_rng(seed=7)
ai_est = np.array([8, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32], dtype=float)
# Actual hours: NOT correlated with estimate; some overshoot, some undershoot
actual = np.array([14, 9, 22, 28, 13, 11, 26, 11, 31, 14, 19, 28], dtype=float)

ax.scatter(ai_est, actual, s=130, color=ACCENT, edgecolors="#7c2d12",
           linewidths=1.2, zorder=3, alpha=0.92, label="real sprint outcome")

# Highlight 2 specific points mentioned in the article
hl_idx = [3, 7]  # AI 16 -> 28, AI 24 -> 11
for i in hl_idx:
    ax.annotate(
        f"AI: {int(ai_est[i])} hr\nactual: {int(actual[i])} hr",
        xy=(ai_est[i], actual[i]),
        xytext=(ai_est[i] + 2.2, actual[i] + (4 if i == 3 else -5)),
        fontsize=9.5, color=INK,
        arrowprops=dict(arrowstyle="->", color=SUB, lw=1, shrinkA=2, shrinkB=4),
        bbox=dict(boxstyle="round,pad=0.4", fc="#fff7ed",
                  ec=YELLOW_LINE, lw=1),
    )

ax.set_xlim(4, 36)
ax.set_ylim(4, 36)
ax.grid(True, color=GRAY_BG, linewidth=1, zorder=0)
for spine in ["top", "right"]:
    ax.spines[spine].set_visible(False)
ax.spines["left"].set_color(GRAY_LINE)
ax.spines["bottom"].set_color(GRAY_LINE)
ax.tick_params(colors=SUB)

leg = ax.legend(loc="upper left", frameon=False, fontsize=10)
for text in leg.get_texts():
    text.set_color(INK)

# Subtitle (placed safely above chart, below title)
fig.text(0.5, 0.905,
         "ถ้ามี correlation จุดควรเรียงเข้าหา line. นี่คือไม่มี.",
         ha="center", fontsize=11, color=SUB, style="italic")

# Bottom note (on figure, not axes)
fig.text(0.5, 0.015,
         "บทเรียน: AI ไม่รู้ว่าใครจะลาในสัปดาห์นี้ ใครถนัด feature นี้ environment เสถียรไหม.",
         ha="center", fontsize=10, color=SUB, style="italic")

plt.tight_layout(rect=[0, 0.05, 1, 0.89])
plt.savefig(OUT_DIR / "img_ai_estimate_vs_actual.png", dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_ai_estimate_vs_actual.png")

print("done.")
