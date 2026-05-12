// QA AI Skills — Team Sharing Session (~45 นาที)
// Covers: Skill concept, repo purpose, problems solved, expectations, tuning, PR flow
// Build: typst compile --root . slides/sharing-session.typ slides/sharing-session.pdf

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
        #box(baseline: 3pt, image(logo-path, height: 0.6cm))#h(5pt)QA AI Skills · Team Sharing Session
      ],
      align(center + horizon)[v1.0 · 8 พ.ค. 69],
      align(right + horizon)[#n / #counter(page).final().first()],
    )
  },
)

#set text(font: ("Sukhumvit Set", "Sarabun", "Helvetica"), size: 14pt, lang: "th", fill: ayodia-primary.darken(20%))
#set par(leading: 0.7em, spacing: 0.85em)

#show heading.where(level: 1): it => block(below: 14pt, above: 0pt)[
  #grid(columns: (4pt, 1fr), gutter: 14pt, align: (left + horizon, left + horizon),
    rect(width: 4pt, height: 32pt, fill: ayodia-accent, stroke: none),
    text(size: 26pt, weight: "bold", fill: ayodia-primary, it.body),
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
    #text(size: 30pt, weight: "bold", fill: color)[#value]
  ],
))

#let kbd(t) = box(fill: ayodia-bg, stroke: 0.4pt + ayodia-border,
  inset: (x: 5pt, y: 2pt), radius: 2pt,
  text(font: "Menlo", size: 10pt, t))

#let skill-pill(name) = box(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border,
  inset: (x: 9pt, y: 5pt), radius: 3pt,
  text(font: "Menlo", size: 10pt, fill: ayodia-primary, name),
)

#let info-box(title, color, body) = block(
  width: 100%,
  fill: color.lighten(88%),
  stroke: (left: 4pt + color),
  radius: 4pt,
  inset: 12pt,
  [
    #text(weight: "bold", size: 12pt, fill: color, title)
    #v(4pt)
    #body
  ],
)

#let pain-card(icon, pain, fix) = block(
  width: 100%,
  fill: ayodia-bg,
  stroke: 0.5pt + ayodia-border,
  radius: 4pt,
  inset: 11pt,
  grid(
    columns: (auto, 1fr),
    column-gutter: 12pt,
    align: (top, top),
    text(size: 24pt, icon),
    [
      #text(weight: "bold", size: 12pt, fill: tier-1, [Pain · #pain])
      #v(3pt)
      #text(size: 11pt, fill: ayodia-accent, [✓ #fix])
    ],
  ),
)

#let numbered-row(num, title, body) = grid(
  columns: (auto, 1fr),
  column-gutter: 14pt,
  align: (top, top),
  text(size: 24pt, weight: "bold", fill: ayodia-accent, str(num)),
  stack(
    spacing: 4pt,
    text(weight: "bold", size: 13pt, fill: ayodia-primary, title),
    text(size: 11pt, body),
  ),
)

#let step-card(num, title, code, hint: none) = block(
  width: 100%,
  fill: ayodia-bg,
  stroke: (left: 3pt + ayodia-accent),
  radius: 3pt,
  inset: 10pt,
  [
    #grid(columns: (auto, 1fr), column-gutter: 10pt,
      text(size: 18pt, weight: "bold", fill: ayodia-accent, str(num)),
      text(weight: "bold", size: 12pt, fill: ayodia-primary, title),
    )
    #v(3pt)
    #code
    #if hint != none [#v(3pt) #text(size: 9pt, fill: ayodia-muted, hint)]
  ],
)

// ================================================================
// Slide 1 — Title
// ================================================================

#align(center + horizon)[
  #image(logo-path, width: 4cm)
  #v(8pt)
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "TEAM SHARING SESSION")
  #v(28pt)
  #text(size: 48pt, weight: "bold", fill: ayodia-primary, "QA AI Skills Repo")
  #v(6pt)
  #text(size: 22pt, fill: ayodia-muted, "ทำความรู้จัก · ใช้งาน · ปรับแต่ง · contribute")
  #v(40pt)
  #text(size: 13pt, fill: ayodia-muted)[v1.0 · 8 พฤษภาคม 2569 · Tester Lead Team]
]

#pagebreak()

// ================================================================
// Slide 2 — Agenda
// ================================================================

= Agenda · 2 ชั่วโมง (Lecture 60 + Workshop 60)

#v(4pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 24pt,
  row-gutter: 8pt,
  [
    #text(weight: "bold", fill: ayodia-primary, size: 13pt, "Part 1 · Lecture + Demo · 60 นาที")
    #v(2pt)
    #text(size: 11pt)[
      - *(10')* Skill คืออะไร · โครงสร้าง · Frontmatter
      - *(10')* จุดประสงค์ของ repo · ปัญหาที่แก้ · 14 Skills
      - *(20')* Deep dive 5 skills ที่ใช้บ่อย
      - *(10')* qa-standards · Severity/Priority/Sizing
      - *(5')* AI Guardrails 5 ข้อ + ความคาดหวัง
      - *(5')* Live Demo
    ]
    #v(6pt)
    #text(weight: "bold", fill: tier-2, size: 12pt, "☕ Break · 10 นาที")
  ],
  [
    #text(weight: "bold", fill: ayodia-accent, size: 13pt, "Part 2 · Workshop · 50 นาที")
    #v(2pt)
    #text(size: 11pt)[
      - *(5')* Lab 0 — Install plugin
      - *(5')* Lab 1 — รัน `bug-report-writer`
      - *(10')* Lab 2 — เขียน TC จาก SRS + tuning
      - *(5')* Lab 3 — สร้าง `project-context.md`
      - *(10')* Lab 4 — แก้ skill + validate + PR
      - *(15')* Free Play — ลองใช้ skill อิสระ
    ]
    #v(6pt)
    #text(weight: "bold", fill: ayodia-accent, size: 12pt, "🎯 Wrap-up + Q&A · 10 นาที")
  ],
)

#v(10pt)

#align(center, block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
  inset: 12pt, width: 85%,
  text(size: 11pt)[
    *เป้าหมาย:* จบ session แล้วทุกคน *(1)* ติดตั้ง plugin ได้ *(2)* รัน skill เป็น *(3)* รู้วิธี tuning + เปิด PR ตัวแรก
  ],
))

#pagebreak()

// ================================================================
// Slide 3 — Skill ของ Claude คืออะไร
// ================================================================

= Skill ของ Claude คืออะไร

#grid(
  columns: (1.4fr, 1fr),
  column-gutter: 24pt,
  align: (top, top),
  [
    #text(size: 15pt)[
      *Skill* = ชุด instruction (Markdown) + template + reference ที่บอก Claude ว่า "งานประเภทนี้ทำยังไง" — โหลดเข้า context *เฉพาะตอนถูก trigger*
    ]
    #v(10pt)

    #info-box("✨ จุดเด่น", ayodia-accent, [
      - Trigger ผ่าน *slash command* (เช่น `/test-case-writer`) หรือ *natural-language keyword* (เช่น "เขียน test case จาก SRS นี้")
      - ไม่ต้อง prompt engineering ใหม่ทุกครั้ง — มาตรฐานเดียวกันทั้งทีม
      - แชร์เป็น *plugin* — ติดตั้งครั้งเดียวใช้ได้ทุก skill
      - แก้ที่ Markdown ไฟล์เดียว ทีมได้พร้อมกัน
    ])
  ],
  [
    #info-box("🎯 ต่างจาก ChatGPT/Prompt ทั่วไปยังไง", ayodia-primary, [
      #text(size: 11pt)[
        *Prompt ทั่วไป:* ต่างคนต่างพิมพ์ ผลลัพธ์คนละมาตรฐาน
        #v(4pt)
        *Custom GPT:* ผูกกับ account คนสร้าง แชร์ยาก แก้ไม่เห็น diff
        #v(4pt)
        *Claude Skill:* อยู่ใน git repo, version control, code review ได้, ทุกคนใช้ตัวเดียวกัน
      ]
    ])
    #v(10pt)
    #stat-tile("14", "Skills ที่ใช้ได้ทันที", color: ayodia-primary)
  ],
)

#pagebreak()

// ================================================================
// Slide 4 — โครงสร้าง 1 Skill
// ================================================================

= โครงสร้าง 1 Skill · มีอะไรบ้าง

#grid(
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📁 Folder structure")
    #v(4pt)
    #raw(block: true, lang: "text",
"skills/<skill-name>/
├── SKILL.md          ← instruction หลัก
├── templates/        ← output template
│   ├── *-th.md
│   └── *.csv
├── references/       ← reference เฉพาะ skill
└── examples/         ← input → output ตัวอย่าง")
    #v(8pt)
    #text(size: 11pt, fill: ayodia-muted)[
      Claude อ่าน *frontmatter* ของ SKILL.md ก่อน เพื่อรู้ว่าเมื่อไหร่ต้อง trigger — ค่อย load body ทั้งหมดเข้า context ตอน trigger จริง
    ]
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📝 SKILL.md · 8 sections มาตรฐาน")
    #v(4pt)
    + *Frontmatter* — name + description + trigger
    + *Purpose* — เป้าหมาย + effort savings
    + *When to Use* — SDP mapping
    + *Inputs* — สิ่งที่ต้องเตรียม
    + *Outputs* — format + template
    + *Process* — step-by-step
    + *Quality Gate* — checklist ก่อนส่ง
    + *AI Guardrails* — ข้อควรระวัง
    + *Chain* — เชื่อมกับ skill อื่น
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[ดูเต็ม: `SKILL-TEMPLATE.md`]
  ],
)

#pagebreak()

// ================================================================
// Slide 5 — Frontmatter ตัวอย่าง
// ================================================================

= Frontmatter · หัวใจของ Skill

#text(size: 12pt, fill: ayodia-muted)[
  ส่วน metadata ที่ Claude อ่านเพื่อรู้ว่า "skill นี้คืออะไร · ตอนไหนต้องเรียก"
]

#v(8pt)

#raw(block: true, lang: "yaml",
"---
name: test-case-writer
description: เขียน test case จาก requirement document (SRS/PRD/spec/user story)
  ให้ครอบคลุมและอ่านง่าย — รองรับ SIT mode (technical view, 23 cols), UAT mode
  + testing techniques (ECP, BVA, Decision Table, State Transition).
  Trigger เมื่อ user ส่ง requirement file/SRS/PRD/spec/user story และขอให้เขียน
  test case, test scenario, SIT test case, UAT test case, \"write test cases\",
  \"create test scenarios\", \"generate UAT checklist\".
  Maps to SDP §5.3.1 (Process 2, 6).
---")

#v(10pt)

#grid(columns: (1fr, 1fr, 1fr), column-gutter: 14pt,
  info-box("🏷️ name", tier-2, text(size: 11pt)[
    kebab-case · ตรงกับชื่อโฟลเดอร์ · unique ทั้ง repo
  ]),
  info-box("💬 description", ayodia-accent, text(size: 11pt)[
    ทำอะไร + input → output + trigger keywords (TH+EN) + SDP mapping
  ]),
  info-box("⚡ trigger", ayodia-primary, text(size: 11pt)[
    Claude scan keyword ใน user message ถ้า match → load skill เข้า context
  ]),
)

#pagebreak()

// ================================================================
// Slide 6 — จุดประสงค์ของ repo
// ================================================================

= จุดประสงค์ของ Repo นี้

#v(6pt)

#grid(
  columns: (1.3fr, 1fr),
  column-gutter: 20pt,
  align: (top, top),
  [
    #text(size: 16pt)[
      *รวม Claude Skills สำหรับทีม Tester* — ทุกคนใช้ตัวเดียวกัน ผลลัพธ์มาตรฐานเดียวกัน อัปเดตจุดเดียว
    ]
    #v(12pt)

    #numbered-row(1, "Standardize work product",
      [TC, Bug Report, Test Plan, Report ใช้ template + Severity/Priority/Sizing เดียวกันทุกคน — alignment กับ SDP §5])
    #v(8pt)
    #numbered-row(2, "ลด effort งานเอกสาร ~50%",
      [AI draft 70-80% เราเหลือแค่ review/verify — เอาเวลาไปทำงานที่ AI ทำแทนไม่ได้])
    #v(8pt)
    #numbered-row(3, "Knowledge as code",
      [วิธีเขียน TC ที่ดี / วิธีรีวิว / วิธีรายงานผล อยู่ใน git — review ได้ versioning ได้ rollback ได้])
    #v(8pt)
    #numbered-row(4, "Onboarding Tester ใหม่เร็วขึ้น",
      [คนใหม่อ่าน skill + ลองรันได้เลย ไม่ต้องนั่งสอน prompt 1-1])
  ],
  [
    #stat-tile("14", "Skills ที่ใช้ได้", color: ayodia-primary)
    #v(10pt)
    #stat-tile("12", "SDP processes ที่ครอบ", color: tier-2)
    #v(10pt)
    #stat-tile("~50%", "เป้าลด effort/artifact", color: ayodia-accent)
    #v(10pt)
    #stat-tile("3", "Workflow chain (SIT/UAT/Perf)", color: tier-3)
  ],
)

#pagebreak()

// ================================================================
// Slide 7 — ปัญหาที่แก้ (Pain → Fix)
// ================================================================

= ทำเพื่ออะไร · แก้ปัญหาอะไร

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, row-gutter: 10pt,
  pain-card("📝", "เขียน TC ใช้เวลาเยอะ — 50-60% ของ sprint หมดกับเอกสาร",
    "test-case-writer draft ให้ 80% เหลือ verify อีก 20%"),
  pain-card("🎲", "TC แต่ละคนเขียนคนละ format / Severity ใช้คนละ scale",
    "qa-standards.md บังคับใช้ทุก skill — มาตรฐานเดียว"),
  pain-card("🔁", "Rework รอบใหญ่ตอน PM บอก \"เข้าใจผิด\"",
    "requirement-analyzer เช็ค Readiness + ส่ง PM confirm ก่อนเขียน TC"),
  pain-card("🐛", "Bug Report ใน Jira ไม่ครบ field ทีม Dev reproduce ไม่ได้",
    "bug-report-writer ใส่ครบ — repro steps + env + Severity×Priority"),
  pain-card("📊", "สรุป Test Report ตอน sprint จบ ใช้เวลาทั้งวัน",
    "test-report-writer สรุปจาก Jira export ได้ใน 10 นาที"),
  pain-card("🤝", "Tester ใหม่ onboarding 2 อาทิตย์ยังเขียน TC ไม่ได้คุณภาพทีม",
    "skill ทำหน้าที่ \"senior Tester ข้างๆ\" — สอน + draft ไปพร้อมกัน"),
)

#pagebreak()

// ================================================================
// Slide 8 — Before vs After
// ================================================================

= Before vs After · เห็นภาพชัด

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  block(fill: tier-1.lighten(90%), stroke: (left: 4pt + tier-1),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 14pt, fill: tier-1, "❌ Before — ไม่มี Skill")
    #v(6pt)
    - PM ส่ง BRD มา → Tester เปิด Word เริ่มเขียน TC จากศูนย์
    - แต่ละคน prompt ChatGPT ต่างกัน ผลคนละแบบ
    - Severity 1-5 หรือ Critical/High/Medium? คนละความเข้าใจ
    - Bug Report บางใบไม่มี repro step ต้องไล่ถาม
    - Test Report ตอน UAT จบ — ใช้เวลา 1 วัน copy-paste
    - Tester ใหม่: \"พี่ TC แบบนี้โอเคมั้ย?\" ทุกครั้ง
    - knowledge อยู่ในหัวคน — ลาออก = หาย
  ]),
  block(fill: ayodia-accent.lighten(90%), stroke: (left: 4pt + ayodia-accent),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 14pt, fill: ayodia-accent, "✅ After — มี Skill")
    #v(6pt)
    - `/requirement-analyzer` เช็ค BRD พร้อมก่อน → PM confirm
    - `/test-case-writer` draft TC ตาม template เดียวกัน
    - Severity = Critical/Major/Minor/Trivial — บังคับใน qa-standards
    - `/bug-report-writer` field ครบทุกใบ → Dev reproduce ได้ทันที
    - `/test-report-writer` สรุปจาก Jira export → 10 นาที
    - Tester ใหม่: รัน skill เห็น output มาตรฐานทีมเลย
    - knowledge อยู่ใน git — รีวิวได้ versioning ได้
  ]),
)

#pagebreak()

// ================================================================
// Slide 9 — 14 Skills · จัดเป็น 4 กลุ่ม
// ================================================================

= ภาพรวม 14 Skills · 4 กลุ่ม

#v(6pt)

#let group-row(tag, color, skills) = grid(
  columns: (4cm, 1fr),
  column-gutter: 14pt,
  align: (left + horizon, left + horizon),
  phase-tag(tag, color),
  skills.map(s => skill-pill(s)).join(h(6pt)),
)

#stack(spacing: 14pt,
  group-row("PRE-TESTING", tier-2,
    ("requirement-analyzer", "data-type-matrix-generator")),
  group-row("TESTING PROCESS · ครอบ 12 SDP", ayodia-primary,
    ("test-plan-writer", "test-case-writer", "test-case-reviewer", "test-report-writer", "perf-test-generator", "perf-result-analyzer")),
  group-row("SUPPORTING", ayodia-accent,
    ("test-matrix-generator", "bug-report-writer", "robot-test-generator", "e2e-test-generator")),
  group-row("LEAD UTILITY", tier-3,
    ("weekly-update-writer", "handoff-writer")),
)

#v(18pt)

#align(center, text(size: 12pt, fill: ayodia-muted)[
  💡 *6 skills ครอบ 12 SDP processes* — เพราะ skill เดียวใช้ซ้ำหลาย mode (SIT/UAT/Perf)
])

#pagebreak()

// ================================================================
// Slide 10 — Workflow chains
// ================================================================

= Workflow Chain · ใช้งานจริง

#v(6pt)

#grid(columns: (1fr, 1fr, 1fr), column-gutter: 14pt,
  block(fill: ayodia-bg, stroke: (left: 3pt + ayodia-primary),
    inset: 12pt, radius: 4pt, [
    #text(weight: "bold", fill: ayodia-primary, size: 13pt, "🔵 SIT Chain")
    #v(4pt)
    #text(size: 11pt)[
      BRD/PRD \
      ↓ requirement-analyzer \
      ↓ test-plan-writer \
      ↓ test-case-writer \
      ↓ test-case-reviewer \
      ↓ \[Execute\] \
      ↓ bug-report-writer \
      ↓ test-report-writer
    ]
  ]),
  block(fill: ayodia-bg, stroke: (left: 3pt + ayodia-accent),
    inset: 12pt, radius: 4pt, [
    #text(weight: "bold", fill: ayodia-accent, size: 13pt, "🟢 UAT Chain")
    #v(4pt)
    #text(size: 11pt)[
      SIT TC approved \
      ↓ test-case-writer (uat) \
      ↓ test-case-reviewer (uat) \
      ↓ test-plan-writer (uat) \
      ↓ \[Execute by User\] \
      ↓ test-report-writer (uat) \
      ↓ User Sign-off \
      ↓ → Production
    ]
  ]),
  block(fill: ayodia-bg, stroke: (left: 3pt + tier-2),
    inset: 12pt, radius: 4pt, [
    #text(weight: "bold", fill: tier-2, size: 13pt, "🟠 Perf Chain")
    #v(4pt)
    #text(size: 11pt)[
      NFR + API Spec \
      ↓ test-plan-writer (perf) \
      ↓ perf-test-generator \
      ↓ \[Run Load/Stress\] \
      ↓ perf-result-analyzer \
      ↓ test-report-writer (perf) \
      ↓ Tuning Recommend
    ]
  ]),
)

#v(14pt)

#align(center, block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 4pt,
  inset: 12pt, width: 90%,
  text(size: 11pt)[
    🔄 *ผ่อนงาน:* skill เดียวกันใช้ได้ 3 mode — `test-plan-writer` รับ argument `mode=sit/uat/perf`
  ]
))

#pagebreak()

// ================================================================
// Slide 11 — ความคาดหวัง 5 ข้อ
// ================================================================

= ความคาดหวัง 5 ข้อ ก่อนเริ่มใช้

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 26pt,
  row-gutter: 14pt,
  numbered-row(1, "AI ช่วย draft, Tester review",
    [AI draft 70-80% เราต้อง review/approve อีก 20-30% ก่อนส่ง · AI ไม่ sign-off แทนคน]),
  numbered-row(2, "Cross-check กับ source",
    [ทุก output ต้องตรวจกับ SRS/PRD/Jira ผ่าน Traceability Matrix · AI hallucinate ได้]),
  numbered-row(3, "ห้าม commit sensitive data",
    [PII / password / token / production credential · ใช้ #kbd("[REDACTED]") หรือ dummy data]),
  numbered-row(4, "Expected Result วัดได้",
    [ห้าม "ทำงานถูกต้อง" / "แสดงผลปกติ" · ต้องระบุตัวเลข สถานะ ค่าเฉพาะ]),
)

#v(10pt)

#block(width: 100%, fill: ayodia-accent.lighten(85%), inset: 12pt, radius: 4pt,
  stroke: (left: 4pt + ayodia-accent),
  numbered-row(5, "ห้าม make up number",
    [ถ้า AI ไม่มีข้อมูลจริง (NFR/SLA/business rule เฉพาะลูกค้า) ให้ระบุ "TBD" หรือถามเรา · ห้ามเดา]),
)

#pagebreak()

// ================================================================
// Slide 12 — งานที่ AI ทำแทนไม่ได้
// ================================================================

= งานที่ AI ทำแทนไม่ได้ · ของเรา 100%

#text(size: 13pt)[
  AI ลด effort 50% แต่ *6 งานนี้ต้องเป็นคนเท่านั้น*
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
// Slide — Section divider · Deep dive 5 skills
// ================================================================

#align(center + horizon)[
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "DEEP DIVE")
  #v(20pt)
  #text(size: 40pt, weight: "bold", fill: ayodia-primary, "5 Skills ที่ใช้บ่อย")
  #v(12pt)
  #text(size: 16pt, fill: ayodia-muted)[Input · Output · Sample Prompt · When to use]
  #v(28pt)
  #grid(columns: 5, column-gutter: 8pt,
    skill-pill("requirement-analyzer"),
    skill-pill("test-case-writer"),
    skill-pill("test-case-reviewer"),
    skill-pill("bug-report-writer"),
    skill-pill("test-report-writer"),
  )
]

#pagebreak()

// ================================================================
// Skill Deep Dive helper
// ================================================================

#let skill-detail(name, when, inputs, outputs, prompt-text) = [
  = #raw(name)

  #text(size: 12pt, fill: ayodia-muted)[*เมื่อไหร่ใช้:* #when]

  #v(6pt)

  #grid(columns: (1fr, 1fr), column-gutter: 14pt, align: (top, top),
    block(fill: rgb("#FFF8ED"), stroke: (left: 2pt + tier-2),
      inset: 12pt, radius: 3pt, [
      #text(weight: "bold", fill: tier-2, "📥 INPUT")
      #v(4pt)
      #inputs
    ]),
    block(fill: rgb("#ECFDF5"), stroke: (left: 2pt + ayodia-accent),
      inset: 12pt, radius: 3pt, [
      #text(weight: "bold", fill: ayodia-accent, "📤 OUTPUT")
      #v(4pt)
      #outputs
    ]),
  )

  #v(8pt)

  #block(width: 100%, fill: ayodia-bg, inset: 12pt, radius: 4pt,
    stroke: 0.4pt + ayodia-border, [
    #text(weight: "bold", size: 11pt, fill: ayodia-muted, "💬 พิมพ์แบบนี้ให้ AI:")
    #v(4pt)
    #text(font: "Menlo", size: 11pt, prompt-text)
  ])
]

// ================================================================
// Slide — Skill 1 · requirement-analyzer
// ================================================================

#skill-detail(
  "1. requirement-analyzer",
  [ก่อนเขียน SIT TC ทุกครั้ง · เช็คว่า BRD/PRD พร้อมให้ AI ทำงานหรือยัง · ป้องกัน rework รอบใหญ่],
  [
    + BRD / PRD / SRS / User Story
    + Module/Feature ที่จะวิเคราะห์
    + Project + PM ที่ต้อง confirm
  ],
  [
    + Readiness Score (Ready / Needs-clarification / Not-ready)
    + Normalized Requirement (FR ID + 9 fields)
    + PM/BA Confirmation Doc (ส่ง review)
    + List of Open Questions
  ],
  "@PRD-loyalty.md วิเคราะห์ requirement — module: Loyalty, project: PEA\nส่ง PM (คุณสมศรี) review ก่อนเขียน TC",
)

#pagebreak()

// ================================================================
// Slide — Skill 2 · test-case-writer
// ================================================================

#skill-detail(
  "2. test-case-writer",
  [หลัง requirement-analyzer ผ่าน + PM confirm · ครอบ SIT (technical) และ UAT (business)],
  [
    + SRS / Normalized Requirement
    + Module ID + project-context.md
    + Mode: sit / uat
    + Testing technique (ECP / BVA / Decision Table / State Transition)
  ],
  [
    + Test Cases 23-column (TC ID, Steps, Expected, Priority, Severity, Sizing)
    + Traceability Matrix (FR ↔ TC)
    + Sizing Summary Block (S/M/L/XL count)
    + รองรับ TH/EN + Markdown/CSV
  ],
  "@normalized-req.md เขียน SIT TC — ภาษาไทย CSV\nครอบ ECP, BVA, Decision Table · เน้น negative + boundary",
)

#pagebreak()

// ================================================================
// Slide — Skill 3 · test-case-reviewer
// ================================================================

#skill-detail(
  "3. test-case-reviewer",
  [หลังเขียน TC เสร็จ · peer review ก่อนเริ่ม execute · หา gap กับ SRS],
  [
    + ไฟล์ Test Cases ที่จะ review
    + SRS / Normalized Requirement (compare)
    + Mode: sit / uat
  ],
  [
    + Review Report ตาราง: TC ID / ปัญหา / ระดับ Must Fix / Should Fix / ข้อเสนอแนะ
    + Coverage gap analysis (FR ที่ไม่มี TC ครอบ)
    + Checklist 8 จุด: Expected ชัด · Precondition ครบ · Positive/Negative/Boundary ครอบ · Traceability ไม่มี gap
  ],
  "review SIT test case @testcases_sit_login_20260420.md\nเทียบ SRS @docs/srs-login.md — หา gap + ปัญหา",
)

#pagebreak()

// ================================================================
// Slide — Skill 4 · bug-report-writer
// ================================================================

#skill-detail(
  "4. bug-report-writer",
  [ทุกครั้งที่เจอ defect ระหว่าง execute · log เข้า Jira ตาม template มาตรฐาน],
  [
    + Symptom ที่เจอ + Steps to reproduce
    + Environment (URL/version/browser)
    + Expected vs Actual
    + Screenshot/log (optional)
    + TC ID ที่เกี่ยวข้อง
  ],
  [
    + Bug Report พร้อม paste เข้า Jira/Linear/GitHub
    + Severity × Priority Action Label ตาม qa-standards
    + Reproduce steps ครบ → Dev reproduce ได้ทันที
    + รองรับ TH / EN
  ],
  "เจอ login ไม่ผ่าน Chrome 130 macOS staging — error 500\nTC: AUTH-TC-005 · severity: Major · เขียน bug report Jira",
)

#pagebreak()

// ================================================================
// Slide — Skill 5 · test-report-writer
// ================================================================

#skill-detail(
  "5. test-report-writer",
  [หลัง execute เสร็จ · สรุปผลเทียบ Exit Criteria + AI Effort Savings KPI],
  [
    + Test Execution Data (Jira export / Excel / CSV)
    + Test Plan (สำหรับเทียบ Exit Criteria)
    + Mode: sit / uat / perf
    + Sign-off info (User name + วันที่)
  ],
  [
    + Summary table (Total/Pass/Fail/Block/Not Run)
    + Exit Criteria Evaluation (Pass/Fail vs target)
    + Defect Summary by Severity + Status + Deferred List
    + AI Effort Savings section (Estimate vs Actual)
    + Conclusion + Recommendation
  ],
  "สรุป SIT Report จาก @sit_execution.csv\nเทียบ Exit Criteria ใน @sit_plan_leave_20260420.md",
)

#pagebreak()

// ================================================================
// Slide — Section divider · qa-standards + Guardrails
// ================================================================

#align(center + horizon)[
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "STANDARDS · GUARDRAILS")
  #v(20pt)
  #text(size: 40pt, weight: "bold", fill: ayodia-primary, "qa-standards.md")
  #v(8pt)
  #text(size: 18pt, fill: ayodia-muted)[+ AI Guardrails 5 ข้อ]
  #v(20pt)
  #align(center, block(
    fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
    inset: 14pt, width: 75%,
    text(size: 12pt)[
      *Single source of truth* — ทุก skill อ่าน standard นี้ \
      ข้อมูลไหลจาก TC → Plan → Report ได้ไม่ต้องแปลง scale
    ],
  ))
]

#pagebreak()

// ================================================================
// Slide — Severity Scale
// ================================================================

= Severity Scale · 4 ระดับ (บังคับทุก skill)

#text(size: 12pt, fill: ayodia-muted)[
  *ความรุนแรงของปัญหา* — ระดับผลกระทบหาก TC fail
]

#v(8pt)

#table(
  columns: (auto, 1fr, 1.4fr, auto),
  inset: 8pt,
  align: (left + horizon, left + horizon, left + horizon, center + horizon),
  stroke: 0.4pt + ayodia-border,
  fill: (col, row) => if row == 0 { ayodia-primary } else { none },
  table.header(
    text(fill: white, weight: "bold", "Level"),
    text(fill: white, weight: "bold", "ความหมาย"),
    text(fill: white, weight: "bold", "ตัวอย่าง"),
    text(fill: white, weight: "bold", "SLA Fix (SIT)"),
  ),
  text(fill: tier-1, weight: "bold", "🔴 Critical"),
  "ระบบหลักพัง ใช้งานไม่ได้",
  "ระบบล่ม · ชำระเงินไม่ผ่าน",
  text(weight: "bold", "≤ 1 วัน"),
  text(fill: tier-2, weight: "bold", "🟠 Major"),
  "ฟังก์ชันหลักใช้ไม่ได้ ระบบยังรันได้",
  "Login พัง · ข้อมูลไม่บันทึก",
  text(weight: "bold", "≤ 2 วัน"),
  text(fill: tier-3, weight: "bold", "🟡 Minor"),
  "ปัญหาเล็กน้อย ไม่กระทบหลัก",
  "UI ไม่ตรง Figma · validation แจ้งผิด",
  "ใน sprint",
  text(fill: tier-4, weight: "bold", "🔵 Trivial"),
  "จุกจิก ไม่กระทบการใช้งาน",
  "Wording · alignment เพี้ยน",
  "best effort",
)

#v(10pt)

#align(center, text(size: 11pt, fill: ayodia-muted)[
  💡 อ้างอิงจาก *Ayodia TEST DEFINITION template* — ใช้คำเดียวกันทั้งทีม ไม่ใช้ Sev1-4 อีกต่อไป
])

#pagebreak()

// ================================================================
// Slide — Priority Scale
// ================================================================

= Priority Scale · 4 ระดับ (บังคับทุก skill)

#text(size: 12pt, fill: ayodia-muted)[
  *ความเร่งด่วนของการทดสอบ/แก้ไข* — ดูจากความสำคัญต่อธุรกิจ + เวลา
]

#v(8pt)

#table(
  columns: (auto, 1.2fr, 1.5fr),
  inset: 8pt,
  align: (left + horizon, left + horizon, left + horizon),
  stroke: 0.4pt + ayodia-border,
  fill: (col, row) => if row == 0 { ayodia-primary } else { none },
  table.header(
    text(fill: white, weight: "bold", "Level"),
    text(fill: white, weight: "bold", "ความหมาย"),
    text(fill: white, weight: "bold", "ตัวอย่าง"),
  ),
  text(fill: tier-1, weight: "bold", "🔴 Critical"),
  "ต้องแก้ทันที เพราะ Block งานอื่น",
  "ปุ่ม Submit พัง — ทดสอบต่อไม่ได้",
  text(fill: tier-2, weight: "bold", "🟠 High"),
  "สำคัญต่อ Core Function · ต้องทำในรอบนี้",
  "Register ใช้งานไม่ได้",
  text(fill: tier-3, weight: "bold", "🟡 Medium"),
  "สำคัญรองลงมา · ทันรอบถัดไปได้",
  "การค้นหาช้ากว่าปกติ",
  text(fill: tier-4, weight: "bold", "🔵 Low"),
  "ไม่เร่งด่วน ทำทีหลังก็ได้",
  "UI ไม่ตรง Figma · สีผิดโทน",
)

#v(10pt)

#block(width: 100%, fill: tier-2.lighten(88%), stroke: (left: 4pt + tier-2),
  inset: 12pt, radius: 4pt, [
  #text(weight: "bold", size: 12pt, fill: tier-2, "⚠️ Priority ≠ Severity")
  #v(2pt)
  #text(size: 11pt)[
    *Trivial bug (typo)* อาจเป็น *Critical Priority* ได้ ถ้าลูกค้าใหญ่บ่น \
    → ทั้งคู่ต้องระบุแยกกัน ใน Bug Report ทุกใบ
  ]
])

#pagebreak()

// ================================================================
// Slide — Severity × Priority Matrix
// ================================================================

= Severity × Priority Matrix · Action Label

#text(size: 11pt, fill: ayodia-muted)[
  จับคู่ Severity กับ Priority แล้วได้ *Action Label* — บอกชัดว่าต้องจัดการยังไง
]

#v(6pt)

#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
  stroke: 0.4pt + ayodia-border,
  fill: (col, row) => if row == 0 or col == 0 { ayodia-bg } else { none },
  table.header(
    text(weight: "bold", size: 10pt, [Sev \\ Pri]),
    text(fill: tier-1, weight: "bold", size: 10pt, "🔴 Critical"),
    text(fill: tier-2, weight: "bold", size: 10pt, "🟠 High"),
    text(fill: tier-3, weight: "bold", size: 10pt, "🟡 Medium"),
    text(fill: tier-4, weight: "bold", size: 10pt, "🔵 Low"),
  ),
  text(fill: tier-1, weight: "bold", size: 10pt, "🔴 Critical"),
  text(size: 9pt, weight: "bold", fill: tier-1, "Blocker"),
  text(size: 9pt, "Urgent"),
  text(size: 9pt, "Important"),
  text(size: 9pt, "Deferred Critical"),

  text(fill: tier-2, weight: "bold", size: 10pt, "🟠 Major"),
  text(size: 9pt, "High Business Risk"),
  text(size: 9pt, weight: "bold", fill: tier-2, "Standard High"),
  text(size: 9pt, "Manageable"),
  text(size: 9pt, "Can Delay"),

  text(fill: tier-3, weight: "bold", size: 10pt, "🟡 Minor"),
  text(size: 9pt, "Prioritize If Impacted"),
  text(size: 9pt, "Optional but Noted"),
  text(size: 9pt, "Acceptable Delay"),
  text(size: 9pt, "Low Impact Cosmetic"),

  text(fill: tier-4, weight: "bold", size: 10pt, "🔵 Trivial"),
  text(size: 9pt, "Non-critical Visible"),
  text(size: 9pt, "Minor Fix Suggested"),
  text(size: 9pt, "Schedule Later"),
  text(size: 9pt, "Optional"),
)

#v(8pt)

#align(center, text(size: 11pt, fill: ayodia-muted)[
  💡 *bug-report-writer* ใส่ Action Label ให้อัตโนมัติ — ทีม dev/PM อ่านปุ๊บรู้ว่าต้องทำไง
])

#pagebreak()

// ================================================================
// Slide — Sizing + Schedule formula
// ================================================================

= Test Sizing + Schedule Formula

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📏 Sizing Scale (บังคับทุก TC)")
    #v(4pt)
    #table(
      columns: (auto, auto, auto, 1fr),
      inset: 6pt,
      align: (center + horizon, center + horizon, center + horizon, left + horizon),
      stroke: 0.4pt + ayodia-border,
      fill: (col, row) => if row == 0 { ayodia-primary } else { none },
      table.header(
        text(fill: white, weight: "bold", size: 10pt, "Size"),
        text(fill: white, weight: "bold", size: 10pt, "Hours"),
        text(fill: white, weight: "bold", size: 10pt, "Steps"),
        text(fill: white, weight: "bold", size: 10pt, "ลักษณะ"),
      ),
      text(weight: "bold", size: 10pt, "S"), text(size: 10pt, "0.17"), text(size: 10pt, "1-3"), text(size: 10pt, "smoke / 1 field"),
      text(weight: "bold", size: 10pt, "M"), text(size: 10pt, "0.42"), text(size: 10pt, "4-8"), text(size: 10pt, "form + ตรวจผล"),
      text(weight: "bold", size: 10pt, "L"), text(size: 10pt, "0.75"), text(size: 10pt, "9-15"), text(size: 10pt, "multi-step + data"),
      text(weight: "bold", size: 10pt, "XL"), text(size: 10pt, "1.25"), text(size: 10pt, "15+"), text(size: 10pt, "E2E ข้าม role"),
    )
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[
      *Midpoint* = ตัวเลขที่ test-plan-writer ใช้คำนวณ schedule
    ]
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🧮 Schedule Formula")
    #v(4pt)
    #block(fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 4pt,
      inset: 10pt, width: 100%, text(size: 11pt, font: "Menlo")[
        Total = Prep + Exec × 1.5 + Review + Report + Buffer 20%
      ])
    #v(6pt)
    #text(size: 11pt)[
      - *Prep:* `Total TC × 0.1 hr`
      - *Exec Cycle 1:* `Σ Sizing midpoint`
      - *Review:* `Total TC × 0.05 hr`
      - *Defect Fix + Retest:* `Exec × 30%`
      - *Regression:* `Exec × 20%`
      - *Report:* `4 hr fixed`
      - *Buffer:* `(sum) × 20%`
    ]
    #v(6pt)
    #info-box("👤 Velocity baseline", tier-3, text(size: 11pt)[
      6 productive hr/day · 10 days/sprint = *60 hr/tester/sprint*
    ])
  ],
)

#pagebreak()

// ================================================================
// Slide — AI Guardrails 5 ข้อ
// ================================================================

= AI Guardrails · 5 ข้อ (อิง SDP §5.3.3)

#text(size: 12pt, fill: ayodia-muted)[
  *หลักการ:* AI = Draft & Assist · Tester = Review & Approve
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, row-gutter: 10pt,
  numbered-row(1, "AI Hallucinate Requirement",
    [AI อาจสร้าง TC จาก requirement ที่ไม่มีในเอกสาร · *ป้องกัน:* Cross-check ทุก output กับ SRS/PRD ผ่าน Traceability Matrix]),
  numbered-row(2, "ไม่รู้ Business Context เฉพาะ",
    [AI ไม่รู้ business rule เฉพาะลูกค้า (tax, discount logic) · *ป้องกัน:* Tester/BA เพิ่ม TC เฉพาะทางหลัง AI draft]),
  numbered-row(3, "ไม่รู้ Environment จริง",
    [AI อาจระบุ Server/DB/URL ผิด · *ป้องกัน:* update environment ผ่าน `project-context.md`]),
  numbered-row(4, "อาจสรุปตัวเลขผิด",
    [Generate Report จาก raw data → อาจนับ/รวมผิด · *ป้องกัน:* ตรวจตัวเลขกับ source data ทุก row]),
)

#v(10pt)

#block(width: 100%, fill: tier-1.lighten(88%), stroke: (left: 4pt + tier-1),
  inset: 12pt, radius: 4pt,
  numbered-row(5, "ข้อมูล Sensitive ห้ามใส่ AI",
    [ชื่อจริง · เลขบัตร · ข้อมูลการเงิน อาจรั่วไป LLM provider · *ป้องกัน:* `[REDACTED]` / dummy data / env var]),
)

#pagebreak()

// ================================================================
// Slide — Guardrail examples (DOs/DONTs)
// ================================================================

= Guardrails · Do / Don't ที่เห็นบ่อย

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 14pt, row-gutter: 8pt,

  block(fill: tier-1.lighten(92%), stroke: (left: 3pt + tier-1),
    inset: 10pt, radius: 4pt, [
    #text(weight: "bold", size: 11pt, fill: tier-1, "❌ Expected Result กำกวม")
    #v(2pt)
    #text(size: 10pt, font: "Menlo", "\"ระบบทำงานถูกต้อง\"")
    #v(3pt)
    #text(weight: "bold", size: 11pt, fill: ayodia-accent, "✅ ใช้แบบนี้")
    #v(2pt)
    #text(size: 10pt, font: "Menlo", "แสดง toast 'บันทึกสำเร็จ' สีเขียว\nภายใน 2 วิ → redirect /dashboard\nDB tbl_leave.status='PENDING'")
  ]),

  block(fill: tier-1.lighten(92%), stroke: (left: 3pt + tier-1),
    inset: 10pt, radius: 4pt, [
    #text(weight: "bold", size: 11pt, fill: tier-1, "❌ commit Sensitive data")
    #v(2pt)
    #text(size: 10pt, font: "Menlo", "User: somsri@bank.co.th\nPwd: P@ssw0rd2026!\nAccount: 1234-5678-9012")
    #v(3pt)
    #text(weight: "bold", size: 11pt, fill: ayodia-accent, "✅ ใช้แบบนี้")
    #v(2pt)
    #text(size: 10pt, font: "Menlo", "User: [REDACTED]\nPwd: [REDACTED]\nAccount: 0000-0000-0000")
  ]),

  block(fill: tier-1.lighten(92%), stroke: (left: 3pt + tier-1),
    inset: 10pt, radius: 4pt, [
    #text(weight: "bold", size: 11pt, fill: tier-1, "❌ AI เดาตัวเลข")
    #v(2pt)
    #text(size: 10pt, font: "Menlo", "p95: 250ms · TPS: 150\n(no source)")
    #v(3pt)
    #text(weight: "bold", size: 11pt, fill: ayodia-accent, "✅ ใช้แบบนี้")
    #v(2pt)
    #text(size: 10pt, font: "Menlo", "p95: TBD (ขอจาก architect)\nTPS: TBD")
  ]),

  block(fill: tier-1.lighten(92%), stroke: (left: 3pt + tier-1),
    inset: 10pt, radius: 4pt, [
    #text(weight: "bold", size: 11pt, fill: tier-1, "❌ ส่ง AI output ตรงไป User")
    #v(2pt)
    #text(size: 10pt)[ส่งให้ stakeholder โดยไม่ผ่าน Tester review]
    #v(3pt)
    #text(weight: "bold", size: 11pt, fill: ayodia-accent, "✅ ใช้แบบนี้")
    #v(2pt)
    #text(size: 10pt)[AI draft → Tester review → fix gap → approve → ส่ง]
  ]),
)

#pagebreak()

// ================================================================
// Slide — Live Demo cue
// ================================================================

#align(center + horizon)[
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "LIVE DEMO · 5 นาที")
  #v(20pt)
  #text(size: 44pt, weight: "bold", fill: ayodia-primary, "ดูของจริง")
  #v(16pt)
  #align(center, block(
    fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 6pt,
    inset: 20pt, width: 75%,
    align(left)[
      #text(weight: "bold", size: 14pt, fill: ayodia-primary, "Tester Lead จะ demo ให้ดู:")
      #v(8pt)
      + เปิด Claude Code · พิมพ์ `/test-case-writer`
      + แนบ SRS file ตัวอย่าง · พิมพ์ prompt
      + ดู output ออกมาเป็น TC 23-column
      + ลองแก้ prompt ให้เน้น negative case
      + เปรียบเทียบ output กับที่เขียนเอง
    ],
  ))
  #v(14pt)
  #align(center, text(size: 11pt, fill: ayodia-muted)[
    📺 ดูที่หน้าจอใหญ่ — ยังไม่ต้องเปิด laptop · workshop เริ่มหลัง break
  ])
]

#pagebreak()

// ================================================================
// Slide — Break
// ================================================================

#align(center + horizon)[
  #text(size: 56pt, weight: "bold", fill: tier-2, "☕")
  #v(4pt)
  #text(size: 42pt, weight: "bold", fill: ayodia-primary, "Break · 10 นาที")
  #v(8pt)
  #text(size: 14pt, fill: ayodia-muted)[ยืดเส้นยืดสาย · เติมกาแฟ · เปิด laptop พร้อม Workshop]
  #v(18pt)
  #align(center, block(
    fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
    inset: 12pt, width: 65%,
    align(left)[
      #text(weight: "bold", size: 12pt, fill: ayodia-accent, "📋 Pre-flight Workshop")
      #v(4pt)
      #text(size: 11pt)[
        - เปิด terminal ไว้รอ
        - เช็ค Claude Code: #kbd("claude --version")
        - เช็ค Node.js: #kbd("node -v") (≥ 18)
        - เช็ค Python 3: #kbd("python3 --version")
        - Clone repo + GitLab access พร้อม
      ]
    ],
  ))
]

#pagebreak()

// ================================================================
// Slide — Workshop overview
// ================================================================

#align(center + horizon)[
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "PART 2 · WORKSHOP")
  #v(20pt)
  #text(size: 40pt, weight: "bold", fill: ayodia-primary, "ลงมือทำ · 60 นาที")
  #v(20pt)
  #grid(columns: (1fr, 1fr), column-gutter: 26pt,
    align(left)[
      #text(weight: "bold", size: 14pt, fill: ayodia-accent, "🎯 เป้าหมาย")
      #v(6pt)
      #text(size: 12pt)[
        - ทุกคนติดตั้ง plugin สำเร็จ
        - รัน skill ตัวแรกของตัวเองใน session นี้
        - เปิด PR แรก (แม้แค่ typo fix ก็ได้)
      ]
    ],
    align(left)[
      #text(weight: "bold", size: 14pt, fill: ayodia-accent, "👥 รูปแบบ")
      #v(6pt)
      #text(size: 12pt)[
        - จับคู่ 2 คน · helper-driver
        - Tester Lead เดินดูช่วยทุก lab
        - ติดตรงไหน ยกมือ — ไม่ต้อง Google
        - มี dummy SRS + bug ตัวอย่างให้ใช้
      ]
    ],
  )
]

#pagebreak()

// ================================================================
// Slide — Lab 0 Install
// ================================================================

= Lab 0 · Install Plugin (5 นาที)

#text(size: 11pt, fill: ayodia-muted)[
  ของจริงควรเตรียมมาก่อนวันงาน · ใน lab ทำอีกที + verify ให้ทุกคนพร้อมตรงกัน
]

#v(4pt)

#grid(columns: (auto, 1fr), column-gutter: 12pt, row-gutter: 8pt,
  align: (left + top, left + top),

  text(size: 20pt, weight: "bold", fill: ayodia-accent, "1"),
  [
    #text(weight: "bold", size: 12pt)[Install CLI + clone repo (ถ้ายัง)]
    #raw(block: true, lang: "bash",
"npm install -g @anthropic-ai/claude-code
cd ~/Documents/GitHub
git clone https://gitlab.ayodiacompany.com/ayodia-tester-teams/qa_ai_skill.git")
  ],

  text(size: 20pt, weight: "bold", fill: ayodia-accent, "2"),
  [
    #text(weight: "bold", size: 12pt)[เปิด Claude → add marketplace → install]
    #raw(block: true, lang: "bash",
"claude
> /plugin marketplace add ~/Documents/GitHub/qa_ai_skill
> /plugin install qa-ai-skill@ayodia-qa
> /reload-plugins")
    #text(size: 9pt, fill: ayodia-muted)[
      💡 path ใช้ `~/...` ได้ Claude expand เอง · หรือใส่ absolute path เต็ม
    ]
  ],

  text(size: 20pt, weight: "bold", fill: ayodia-accent, "3"),
  [
    #text(weight: "bold", size: 12pt)[Verify]
    #text(size: 11pt)[
      - #kbd("/plugins") → tab Installed ต้องเห็น `qa-ai-skill`
      - #kbd("/help") → เห็นรายการ skill (test-case-writer, bug-report-writer, ...)
      - ✋ ติดตรงไหน — ยกมือ Tester Lead เดินไปช่วย
    ]
  ],
)

#pagebreak()

// ================================================================
// Slide — Lab 1 first skill
// ================================================================

= Lab 1 · รัน Skill ตัวแรก (5 นาที)

#text(size: 12pt, fill: ayodia-muted)[
  *Skill:* `bug-report-writer` · *Goal:* เขียน bug ตัวแรกผ่าน skill
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📋 ขั้นตอน")
    #v(4pt)
    + เปิด Claude Code · #kbd("claude")
    + พิมพ์: #kbd("/bug-report-writer")
    + ใส่ bug ตัวอย่าง (ดูฝั่งขวา)
    + รอ AI generate
    + อ่าน output — *Severity, Priority, Action Label* ครบมั้ย?
    + ลอง #kbd("/bug-report-writer") อีกรอบ — ขอเป็น *EN* ดู
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🐛 Sample bug")
    #v(4pt)
    #block(fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 4pt,
      inset: 12pt, text(size: 11pt, font: "Menlo")[
        เจอปัญหาในหน้า checkout: \
        ใส่ coupon ซ้อน 2 ใบ ยอดรวมผิด \
        คาดว่าได้ส่วนลดแค่ใบเดียว \
        แต่ระบบลด 2 ใบ
        #v(4pt)
        Browser: Chrome 130 macOS \
        Env: staging \
        TC: SHOP-TC-018 \
        Severity: Major
      ])
  ],
)

#v(8pt)

#info-box("✅ Done criteria", ayodia-accent, text(size: 11pt)[
  Output มี: Title · Steps · Expected vs Actual · Env · Severity *Major* · Priority *High* · Action Label *Standard High* · Reproduce steps ครบ
])

#pagebreak()

// ================================================================
// Slide — Lab 2 write TC + tuning
// ================================================================

= Lab 2 · เขียน TC + Tuning (10 นาที)

#text(size: 12pt, fill: ayodia-muted)[
  *Skill:* `test-case-writer` · *Goal:* เขียน TC + ลอง tuning per-run
]

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📝 Round 1 · Default")
    #v(4pt)
    + ใช้ dummy SRS: `examples/srs-login-sample.md`
    + พิมพ์: #kbd("/test-case-writer")
    + Prompt: `เขียน SIT TC จาก srs-login-sample.md ภาษาไทย`
    + อ่าน output — กี่ TC? ครอบ ECP/BVA มั้ย?
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🎛️ Round 2 · Tune")
    #v(4pt)
    + ลองอันนี้ดู:
    #raw(block: true, lang: "text",
"/test-case-writer
@srs-login-sample.md
เน้น negative case + boundary
+ Decision Table สำหรับ
combo username/password
+ State Transition login flow")
    + เทียบ output round 1 vs round 2
  ],
)

#v(6pt)

#block(width: 100%, fill: tier-3.lighten(88%), stroke: (left: 4pt + tier-3),
  inset: 12pt, radius: 4pt, [
  #text(weight: "bold", size: 12pt, fill: tier-3, "💭 ถามตัวเอง")
  #v(2pt)
  #text(size: 11pt)[
    Round 2 ครอบเยอะกว่า round 1 มั้ย? · ถ้าครอบเกิน — เก็บแค่ที่ make sense · ถ้าขาด — สั่ง tune เพิ่ม
  ]
])

#pagebreak()

// ================================================================
// Slide — Lab 3 project-context.md
// ================================================================

= Lab 3 · project-context.md (5 นาที)

#text(size: 12pt, fill: ayodia-muted)[
  *Goal:* ใส่ context ของ project ใน 1 ไฟล์ → skill ใช้อัตโนมัติ ไม่ต้องบอกซ้ำ
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📋 ขั้นตอน · 3 ข้อ")
    #v(6pt)
    #text(size: 12pt)[
      + ใน working dir → สร้างไฟล์ `project-context.md` แล้ว copy template ฝั่งขวา
      + รัน #kbd("/test-case-writer") กับ SRS เดิม (จาก Lab 2)
      + ดู output → ควรมี *URL ของ SIT* + *คำย่อ AT* ปรากฏ (ไม่ต้องบอก skill ซ้ำ)
    ]
    #v(10pt)
    #info-box("💡 Tip", tier-3, text(size: 11pt)[
      เพิ่ม section อื่น (Business Rules / NFR / Severity) ได้ทีหลังเมื่อต้องใช้จริง · เริ่มเล็กๆ ก่อน
    ])
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📄 Template (เริ่มแค่ 2 section)")
    #v(6pt)
    #raw(block: true, lang: "markdown",
"# project-context.md

## Environment
- SIT URL: https://sit.demo.com

## Glossary
- AT = Assessment Tax")
  ],
)

#pagebreak()

// ================================================================
// Slide — Lab 4 tune skill + PR
// ================================================================

= Lab 4 · แก้ Skill + เปิด PR (10 นาที)

#text(size: 12pt, fill: ayodia-muted)[
  *Goal:* ลอง full flow · แก้ skill → validate → เปิด PR
]

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, row-gutter: 8pt, align: (top, top),

  step-card("1", "เลือกของแก้แบบเล็ก", text(size: 11pt)[
    เพิ่ม example ใน `skills/bug-report-writer/examples/` · หรือเพิ่มประโยคใน trigger description
  ]),

  step-card("2", "Branch + แก้ (GitHub Desktop)", [
    #set text(size: 11pt)
    + GitHub Desktop → *Current Branch* → *New Branch*
    + ชื่อ: `docs/bug-report-example`
    + ปุ่ม *Publish branch*
    + แก้ไฟล์ตามที่เลือก ใน editor
  ]),

  step-card("3", "Validate",
    raw(block: true, lang: "bash",
"python3 scripts/validate_skills.py
# exit 0 = pass")),

  step-card("4", "Test ใน Claude", text(size: 11pt)[
    + #kbd("/reload-plugins")
    + รัน skill อีกรอบ — ของใหม่ขึ้นมั้ย?
  ]),

  step-card("5", "Commit + Push (GitHub Desktop)", [
    #set text(size: 11pt)
    + tab *Changes* → เห็นไฟล์ที่แก้
    + Summary: `docs: ...` + Description
    + ปุ่ม *Commit to <branch>* → *Push origin*
  ]),

  step-card("6", "เปิด PR + ขอ review (GitLab web)", [
    #set text(size: 11pt)
    + browser → GitLab → *Merge Requests* → *New*
    + target = `master`
    + ใส่ PR description ตาม template
    + ขอ Tester Lead review
  ]),
)

#pagebreak()

// ================================================================
// Slide — Free Play
// ================================================================

= Free Play · ลองใช้เอง (15 นาที)

#text(size: 12pt, fill: ayodia-muted)[
  *Goal:* เลือก skill ที่อยากใช้จริง · ลองรันกับงานของตัวเอง · ติดตรงไหน Lead เดินดูช่วย
]

#v(10pt)

#grid(columns: (1fr, 1fr), column-gutter: 22pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "💡 ไอเดียลอง")
    #v(6pt)
    #text(size: 12pt)[
      - เอา BRD/SRS งานจริงมา → `/test-case-writer`
      - เอา bug ค้างใน Jira → `/bug-report-writer`
      - มี TC เดิม → `/test-case-reviewer` หา gap
      - ทดลอง `/requirement-analyzer` กับ spec ที่ยังไม่ชัด
      - สลับ language TH/EN ดู
    ]
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🛟 ระหว่างเล่น")
    #v(6pt)
    #text(size: 12pt)[
      - Lead เดินดูช่วยตามจุด
      - สงสัยไหม → ถามได้ทันที (ไม่ต้องรอ Q&A)
      - เจอ output แปลก → screenshot เก็บไว้แชร์ใน Wrap-up
      - ติดยาว → ขอ pair กับเพื่อนข้างๆ
    ]
  ],
)

#v(14pt)

#align(center, block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
  inset: 12pt, width: 85%,
  text(size: 11pt)[
    *ไม่มีถูกผิด* — เป้าหมายช่วงนี้คือให้คุ้นมือ · ของจริงเริ่มใช้ใน sprint หน้า
  ],
))

#pagebreak()

// ================================================================
// Slide 13 — Tuning · 3 ระดับ
// ================================================================

= ถ้าจะ Tuning · มี 3 ระดับ

#v(6pt)

#grid(columns: (1fr, 1fr, 1fr), column-gutter: 14pt, align: (top, top),

  block(fill: tier-4.lighten(88%), stroke: (left: 4pt + tier-4),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 13pt, fill: tier-4, "Level 1 · Per-Run")
    #v(6pt)
    #text(size: 11pt)[
      *ปรับเฉพาะครั้งนี้* — เขียน prompt เพิ่มตอนเรียก skill
    ]
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[ตัวอย่าง:]
    #v(2pt)
    #raw(block: true, lang: "text",
"/test-case-writer
@srs.md เน้น
negative case +
boundary value")
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[
      ✅ ใช้บ่อย · ไม่ต้องแก้ไฟล์ \
      ❌ ไม่ persist
    ]
  ]),

  block(fill: tier-3.lighten(88%), stroke: (left: 4pt + tier-3),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 13pt, fill: tier-3, "Level 2 · Per-Project")
    #v(6pt)
    #text(size: 11pt)[
      *ปรับเฉพาะ project* — สร้าง `project-context.md` ใน working dir
    ]
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[ตัวอย่าง:]
    #v(2pt)
    #raw(block: true, lang: "markdown",
"## Environment
SIT URL: ...
## NFR
p95 ≤ 3s
## Glossary
AT = Assess Tax")
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[
      ✅ ใช้ข้าม session · ใน project \
      ❌ ทีมอื่นไม่ได้
    ]
  ]),

  block(fill: ayodia-accent.lighten(88%), stroke: (left: 4pt + ayodia-accent),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "Level 3 · แก้ Skill")
    #v(6pt)
    #text(size: 11pt)[
      *แก้ SKILL.md / template* — ทุกคนในทีมได้
    ]
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[เคสที่ต้องแก้:]
    + พบ pattern ที่ AI พลาดซ้ำ
    + qa-standards เปลี่ยน
    + เพิ่ม technique ใหม่ (ECP/BVA)
    + เพิ่ม template ภาษา/format
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[
      ✅ shared ทั้งทีม \
      ⚠️ ต้องผ่าน PR review
    ]
  ]),
)

#pagebreak()

// ================================================================
// Slide 14 — Step-by-step การแก้ skill
// ================================================================

= ถ้าจะแก้ Skill · 6 Steps

#v(4pt)

#grid(columns: (1fr, 1fr), column-gutter: 16pt, row-gutter: 10pt,

  step-card("1", "สร้าง branch (GitHub Desktop)", [
    #set text(size: 11pt)
    + เปิด GitHub Desktop → repo `qa_ai_skill`
    + ปุ่ม *Current Branch* (ด้านบน) → *New Branch*
    + ตั้งชื่อ เช่น `fix/test-case-writer-bva` → *Create Branch*
    + ปุ่ม *Publish branch*
    #v(2pt)
    #text(size: 9pt, fill: ayodia-muted)[ชื่อ branch: `<type>/<skill>-<short>` · type = fix/feat/docs/refactor]
  ]),

  step-card("2", "หาไฟล์ที่ต้องแก้", [
    #set text(size: 11pt)
    - `SKILL.md` — instruction หลัก
    - `templates/` — output template
    - `examples/` — ตัวอย่าง input/output
    - `references/qa-standards.md` — ถ้าแก้ standard ทั้งทีม
  ]),

  step-card("3", "แก้ + ทดสอบใน Claude", [
    #set text(size: 11pt)
    + แก้ไฟล์
    + Claude session: `/reload-plugins`
    + ลองรัน skill กับ test input จริง
    + verify output ตรงตาม Quality Gate
  ]),

  step-card("4", "Run validate script",
    raw(block: true, lang: "bash", "python3 scripts/validate_skills.py"),
    hint: "เช็ค frontmatter / 8 sections / dead links / deprecated codes"),

  step-card("5", "Commit + Push (GitHub Desktop)", [
    #set text(size: 11pt)
    + tab *Changes* → ตรวจไฟล์ที่จะ commit
    + ใส่ Summary + Description ช่องล่างซ้าย
    + ปุ่ม *Commit to <branch>*
    + ปุ่ม *Push origin* (toolbar บน)
  ]),

  step-card("6", "เปิด PR (GitLab web)", [
    #set text(size: 11pt)
    + เปิด browser → GitLab repo
    + menu *Merge Requests* → *New*
    + fill template (ดู slide ถัดไป)
    + request review *Tester Lead* + 1 peer
  ]),
)

#pagebreak()

// ================================================================
// Slide 15 — ก่อนแก้ ต้องเตรียมอะไร
// ================================================================

= Pre-flight Checklist · ก่อนแก้

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 22pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📚 อ่านก่อน")
    #v(4pt)
    + #kbd("SKILL-TEMPLATE.md") — universal 8-section
    + #kbd("references/ai-guardrails.md") — 5 หลัก guardrail
    + #kbd("references/qa-standards.md") — Severity/Priority/Sizing
    + #kbd("references/sdp-mapping.md") — process → skill mapping
    + SKILL.md ของ skill ที่จะแก้
    #v(8pt)

    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🛠️ Tool ที่ต้องมี")
    #v(4pt)
    + Claude Code CLI (#kbd("npm i -g @anthropic-ai/claude-code"))
    + Python 3 (#kbd("validate_skills.py"))
    + GitHub Desktop + GitLab access (sign in ค่า remote ของ repo)
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🤔 ถามตัวเองก่อน")
    #v(4pt)
    #info-box("Q1 · ปัญหาเกิดซ้ำมั้ย?", tier-2, text(size: 11pt)[
      ถ้าครั้งเดียว → Level 1 (per-run prompt) พอ \
      ถ้าซ้ำ ≥ 3 ครั้ง → Level 3 (แก้ skill)
    ])
    #v(8pt)
    #info-box("Q2 · กระทบ skill อื่นมั้ย?", tier-2, text(size: 11pt)[
      ถ้าแก้ Severity scale → กระทบทุก skill ที่ใช้ \
      ต้องแก้ที่ qa-standards.md ไม่ใช่แก้ทีละ skill
    ])
    #v(8pt)
    #info-box("Q3 · กระทบ user ปัจจุบันมั้ย?", tier-2, text(size: 11pt)[
      breaking change → ต้อง flag ใน PR \
      backward-compat → ใส่ ติดท้าย safe
    ])
  ],
)

#pagebreak()

// ================================================================
// Slide 16 — Validate ก่อน commit
// ================================================================

= Validate ก่อน Commit

#text(size: 12pt, fill: ayodia-muted)[
  ทุก PR ผ่าน CI · แต่รัน local ก่อนช่วยให้ feedback loop เร็วขึ้น
]

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🤖 Auto check")
    #v(6pt)
    #raw(block: true, lang: "bash", "python3 scripts/validate_skills.py")
    #v(8pt)
    #text(size: 11pt)[
      Script เช็ค 5 อย่าง:
    ]
    + Frontmatter ครบ + name = folder name + unique
    + 8 sections มาครบ + ลำดับถูกต้อง
    + Link ไป `references/ai-guardrails.md`
    + ไม่ใช้ deprecated code (P0-P3, Sev1-4)
    + Markdown link ไม่ dead
    #v(6pt)
    #text(size: 10pt, fill: ayodia-muted)[exit 0 = pass · exit 1 = fail (CI fail)]
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🧪 Manual test")
    #v(6pt)
    + เปิด Claude Code: #kbd("claude")
    + #kbd("/reload-plugins") → โหลด skill version ใหม่
    + รัน skill กับ test input *จริง* (ใช้ examples/)
    + Verify output ตาม Quality Gate ใน SKILL.md
    + ลอง edge case ที่เป็นเหตุให้แก้ตั้งแต่แรก
    #v(8pt)
    #info-box("⚠️ ห้ามลืม", tier-1, text(size: 11pt)[
      ถ้าแก้ template → ต้อง regenerate ตัวอย่างใน `examples/` ด้วย เพื่อให้ user คนต่อไปเห็น output แบบใหม่
    ])
  ],
)

#pagebreak()

// ================================================================
// Slide 17 — เปิด PR ยังไง
// ================================================================

= วิธีเปิด PR · ผ่าน GitHub Desktop + GitLab web

#text(size: 11pt, fill: ayodia-muted)[
  *Note:* repo อยู่บน GitLab → "PR" ในที่นี้ = GitLab Merge Request · GitHub Desktop ใช้ commit/push เสร็จแล้วเปิด PR ใน GitLab web เอง
]

#v(4pt)

#grid(columns: (auto, 1fr), column-gutter: 14pt, row-gutter: 10pt, align: (left + top, left + top),

  text(size: 22pt, weight: "bold", fill: ayodia-accent, "1"),
  [
    #text(weight: "bold", size: 13pt)[Commit + Push ใน GitHub Desktop]
    #v(2pt)
    #text(size: 11pt)[
      - tab *Changes* → เห็นไฟล์ที่แก้
      - ใส่ commit message ช่องล่าง (Summary + Description)
      - กดปุ่ม *Commit to <branch>*
      - กดปุ่ม *Push origin* (toolbar ด้านบน)
    ]
  ],

  text(size: 22pt, weight: "bold", fill: ayodia-accent, "2"),
  [
    #text(weight: "bold", size: 13pt)[เปิด GitLab web → New Merge Request]
    #v(2pt)
    #text(size: 11pt)[
      - เปิด browser ไป `gitlab.ayodiacompany.com/.../qa_ai_skill`
      - menu *Merge Requests* → *New merge request*
      - Source = branch ของเรา · Target = `master`
    ]
  ],

  text(size: 22pt, weight: "bold", fill: ayodia-accent, "3"),
  [
    #text(weight: "bold", size: 13pt)[เขียน Title + Description]
    #v(2pt)
    #text(size: 11pt)[
      Title format: `<type>: <skill> — <change ย่อ>` \
      เช่น: `fix: test-case-writer — add BVA reminder for date fields`
    ]
  ],

  text(size: 22pt, weight: "bold", fill: ayodia-accent, "4"),
  [
    #text(weight: "bold", size: 13pt)[Assign reviewer + รอ CI]
    #v(2pt)
    #text(size: 11pt)[
      *Required:* Tester Lead + 1 peer · CI pipeline ต้องเขียว ก่อน merge
    ]
  ],
)

#pagebreak()

// ================================================================
// Slide 18 — PR Description Template
// ================================================================

= PR Description Template

#text(size: 11pt, fill: ayodia-muted)[
  Copy template นี้ใส่ใน PR description (GitLab → Merge Request description box) — กรอกตามหัวข้อ
]

#v(6pt)

#block(fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 4pt,
  inset: 12pt, width: 100%,
  text(font: "Menlo", size: 10pt)[
    \#\# What \
    แก้อะไร — 1-2 บรรทัด
    #v(2pt)
    \#\# Why \
    ทำไมต้องแก้ — link Jira ticket / ตัวอย่าง output ที่พลาด / pattern ที่ซ้ำ
    #v(2pt)
    \#\# How \
    \- เปลี่ยนใน SKILL.md section X \
    \- เพิ่ม template Y \
    \- update qa-standards.md (ถ้ากระทบ standard)
    #v(2pt)
    \#\# Test \
    \- \[ \] รัน `python3 scripts/validate_skills.py` ผ่าน \
    \- \[ \] ทดสอบ skill กับ input จริง: \<ตัวอย่าง / paste output\> \
    \- \[ \] ตรวจ Quality Gate ใน SKILL.md ครบ \
    \- \[ \] ตรวจกระทบ skill อื่นที่เกี่ยวข้อง
    #v(2pt)
    \#\# Breaking change? \
    \- \[ \] No \
    \- \[ \] Yes → notify ทีม + อัปเดต CHANGELOG
    #v(2pt)
    \#\# Sample output \
    \<paste output ตัวอย่างหลังแก้\>
  ])

#pagebreak()

// ================================================================
// Slide 19 — DOs and DONTs
// ================================================================

= DOs · DON'Ts ตอน Tuning

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt,
  block(fill: ayodia-accent.lighten(90%), stroke: (left: 4pt + ayodia-accent),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 14pt, fill: ayodia-accent, "✅ DOs")
    #v(6pt)
    #text(size: 11pt)[
      - แก้ที่ root cause · ถ้า standard ผิด → แก้ `qa-standards.md` ไม่แก้ทีละ skill
      - เพิ่ม example ทุกครั้งที่เพิ่ม technique ใหม่
      - test กับ input จริง 2-3 cases ก่อนเปิด PR
      - เขียน description ละเอียด (Why > What)
      - ขอ peer review ตั้งแต่ draft PR
      - update `examples/` พร้อม template
      - run `validate_skills.py` ก่อน push
    ]
  ]),
  block(fill: tier-1.lighten(90%), stroke: (left: 4pt + tier-1),
    inset: 14pt, radius: 4pt, [
    #text(weight: "bold", size: 14pt, fill: tier-1, "❌ DON'Ts")
    #v(6pt)
    #text(size: 11pt)[
      - ห้าม hardcode company-specific (URL/IP/DB) ใน SKILL.md
      - ห้าม commit credential / token / PII (ใช้ `[REDACTED]`)
      - ห้าม push ตรงเข้า `master` — ทุกอย่างผ่าน PR
      - ห้ามแก้ Severity/Priority scale โดยไม่ update qa-standards
      - ห้าม merge เอง — ต้องรอ Tester Lead approve
      - ห้าม skip CI · ห้าม `--no-verify`
      - ห้าม merge ระหว่าง CI ยัง red
    ]
  ]),
)

#pagebreak()

// ================================================================
// Slide 20 — Versioning + ติดตามการแก้
// ================================================================

= Versioning · ติดตามการแก้ยังไง

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 20pt, align: (top, top),
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "📜 ดู history ของ skill")
    #v(4pt)
    #raw(block: true, lang: "bash",
"# log ของ skill ใดๆ
git log --oneline skills/test-case-writer/

# ดู diff รอบล่าสุด
git log -p -1 skills/test-case-writer/SKILL.md

# ใครแก้บรรทัดไหน
git blame skills/test-case-writer/SKILL.md")
    #v(8pt)
    #text(size: 11pt, fill: ayodia-muted)[
      ทุกการแก้ผ่าน PR → อยู่ใน git history → reverse engineer ได้ตลอด
    ]
  ],
  [
    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "🔔 รู้ได้ไงว่ามีของใหม่")
    #v(4pt)
    + Watch repo ใน GitLab — get notify ทุก PR (Merge Request)
    + อ่าน CHANGELOG.md (เพิ่มเข้า repo เร็วๆ นี้)
    + Weekly Update email — Tester Lead สรุป skill ที่อัปเดต
    + #kbd("git pull") + #kbd("/plugin marketplace update ayodia-qa") ทุกต้นสัปดาห์
    #v(8pt)
    #info-box("💡 Tip", tier-3, text(size: 11pt)[
      ถ้าแก้ skill แล้ว breaking — โพสต์ Slack Tester channel + tag ทุกคนที่ใช้ skill นั้นบ่อย
    ])
  ],
)

#pagebreak()

// ================================================================
// Slide 21 — เริ่มยังไง / Call to action
// ================================================================

= สิ่งที่อยากให้ทำต่อ

#v(8pt)

#grid(columns: (1fr, 1fr), column-gutter: 22pt, align: (top, top),
  [
    #text(weight: "bold", size: 14pt, fill: ayodia-accent, "🟢 อาทิตย์นี้")
    #v(6pt)
    + ติดตั้ง plugin ตาม README (5 นาที)
    + ลองรัน 1 skill ที่ใช้บ่อยสุด — `bug-report-writer` หรือ `test-case-writer`
    + อ่าน `docs/qa-onboarding.md` (15 นาที)
    + บันทึก feedback: ของง่าย / ยาก / ขาดอะไร
  ],
  [
    #text(weight: "bold", size: 14pt, fill: ayodia-accent, "🟡 อาทิตย์ถัดไป")
    #v(6pt)
    + ใช้ skill ใน sprint จริง — เก็บตัวเลข effort saving
    + เจอจุดที่ output ไม่ตรง standard → แจ้งใน Slack
    + ถ้าอยากเพิ่ม feature เล็กๆ → ลองเปิด PR แรก (`docs:` หรือ `fix:`)
    + Pair กับ Tester Lead ทำ PR ตัวแรกของตัวเอง
  ],
)

#v(14pt)

#align(center, block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
  inset: 14pt, width: 85%,
  text(size: 12pt)[
    *เป้าหมาย sprint หน้า:* ทุกคนเปิด PR แรกของตัวเอง · จุดเริ่มที่ดี = แก้ typo / เพิ่ม example / ปรับ wording
  ],
))

#pagebreak()

// ================================================================
// Slide 22 — Reference + Q&A
// ================================================================

#align(horizon)[
  #align(center)[
    #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "ขอบคุณที่อยู่ฟังจนจบ")
    #v(20pt)
    #text(size: 44pt, weight: "bold", fill: ayodia-primary)[Q & A]
    #v(28pt)
  ]

  #align(center, block(
    fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 6pt,
    inset: 22pt, width: 80%,
    align(left)[
      #text(weight: "bold", size: 14pt, fill: ayodia-primary, "📚 อ่านต่อ")
      #v(8pt)
      + #kbd("README.md") — ภาพรวม + install
      + #kbd("docs/qa-onboarding.md") — Quick Start 5 นาที + Decision Tree
      + #kbd("docs/how-to-sit-uat.md") — 10 steps พิมพ์อะไรให้ AI ทุกขั้น
      + #kbd("SKILL-TEMPLATE.md") — universal 8-section
      + #kbd("references/qa-standards.md") — Severity/Priority/Sizing/KPI
      + #kbd("references/ai-guardrails.md") — 5 หลักการ
    ],
  ))

  #v(18pt)
  #align(center, text(size: 12pt, fill: ayodia-muted)[
    ติดปัญหา / มีไอเดียเพิ่ม skill — ทักใน Slack \#qa-ai-skill หรือ Tester Lead Team
  ])
]
