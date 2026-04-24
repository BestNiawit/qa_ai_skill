// QA AI Skills — Tester Team Overview Deck v2 (15 min, mixed audience)
// Build: typst compile --root . slides/qa-skills-overview.typ slides/qa-skills-overview.pdf

#import "../references/typst-templates/lib.typ": (
  ayodia-primary, ayodia-accent, ayodia-muted, ayodia-bg, ayodia-border,
  tier-1, tier-2, tier-3, tier-4,
  badge,
)

// ── Logo ──────────────────────────────────────────────────────────
#let logo-path = "../references/typst-templates/assets/ayodia-logo.png"

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
      align(left + horizon)[
        #box(baseline: 3pt, image(logo-path, height: 0.6cm))#h(5pt)QA AI Skills · Ayodia Testing Team
      ],
      align(center + horizon)[April 2026],
      align(right + horizon)[#n / #counter(page).final().first()],
    )
  },
)

#set text(font: ("Helvetica", "Arial"), size: 13pt, lang: "th")
#set par(leading: 0.6em, spacing: 0.7em)

#show heading.where(level: 1): it => block(below: 12pt, above: 0pt)[
  #grid(columns: (4pt, 1fr), gutter: 12pt, align: (left + horizon, left + horizon),
    rect(width: 4pt, height: 28pt, fill: ayodia-accent, stroke: none),
    text(size: 26pt, weight: "bold", fill: ayodia-primary, it.body),
  )
]
#show heading.where(level: 2): it => block(below: 7pt, above: 14pt,
  text(size: 15pt, weight: "bold", fill: ayodia-accent, it.body))
#show heading.where(level: 3): it => block(below: 4pt, above: 2pt,
  text(size: 12pt, weight: "bold", fill: ayodia-primary, it.body))

#show list: set block(spacing: 0.7em)
#show list: set par(leading: 0.7em)
#show enum: set block(spacing: 0.7em)
#show enum: set par(leading: 0.7em)

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
  #v(1.8cm)
  #align(center)[
    #image(logo-path, width: 4.2cm)
    #v(0.6cm)
    #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 4pt)[
      AYODIA TESTING TEAM · INTERNAL SHARING
    ]
    #v(0.6cm)
    #text(size: 56pt, weight: "bold", fill: ayodia-primary)[
      QA AI Skills
    ]
    #v(0.2cm)
    #rect(width: 80pt, height: 3pt, fill: ayodia-accent, stroke: none)
    #v(0.4cm)
    #text(size: 22pt, fill: ayodia-muted)[
      ลด effort ทุก phase ของการเทส ด้วย AI
    ]
    #v(1.4cm)
    #grid(columns: (auto, auto, auto), gutter: 1.8cm,
      stat("13", "AI Skills"),
      stat("30–70%", "ลด Effort"),
      stat("12", "Process ที่ครอบคลุม"),
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
= ปัญหาเดิมของทีม Tester

#text(size: 13pt, fill: ayodia-muted)[เราเสียเวลากับงานซ้ำๆ มากกว่า "ตั้งใจหา bug"]
#v(0.6cm)

#grid(columns: (1fr, 1fr, 1fr), gutter: 0.6cm,
  pain-icon("X", "Doc ซ้ำๆ ทุก project",
    [Test Plan / Test Case / Report \ เขียนเหมือนเดิม 10 รอบ/ปี]),
  pain-icon("?", "Requirement ยังไม่ชัด",
    [ทำ TC ไปครึ่งทาง เจอ gap \ ต้อง revise รอบใหญ่]),
  pain-icon("!", "Bug log ไม่ครบ",
    [Dev ถามซ้ำ "repro ยังไง?" \ → loop ส่ง-ตอบกัน 3 รอบ]),
)

#v(0.6cm)

#grid(columns: (1fr, 1fr, 1fr), gutter: 0.6cm,
  pain-icon("∞", "Automation เขียนไม่ทัน",
    [TC manual 100 ตัว → automate \ ได้แค่ 20 → coverage ตก]),
  pain-icon("~", "Perf result analyze ช้า",
    [k6 ออก JSON 50 MB → \ หา bottleneck ใน Excel ทั้งวัน]),
  pain-icon("@", "Update รายสัปดาห์ใช้เวลา",
    [เขียน weekly email ให้หัวหน้า \ ใช้เวลา 2 ชม. ทุกศุกร์]),
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 3. THE SOLUTION
// ════════════════════════════════════════════════════════════════════
= ทางออก — AI ช่วย draft, Tester ตรวจและ approve

#v(0.5cm)
#align(center)[
  #grid(columns: (1fr, auto, 1fr, auto, 1fr), gutter: 0.5cm, align: horizon,
    flow-box("Input\nReq doc / Test result", color: ayodia-primary, fill: rgb("#eff6ff"), w: 5cm),
    text(size: 24pt, fill: ayodia-accent, weight: "bold", " → "),
    flow-box("AI Skill\n(อ่าน template + ร่าง output)", color: ayodia-accent, fill: rgb("#ecfdf5"), w: 5cm),
    text(size: 24pt, fill: ayodia-accent, weight: "bold", " → "),
    flow-box("Draft Output\nไฟล์ md / csv พร้อม review", color: ayodia-primary, fill: rgb("#eff6ff"), w: 5cm),
  )
  #v(0.4cm)
  #downarr
  #v(0.2cm)
  #box(fill: tier-2, inset: (x: 14pt, y: 8pt), radius: 5pt,
    text(fill: white, weight: "bold", size: 14pt, "Tester ตรวจ + แก้ + Approve  →  Commit / ส่งงาน"))
]

#v(0.8cm)

#grid(columns: (1fr, 1fr), gutter: 1cm,
  block(fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt, inset: 12pt, width: 100%)[
    #text(size: 13pt, weight: "bold", fill: ayodia-primary)[AI ทำได้ดี]
    #v(4pt)
    #text(size: 11pt)[
      - ร่าง template ที่โครงสร้างชัด (Plan / TC / Report)
      - คิด edge case + negative test ที่คนมักลืม
      - แปลงข้าม format (TC → Playwright)
      - อ่าน result file ขนาดใหญ่ (k6 JSON, JMeter CSV)
    ]
  ],
  block(fill: rgb("#fef3c7"), stroke: 0.5pt + tier-3, radius: 5pt, inset: 12pt, width: 100%)[
    #text(size: 13pt, weight: "bold", fill: ayodia-primary)[คนยังต้องทำเอง]
    #v(4pt)
    #text(size: 11pt)[
      - ตรวจว่าตรง business intent หรือเปล่า
      - ตัดสิน Severity / Priority ที่เหมาะกับ context จริง
      - Approve ก่อนส่ง PM / Dev
      - คุยกับ user ตอน UAT
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 4. 13 SKILLS overview
// ════════════════════════════════════════════════════════════════════
= 13 Skills · จัดกลุ่มตาม Phase ของการเทส

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
    ทุก skill ใช้มาตรฐานเดียวกัน (Severity / Priority / Sizing) — output ส่งต่อข้าม skill ได้เลย ไม่ต้องมาแปลง
  ]
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 5. CASE STUDY — Login feature: 8d → 3d
// ════════════════════════════════════════════════════════════════════
= Target · Login Feature (ประมาณการ)

#text(size: 11pt, fill: ayodia-muted)[ประมาณการ effort ต่อ feature — module เดียวกัน · ขอบเขตเดียวกัน · เอาไว้ดู pattern ไม่ใช่เป้าบังคับ]
#v(0.2cm)

#grid(columns: (auto, auto, auto, 1fr), gutter: 0.6cm, align: horizon,
  block(fill: rgb("#fef2f2"), stroke: 1.5pt + tier-1, radius: 6pt, inset: 8pt, width: 4cm)[
    #align(center)[
      #text(size: 9pt, weight: "bold", fill: tier-1, tracking: 2pt)[เดิม · MANUAL]
      #v(2pt)
      #text(size: 30pt, weight: "bold", fill: tier-1)[8 วัน]
      #v(0pt)
      #text(size: 9pt, fill: ayodia-muted)[1 tester · ทำเองทั้งหมด]
    ]
  ],
  text(size: 22pt, fill: ayodia-accent, weight: "bold")[ → ],
  block(fill: rgb("#ecfdf5"), stroke: 1.5pt + ayodia-accent, radius: 6pt, inset: 8pt, width: 4cm)[
    #align(center)[
      #text(size: 9pt, weight: "bold", fill: ayodia-accent, tracking: 2pt)[ใหม่ · AI-ASSISTED]
      #v(2pt)
      #text(size: 30pt, weight: "bold", fill: ayodia-accent)[3 วัน]
      #v(0pt)
      #text(size: 9pt, fill: ayodia-muted)[1 tester · AI draft + review]
    ]
  ],
  align(center)[
    #box(fill: tier-2, inset: (x: 12pt, y: 8pt), radius: 5pt,
      text(fill: white, weight: "bold", size: 13pt)[ประหยัด 5 วันคน \ #text(size: 18pt)[62% เร็วขึ้น]])
  ],
)

#v(0.3cm)

#mock-panel("Effort breakdown ต่อ skill (วัน)")[
  #set text(size: 9pt)
  #table(
    columns: (1.5fr, auto, auto, auto, 2fr),
    align: (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon),
    stroke: 0.4pt + ayodia-border, inset: 4pt,
    fill: (col, row) => if row == 0 { ayodia-bg },
    [*Step*], [*เดิม*], [*ใหม่*], [*ลด*], [*ทำอะไร*],
    [requirement-analyzer], [—], [0.3], [—], [เช็ค BRD · 5 คำถามค้าง ส่ง PM],
    [test-plan-writer], [1.0], [0.3], [70%], [SIT Plan · Exit Criteria · Schedule],
    [test-case-writer], [3.0], [1.0], [67%], [28 TCs (positive/negative/boundary)],
    [test-case-reviewer], [0.5], [0.2], [60%], [Peer review checklist · 3 fixes],
    [e2e-test-generator], [2.0], [0.5], [75%], [Playwright POM · 12 auto scripts],
    [bug-report-writer], [0.5], [0.2], [60%], [4 bugs ครบ Severity × Priority],
    [test-report-writer], [1.0], [0.5], [50%], [SIT Report · Exit Criteria evaluation],
  )
]

#v(0.2cm)

#block(
  fill: rgb("#fef3c7"), stroke: (left: 3pt + tier-3), radius: 3pt,
  inset: 8pt, width: 100%, breakable: false,
)[
  #text(size: 9pt)[
    *ที่มาตัวเลข* — ไม่ได้จับเวลาเป๊ะๆ · "เดิม" คือ effort ที่ทีมเคยใช้ก่อนมี skill · "ใหม่" มาจากลองใช้จริงกับ 1–2 feature · ใช้ดู pattern ของการประหยัด ไม่ใช่เป้าที่บังคับว่าต้องได้เท่านี้ · ของจริงขึ้นกับว่า feature ซับซ้อนแค่ไหน ทีมคล่อง skill แล้วรึยัง และ requirement ชัดพอรึเปล่า
  ]
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// SECTION DIVIDER · PHASE 1 PRE-SIT
// ════════════════════════════════════════════════════════════════════
#section-divider("1", "Pre-SIT Gate", tier-1,
  "เช็ค requirement ก่อนเริ่มเทส", "BA + Tester Lead")

// ════════════════════════════════════════════════════════════════════
// 6. PRE-SIT GATE
// ════════════════════════════════════════════════════════════════════
#phase-tag("PHASE 1 · PRE-SIT", tier-1) #h(8pt) #text(size: 11pt, fill: ayodia-muted)[(For BA + Tester Lead)]
#v(0.2cm)
= Pre-SIT Gate · เช็ค requirement ก่อนเริ่มเทส

#text(size: 12pt, fill: ayodia-muted)[ป้องกันสถานการณ์ "ทำ TC ไปครึ่งวัน ค่อยรู้ว่า requirement ยังมี gap ต้องรื้อใหม่"]
#v(0.4cm)

#grid(columns: (1fr, 1fr), gutter: 0.7cm,
  skill-card(
    "requirement-analyzer",
    "BA · Tester Lead — ตัวเช็ค BRD / PRD / SRS",
    "30–40%",
    [
      ดูว่า requirement พร้อมทำ TC หรือยัง:
      - ให้คะแนน: Ready / Partial / Not-ready
      - List คำถามค้างส่ง PM
      - แปลงเป็น template รูปแบบเดียว ใช้ต่อได้ทุก skill
    ],
  ),
  skill-card(
    "data-type-matrix-generator",
    "Tester — ใช้เมื่อ req ยังไม่ชัด แต่ deadline ใกล้",
    "30–50%",
    [
      เดินหน้าได้แม้ requirement ไม่ครบ:
      - Data Type Matrix (ต่อ field × ECP / BVA)
      - Happy Path E2E + Integration Points
      - Checklist ข้อสมมติ · ส่ง PM กาถูก 10 นาทีเสร็จ
    ],
  ),
)

#v(0.4cm)

#align(center)[
  #grid(columns: (auto, auto, auto, auto, auto), gutter: 0pt, align: horizon,
    flow-box("BRD/SRS\nจาก PM", color: ayodia-muted, fill: rgb("#f1f5f9"), w: 2.4cm),
    arr,
    flow-box("requirement\nanalyzer", color: tier-1, fill: rgb("#fef2f2"), w: 2.4cm),
    arr,
    block[
      #text(size: 10pt)[
        คะแนน #badge("READY", fill: tier-4) → เขียน TC ได้เลย \
        คะแนน #badge("PARTIAL", fill: tier-3) → ส่งคำถามให้ PM ก่อน \
        คะแนน #badge("NOT-READY", fill: tier-1) → ไปใช้ data-type-matrix แทน
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
= requirement-analyzer · ตัวอย่าง output

#grid(columns: (1fr, 1.15fr), gutter: 0.9cm,
  [
    == ใส่อะไรเข้าไป
    - BRD / PRD / SRS / user story ที่ PM ส่งมาตรงๆ
    - `project-context.md` (คำศัพท์ + business rule ของ project)

    == ได้อะไรออกมา
    + *Readiness Report* — คะแนน + คำถามค้างส่ง PM
    + *Normalized Requirement* — template รูปแบบเดียว ใช้ต่อทุก skill
    + *PM Confirmation Doc* — checklist ให้ PM ยืนยัน

    == ทำไปทำไม
    รู้ก่อนว่า requirement มี gap ตรงไหน จะได้ไม่ต้องมารื้อ TC ตอนใกล้ deadline
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
        - Functional flow ✓ครบ
        - Acceptance criteria ⚠ ขาด 3 จุด
        - Edge cases ⚠ ขาด (leap year, half-day)
        - Security ✗ ไม่กล่าวถึง
      ]
      #v(4pt)
      #text(size: 9pt, weight: "bold", fill: tier-1)[Open Questions (5)]
      #text(size: 9pt)[
        Q1. ลาครึ่งวันได้กี่ slot/วัน? \
        Q2. ลาทับวันหยุดเสาร์-อาทิตย์ ตัด leave? \
        Q3. ปีอธิกสุรทิน เพิ่ม 1 วันให้ entitlement? \
        Q4. หัวหน้าไม่ approve ใน 3 วัน → escalate? \
        Q5. ยกเลิกใบลา approved แล้ว flow?
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
    SIT Plan · Scope · Entry/Exit Criteria · Schedule (Σ Sizing × buffer 20%) · Risk
  ]),
  skill-card("test-matrix-generator", "Tester · ก่อนเขียน TC", "—", [
    Coverage / Pairwise / Platform matrix — เช็ค coverage เร็วๆ ตอนเขียน TC เต็มไม่ทัน
  ]),
)
#v(0.2cm)
#grid(columns: (1fr, 1fr), gutter: 0.6cm,
  skill-card("test-case-writer", "Tester · ใช้บ่อยที่สุด", "50–60%", [
    SIT TC 23 cols + ECP / BVA / Decision Table / State Transition + Traceability
  ]),
  skill-card("test-case-reviewer", "Tester Peer", "40%", [
    Peer Review checklist อัตโนมัติ: Expected ชัด · Negative / Boundary ครบ · traceability ครบ
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
= test-case-writer · ตัวอย่าง output

#grid(columns: (0.9fr, 1.3fr), gutter: 0.7cm,
  [
    == 2 โหมด
    - *SIT mode* — มุม technical, 23 columns
    - *UAT mode* — มุม business หรือ multi-role checklist

    == เทคนิคที่มีให้ใช้
    - ECP · BVA · Decision Table
    - State Transition · Use Case
    - Error Guessing

    == ได้ออกมาเป็น
    Markdown · CSV · ไทย / อังกฤษ

    == สั่งยังไง
    #block(fill: ayodia-bg, inset: 7pt, radius: 4pt, width: 100%)[
      #text(size: 9pt, font: "Menlo")[
        เขียน SIT test case จาก \
        docs/srs-login.md ภาษาไทย CSV \
        เน้น negative + boundary
      ]
    ]
  ],
  [
    #mock-panel("testcases_sit_login_20260420.md (ตัวอย่าง 4 จาก 28 cases)")[
      #set text(size: 8pt)
      #table(
        columns: (auto, 1.6fr, 1.4fr, auto, auto, auto),
        align: (left, left, left, center, center, center),
        stroke: 0.4pt + ayodia-border,
        inset: 4pt,
        fill: (col, row) => if row == 0 { ayodia-bg },
        [*TC ID*], [*Steps (สรุป)*], [*Expected*], [*Sev*], [*Pri*], [*Auto*],
        [AUTH_001], [Login email + รหัสถูก], [เข้า dashboard], badge("Mi", fill: tier-3), badge("H", fill: tier-2), [Y],
        [AUTH_002], [Login รหัสผิด 5 ครั้ง], [Lock 15 นาที], badge("Cr", fill: tier-1), badge("Cr", fill: tier-1), [Y],
        [AUTH_003], [Email format ผิด (no @)], [Validation error inline], badge("Mi", fill: tier-3), badge("M", fill: tier-3), [Y],
        [AUTH_004], [SQL injection ในช่อง email], [Reject + log security event], badge("Cr", fill: tier-1), badge("Cr", fill: tier-1), [Y],
      )
      #v(2pt)
      #text(size: 7pt, fill: ayodia-muted, style: "italic")[
        + Pre-condition · Post-condition · Test Data · Sizing · Traceability · Author · ... (อีก 17 cols)
      ]
    ]

    #v(4pt)
    #block(fill: rgb("#ecfdf5"), stroke: 0.5pt + ayodia-accent, radius: 4pt, inset: 7pt, width: 100%)[
      #text(size: 9pt)[
        *ทำต่อ:* `test-case-reviewer` (peer review) → `e2e-test-generator` (ทำ auto script จาก TC ที่ Auto=Y)
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
= Execute · Bug Report ที่ Dev อ่านครั้งเดียวเข้าใจ

#grid(columns: (1.1fr, 1fr), gutter: 0.7cm,
  [
    == bug-report-writer
    เขียน Jira / Linear / GitHub issue ครบในรอบเดียว — Dev ไม่ต้องถามกลับ:
    - Title สั้น ตรงจุด
    - Environment (browser, build, env)
    - Steps to Reproduce (เป็นข้อๆ repro ได้จริง)
    - Expected vs Actual
    - *Severity × Priority → Action label*

    == ตัวอย่างคำสั่ง
    #block(fill: ayodia-bg, inset: 7pt, radius: 4pt, width: 100%)[
      #text(size: 9pt, font: "Menlo")[
        เขียน bug report: \
        [Checkout] ยอดรวมผิด เมื่อใส่ coupon ซ้อน 2 ใบ \
        Chrome 130 บน macOS, staging \
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
      มาตรฐาน 4 ระดับ ตาม Ayodia TEST DEFINITION template · ใช้เหมือนกันทุก project
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 11. DEEP DIVE — e2e-test-generator
// ════════════════════════════════════════════════════════════════════
#deep-dive-tag #h(8pt) #phase-tag("AUTOMATION", tier-2) #h(8pt) #text(size: 11pt, fill: ayodia-muted)[(For Dev)]
#v(0.2cm)
= e2e-test-generator · ตัวอย่าง output

#grid(columns: (0.9fr, 1.3fr), gutter: 0.7cm,
  [
    == 4 Frameworks
    - Playwright + TypeScript
    - Cypress + TypeScript
    - WebdriverIO + TypeScript
    - Selenium + Java

    == กฎที่ยึดตลอด
    - Page Object Model (3 ชั้น)
    - Advanced XPath — *ห้าม locator แบบ index*
    - Unique locator กับ shared locator แยกกันชัด
    - Text เก็บเป็น constants (พร้อมทำ i18n)

    == Skill คู่กัน
    *robot-test-generator* (Robot Framework ตาม pattern athm_automation)
  ],
  [
    #mock-panel("File structure ที่ generate ออกมา")[
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
= Phase 4–5 · UAT และ Performance

#grid(columns: (1fr, 1fr), gutter: 0.7cm,
  [
    #phase-tag("UAT", tier-2)
    #v(0.2cm)
    #skill-card("test-case-writer (uat mode)", "Tester · §P6", "50–60%", [
      Business view 23 cols *หรือ* UAT Checklist แบบหลาย role (ข้าราชการ · การเงิน · หัวหน้า · ...)
    ])
    #v(0.2cm)
    #skill-card("test-report-writer (uat)", "Tester Lead · §P8", "60–70%", [
      Total / Pass / Fail / Block / Not Run · Exit Criteria · *User Sign-off section* (ชื่อ · วันที่ · decision)
    ])
    #v(0.2cm)
    #text(size: 10pt, fill: ayodia-muted, style: "italic")[
      SIT TC ที่ approved แล้ว → แปลงเป็น UAT TC (ภาษา business) ได้เลย ไม่ต้องเริ่มจากศูนย์
    ]
  ],
  [
    #phase-tag("PERFORMANCE", tier-4)
    #v(0.2cm)
    #skill-card("perf-test-generator", "Dev / Tester · §P10", "50%", [
      *k6* test (smoke / load / stress / soak / spike) + HTTP wrapper + threshold ต่อ endpoint
    ])
    #v(0.2cm)
    #skill-card("perf-result-analyzer", "Tester Lead · §P11", "50%", [
      อ่าน k6 / JMeter / Gatling → Avg / p95 / p99 + TPS + Error Rate ต่อ endpoint + เทียบ NFR + ชี้จุด *Bottleneck*
    ])
    #v(0.2cm)
    #text(size: 10pt, fill: ayodia-muted, style: "italic")[
      Plan → Generate → Run → Analyze → Report — งาน analyze จากครึ่งวันเหลือ ~15 นาที
    ]
  ],
)
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 13. NEW — 1 DAY IN THE LIFE OF TESTER
// ════════════════════════════════════════════════════════════════════
= 1 Day in the Life · Tester ใช้ AI Skills

#text(size: 12pt, fill: ayodia-muted)[Login feature · 1 sprint day · ตัวอย่างการใช้งานจริง]
#v(0.4cm)

#tl-row("09:00", "/requirement-analyzer", "BRD เข้ามา → รัน gate → คะแนน Partial · ส่ง 5 คำถามค้างให้ PM")
#v(6pt)
#tl-row("10:00", "(รอ PM ตอบ)", "ระหว่างรอ → /test-matrix-generator ทำ coverage matrix ไว้ก่อน")
#v(6pt)
#tl-row("11:00", "/test-plan-writer", "PM ตอบกลับ → SIT Plan + Exit Criteria + Schedule (1.5 วัน)")
#v(6pt)
#tl-row("13:00", "/test-case-writer", "เขียน 28 SIT TCs (positive 12 · negative 10 · boundary 6)")
#v(6pt)
#tl-row("14:30", "/test-case-reviewer", "Peer review checklist → แก้ 3 จุด (Expected ไม่ชัดพอ)")
#v(6pt)
#tl-row("15:00", "/e2e-test-generator", "TC ที่ Auto=Y 12 ตัว → ได้ Playwright POM scripts พร้อมรัน")
#v(6pt)
#tl-row("16:00", "[Execute SIT]", "รัน script + exploratory manual → เจอ 4 bugs")
#v(6pt)
#tl-row("16:30", "/bug-report-writer", "log 4 bugs ครบ Severity × Priority + Action label เข้า Jira")
#v(6pt)
#tl-row("17:00", "/test-report-writer", "ร่าง SIT Report เทียบ Exit Criteria · ส่ง Tester Lead ดู")

#v(0.5cm)
#align(center)[
  #box(fill: ayodia-accent, inset: (x: 14pt, y: 8pt), radius: 5pt,
    text(fill: white, weight: "bold", size: 13pt, "1 วัน · 8 skills · ครบ 1 feature end-to-end"))
]
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 14. AI GUARDRAILS
// ════════════════════════════════════════════════════════════════════
= AI Guardrails · 5 หลักการที่ทุก skill ยึด

#text(size: 11pt, fill: ayodia-muted)[ให้ AI เป็นผู้ช่วย ไม่ใช่ผู้ตัดสินคุณภาพ]
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

#principle(1, "AI ร่าง · Tester ตรวจและ approve",
  [AI ไม่ได้ตัดสินคุณภาพ — ทุก deliverable ต้องผ่านคนก่อนส่ง])
#v(6pt)
#principle(2, "เทียบกับของจริงเสมอ",
  [TC ต้องโยงกลับ SRS ได้ · Bug ต้อง repro บน build จริง · Perf ต้องตรง NFR])
#v(6pt)
#principle(3, "ห้าม commit ข้อมูลที่ sensitive",
  [ใช้ `[REDACTED]` หรือ env var — อย่าให้ password / PII หลุดเข้า prompt หรือ output])
#v(6pt)
#principle(4, "Expected Result ต้องวัดได้",
  [ห้ามเขียน "ทำงานถูกต้อง" / "เร็วพอ" — ต้องมีตัวเลขหรือพฤติกรรมที่สังเกตได้])
#v(6pt)
#principle(5, "ห้ามมั่วตัวเลข",
  [ไม่มีข้อมูลจริง → ถาม user หรือใส่ "TBD" · ห้ามเดา throughput, response time, จำนวน defect])
#pagebreak()

// ════════════════════════════════════════════════════════════════════
// 15. NEW — ROADMAP
// ════════════════════════════════════════════════════════════════════
= Roadmap · สิ่งที่จะมาเพิ่ม

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
    - SIT/UAT/Perf full chain
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
    text(size: 14pt, weight: "bold", fill: ayodia-accent)[อยากได้ skill ใหม่?],
    text(size: 11pt)[
      เปิด *PR* ตาม `SKILL-TEMPLATE.md` หรือโพสใน *\#testing-team* — ทีมจะช่วยดูและเอาเข้า roadmap รอบถัดไป
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
    == ติดตั้ง (ครั้งเดียว)
    + ติดตั้ง Claude Code: \
      `npm install -g @anthropic-ai/claude-code`
    + Clone repo: \
      `git clone <gitlab>/qa_ai_skill.git`
    + ใน Claude session:
      ```
      /plugin marketplace add /path/to/qa_ai_skill
      /plugin install qa-ai-skill@ayodia-qa
      ```
    + เช็ค: `/plugins` → tab Installed

    == อัปเดต
    `git pull` → `/plugin marketplace update ayodia-qa`
  ],
  [
    == อ่านต่อ
    - *เพิ่งเริ่ม?* `docs/qa-onboarding.md` — Quick Start 5 นาที + Decision Tree
    - *รัน SIT → UAT?* `docs/how-to-sit-uat.md` — 10 ขั้นตอน + prompt
    - *Input / Process / Output ของทุก skill?* `docs/work-product-flow.md`
    - *มาตรฐาน?* `references/qa-standards.md` (Sev / Pri / Sizing)
    - *เพิ่ม skill ใหม่?* `SKILL-TEMPLATE.md`

    == อยากช่วย
    ยินดีรับ PR — เขียนตามโครงสร้าง 8 section มาตรฐาน
  ],
)

#v(0.7cm)
#align(center)[
  #text(size: 32pt, weight: "bold", fill: ayodia-primary)[Questions?]
  #v(0.2cm)
  #text(size: 13pt, fill: ayodia-muted)[
    ถามได้เลย — อยากดู demo, อยากคุยประเด็นไหน, หรืออยากให้ลอง use case ไหนก่อน
  ]
]
