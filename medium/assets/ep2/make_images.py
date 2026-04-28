"""
Generate 3 PNG images for the Medium post EP2.
Style: clean, light, Medium-friendly. No emojis. No em dashes.
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch
import matplotlib.font_manager as fm

# Common style
BG = "#ffffff"
INK = "#1a1a1a"
SUB = "#6b6b6b"
RED_BG = "#fdecea"
RED_LINE = "#e07a72"
GREEN_BG = "#e8f3ec"
GREEN_LINE = "#5a9a6e"
GRAY_BG = "#f5f5f4"
GRAY_LINE = "#c9c8c5"
ACCENT = "#c2410c"

def card(ax, x, y, w, h, fill, edge, lw=1.5):
    box = FancyBboxPatch((x, y), w, h,
                         boxstyle="round,pad=0.02,rounding_size=0.4",
                         linewidth=lw, edgecolor=edge, facecolor=fill)
    ax.add_patch(box)

# ============================================================
# IMAGE 1: Prompt A vs Prompt B (Token Economy comparison)
# ============================================================
fig, ax = plt.subplots(figsize=(12, 7), dpi=160)
ax.set_xlim(0, 24)
ax.set_ylim(0, 14)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

# Title
ax.text(12, 13.2, "Same requirement. Two prompts.",
        ha="center", va="center", fontsize=18, color=INK, weight="bold")
ax.text(12, 12.4, "We ran this early on to see if tokens actually mattered.",
        ha="center", va="center", fontsize=11, color=SUB, style="italic")

# Left card: Prompt A
card(ax, 0.8, 1.5, 10.8, 10.0, RED_BG, RED_LINE)
ax.text(6.2, 10.7, "PROMPT A", ha="center", fontsize=10, color=RED_LINE, weight="bold")
ax.text(6.2, 10.0, "the old way", ha="center", fontsize=14, color=INK, weight="bold")

bullets_a = [
    "Severity scale (5 levels, defined here)",
    "Priority scale (P0 to P3, examples)",
    "Output format (columns, order, headers)",
    'What an "expected result" should look like',
    "Guardrails for sensitive data",
    "...",
    "Then: paste the full 400-line requirement",
]
for i, b in enumerate(bullets_a):
    ax.text(1.4, 8.7 - i*0.7, "-  " + b, ha="left", va="center",
            fontsize=10.5, color=INK)

# Token count box
ax.add_patch(FancyBboxPatch((1.4, 2.1), 9.6, 1.4,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.2, edgecolor=RED_LINE,
                            facecolor="#ffffff"))
ax.text(6.2, 3.0, "~1,400 tokens", ha="center", fontsize=20,
        color=RED_LINE, weight="bold")
ax.text(6.2, 2.4, "spent before the requirement even starts",
        ha="center", fontsize=10, color=SUB, style="italic")

# Right card: Prompt B
card(ax, 12.4, 1.5, 10.8, 10.0, GREEN_BG, GREEN_LINE)
ax.text(17.8, 10.7, "PROMPT B", ha="center", fontsize=10,
        color=GREEN_LINE, weight="bold")
ax.text(17.8, 10.0, "the skill way", ha="center", fontsize=14,
        color=INK, weight="bold")

# Code-style block
ax.add_patch(FancyBboxPatch((13.0, 6.5), 9.6, 2.6,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.0, edgecolor=GRAY_LINE,
                            facecolor="#ffffff"))
ax.text(13.4, 8.3, "/test-case-writer", ha="left", va="center",
        fontsize=14, color=ACCENT, family="monospace", weight="bold")
ax.text(13.4, 7.5, "+ <400-line requirement>", ha="left", va="center",
        fontsize=12, color=INK, family="monospace")
ax.text(13.4, 6.85, "(no instructions, no explanation)",
        ha="left", va="center", fontsize=10, color=SUB, style="italic")

ax.text(17.8, 5.7, "The skill already knows everything",
        ha="center", fontsize=11, color=INK)
ax.text(17.8, 5.2, "from Prompt A. It is baked in.",
        ha="center", fontsize=11, color=INK)

# Token count box
ax.add_patch(FancyBboxPatch((13.0, 2.1), 9.6, 1.4,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.2, edgecolor=GREEN_LINE,
                            facecolor="#ffffff"))
ax.text(17.8, 3.0, "~0 tokens of instructions",
        ha="center", fontsize=20, color=GREEN_LINE, weight="bold")
ax.text(17.8, 2.4, "all attention goes to the requirement",
        ha="center", fontsize=10, color=SUB, style="italic")

# Bottom verdict
ax.text(12, 0.7, "Output quality:  roughly the same.",
        ha="center", fontsize=12.5, color=INK, weight="bold")

plt.tight_layout()
plt.savefig("/sessions/modest-happy-bohr/mnt/outputs/img_token_compare.png",
            dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_token_compare.png")

# ============================================================
# IMAGE 2: Locator source (HTML / data-testid)
# ============================================================
fig, ax = plt.subplots(figsize=(12, 7.5), dpi=160)
ax.set_xlim(0, 24)
ax.set_ylim(0, 15)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(12, 14.2, "Why automation skills need a locator source",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(12, 13.4, "Without HTML or data-testid hooks, the AI invents selectors that look real but do not exist.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# Left card: Without locator (bad)
card(ax, 0.8, 1.5, 10.8, 11.0, RED_BG, RED_LINE)
ax.text(6.2, 11.7, "WITHOUT LOCATOR SOURCE",
        ha="center", fontsize=10, color=RED_LINE, weight="bold")
ax.text(6.2, 11.0, "what the AI guesses", ha="center",
        fontsize=13, color=INK, weight="bold")

# Code block
ax.add_patch(FancyBboxPatch((1.3, 4.0), 9.8, 6.4,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.0, edgecolor=GRAY_LINE,
                            facecolor="#1f1f1f"))
code_a = [
    "*** Login Keywords ***",
    "Click Login Button",
    "    Click Element    css=.btn-primary-login",
    "    # ^ this class does NOT exist on the page",
    "",
    "Fill Username",
    "    Input Text    id=user_email_input",
    "    # ^ guessed id, real one is different",
    "",
    "Submit Form",
    "    Click Element    xpath=//button[@type='submit']",
    "    # ^ matches 3 buttons, ambiguous",
]
for i, line in enumerate(code_a):
    color = "#9ca3af" if line.strip().startswith("#") else "#f3f4f6"
    if line.strip().startswith("***"):
        color = "#fbbf24"
    ax.text(1.55, 9.9 - i*0.45, line, ha="left", va="center",
            fontsize=9, color=color, family="monospace")

ax.text(6.2, 3.2, "Looks plausible at review.", ha="center",
        fontsize=10.5, color=INK)
ax.text(6.2, 2.6, "Blows up at runtime.", ha="center",
        fontsize=11, color=RED_LINE, weight="bold")
ax.text(6.2, 2.0, '("worse than generating nothing")', ha="center",
        fontsize=9.5, color=SUB, style="italic")

# Right card: With data-testid (good)
card(ax, 12.4, 1.5, 10.8, 11.0, GREEN_BG, GREEN_LINE)
ax.text(17.8, 11.7, "WITH data-testid HOOKS",
        ha="center", fontsize=10, color=GREEN_LINE, weight="bold")
ax.text(17.8, 11.0, "give the skill something real",
        ha="center", fontsize=13, color=INK, weight="bold")

ax.add_patch(FancyBboxPatch((12.9, 4.0), 9.8, 6.4,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.0, edgecolor=GRAY_LINE,
                            facecolor="#1f1f1f"))
code_b = [
    "<!-- HTML we control -->",
    '<input data-testid="login-email" />',
    '<input data-testid="login-password" />',
    '<button data-testid="login-submit">Log in</button>',
    "",
    "*** Login Keywords ***",
    "Fill Username",
    '    Input Text    css=[data-testid="login-email"]',
    "",
    "Submit Form",
    '    Click Element    css=[data-testid="login-submit"]',
    "    # ^ stable, unambiguous, owned by us",
]
for i, line in enumerate(code_b):
    color = "#9ca3af" if line.strip().startswith("#") or line.strip().startswith("<!--") else "#f3f4f6"
    if line.strip().startswith("***"):
        color = "#fbbf24"
    ax.text(13.15, 9.9 - i*0.45, line, ha="left", va="center",
            fontsize=9, color=color, family="monospace")

ax.text(17.8, 3.2, "Stable across UI refactors.",
        ha="center", fontsize=10.5, color=INK)
ax.text(17.8, 2.6, "Runs first try.",
        ha="center", fontsize=11, color=GREEN_LINE, weight="bold")
ax.text(17.8, 2.0, "(the rule: no automation skill without this)",
        ha="center", fontsize=9.5, color=SUB, style="italic")

plt.tight_layout()
plt.savefig("/sessions/modest-happy-bohr/mnt/outputs/img_locator_source.png",
            dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_locator_source.png")

# ============================================================
# IMAGE 3: Slack message vs requirement-analyzer output
# ============================================================
fig, ax = plt.subplots(figsize=(12, 7.5), dpi=160)
ax.set_xlim(0, 24)
ax.set_ylim(0, 15)
ax.set_aspect("equal")
ax.axis("off")
fig.patch.set_facecolor(BG)

ax.text(12, 14.2, "Same complaint. Two formats. Different reactions.",
        ha="center", fontsize=17, color=INK, weight="bold")
ax.text(12, 13.4, "We did not set out to change PM behavior. The format did it for us.",
        ha="center", fontsize=10.5, color=SUB, style="italic")

# Left: Slack message (the old way)
card(ax, 0.8, 1.5, 10.8, 11.0, GRAY_BG, GRAY_LINE)
ax.text(6.2, 11.7, "BEFORE: SLACK DM",
        ha="center", fontsize=10, color=SUB, weight="bold")

# Slack-style message bubble
ax.add_patch(FancyBboxPatch((1.5, 6.5), 9.4, 4.0,
                            boxstyle="round,pad=0.02,rounding_size=0.3",
                            linewidth=0, facecolor="#ffffff"))
ax.text(2.0, 9.8, "QA Bell", ha="left", fontsize=10.5,
        color=INK, weight="bold")
ax.text(3.6, 9.8, "10:42 AM", ha="left", fontsize=8.5, color=SUB)
ax.text(2.0, 9.0, "hey this BRD is kinda unclear",
        ha="left", fontsize=11, color=INK)
ax.text(2.0, 8.4, "can you take a look when free?",
        ha="left", fontsize=11, color=INK)
ax.text(2.0, 7.6, "PM", ha="left", fontsize=10.5,
        color=INK, weight="bold")
ax.text(2.5, 7.6, "11:08 AM", ha="left", fontsize=8.5, color=SUB)
ax.text(2.0, 6.9, "ok will check later today",
        ha="left", fontsize=11, color=INK)

# Result
ax.add_patch(FancyBboxPatch((1.5, 2.3), 9.4, 3.4,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.0, edgecolor=GRAY_LINE,
                            facecolor="#ffffff"))
ax.text(6.2, 5.0, "Reaction:", ha="center", fontsize=10,
        color=SUB, weight="bold")
ax.text(6.2, 4.3, "easy to scroll past", ha="center",
        fontsize=11.5, color=INK)
ax.text(6.2, 3.7, "no clear next step", ha="center",
        fontsize=11.5, color=INK)
ax.text(6.2, 3.0, "gets answered later (or not)",
        ha="center", fontsize=11.5, color=INK)

# Right: requirement-analyzer output (the new way)
card(ax, 12.4, 1.5, 10.8, 11.0, "#fff7ed", ACCENT)
ax.text(17.8, 11.7, "AFTER: requirement-analyzer OUTPUT",
        ha="center", fontsize=10, color=ACCENT, weight="bold")

ax.add_patch(FancyBboxPatch((12.9, 5.7), 9.8, 5.5,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.0, edgecolor=GRAY_LINE,
                            facecolor="#ffffff"))
ax.text(13.2, 10.7, "Readiness: 71%   |   4 open questions",
        ha="left", fontsize=10.5, color=INK, weight="bold")

# Severity rows
rows = [
    ("HIGH",   "#dc2626", "Discount cap not specified for combo orders.",
     "could cause rework"),
    ("HIGH",   "#dc2626", 'Refund window: "reasonable time" is undefined.',
     "blocks TC writing"),
    ("MED",    "#d97706", "Currency rounding rule missing for THB / USD.",
     "data-type-matrix flag"),
    ("LOW",    "#65a30d", "UI copy for empty cart not in spec.",
     "TC-able with assumption"),
]
y0 = 9.7
for tag, tcolor, msg, note in rows:
    ax.add_patch(FancyBboxPatch((13.2, y0 - 0.45), 0.9, 0.55,
                                boxstyle="round,pad=0.0,rounding_size=0.1",
                                linewidth=0, facecolor=tcolor))
    ax.text(13.65, y0 - 0.18, tag, ha="center", va="center",
            fontsize=8, color="#ffffff", weight="bold")
    ax.text(14.3, y0 - 0.05, msg, ha="left", va="center",
            fontsize=9.5, color=INK)
    ax.text(14.3, y0 - 0.5, note, ha="left", va="center",
            fontsize=8.5, color=SUB, style="italic")
    y0 -= 1.1

# Result
ax.add_patch(FancyBboxPatch((12.9, 2.3), 9.8, 3.0,
                            boxstyle="round,pad=0.02,rounding_size=0.2",
                            linewidth=1.0, edgecolor=ACCENT,
                            facecolor="#ffffff"))
ax.text(17.8, 4.7, "Reaction:", ha="center", fontsize=10,
        color=ACCENT, weight="bold")
ax.text(17.8, 4.0, "harder to ignore", ha="center",
        fontsize=11.5, color=INK, weight="bold")
ax.text(17.8, 3.4, "PM replies with specifics, not vibes",
        ha="center", fontsize=11.5, color=INK)
ax.text(17.8, 2.8, "(rare, but it happened same day)",
        ha="center", fontsize=10, color=SUB, style="italic")

plt.tight_layout()
plt.savefig("/sessions/modest-happy-bohr/mnt/outputs/img_pm_format.png",
            dpi=160, bbox_inches="tight", facecolor=BG)
plt.close()
print("saved img_pm_format.png")

print("done.")
