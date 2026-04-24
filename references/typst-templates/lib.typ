// Ayodia QA — Shared Typst Library
// Branding, colors, components for all QA deliverables (Plan / Report / Test Case)

#let ayodia-primary = rgb("#1e3a5f")     // deep navy
#let ayodia-accent  = rgb("#2d8f6f")     // teal/green
#let ayodia-muted   = rgb("#64748b")     // slate
#let ayodia-bg      = rgb("#f8fafc")     // light gray bg
#let ayodia-border  = rgb("#cbd5e1")     // subtle border

// Ayodia Test Definition palette (4-tier, consistent across Severity + Priority)
#let tier-1 = rgb("#dc2626")  // 🔴 Critical
#let tier-2 = rgb("#ea580c")  // 🟠 Major / High
#let tier-3 = rgb("#ca8a04")  // 🟡 Minor / Medium
#let tier-4 = rgb("#2563eb")  // 🔵 Trivial / Low

// Severity aliases
#let sev-critical = tier-1
#let sev-major    = tier-2
#let sev-minor    = tier-3
#let sev-trivial  = tier-4

// Priority aliases
#let pri-critical = tier-1
#let pri-high     = tier-2
#let pri-medium   = tier-3
#let pri-low      = tier-4

#let status-pass  = rgb("#16a34a")
#let status-fail  = rgb("#dc2626")
#let status-block = rgb("#ea580c")
#let status-skip  = rgb("#64748b")
#let status-notrun = rgb("#94a3b8")

// ── Badge component ───────────────────────────────────────────
#let badge(text-body, fill: ayodia-muted) = box(
  fill: fill,
  inset: (x: 7pt, y: 3pt),
  radius: 3pt,
  baseline: 1pt,
  text(fill: white, weight: "bold", size: 8pt, text-body)
)

// Severity — Critical / Major / Minor / Trivial (S1-S4 also accepted)
#let sev-badge(s) = {
  let s-upper = upper(s)
  let color = if s-upper.contains("CRITICAL") or s-upper == "S1" { sev-critical }
    else if s-upper.contains("MAJOR") or s-upper == "S2" { sev-major }
    else if s-upper.contains("MINOR") or s-upper == "S3" { sev-minor }
    else if s-upper.contains("TRIVIAL") or s-upper.contains("COSMETIC") or s-upper == "S4" { sev-trivial }
    else { ayodia-muted }
  badge(s, fill: color)
}

// Priority — Critical / High / Medium / Low (P0-P3 also accepted)
#let pri-badge(p) = {
  let p-upper = upper(p)
  let color = if p-upper.contains("CRITICAL") or p-upper == "P0" { pri-critical }
    else if p-upper.contains("HIGH") or p-upper == "P1" { pri-high }
    else if p-upper.contains("MEDIUM") or p-upper.contains("MED") or p-upper == "P2" { pri-medium }
    else if p-upper.contains("LOW") or p-upper == "P3" { pri-low }
    else { ayodia-muted }
  badge(p, fill: color)
}

// ── Colored dot (for inline legend matching the Ayodia reference sheet) ───
#let tier-dot(color) = box(
  baseline: -1pt,
  circle(radius: 4pt, fill: color, stroke: none)
)

#let status-badge(s) = {
  let s-lower = lower(s)
  let color = if s-lower == "pass" or s-lower == "passed" { status-pass }
    else if s-lower == "fail" or s-lower == "failed" { status-fail }
    else if s-lower.contains("block") { status-block }
    else if s-lower == "skipped" or s-lower == "skip" { status-skip }
    else { status-notrun }
  badge(s, fill: color)
}

// ── Helper: row of badges with consistent gap ─────────────────
#let badge-row(..items) = items.pos().map(b => [#b#h(6pt)]).join()

// ── Info row (label: value) ───────────────────────────────────
#let info-row(label, value) = grid(
  columns: (32%, 68%),
  gutter: 6pt,
  text(weight: "bold", fill: ayodia-muted, label),
  value
)

// ── Styled table (header row colored, generous padding) ───────
#let qa-table(columns: auto, header: (), ..rows) = table(
  columns: columns,
  stroke: 0.5pt + ayodia-border,
  inset: (x: 8pt, y: 7pt),
  fill: (_, y) => if y == 0 { ayodia-primary } else if calc.odd(y) { ayodia-bg },
  table.header(..header.map(h => text(fill: white, weight: "bold", size: 9.5pt, h))),
  ..rows,
)

// ── Cover page ────────────────────────────────────────────────
#let cover-page(
  title: "",
  subtitle: "",
  doc-id: "",
  version: "",
  date: "",
  author: "",
  reviewer: "",
  approver: "",
  doc-type: "",
) = {
  set page(margin: (top: 3cm, bottom: 3cm, x: 2.5cm))
  place(top + right, dx: 0cm, dy: 0cm)[
    #image("assets/ayodia-logo.png", width: 3cm)
  ]
  v(5cm)
  align(center)[
    #text(size: 14pt, fill: ayodia-accent, weight: "bold", tracking: 2pt, upper(doc-type))
    #v(14pt)
    #text(size: 28pt, weight: "bold", fill: ayodia-primary, title)
    #if subtitle != "" [
      #v(12pt)
      #text(size: 15pt, fill: ayodia-muted, subtitle)
    ]
  ]
  v(3.5cm)
  align(center)[
    #block(
      fill: ayodia-bg,
      stroke: 0.5pt + ayodia-border,
      inset: 24pt,
      radius: 6pt,
      width: 78%,
      align(left)[
        #info-row("Document ID", raw(doc-id))
        #v(10pt)
        #info-row("Version", version)
        #v(10pt)
        #info-row("Date", date)
        #v(10pt)
        #info-row("Author", author)
        #v(10pt)
        #info-row("Reviewer", reviewer)
        #v(10pt)
        #info-row("Approver", approver)
      ]
    )
  ]
  v(1fr)
  align(center)[
    #text(size: 9pt, fill: ayodia-muted, tracking: 0.5pt)[
      AYODIA COMPANY LIMITED · QUALITY ASSURANCE DELIVERABLE
    ]
  ]
  pagebreak()
}

// ── Test Definition Matrix (Ayodia standard) ──────────────────
// Renders the full Priority + Severity + Severity×Priority matrix
// Usage as appendix: #test-definition-matrix()
#let test-definition-matrix() = {
  [== Priority — ความสำคัญของการทดสอบ]
  [_ใช้กับ Test Case — ระดับความเร่งด่วนของการทดสอบ Test Case หรือ การแก้ไขระบบเมื่อ Test Case นั้นล้มเหลว (Fail)_]

  qa-table(
    columns: (auto, 1fr, 1.2fr),
    header: ([Priority], [Definition], [Example]),
    [#tier-dot(pri-critical) *Critical*], [ต้องแก้ทันที เพราะ Blocked งานอื่น], [ปุ่ม "Submit" พัง ทำให้ทดสอบต่อไม่ได้],
    [#tier-dot(pri-high) *High*], [สำคัญต่อ Core Function ต้องทำในรอบนี้], [Register ใช้งานไม่ได้],
    [#tier-dot(pri-medium) *Medium*], [สำคัญรองลงมา แต่ควรทำให้ทันรอบถัดไป], [การค้นหาข้อมูลช้ากว่าปกติ],
    [#tier-dot(pri-low) *Low*], [ไม่เร่งด่วน ทำทีหลังก็ได้], [UI ไม่ตรงกับ Figma, สีผิดโทน, Wording ไม่ถูกต้อง],
  )

  v(8pt)

  [== Severity — ความรุนแรงของปัญหา / ข้อผิดพลาด]
  [_ใช้กับ Test Case — ความรุนแรงของผลกระทบ หาก Test Case นั้นล้มเหลว (Fail)_]

  qa-table(
    columns: (auto, 1fr, 1.2fr),
    header: ([Severity], [Definition], [Example]),
    [#tier-dot(sev-critical) *Critical*], [ระบบหลักพัง ใช้งานไม่ได้], [ระบบล่ม, ชำระเงินไม่ผ่าน],
    [#tier-dot(sev-major) *Major*], [ฟังก์ชันหลักใช้ไม่ได้ แต่ระบบยังรันได้], [Login พัง, ข้อมูลไม่บันทึก],
    [#tier-dot(sev-minor) *Minor*], [ปัญหาเล็กน้อย ไม่มีผลต่อการใช้งานหลัก], [UI ไม่ตรงกับ Figma, Validation แจ้งเตือนผิด],
    [#tier-dot(sev-trivial) *Trivial*], [จุกจิก ไม่กระทบการใช้งานเลย], [Wording ไม่ถูกต้อง, Alignment เพี้ยน],
  )

  v(8pt)

  [== Severity × Priority — การจัดลำดับการแก้]

  let hdr = h => text(fill: white, weight: "bold", size: 9pt, h)
  let row-label(color, label) = [#tier-dot(color) *#label*]
  let cell(title, desc) = [*#title:* #desc]

  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    stroke: 0.5pt + ayodia-border,
    inset: (x: 6pt, y: 7pt),
    fill: (x, y) => if y == 0 or x == 0 { ayodia-primary },
    [], hdr[Critical], hdr[High], hdr[Medium], hdr[Low],

    text(fill: white, weight: "bold", row-label(tier-1, "Critical")),
    cell("Blocker", "ต้องดำเนินการโดยทันที เพื่อไม่ให้กระทบต่อระบบโดยรวม"),
    cell("Urgent", "แก้ไขเร่งด่วนภายในรอบการพัฒนาต่อไปเนื่องจากเป็นข้อผิดพลาดรุนแรง"),
    cell("Important", "สำคัญแต่ไม่ใช่ข้อผิดพลาดที่ทำให้ระบบหยุดทำงาน"),
    cell("Deferred Critical", "ปัญหาสำคัญแต่ยังไม่เร่งด่วน"),

    text(fill: white, weight: "bold", row-label(tier-2, "Major")),
    cell("High Business Risk", "ควรเร่งดำเนินการเพราะกระทบต่อฟังก์ชันหลัก"),
    cell("Standard High", "ฟังก์ชันผิดพลาด ควรแก้ไขในรอบพัฒนานี้"),
    cell("Manageable", "แก้ไขเมื่อมีเวลา เพราะยังมีวิธีอื่นในการใช้งานอ้อม"),
    cell("Can Delay", "อนุโลมให้เลื่อนได้"),

    text(fill: white, weight: "bold", row-label(tier-3, "Minor")),
    cell("Prioritize If Impacted", "เร่งแก้เฉพาะเมื่อพีเจอร์นั้นเป็นจุดสำคัญ"),
    cell("Optional but Noted", "ควรแก้ถ้ามีเวลา"),
    cell("Acceptable Delay", "ไม่กระทบหลัก สามารถดำเนินการภายหลัง"),
    cell("Low Impact Cosmetic", "ความคลาดเคลื่อนที่ไม่กระทบการใช้งาน"),

    text(fill: white, weight: "bold", row-label(tier-4, "Trivial")),
    cell("Non-critical but Visible", "ควรแก้ในกรณีที่อยู่ในหน้าหลักที่ส่งผลต่อภาพลักษณ์"),
    cell("Minor Fix Suggested", "แนะนำให้แก้เพื่อความสมบูรณ์"),
    cell("Can Be Scheduled Later", "ไม่รีบ ทำในรอบถัดไป"),
    cell("Optional", "ไม่จำเป็นต้องแก้ในการพัฒนา"),
  )
}

// ── Sign-off table (keep together on one page) ────────────────
#let signoff-table(roles) = block(breakable: false, table(
  columns: (25%, 25%, 30%, 20%),
  stroke: 0.5pt + ayodia-border,
  inset: (x: 8pt, y: 12pt),
  fill: (_, y) => if y == 0 { ayodia-primary },
  ..([Role], [Name], [Signature], [Date]).map(h =>
    text(fill: white, weight: "bold", size: 9.5pt, h)
  ),
  ..roles.map(r => (text(weight: "bold", r), "", "", "")).flatten(),
))

// ── Main document wrapper ─────────────────────────────────────
#let qa-doc(
  title: "",
  subtitle: "",
  doc-id: "",
  version: "1.0",
  date: "",
  author: "",
  reviewer: "",
  approver: "",
  doc-type: "",
  body
) = {
  // Global styles — tuned for Thai text (Sarabun needs more leading for tone marks)
  set text(
    font: ("Sarabun", "Helvetica Neue", "Helvetica"),
    size: 10pt,
    lang: "th",
  )
  set par(
    justify: true,
    leading: 0.85em,
    spacing: 1.1em,
    first-line-indent: 0pt,
  )
  set block(spacing: 1.3em)
  set list(
    marker: ([•], [◦], [‣]),
    indent: 8pt,
    body-indent: 6pt,
    spacing: 0.9em,
  )
  set enum(
    indent: 8pt,
    body-indent: 6pt,
    spacing: 0.9em,
  )
  show link: set text(fill: ayodia-accent)
  show raw: set text(size: 9pt)

  // Cover page
  cover-page(
    title: title,
    subtitle: subtitle,
    doc-id: doc-id,
    version: version,
    date: date,
    author: author,
    reviewer: reviewer,
    approver: approver,
    doc-type: doc-type,
  )

  // Body pages — header/footer via proper page margin
  set page(
    margin: (top: 3cm, bottom: 3cm, x: 2.2cm),
    header: context {
      if counter(page).get().first() > 1 {
        set text(size: 8pt, fill: ayodia-muted)
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          title,
          image("assets/ayodia-logo.png", height: 0.8cm),
        )
        line(length: 100%, stroke: 0.5pt + ayodia-border)
      }
    },
    header-ascent: 20%,
    footer: context {
      if counter(page).get().first() > 1 {
        set text(size: 8pt, fill: ayodia-muted)
        line(length: 100%, stroke: 0.5pt + ayodia-border)
        v(4pt)
        grid(
          columns: (1fr, auto, 1fr),
          align: (left, center, right),
          raw(doc-id),
          [Page #counter(page).display() of #context counter(page).final().first()],
          [Ayodia · Confidential],
        )
      }
    },
    footer-descent: 20%,
  )

  // Heading styles — sticky so they never orphan above next content
  show heading: set block(sticky: true)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(6pt)
    block(
      stroke: (left: 3pt + ayodia-accent),
      inset: (left: 12pt, y: 6pt),
      text(size: 18pt, weight: "bold", fill: ayodia-primary, it.body)
    )
    v(10pt)
  }
  show heading.where(level: 2): it => block(sticky: true, {
    v(14pt)
    text(size: 13pt, weight: "bold", fill: ayodia-primary, it.body)
    v(6pt)
  })
  show heading.where(level: 3): it => block(sticky: true, {
    v(10pt)
    text(size: 11pt, weight: "bold", fill: ayodia-accent, it.body)
    v(4pt)
  })

  // TOC page
  {
    set page(header: none, footer: none)
    v(1cm)
    text(size: 20pt, weight: "bold", fill: ayodia-primary)[สารบัญ]
    v(2pt)
    text(size: 12pt, fill: ayodia-muted)[Table of Contents]
    v(20pt)
    outline(
      title: none,
      indent: auto,
      depth: 2,
    )
    pagebreak()
  }

  // Tighter leading for table content (tables look airy otherwise)
  show table: set par(leading: 0.7em, spacing: 0.8em)

  body
}
