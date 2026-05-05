// QA AI Skills — Team Onboarding Slides v1 (~30 min, 15 slides)
// Build: typst compile --root . slides/team-onboarding.typ slides/team-onboarding.pdf

#import "../references/typst-templates/lib.typ": (
  ayodia-primary, ayodia-accent, ayodia-muted, ayodia-bg, ayodia-border,
  tier-1, tier-2, tier-3, tier-4,
)

#let logo-path = "../references/typst-templates/assets/ayodia-logo.png"

// ── Background decoration ──────────────────────────────────────
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

// ── Page setup: 16:9 landscape ──────────────────────────────────
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
        #box(baseline: 3pt, image(logo-path, height: 0.6cm))#h(5pt)QA AI Skills · Tester Team Onboarding
      ],
      align(center + horizon)[v1.0 · 5 พ.ค. 69],
      align(right + horizon)[#n / #counter(page).final().first()],
    )
  },
)

#set text(font: ("Sukhumvit Set", "Sarabun", "Helvetica"), size: 14pt, lang: "th", fill: ayodia-primary.darken(20%))
#set par(leading: 0.7em, spacing: 0.85em)

#show heading.where(level: 1): it => block(below: 14pt, above: 0pt)[
  #grid(columns: (4pt, 1fr), gutter: 14pt, align: (left + horizon, left + horizon),
    rect(width: 4pt, height: 32pt, fill: ayodia-accent, stroke: none),
    text(size: 28pt, weight: "bold", fill: ayodia-primary, it.body),
  )
]
#show heading.where(level: 2): it => block(below: 7pt, above: 14pt,
  text(size: 16pt, weight: "bold", fill: ayodia-accent, it.body))

#show list: set block(spacing: 0.8em)
#show list: set par(leading: 0.7em)

// ── Helpers ─────────────────────────────────────────────────────
#let phase-tag(label, color) = box(
  fill: color, inset: (x: 10pt, y: 4pt), radius: 4pt,
  text(fill: white, weight: "bold", size: 11pt, label),
)

#let stat-tile(value, label, color: ayodia-accent) = align(center, block(
  width: 100%,
  inset: 14pt,
  radius: 6pt,
  fill: color.lighten(90%),
  stroke: (left: 4pt + color),
  align(left)[
    #text(size: 11pt, fill: ayodia-muted)[#label] \
    #text(size: 32pt, weight: "bold", fill: color)[#value]
  ],
))

#let flow-box(num, label, role: "", color: ayodia-primary) = box(
  width: 100%,
  fill: color.lighten(88%),
  stroke: (left: 3pt + color, rest: 0.4pt + color.lighten(50%)),
  radius: 3pt,
  inset: (x: 10pt, y: 7pt),
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    text(weight: "bold", fill: color, size: 11pt, [#num. #label]),
    if role != "" { text(size: 9pt, fill: ayodia-muted, role) } else { [] },
  ),
)

#let down-arrow = align(center, block(above: 2pt, below: 2pt,
  text(size: 12pt, fill: ayodia-muted, "▼")))

#let chain-flow(..steps) = stack(
  spacing: 0pt,
  ..steps.pos().enumerate().map(((i, s)) => {
    let item = flow-box(s.num, s.label, role: s.at("role", default: ""), color: s.at("color", default: ayodia-primary))
    if i == 0 { item } else { stack(spacing: 0pt, down-arrow, item) }
  })
)

#let expectation-row(num, title, body) = grid(
  columns: (auto, 1fr),
  column-gutter: 14pt,
  align: (top, top),
  text(size: 28pt, weight: "bold", fill: ayodia-accent, str(num)),
  stack(
    spacing: 5pt,
    text(weight: "bold", size: 14pt, fill: ayodia-primary, title),
    text(size: 11pt, body),
  ),
)

#let skill-pill(name) = box(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border,
  inset: (x: 9pt, y: 5pt), radius: 3pt,
  text(font: "Menlo", size: 10pt, fill: ayodia-primary, name),
)

#let kbd(t) = box(fill: ayodia-bg, stroke: 0.4pt + ayodia-border,
  inset: (x: 5pt, y: 2pt), radius: 2pt,
  text(font: "Menlo", size: 9pt, t))

// ================================================================
// Slide 1 — Title
// ================================================================

#align(center + horizon)[
  #image(logo-path, width: 4cm)
  #v(8pt)
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "TESTER TEAM ONBOARDING")
  #v(28pt)
  #text(size: 50pt, weight: "bold", fill: ayodia-primary, "QA AI Skills")
  #v(6pt)
  #text(size: 22pt, fill: ayodia-muted, "คู่มือใช้งาน 14 Skills สำหรับทีม Tester")
  #v(40pt)
  #text(size: 13pt, fill: ayodia-muted)[v1.0 · 5 พฤษภาคม 2569 · Tester Lead Team]
]

#pagebreak()

// ================================================================
// Slide 2 — Agenda
// ================================================================

= Agenda · 30 นาที

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 30pt,
  row-gutter: 12pt,
  [
    #text(weight: "bold", fill: ayodia-accent, "ส่วนแรก · ทำความเข้าใจ (15 นาที)")
    + ทำไมเราใช้ AI Skills + เป้าหมาย
    + ความคาดหวัง 5 ข้อ
    + 14 Skills จัดกลุ่มยังไง
    + Workflow 3 chain ที่ใช้
  ],
  [
    #text(weight: "bold", fill: ayodia-accent, "ส่วนสอง · ลงมือใช้ (15 นาที)")
    + 3 Skills ที่จะใช้บ่อยสุด
    + งานที่ AI ทำแทนไม่ได้
    + วิธีติดตั้ง 4 ขั้นตอน
    + Q&A และเริ่มลองใช้จริง
  ],
)

#v(20pt)

#align(center, block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
  inset: 14pt, width: 80%,
  text(size: 12pt)[
    *เป้าหมายของวันนี้:* จบ session แล้วทุกคนติดตั้ง plugin ได้ + ใช้ skill ตัวแรกของตัวเองในวันนี้
  ],
))

#pagebreak()

// ================================================================
// Slide 3 — Why + target
// ================================================================

= ทำไมเราใช้ AI Skills

#grid(
  columns: (1.2fr, 1fr),
  column-gutter: 24pt,
  align: (top, top),
  [
    #text(size: 16pt)[
      เราเขียนงานเอกสารเยอะมาก · BRD/PRD ก็ต้องอ่าน TC ก็ต้องเขียน Bug Report ก็ต้องเก็บ Test Report ก็ต้องสรุป
    ]
    #v(10pt)
    #text(size: 16pt)[
      *เป้าหมาย:* ให้ AI ช่วย draft งานพวกนี้ให้ราว *50%* แล้วเราเอาเวลาที่ได้ไปทำสิ่งที่ AI ทำไม่ได้ เช่น verify จริง คุยกับ PM/BA หา edge case
    ]
    #v(14pt)
    #block(fill: rgb("#FFF8ED"), stroke: (left: 3pt + tier-2),
      inset: 12pt, radius: 4pt,
      text(size: 12pt)[
        ตัวเลข 50% ที่เห็นในเอกสารคือ *เป้าที่ตั้งไว้* ยังไม่ใช่ผลที่วัดมาจริง · ทีมจะเก็บข้อมูลจริง 1-2 sprint แรกแล้ว update เข้า project-context.md
      ])
  ],
  align(center + horizon, [
    #stat-tile("~50%", "เป้าหมายลด effort ต่อ artifact", color: ayodia-accent)
    #v(14pt)
    #stat-tile("14", "Skills ที่ใช้ได้ทันที", color: ayodia-primary)
    #v(14pt)
    #stat-tile("12", "SDP processes ที่ครอบ", color: tier-2)
  ]),
)

#pagebreak()

// ================================================================
// Slide 4 — 5 Expectations
// ================================================================

= ความคาดหวัง 5 ข้อ ก่อนเริ่มใช้

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 30pt,
  row-gutter: 14pt,
  expectation-row(1, "AI ช่วย draft, Tester review",
    [AI ช่วย draft 70-80% เราต้อง review/approve อีก 20-30% ก่อนส่ง · AI ไม่ sign-off แทนคน]),
  expectation-row(2, "Cross-check กับ source",
    [ทุก output ต้องตรวจกับ SRS/PRD/Jira ผ่าน Traceability Matrix · AI hallucinate ได้]),
  expectation-row(3, "ห้าม commit sensitive data",
    [PII / password / token / production credential · ใช้ #kbd("[REDACTED]") หรือ dummy data]),
  expectation-row(4, "Expected Result วัดได้",
    [ห้าม "ทำงานถูกต้อง" / "แสดงผลปกติ" · ต้องระบุตัวเลข สถานะ ค่า]),
)

#v(10pt)

#block(width: 100%, fill: ayodia-accent.lighten(85%), inset: 12pt, radius: 4pt,
  stroke: (left: 4pt + ayodia-accent),
  expectation-row(5, "ห้าม make up number",
    [ถ้า AI ไม่มีข้อมูลจริง (NFR/SLA/business rule เฉพาะลูกค้า) ให้ระบุ "TBD" หรือถามเรา · ห้ามเดา]),
)

#pagebreak()

// ================================================================
// Slide 5 — 14 Skills overview (4 groups)
// ================================================================

= 14 Skills · จัดเป็น 4 กลุ่ม

#v(6pt)

#let group-row(tag, color, skills) = grid(
  columns: (4cm, 1fr),
  column-gutter: 14pt,
  align: (left + horizon, left + horizon),
  phase-tag(tag, color),
  skills.map(s => skill-pill(s)).join(h(6pt)),
)

#stack(spacing: 14pt,
  group-row("PRE-TESTING", tier-2, ("requirement-analyzer", "data-type-matrix-generator")),
  group-row("TESTING PROCESS · 6 ตัว ครอบ 12 SDP", ayodia-primary,
    ("test-plan-writer", "test-case-writer", "test-case-reviewer", "test-report-writer", "perf-test-generator", "perf-result-analyzer")),
  group-row("SUPPORTING", ayodia-accent,
    ("test-matrix-generator", "bug-report-writer", "robot-test-generator", "e2e-test-generator")),
  group-row("LEAD UTILITY", tier-3,
    ("weekly-update-writer", "handoff-writer")),
)

#v(20pt)

#align(center, text(size: 12pt, fill: ayodia-muted)[
  💡 *ทำไม skill 6 ตัวครอบ 12 SDP processes?* skill เดียวใช้ซ้ำหลาย mode เช่น `test-plan-writer` ครอบ P1 (SIT) + P5 (UAT) + P9 (Perf) ในตัวเดียว
])

#pagebreak()

// ================================================================
// Slide 6 — SIT chain
// ================================================================

= Workflow · SIT Chain

#text(size: 12pt, fill: ayodia-muted)[
  *Input:* BRD/PRD/SRS · *Output:* SIT Report + Defect List · *Cycle:* 3 วัน เหลือ 1.5 วัน
]

#v(10pt)

#grid(columns: (1fr, 1fr), column-gutter: 24pt,
  chain-flow(
    (num: "📥", label: "BRD / PRD / SRS", role: "PM/BA"),
    (num: "0", label: "requirement-analyzer", role: "Readiness Score + PM Confirm", color: tier-2),
    (num: "1", label: "test-plan-writer", role: "SIT Test Plan"),
    (num: "2", label: "test-case-writer", role: "SIT TC + Sizing"),
    (num: "3", label: "test-case-reviewer", role: "Peer Review Report"),
  ),
  chain-flow(
    (num: "—", label: "Execute SIT", role: "Manual run"),
    (num: "4a", label: "bug-report-writer", role: "Jira ticket", color: tier-1),
    (num: "4b", label: "test-report-writer", role: "SIT Report + Go/No-Go", color: ayodia-accent),
    (num: "✅", label: "Final Deliverables", role: "Plan + TC + Bugs + Report"),
  ),
)

#pagebreak()

// ================================================================
// Slide 7 — UAT chain
// ================================================================

= Workflow · UAT Chain

#text(size: 12pt, fill: ayodia-muted)[
  *Input:* SIT TC ที่ approved · *Output:* UAT Report + User Sign-off · *Cycle:* 2 วัน เหลือ 1 วัน
]

#v(10pt)

#grid(columns: (1fr, 1fr), column-gutter: 24pt,
  chain-flow(
    (num: "📥", label: "SIT TC + User roles", role: "Tester + BA"),
    (num: "1", label: "test-case-writer (mode=uat)", role: "UAT TC / Checklist"),
    (num: "2", label: "test-case-reviewer (mode=uat)", role: "Business clarity check"),
    (num: "3", label: "test-plan-writer (mode=uat)", role: "UAT Plan + Training"),
  ),
  chain-flow(
    (num: "—", label: "Execute by End User", role: "Manual run"),
    (num: "4", label: "test-report-writer (mode=uat)", role: "UAT Report + Sign-off", color: ayodia-accent),
    (num: "✅", label: "Gate ก่อน Production", role: "User formally signs off"),
  ),
)

#pagebreak()

// ================================================================
// Slide 8 — Perf chain
// ================================================================

= Workflow · Performance Chain

#text(size: 12pt, fill: ayodia-muted)[
  *Input:* NFR + API Spec · *Output:* Perf Report + Bottleneck Analysis · *Cycle:* 2 วัน เหลือ 1 วัน
]

#v(10pt)

#grid(columns: (1fr, 1fr), column-gutter: 24pt,
  chain-flow(
    (num: "📥", label: "NFR (p95/TPS) + API Spec", role: "Architect + Perf Tester"),
    (num: "1", label: "test-plan-writer (mode=perf)", role: "Perf Plan + Workload"),
    (num: "2", label: "perf-test-generator", role: "k6 scripts + thresholds"),
  ),
  chain-flow(
    (num: "—", label: "Execute Perf", role: "Load/Stress/Soak/Spike"),
    (num: "3", label: "perf-result-analyzer", role: "Bottleneck + NFR check"),
    (num: "4", label: "test-report-writer (mode=perf)", role: "Report + Tuning Recommend", color: ayodia-accent),
  ),
)

#pagebreak()

// ================================================================
// Slide 9 — Top skill 1: requirement-analyzer
// ================================================================

= Skill ที่ใช้บ่อย · 1. requirement-analyzer

#text(size: 12pt, fill: ayodia-muted)[
  *เมื่อไหร่ใช้:* ก่อนเขียน SIT TC ทุกครั้ง · เช็คว่า BRD/PRD พร้อมให้ AI ทำงานหรือยัง
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt, align: (top, top),
  block(fill: rgb("#FFF8ED"), stroke: (left: 2pt + tier-2),
    inset: 12pt, radius: 3pt, [
    #text(weight: "bold", fill: tier-2, "📥 INPUT")
    #v(4pt)
    + BRD / PRD / SRS / User Story
    + Module/Feature ที่จะวิเคราะห์
  ]),
  block(fill: rgb("#ECFDF5"), stroke: (left: 2pt + ayodia-accent),
    inset: 12pt, radius: 3pt, [
    #text(weight: "bold", fill: ayodia-accent, "📤 OUTPUT")
    #v(4pt)
    + Readiness Score (Ready / Needs-clarification / Not-ready)
    + Normalized Requirement (FR ID + 9 fields)
    + PM/BA Confirmation Doc
  ]),
)

#v(10pt)

#block(width: 100%, fill: ayodia-bg, inset: 12pt, radius: 4pt, stroke: 0.4pt + ayodia-border, [
  #text(weight: "bold", size: 11pt, fill: ayodia-muted, "💬 พิมพ์แบบนี้ให้ AI:")
  #v(4pt)
  #text(font: "Menlo", size: 11pt, "@PRD-loyalty.md วิเคราะห์ requirement ให้หน่อย ส่ง PM review ก่อนเขียน TC")
])

#pagebreak()

// ================================================================
// Slide 10 — Top skill 2: test-case-writer
// ================================================================

= Skill ที่ใช้บ่อย · 2. test-case-writer

#text(size: 12pt, fill: ayodia-muted)[
  *เมื่อไหร่ใช้:* หลัง requirement-analyzer ผ่าน + PM confirm · ครอบ SIT (technical) และ UAT (business)
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt, align: (top, top),
  block(fill: rgb("#FFF8ED"), stroke: (left: 2pt + tier-2),
    inset: 12pt, radius: 3pt, [
    #text(weight: "bold", fill: tier-2, "📥 INPUT")
    #v(4pt)
    + SRS / Normalized Requirement
    + Module ID + project-context.md
    + Mode: sit / uat
  ]),
  block(fill: rgb("#ECFDF5"), stroke: (left: 2pt + ayodia-accent),
    inset: 12pt, radius: 3pt, [
    #text(weight: "bold", fill: ayodia-accent, "📤 OUTPUT")
    #v(4pt)
    + Test Cases 23-column (TC ID, Steps, Expected, Priority, Severity, Sizing)
    + Traceability Matrix (FR ↔ TC)
    + Sizing Summary Block (S/M/L/XL count)
  ]),
)

#v(10pt)

#block(width: 100%, fill: ayodia-bg, inset: 12pt, radius: 4pt, stroke: 0.4pt + ayodia-border, [
  #text(weight: "bold", size: 11pt, fill: ayodia-muted, "💬 พิมพ์แบบนี้ให้ AI:")
  #v(4pt)
  #text(font: "Menlo", size: 11pt, "@normalized-req.md เขียน SIT TC ใช้ qa-standards ครอบ ECP, BVA, Decision Table")
])

#pagebreak()

// ================================================================
// Slide 11 — Top skill 3: bug-report-writer
// ================================================================

= Skill ที่ใช้บ่อย · 3. bug-report-writer

#text(size: 12pt, fill: ayodia-muted)[
  *เมื่อไหร่ใช้:* ทุกครั้งที่เจอ defect ระหว่าง execute · log เข้า Jira ตาม template มาตรฐาน
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt, align: (top, top),
  block(fill: rgb("#FFF8ED"), stroke: (left: 2pt + tier-2),
    inset: 12pt, radius: 3pt, [
    #text(weight: "bold", fill: tier-2, "📥 INPUT")
    #v(4pt)
    + Symptom ที่เจอ
    + Steps to reproduce
    + Environment (URL/version/browser)
    + Expected vs Actual
    + Screenshot/log (optional)
  ]),
  block(fill: rgb("#ECFDF5"), stroke: (left: 2pt + ayodia-accent),
    inset: 12pt, radius: 3pt, [
    #text(weight: "bold", fill: ayodia-accent, "📤 OUTPUT")
    #v(4pt)
    + Bug Report พร้อม paste เข้า Jira
    + Severity × Priority Action Label ตาม qa-standards
    + รองรับ TH / EN
  ]),
)

#v(10pt)

#block(width: 100%, fill: ayodia-bg, inset: 12pt, radius: 4pt, stroke: 0.4pt + ayodia-border, [
  #text(weight: "bold", size: 11pt, fill: ayodia-muted, "💬 พิมพ์แบบนี้ให้ AI:")
  #v(4pt)
  #text(font: "Menlo", size: 11pt, [เจอ login ไม่ผ่าน Chrome error 500 เขียน bug report ส่ง Jira severity Major])
])

#pagebreak()

// ================================================================
// Slide 12 — งานที่ AI ทำแทนไม่ได้
// ================================================================

= งานที่ AI ทำแทนไม่ได้

#text(size: 13pt)[
  AI ช่วยลด effort ได้ราว 50% แต่ *6 งานนี้ยังเป็นของพวกเรา 100%*
]

#v(10pt)

#grid(columns: (1fr, 1fr), column-gutter: 24pt, row-gutter: 12pt,
  [
    #text(weight: "bold", fill: ayodia-accent)[Cross-check Business Rule เฉพาะลูกค้า] \
    #text(size: 11pt, fill: ayodia-muted)[promotion / VIP benefit / business logic ที่ AI ไม่รู้]
  ],
  [
    #text(weight: "bold", fill: ayodia-accent)[Accept / Reject Coverage Gap] \
    #text(size: 11pt, fill: ayodia-muted)[บาง gap ยอมได้ (Phase 2) บาง gap ต้องแก้ทันที]
  ],
  [
    #text(weight: "bold", fill: ayodia-accent)[Verify Environment + Credential จริง] \
    #text(size: 11pt, fill: ayodia-muted)[AI เดา IP/URL/DB connection จริงไม่ได้]
  ],
  [
    #text(weight: "bold", fill: ayodia-accent)[Sign-off Ready / Not Ready] \
    #text(size: 11pt, fill: ayodia-muted)[ความรับผิดชอบทางวิชาชีพ ลายเซ็นเป็นของคน]
  ],
  [
    #text(weight: "bold", fill: ayodia-accent)[Approve Deferred Bug] \
    #text(size: 11pt, fill: ayodia-muted)[ต้องเป็น PM / Stakeholder decision]
  ],
  [
    #text(weight: "bold", fill: ayodia-accent)[Communicate กับ PM/BA/Dev] \
    #text(size: 11pt, fill: ayodia-muted)[การ negotiate / ขอเลื่อน timeline · human-to-human]
  ],
)

#pagebreak()

// ================================================================
// Slide 13 — Install part 1
// ================================================================

= วิธีติดตั้ง Plugin · 4 ขั้นตอน · 5 นาที

#v(6pt)

#grid(columns: (auto, 1fr), column-gutter: 14pt, row-gutter: 14pt,
  align: (left + top, left + top),

  text(size: 24pt, weight: "bold", fill: ayodia-accent, "1"),
  [
    #text(weight: "bold", size: 14pt)[Prerequisite + Clone repo]
    #v(4pt)
    #raw(block: true, lang: "bash",
      "npm install -g @anthropic-ai/claude-code\n" +
      "cd ~/Documents/GitHub\n" +
      "git clone https://gitlab.ayodiacompany.com/ayodia-tester-teams/qa_ai_skill.git")
  ],

  text(size: 24pt, weight: "bold", fill: ayodia-accent, "2"),
  [
    #text(weight: "bold", size: 14pt)[เปิด Claude แล้ว add marketplace]
    #v(4pt)
    #raw(block: true, lang: "bash",
      "claude\n> /plugin marketplace add /Users/<you>/Documents/GitHub/qa_ai_skill")
    #v(2pt)
    #text(size: 10pt, fill: ayodia-muted)[ใส่ absolute path · ชี้ root ไม่ใช่ `.claude-plugin/`]
  ],
)

#pagebreak()

// ================================================================
// Slide 14 — Install part 2 + verify
// ================================================================

= วิธีติดตั้ง Plugin · ต่อ

#v(6pt)

#grid(columns: (auto, 1fr), column-gutter: 14pt, row-gutter: 14pt,
  align: (left + top, left + top),

  text(size: 24pt, weight: "bold", fill: ayodia-accent, "3"),
  [
    #text(weight: "bold", size: 14pt)[Install plugin]
    #v(4pt)
    #raw(block: true, lang: "bash", "> /plugin install qa-ai-skill@ayodia-qa")
  ],

  text(size: 24pt, weight: "bold", fill: ayodia-accent, "4"),
  [
    #text(weight: "bold", size: 14pt)[ตรวจว่าติดตั้งสำเร็จ]
    #v(4pt)
    + พิมพ์ #kbd("/plugins") · ตรวจ tab *Installed* ต้องเห็น `qa-ai-skill`
    + พิมพ์ #kbd("/help") · เห็น `test-case-writer` `bug-report-writer` ฯลฯ
    + ลองเรียก #kbd("/test-case-writer") · ต้อง trigger ได้
  ],
)

#v(14pt)

#block(width: 100%, fill: rgb("#FFF8ED"), stroke: (left: 3pt + tier-2),
  inset: 12pt, radius: 4pt,
  [
    #text(weight: "bold", size: 12pt, fill: tier-2, "🛠️ ติดปัญหา?")
    #v(2pt)
    #text(size: 11pt)[
      ดู troubleshooting ใน team-guide-v1.pdf หน้า 24 (4 errors ที่เจอบ่อย) · หรือทัก Tester Lead ใน Slack
    ]
  ])

#pagebreak()

// ================================================================
// Slide 15 — Closing / Q&A
// ================================================================

#align(horizon)[
  #align(center)[
    #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "เริ่มจากตัวเดียวก่อนก็ได้")
    #v(20pt)
    #text(size: 44pt, weight: "bold", fill: ayodia-primary)[Q & A]
    #v(30pt)
  ]

  #align(center, block(
    fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 6pt,
    inset: 24pt, width: 75%,
    align(left)[
      #text(weight: "bold", size: 16pt, fill: ayodia-primary, "สิ่งที่อยากให้ทุกคนทำสัปดาห์นี้")
      #v(10pt)
      + อ่านหน้า "ความคาดหวัง 5 ข้อ" ใน team-guide PDF
      + ติดตั้ง plugin ตาม 4 ขั้นตอน
      + เริ่มจาก #skill-pill("bug-report-writer") หรือ #skill-pill("test-case-writer") ก่อน
      + เจอจุดที่ output ไม่ตรง qa-standards · ทักได้เลย
    ],
  ))

  #v(20pt)
  #align(center, text(size: 12pt, fill: ayodia-muted)[
    เอกสารเต็ม: team-guide-v1.pdf (25 หน้า) · Tester Lead Team
  ])
]
