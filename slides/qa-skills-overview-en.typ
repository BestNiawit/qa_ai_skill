// QA AI Skills — Tester Team Overview Deck v2 (EN, 15 min, mixed audience)
// Build: typst compile --root . slides/qa-skills-overview-en.typ slides/qa-skills-overview-en.pdf

#import "../references/typst-templates/lib.typ": (
  ayodia-primary, ayodia-accent, ayodia-muted, ayodia-bg, ayodia-border,
  tier-1, tier-2, tier-3, tier-4,
  badge,
)

// ── Background decoration: subtle accent shapes ──────────────────────
#let corner-decor = place(
  top + right, dx: 0pt, dy: 0pt,
  polygon(
    fill: ayodia-accent.transparentize(88%), stroke: none,
    (0pt, 0pt), (5cm, 0pt), (0pt, 5cm),
  ),
) + place(
  bottom + left, dx: 0pt, dy: 0pt,
  polygon(
    fill: ayodia-primary.transparentize(92%), stroke: none,
    (0pt, 0pt), (3cm, 0pt), (0pt, 3cm),
  ),
)

// ── Page setup: 16:9 landscape ──────────────────────────────────────
#set page(
  paper: "presentation-16-9",
  margin: (top: 1.1cm, bottom: 1.1cm, left: 1.6cm, right: 1.6cm),
  fill: white,
  background: corner-decor,
  footer: context {
    let n = counter(page).get().first()
    if n == 1 { return }
    set text(size: 8pt, fill: ayodia-muted)
    grid(
      columns: (1fr, auto, 1fr),
      align(left)[QA AI Skills · Ayodia Testing Team],
      align(center)[April 2026],
      align(right)[#n / #counter(page).final().first()],
    )
  },
)

#set text(font: ("Helvetica", "Arial"), size: 13pt, lang: "en")
#set par(leading: 0.6em, spacing: 0.7em)

#show heading.where(level: 1): it => block(below: 12pt, above: 0pt)[
  #grid(columns: (4pt, 1fr), gutter: 12pt, align: (left + horizon, left + horizon),
    rect(width: 4pt, height: 28pt, fill: ayodia-accent, stroke: none),
    text(size: 26pt, weight: "bold", fill: ayodia-primary, it.body),
  )
]
#show heading.where(level: 2): it => block(below: 6pt, above: 4pt,
  text(size: 15pt, weight: "bold", fill: ayodia-accent, it.body))
#show heading.where(level: 3): it => block(below: 4pt, above: 2pt,
  text(size: 12pt, weight: "bold", fill: ayodia-primary, it.body))

#show list: set block(spacing: 0.55em)
#show list: set par(leading: 0.55em)

// ── Helpers ─────────────────────────────────────────────────────────
#let phase-tag(label, color) = box(
  fill: color, inset: (x: 9pt, y: 4pt), radius: 4pt,
  text(fill: white, weight: "bold", size: 10pt, label),
)

#let stat(value, label) = align(center)[
  #text(size: 38pt, weight: "bold", fill: ayodia-accent)[#value] \
  #text(size: 11pt, fill: ayodia-muted)[#label]
]

#let skill-card(name, role, savings, body) = block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
  inset: 9pt, width: 100%,
)[
  #grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
    text(size: 12pt, weight: "bold", fill: ayodia-primary)[#name],
    if savings != "" {
      text(size: 9pt, fill: ayodia-accent, weight: "bold")[Save #savings]
    },
  )
  #text(size: 8pt, fill: ayodia-muted)[#role]
  #v(2pt)
  #text(size: 10pt)[#body]
]

#let deep-dive-tag = box(
  fill: tier-1, inset: (x: 9pt, y: 3pt), radius: 3pt,
  text(fill: white, weight: "bold", size: 9pt, "DEEP DIVE"),
)

#let flow-box(label, color: ayodia-primary, fill: white, w: 3.2cm) = box(
  width: w, fill: fill, stroke: 1.5pt + color, radius: 4pt,
  inset: (x: 6pt, y: 8pt),
  align(center, text(size: 10pt, weight: "bold", fill: color, label)),
)
#let arr = text(size: 14pt, fill: ayodia-muted, weight: "bold", " → ")
#let downarr = align(center, text(size: 14pt, fill: ayodia-muted, weight: "bold", "↓"))

#let pain-icon(symbol, title, desc) = block(width: 100%)[
  #align(center)[
    #box(width: 60pt, height: 60pt, radius: 30pt, fill: rgb("#fef2f2"), stroke: 1.5pt + tier-1,
      align(center + horizon, text(size: 24pt, weight: "bold", fill: tier-1, symbol)))
    #v(8pt)
    #text(size: 13pt, weight: "bold", fill: ayodia-primary, title)
    #v(6pt)
    #block[
      #set par(leading: 0.85em)
      #text(size: 10pt, fill: ayodia-muted, desc)
    ]
  ]
]

#let mock-panel(title, body) = block(
  fill: white, stroke: 0.8pt + ayodia-border, radius: 4pt,
  inset: 0pt, width: 100%,
)[
  #block(fill: ayodia-primary, inset: (x: 8pt, y: 4pt), width: 100%)[
    #text(size: 9pt, weight: "bold", fill: white, title)
  ]
  #block(inset: 8pt, body)
]

// Section divider — full color page with phase headline
#let section-divider(num, label, color, subtitle, audience) = page(
  fill: color, background: none, footer: none,
)[
  #set text(fill: white)
  #v(1fr)
  #align(center)[
    #text(size: 13pt, weight: "bold", tracking: 5pt)[
      PHASE #num
    ]
    #v(0.3cm)
    #text(size: 56pt, weight: "bold", label)
    #v(0.3cm)
    #rect(width: 90pt, height: 3pt, fill: white, stroke: none)
    #v(0.4cm)
    #text(size: 18pt, fill: white.transparentize(15%), subtitle)
    #v(0.4cm)
    #box(fill: white.transparentize(80%), inset: (x: 14pt, y: 6pt), radius: 4pt,
      text(size: 11pt, weight: "bold", fill: white, [for #audience]))
  ]
  #v(1fr)
]

// Timeline row (for "1 day in life")
#let tl-row(time, skill, action) = grid(
  columns: (1.6cm, auto, 1fr), gutter: 12pt, align: (right + horizon, center + horizon, left + horizon),
  text(size: 11pt, weight: "bold", fill: ayodia-accent)[#time],
  box(width: 12pt, height: 12pt, radius: 6pt, fill: ayodia-accent, stroke: 2pt + white),
  text(size: 11pt)[#text(weight: "bold", fill: ayodia-primary)[#skill] · #action],
)

// ════════════════════════════════════════════════════════════════════
// 1. TITLE SLIDE
// ════════════════════════════════════════════════════════════════════
#block(height: 100%, width: 100%)[
  #v(2.5cm)
  #align(center)[
    #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 4pt)[
      AYODIA TESTING TEAM · INTERNAL SHARING
    ]
    #v(0.8cm)
    #text(size: 56pt, weight: "bold", fill: ayodia-primary)[
      QA AI Skills
    ]
    #v(0.2cm)
    #rect(width: 80pt, height: 3pt, fill: ayodia-accent, stroke: none)
    #v(0.4cm)
    #text(size: 22pt, fill: ayodia-muted)[
      Cut effort across every testing phase with AI
    ]
    #v(1.4cm)
    #grid(columns: (auto, auto, auto), gutter: 1.8cm,
      stat("13", "AI Skills"),
      stat("30–70%", "Effort Saved"),
      stat("12", "Processes Covered"),
    )
    #v(1cm)
    #text(size: 11pt, fill: ayodia-muted)[
      For Dev · BA · Tester · 15 min · April 2026
    ]
  ]
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 2. THE PROBLEM
// ════════════════════════════════════════════════════════════════════
= The problems we had

#text(size: 13pt, fill: ayodia-muted)[We spent more time on repetitive work than actually hunting bugs]
#v(0.6cm)

#grid(columns: (1fr, 1fr, 1fr), gutter: 0.6cm,
  pain-icon("X", "Repetitive docs every project",
    [Test Plan / Test Case / Report \ rewritten 10× per year]),
  pain-icon("?", "Requirement still unclear",
    [Mid-way through TCs, a gap shows up \ → major revision required]),
  pain-icon("!", "Bug logs incomplete",
    [Dev keeps asking "how to repro?" \ → 3 round-trip loops]),
)

#v(0.6cm)

#grid(columns: (1fr, 1fr, 1fr), gutter: 0.6cm,
  pain-icon("∞", "Automation can't keep up",
    [100 manual TCs → only 20 \ automated → coverage slips]),
  pain-icon("~", "Perf analysis is slow",
    [k6 outputs 50 MB JSON → \ hunt bottleneck in Excel all day]),
  pain-icon("@", "Weekly updates eat hours",
    [Weekly email to leadership \ takes 2 hrs every Friday]),
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 3. THE SOLUTION
// ════════════════════════════════════════════════════════════════════
= The answer — AI drafts, Tester approves

#v(0.5cm)
#align(center)[
  #grid(columns: (1fr, auto, 1fr, auto, 1fr), gutter: 0.5cm, align: horizon,
    flow-box("Input\nReq doc / Test result", color: ayodia-primary, fill: rgb("#eff6ff"), w: 5cm),
    text(size: 24pt, fill: ayodia-accent, weight: "bold", " → "),
    flow-box("AI Skill\n(Claude reads template)", color: ayodia-accent, fill: rgb("#ecfdf5"), w: 5cm),
    text(size: 24pt, fill: ayodia-accent, weight: "bold", " → "),
    flow-box("Draft Output\n.md / .csv ready for review", color: ayodia-primary, fill: rgb("#eff6ff"), w: 5cm),
  )
  #v(0.4cm)
  #downarr
  #v(0.2cm)
  #box(fill: tier-2, inset: (x: 14pt, y: 8pt), radius: 5pt,
    text(fill: white, weight: "bold", size: 14pt, "Tester reviews + edits + approves  →  Commit / ship"))
]

#v(0.8cm)

#grid(columns: (1fr, 1fr), gutter: 1cm,
  block(fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt, inset: 12pt, width: 100%)[
    #text(size: 13pt, weight: "bold", fill: ayodia-primary)[What AI does well]
    #v(4pt)
    #text(size: 11pt)[
      - Drafts structured templates (Plan / TC / Report)
      - Surfaces edge cases + boundary / negative tests
      - Converts across formats (TC → Playwright code)
      - Parses result files (k6 JSON, JMeter CSV)
    ]
  ],
  block(fill: rgb("#fef3c7"), stroke: 0.5pt + tier-3, radius: 5pt, inset: 12pt, width: 100%)[
    #text(size: 13pt, weight: "bold", fill: ayodia-primary)[What humans still own]
    #v(4pt)
    #text(size: 11pt)[
      - Reviewing correctness vs. business intent
      - Real Severity / Priority decisions
      - Approving before it goes to PM / Dev
      - Talking to users during UAT
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 4. 13 SKILLS overview
// ════════════════════════════════════════════════════════════════════
= 13 Skills · grouped by testing phase

#v(0.2cm)

#let skill-pill(name) = box(
  fill: white, stroke: 0.6pt + ayodia-border, radius: 14pt,
  inset: (x: 9pt, y: 4pt),
  text(size: 10pt, weight: "bold", fill: ayodia-primary, name),
)

#let phase-row(tag-label, tag-color, skills-list) = grid(
  columns: (3.5cm, 1fr), gutter: 0.5cm, align: (right + horizon, left + horizon),
  phase-tag(tag-label, tag-color),
  block(inset: (y: 4pt), skills-list),
)

#phase-row("PRE-SIT", tier-1)[
  #skill-pill("requirement-analyzer") #h(4pt)
  #skill-pill("data-type-matrix-generator")
]
#v(0.18cm)
#phase-row("SIT — Plan & Design", tier-2)[
  #skill-pill("test-plan-writer") #h(4pt)
  #skill-pill("test-matrix-generator") #h(4pt)
  #skill-pill("test-case-writer") #h(4pt)
  #skill-pill("test-case-reviewer")
]
#v(0.18cm)
#phase-row("EXECUTE", tier-3)[
  #skill-pill("bug-report-writer") #h(4pt)
  #skill-pill("e2e-test-generator") #h(4pt)
  #skill-pill("robot-test-generator")
]
#v(0.18cm)
#phase-row("UAT", tier-2)[
  #skill-pill("test-case-writer (uat mode)") #h(4pt)
  #skill-pill("test-plan-writer (uat)") #h(4pt)
  #skill-pill("test-report-writer (uat)")
]
#v(0.18cm)
#phase-row("PERFORMANCE", tier-4)[
  #skill-pill("perf-test-generator") #h(4pt)
  #skill-pill("perf-result-analyzer")
]
#v(0.18cm)
#phase-row("REPORT & COMM", ayodia-muted)[
  #skill-pill("test-report-writer") #h(4pt)
  #skill-pill("weekly-update-writer")
]

#v(0.5cm)
#align(center)[
  #text(size: 10pt, fill: ayodia-muted, style: "italic")[
    Every skill shares the same standard (Severity / Priority / Sizing) — data flows across skills with no conversion
  ]
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 5. CASE STUDY — Login feature: 8d → 3d
// ════════════════════════════════════════════════════════════════════
= Case Study · Login Feature (illustrative)

#text(size: 11pt, fill: ayodia-muted)[Hypothetical before/after effort — same module, same scope · numbers illustrate the pattern, not a measured benchmark]
#v(0.2cm)

#grid(columns: (auto, auto, auto, 1fr), gutter: 0.6cm, align: horizon,
  block(fill: rgb("#fef2f2"), stroke: 1.5pt + tier-1, radius: 6pt, inset: 8pt, width: 4cm)[
    #align(center)[
      #text(size: 9pt, weight: "bold", fill: tier-1, tracking: 2pt)[BEFORE · MANUAL]
      #v(2pt)
      #text(size: 30pt, weight: "bold", fill: tier-1)[8 days]
      #v(0pt)
      #text(size: 9pt, fill: ayodia-muted)[1 tester · fully manual]
    ]
  ],
  text(size: 22pt, fill: ayodia-accent, weight: "bold")[ → ],
  block(fill: rgb("#ecfdf5"), stroke: 1.5pt + ayodia-accent, radius: 6pt, inset: 8pt, width: 4cm)[
    #align(center)[
      #text(size: 9pt, weight: "bold", fill: ayodia-accent, tracking: 2pt)[AFTER · AI-ASSISTED]
      #v(2pt)
      #text(size: 30pt, weight: "bold", fill: ayodia-accent)[3 days]
      #v(0pt)
      #text(size: 9pt, fill: ayodia-muted)[1 tester · AI draft + review]
    ]
  ],
  align(center)[
    #box(fill: tier-2, inset: (x: 12pt, y: 8pt), radius: 5pt,
      text(fill: white, weight: "bold", size: 13pt)[Save 5 person-days \ #text(size: 18pt)[62% faster]])
  ],
)

#v(0.3cm)

#mock-panel("Effort breakdown per skill (days)")[
  #set text(size: 9pt)
  #table(
    columns: (1.5fr, auto, auto, auto, 2fr),
    align: (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon),
    stroke: 0.4pt + ayodia-border, inset: 4pt,
    fill: (col, row) => if row == 0 { ayodia-bg },
    [*Step*], [*Before*], [*After*], [*Cut*], [*What it does*],
    [requirement-analyzer], [—], [0.3], [—], [Check BRD · 5 Open Qs to PM],
    [test-plan-writer], [1.0], [0.3], [70%], [SIT Plan · Exit Criteria · Schedule],
    [test-case-writer], [3.0], [1.0], [67%], [28 TCs (positive / negative / boundary)],
    [test-case-reviewer], [0.5], [0.2], [60%], [Peer review checklist · 3 fixes],
    [e2e-test-generator], [2.0], [0.5], [75%], [Playwright POM · 12 auto scripts],
    [bug-report-writer], [0.5], [0.2], [60%], [4 bugs with Severity × Priority],
    [test-report-writer], [1.0], [0.5], [50%], [SIT Report · Exit Criteria evaluation],
  )
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// SECTION DIVIDER · PHASE 1 PRE-SIT
// ════════════════════════════════════════════════════════════════════
#section-divider("1", "Pre-SIT Gate", tier-1,
  "Check the requirement before testing starts", "BA + Tester Lead")

// ════════════════════════════════════════════════════════════════════
// 6. PRE-SIT GATE
// ════════════════════════════════════════════════════════════════════
#phase-tag("PHASE 1 · PRE-SIT", tier-1) #h(8pt) #text(size: 11pt, fill: ayodia-muted)[(For BA + Tester Lead)]
#v(0.2cm)
= Pre-SIT Gate · check the requirement before testing starts

#text(size: 12pt, fill: ayodia-muted)[Prevents the "half a day in, gaps in the requirement force a full redo" situation]
#v(0.4cm)

#grid(columns: (1fr, 1fr), gutter: 0.7cm,
  skill-card(
    "requirement-analyzer",
    "BA · Tester Lead — gate for BRD / PRD / SRS",
    "30–40%",
    [
      Decides whether the requirement is TC-ready:
      - Score: Ready / Partial / Not-ready
      - Lists "Open Questions" to send back to PM
      - Converts to a Normalized Template reused by every skill
    ],
  ),
  skill-card(
    "data-type-matrix-generator",
    "Tester — fallback when reqs are thin and a deadline looms",
    "30–50%",
    [
      Keep moving even when the requirement is incomplete:
      - Data Type Matrix (per field × ECP / BVA)
      - Happy Path E2E + Integration Points
      - Assumption Checklist the PM can tick in 10 min
    ],
  ),
)

#v(0.4cm)

#align(center)[
  #grid(columns: (auto, auto, auto, auto, auto), gutter: 0pt, align: horizon,
    flow-box("BRD / SRS\nfrom PM", color: ayodia-muted, fill: rgb("#f1f5f9"), w: 2.4cm),
    arr,
    flow-box("requirement\nanalyzer", color: tier-1, fill: rgb("#fef2f2"), w: 2.4cm),
    arr,
    block[
      #text(size: 10pt)[
        Score #badge("READY", fill: tier-4) → go write TCs \
        Score #badge("PARTIAL", fill: tier-3) → send Open Qs to PM \
        Score #badge("NOT-READY", fill: tier-1) → fall back to data-type-matrix
      ]
    ],
  )
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 7. DEEP DIVE — requirement-analyzer
// ════════════════════════════════════════════════════════════════════
#deep-dive-tag #h(8pt) #phase-tag("PRE-SIT", tier-1) #h(8pt) #text(size: 11pt, fill: ayodia-muted)[(For BA)]
#v(0.2cm)
= requirement-analyzer · sample output

#grid(columns: (1.1fr, 1fr), gutter: 0.7cm,
  [
    == Inputs
    - BRD / PRD / SRS / user story (raw from PM)
    - `project-context.md` (glossary, business rules)

    == Outputs (3 files)
    + *Readiness Report* — score + Open Questions
    + *Normalized Requirement* — standard template
    + *PM Confirmation Doc* — checklist for the PM

    == Why it matters
    Cuts the big rework cycle when a requirement gap surfaces late — TCs hit the mark on the first pass
  ],
  [
    #mock-panel("readiness-report.md")[
      #text(size: 10pt)[
        *Module:* LEAVE Management \
        *Source:* `docs/brd-leave.md` \
        *Score:* #badge("PARTIAL", fill: tier-3) (62/100)
      ]
      #v(4pt)
      #line(length: 100%, stroke: 0.4pt + ayodia-border)
      #v(2pt)
      #text(size: 9pt, weight: "bold", fill: ayodia-primary)[Coverage Check]
      #text(size: 9pt)[
        - Functional flow ✓ complete
        - Acceptance criteria ⚠ 3 gaps
        - Edge cases ⚠ missing (leap year, half-day)
        - Security ✗ not addressed
      ]
      #v(4pt)
      #text(size: 9pt, weight: "bold", fill: tier-1)[Open Questions (5)]
      #text(size: 9pt)[
        Q1. How many half-day slots per day are allowed? \
        Q2. Does leave overlapping Sat–Sun consume leave days? \
        Q3. Leap year → +1 day to entitlement? \
        Q4. Manager hasn't approved in 3 days → escalate? \
        Q5. Flow for canceling an already-approved leave?
      ]
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// SECTION DIVIDER · PHASE 2 SIT
// ════════════════════════════════════════════════════════════════════
#section-divider("2", "SIT", tier-2,
  "Plan → Design → Review → Execute", "Tester · Tester Lead")

// ════════════════════════════════════════════════════════════════════
// 8. SIT — Plan / Design / Review
// ════════════════════════════════════════════════════════════════════
#phase-tag("PHASE 2 · SIT", tier-2)
#v(0.2cm)
= SIT · Plan → Design → Review

#grid(columns: (1fr, 1fr), gutter: 0.6cm,
  skill-card("test-plan-writer", "Tester Lead", "40–50%", [
    SIT Plan: Scope · Entry/Exit Criteria · Schedule (Σ Sizing × 20% buffer) · Risk
  ]),
  skill-card("test-matrix-generator", "Tester · before TCs", "—", [
    Coverage / Pairwise / Platform matrix — a quick coverage sanity check when full TCs aren't ready yet
  ]),
)
#v(0.2cm)
#grid(columns: (1fr, 1fr), gutter: 0.6cm,
  skill-card("test-case-writer", "Tester · the workhorse", "50–60%", [
    SIT TCs · 23 cols + ECP / BVA / Decision Table / State Transition + Traceability
  ]),
  skill-card("test-case-reviewer", "Tester Peer", "40%", [
    Automated peer review checklist: clear Expected, Negative/Boundary coverage, no traceability gaps
  ]),
)

#v(0.4cm)

#align(center)[
  #grid(columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto), gutter: 0pt, align: horizon,
    flow-box("SRS", color: ayodia-muted, fill: rgb("#f1f5f9"), w: 1.8cm),
    arr,
    flow-box("Plan", color: tier-2, w: 1.8cm),
    arr,
    flow-box("Matrix\n(optional)", color: tier-2, w: 2cm),
    arr,
    flow-box("Test Case", color: tier-2, w: 2cm),
    arr,
    flow-box("Peer Review", color: tier-2, w: 2.2cm),
  )
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 9. DEEP DIVE — test-case-writer
// ════════════════════════════════════════════════════════════════════
#deep-dive-tag #h(8pt) #phase-tag("SIT / UAT", tier-2) #h(8pt) #text(size: 11pt, fill: ayodia-muted)[(For Tester)]
#v(0.2cm)
= test-case-writer · sample output

#grid(columns: (0.9fr, 1.3fr), gutter: 0.7cm,
  [
    == 2 Modes
    - *SIT mode* — technical, 23 columns
    - *UAT mode* — business view or multi-role checklist

    == Built-in Techniques
    - ECP · BVA · Decision Table
    - State Transition · Use Case
    - Error Guessing

    == Output formats
    Markdown · CSV · TH/EN

    == How to invoke
    #block(fill: ayodia-bg, inset: 7pt, radius: 4pt, width: 100%)[
      #text(size: 9pt, font: "Menlo")[
        Write SIT test cases from \
        docs/srs-login.md in English CSV \
        emphasize negative + boundary
      ]
    ]
  ],
  [
    #mock-panel("testcases_sit_login_20260420.md (4 of 28 cases)")[
      #set text(size: 8pt)
      #table(
        columns: (auto, 1.6fr, 1.4fr, auto, auto, auto),
        align: (left, left, left, center, center, center),
        stroke: 0.4pt + ayodia-border,
        inset: 4pt,
        fill: (col, row) => if row == 0 { ayodia-bg },
        [*TC ID*], [*Steps (summary)*], [*Expected*], [*Sev*], [*Pri*], [*Auto*],
        [AUTH_001], [Login with valid email + password], [Reaches dashboard], badge("Mi", fill: tier-3), badge("H", fill: tier-2), [Y],
        [AUTH_002], [Login with wrong password 5 times], [Lock for 15 min], badge("Cr", fill: tier-1), badge("Cr", fill: tier-1), [Y],
        [AUTH_003], [Invalid email format (no @)], [Inline validation error], badge("Mi", fill: tier-3), badge("M", fill: tier-3), [Y],
        [AUTH_004], [SQL injection in email field], [Reject + log security event], badge("Cr", fill: tier-1), badge("Cr", fill: tier-1), [Y],
      )
      #v(2pt)
      #text(size: 7pt, fill: ayodia-muted, style: "italic")[
        + Pre-condition · Post-condition · Test Data · Sizing · Traceability · Author · ... (17 more cols)
      ]
    ]

    #v(4pt)
    #block(fill: rgb("#ecfdf5"), stroke: 0.5pt + ayodia-accent, radius: 4pt, inset: 7pt, width: 100%)[
      #text(size: 9pt)[
        *Chain next:* `test-case-reviewer` (peer review) → `e2e-test-generator` (auto scripts for TC.Auto=Y)
      ]
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// SECTION DIVIDER · PHASE 3 EXECUTE
// ════════════════════════════════════════════════════════════════════
#section-divider("3", "Execute", tier-3,
  "Bug · Automation", "Tester + Dev")

// ════════════════════════════════════════════════════════════════════
// 10. EXECUTE — Bug
// ════════════════════════════════════════════════════════════════════
#phase-tag("PHASE 3 · EXECUTE", tier-3)
#v(0.2cm)
= Execute · Bug reports devs read once and get

#grid(columns: (1.1fr, 1fr), gutter: 0.7cm,
  [
    == bug-report-writer
    Writes a complete Jira / Linear / GitHub issue in one pass — no follow-up pings:
    - Short, specific title
    - Environment (browser, build, env)
    - Steps to Reproduce (numbered, actually reproducible)
    - Expected vs Actual
    - *Severity × Priority → Action label*

    == Example prompt
    #block(fill: ayodia-bg, inset: 7pt, radius: 4pt, width: 100%)[
      #text(size: 9pt, font: "Menlo")[
        Write a bug report: \
        [Checkout] total is wrong when two coupons are stacked \
        Chrome 130 on macOS, staging \
        Severity: Major
      ]
    ]
  ],
  [
    == Severity × Priority → Action
    #v(2pt)
    #set text(size: 9pt)
    #table(
      columns: (auto, auto, 1fr),
      align: (center + horizon, center + horizon, left + horizon),
      stroke: 0.4pt + ayodia-border,
      inset: 5pt,
      fill: (col, row) => if row == 0 { ayodia-bg },
      [*Severity*], [*Priority*], [*Action*],
      badge("Critical", fill: tier-1), badge("Critical", fill: tier-1), [#text(weight: "bold")[Blocker] · stop release],
      badge("Critical", fill: tier-1), badge("High", fill: tier-2), [Urgent · fix in sprint],
      badge("Major", fill: tier-2), badge("High", fill: tier-2), [Standard High],
      badge("Major", fill: tier-2), badge("Medium", fill: tier-3), [Plan next sprint],
      badge("Minor", fill: tier-3), badge("Low", fill: tier-4), [Backlog],
      badge("Trivial", fill: tier-4), badge("Low", fill: tier-4), [Defer / cosmetic],
    )

    #v(4pt)
    #text(size: 9pt, fill: ayodia-muted, style: "italic")[
      4-level standard from the Ayodia TEST DEFINITION template — identical across every project
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 11. DEEP DIVE — e2e-test-generator
// ════════════════════════════════════════════════════════════════════
#deep-dive-tag #h(8pt) #phase-tag("AUTOMATION", tier-2) #h(8pt) #text(size: 11pt, fill: ayodia-muted)[(For Dev)]
#v(0.2cm)
= e2e-test-generator · sample output

#grid(columns: (0.9fr, 1.3fr), gutter: 0.7cm,
  [
    == 4 Frameworks
    - Playwright + TypeScript
    - Cypress + TypeScript
    - WebdriverIO + TypeScript
    - Selenium + Java

    == Pattern guarantees
    - Page Object Model (3-tier)
    - Advanced XPath — *no index-based locators*
    - Unique vs shared locators split
    - Text-as-constants (i18n-ready)

    == Sister skill
    *robot-test-generator* (Robot Framework, athm_automation pattern)
  ],
  [
    #mock-panel("Generated file structure")[
      #set text(size: 9pt)
      #raw(block: true, "tests/auth/
├─ login.spec.ts            // test cases
├─ pages/
│  ├─ LoginPage.ts          // page object
│  └─ DashboardPage.ts
├─ locators/
│  └─ login.locators.ts     // XPath constants
└─ constants/
   └─ login.text.ts         // UI text (i18n)")
    ]
    #v(6pt)
    #mock-panel("login.spec.ts (snippet)")[
      #set text(size: 9pt)
      #raw(block: true, lang: "typescript", "test('AUTH_002 · lock account after 5 wrong tries',
  async ({ page }) => {
    const login = new LoginPage(page);
    await login.goto();
    for (let i = 0; i < 5; i++) {
      await login.submit(EMAIL, WRONG_PASSWORD);
    }
    await expect(login.lockedBanner).toBeVisible();
});")
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// SECTION DIVIDER · PHASE 4-5 UAT + PERF
// ════════════════════════════════════════════════════════════════════
#section-divider("4–5", "UAT + Performance", tier-4,
  "Business sign-off · Load · Bottleneck", "Tester Lead + Dev")

// ════════════════════════════════════════════════════════════════════
// 12. UAT + PERF
// ════════════════════════════════════════════════════════════════════
= Phase 4–5 · UAT and Performance

#grid(columns: (1fr, 1fr), gutter: 0.7cm,
  [
    #phase-tag("UAT", tier-2)
    #v(0.2cm)
    #skill-card("test-case-writer (uat mode)", "Tester · §P6", "50–60%", [
      Business view 23 cols *or* UAT Checklist multi-role workflow (officer, finance, manager, ...)
    ])
    #v(0.2cm)
    #skill-card("test-report-writer (uat)", "Tester Lead · §P8", "60–70%", [
      Total / Pass / Fail / Block / Not Run · Exit Criteria · *User Sign-off section* (name + date + decision)
    ])
    #v(0.2cm)
    #text(size: 10pt, fill: ayodia-muted, style: "italic")[
      Approved SIT TCs → auto-converted to UAT TCs (business language) — no starting from scratch
    ]
  ],
  [
    #phase-tag("PERFORMANCE", tier-4)
    #v(0.2cm)
    #skill-card("perf-test-generator", "Dev / Tester · §P10", "50%", [
      *k6* tests (smoke / load / stress / soak / spike) + HTTP wrapper + per-endpoint thresholds
    ])
    #v(0.2cm)
    #skill-card("perf-result-analyzer", "Tester Lead · §P11", "50%", [
      Parse k6 / JMeter / Gatling → Avg / p95 / p99 + TPS + Error Rate per endpoint + NFR compare + call out *Bottleneck*
    ])
    #v(0.2cm)
    #text(size: 10pt, fill: ayodia-muted, style: "italic")[
      Plan(perf) → Generate → Run → Analyze → Report — analysis time drops from half a day to ~15 min
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 13. 1 DAY IN THE LIFE OF TESTER
// ════════════════════════════════════════════════════════════════════
= A day in the life · Tester using AI Skills

#text(size: 12pt, fill: ayodia-muted)[Login feature · 1 sprint day · end-to-end example]
#v(0.4cm)

#tl-row("09:00", "/requirement-analyzer", "BRD arrives → run gate → Score Partial · 5 Open Qs sent to PM")
#v(6pt)
#tl-row("10:00", "(waiting on PM)", "While waiting → /test-matrix-generator drafts coverage matrix")
#v(6pt)
#tl-row("11:00", "/test-plan-writer", "PM replies → SIT Plan + Exit Criteria + Schedule (1.5 days)")
#v(6pt)
#tl-row("13:00", "/test-case-writer", "Write 28 SIT TCs (positive 12 · negative 10 · boundary 6)")
#v(6pt)
#tl-row("14:30", "/test-case-reviewer", "Peer review checklist → fix 3 items (unclear Expected)")
#v(6pt)
#tl-row("15:00", "/e2e-test-generator", "TC.Auto=Y · 12 cases → Playwright POM scripts ready to run")
#v(6pt)
#tl-row("16:00", "[Execute SIT]", "Run scripts + manual exploratory → find 4 bugs")
#v(6pt)
#tl-row("16:30", "/bug-report-writer", "Log 4 bugs with full Severity × Priority + Action label in Jira")
#v(6pt)
#tl-row("17:00", "/test-report-writer", "Draft SIT Report vs. Exit Criteria · send to Tester Lead for review")

#v(0.5cm)
#align(center)[
  #box(fill: ayodia-accent, inset: (x: 14pt, y: 8pt), radius: 5pt,
    text(fill: white, weight: "bold", size: 13pt, "1 day · 8 skills · 1 feature end-to-end"))
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 14. AI GUARDRAILS
// ════════════════════════════════════════════════════════════════════
= AI Guardrails · 5 principles every skill holds to

#text(size: 11pt, fill: ayodia-muted)[Keeps AI as an assistant — not the quality judge]
#v(0.4cm)

#let principle(n, title, body) = grid(
  columns: (auto, 1fr), gutter: 12pt, align: (center + horizon, left + horizon),
  box(
    width: 36pt, height: 36pt, radius: 18pt, fill: ayodia-accent,
    align(center + horizon, text(fill: white, size: 16pt, weight: "bold")[#n]),
  ),
  [
    #text(size: 13pt, weight: "bold", fill: ayodia-primary)[#title] \
    #text(size: 11pt, fill: ayodia-muted)[#body]
  ],
)

#principle(1, "AI = Draft & Assist · Tester = Review & Approve",
  [AI doesn't judge quality — there's a human gate on every deliverable])
#v(6pt)
#principle(2, "Always cross-check against the source",
  [TCs traceable back to SRS · Bugs reproduced on a real build · Perf numbers aligned with the NFR])
#v(6pt)
#principle(3, "Never commit sensitive data",
  [`[REDACTED]` or env vars — no passwords or PII enter prompts or output])
#v(6pt)
#principle(4, "Expected Result must be measurable",
  [No "works correctly" / "fast enough" — use numbers or observable behavior])
#v(6pt)
#principle(5, "Don't make up numbers",
  [No data? Ask the user or mark "TBD" — never guess throughput, response time, or defect counts])
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 15. ROADMAP
// ════════════════════════════════════════════════════════════════════
= Roadmap · what's coming next

#v(0.3cm)

#let road-col(title, color, when, items) = block(
  width: 100%, fill: color.transparentize(85%),
  stroke: (left: 3pt + color), radius: 3pt, inset: 12pt,
)[
  #text(size: 10pt, weight: "bold", fill: color, tracking: 2pt)[#when]
  #v(2pt)
  #text(size: 14pt, weight: "bold", fill: ayodia-primary)[#title]
  #v(6pt)
  #text(size: 10pt)[#items]
]

#grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 0.5cm,
  road-col("Shipped (13 skills)", ayodia-accent, "NOW · Q2 2026")[
    - Pre-SIT gate
    - SIT / UAT / Perf full chain
    - Bug · Automation · Reporting
    - Weekly update
  ],
  road-col("Mobile + Visual", tier-2, "Q3 2026")[
    - mobile-test-generator (Appium)
    - visual-regression-checker
    - accessibility-auditor (a11y)
  ],
  road-col("API + Data", tier-3, "Q4 2026")[
    - api-contract-tester (Pact)
    - test-data-generator (faker + rules)
    - db-state-validator
  ],
  road-col("Smart agents", tier-1, "2027")[
    - self-healing locators
    - auto-triage agent (Jira)
    - flaky-test detector
  ],
)

#v(0.5cm)

#block(fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt, inset: 12pt, width: 100%)[
  #grid(columns: (auto, 1fr), gutter: 12pt, align: (left + horizon, left + horizon),
    text(size: 14pt, weight: "bold", fill: ayodia-accent)[Want a skill?],
    text(size: 11pt)[
      Open a *PR* against `SKILL-TEMPLATE.md` or post in *\#testing-team* — the team will review and add it to the next roadmap cycle
    ],
  )
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 16. GET STARTED + Q&A
// ════════════════════════════════════════════════════════════════════
= Get Started

#grid(columns: (1fr, 1fr), gutter: 0.8cm,
  [
    == Install (one-time)
    + Install Claude Code: \
      `npm install -g @anthropic-ai/claude-code`
    + Clone the repo: \
      `git clone <gitlab>/qa_ai_skill.git`
    + Inside a Claude session:
      ```
      /plugin marketplace add /path/to/qa_ai_skill
      /plugin install qa-ai-skill@ayodia-qa
      ```
    + Verify: `/plugins` → Installed tab

    == Update
    `git pull` → `/plugin marketplace update ayodia-qa`
  ],
  [
    == Further reading
    - *New tester?* `docs/qa-onboarding.md` — 5-min quick start + decision tree
    - *Run SIT → UAT?* `docs/how-to-sit-uat.md` — 10 steps + prompts
    - *Input/Process/Output per skill?* `docs/work-product-flow.md`
    - *Standards?* `references/qa-standards.md` (Sev / Pri / Sizing)
    - *Add a new skill?* `SKILL-TEMPLATE.md`

    == Contribute
    PRs welcome — follow the universal 8-section structure
  ],
)

#v(0.7cm)
#align(center)[
  #text(size: 32pt, weight: "bold", fill: ayodia-primary)[Questions?]
  #v(0.2cm)
  #text(size: 13pt, fill: ayodia-muted)[
    Demo · Discussion · Use cases the team wants to pilot first
  ]
]
