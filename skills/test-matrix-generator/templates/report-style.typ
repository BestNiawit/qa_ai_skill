// ================================================================
// report-style.typ — Ayodia QA Test Matrix Report (Typst theme)
// ================================================================
// ใช้คู่กับ report.typ — import แล้วเรียก `report(...)` พร้อม data
// Font: Sarabun (Thai), color theme: Ayodia logo (orange/red/yellow)
// ================================================================

// ---------- color tokens ----------
#let c-orange = rgb("#F39C12")
#let c-red    = rgb("#D93F3F")
#let c-yellow = rgb("#F5C518")
#let c-ink    = rgb("#1F2933")
#let c-mute   = rgb("#6B7280")
#let c-line   = rgb("#E5E7EB")
#let c-bg-soft = rgb("#FFF8EC")

#let c-pass    = rgb("#16A34A")
#let c-fail    = rgb("#DC2626")
#let c-block   = rgb("#9333EA")
#let c-pending = rgb("#6B7280")
#let c-na      = rgb("#9CA3AF")

// ---------- status badge ----------
#let status-cell(s) = {
  let s-up = upper(s)
  let (col, label) = if s-up == "PASS" or s-up == "P" {
    (c-pass, "PASS")
  } else if s-up == "FAIL" or s-up == "F" {
    (c-fail, "FAIL")
  } else if s-up == "BLOCK" or s-up == "BLOCKED" or s-up == "B" {
    (c-block, "BLOCK")
  } else if s-up == "PENDING" or s-up == "NOT RUN" or s-up == "NR" {
    (c-pending, "PENDING")
  } else if s-up == "N/A" or s-up == "NA" or s-up == "-" {
    (c-na, "N/A")
  } else if s-up == "✓" or s-up == "Y" or s-up == "YES" {
    (c-pass, "✓")
  } else if s-up == "✗" or s-up == "X" or s-up == "NO" {
    (c-fail, "✗")
  } else {
    (c-mute, s)
  }
  box(
    fill: col,
    inset: (x: 6pt, y: 2pt),
    radius: 3pt,
    text(fill: white, weight: "bold", size: 8pt, label),
  )
}

// ---------- KPI tile ----------
#let kpi-tile(label, value, color: c-orange) = {
  box(
    width: 100%,
    fill: c-bg-soft,
    stroke: (left: 3pt + color),
    inset: 10pt,
    radius: 3pt,
    [
      #text(size: 9pt, fill: c-mute)[#label] \
      #text(size: 18pt, weight: "bold", fill: c-ink)[#value]
    ],
  )
}

// ---------- section heading ----------
// ใช้ metadata + bookmark trick: heading ที่ถูก hide ไว้สำหรับ outline
// แล้ววาด title เองด้วย style ของเรา → TOC ทำงาน + สวยตาม design
#let h-section(title, subtitle: none) = {
  block(above: 18pt, below: 10pt)[
    #heading(level: 1, outlined: true, bookmarked: true, numbering: none,
      text(size: 14pt, weight: "bold", fill: c-ink, title))
    #if subtitle != none {
      v(-6pt)
      text(size: 9pt, fill: c-mute, subtitle)
    }
    #v(2pt)
    #line(length: 100%, stroke: 1.2pt + c-orange)
  ]
}

// ---------- coverage matrix table ----------
// rows: list of (req-id, req-desc, scenarios: list of (scn-id, status))
// scenario-cols: list of scenario column ids (header)
#let coverage-matrix(rows, scenario-cols) = {
  let header = ([*Req ID*], [*Requirement*],) + scenario-cols.map(c => [*#c*])
  let body = ()
  for r in rows {
    let row = ([#r.id], [#r.desc])
    for sc in scenario-cols {
      let cell = r.scenarios.at(sc, default: "-")
      row = row + (status-cell(cell),)
    }
    body = body + row
  }
  table(
    columns: (auto, 1fr,) + scenario-cols.map(_ => auto),
    align: (left, left,) + scenario-cols.map(_ => center + horizon),
    fill: (col, row) => if row == 0 { c-orange.lighten(80%) } else if calc.odd(row) { white } else { c-bg-soft },
    stroke: 0.4pt + c-line,
    inset: 6pt,
    ..header,
    ..body,
  )
}

// ---------- combination (pairwise) table ----------
// cols: list of column-name strings (input parameters + last col = expected)
// rows: list of list-of-cell-values (string)
#let combination-matrix(cols, rows) = {
  let header = cols.map(c => [*#c*])
  let body = ()
  for r in rows {
    body = body + r.map(v => [#v])
  }
  table(
    columns: cols.map(_ => auto),
    align: center + horizon,
    fill: (col, row) => if row == 0 { c-orange.lighten(80%) } else if calc.odd(row) { white } else { c-bg-soft },
    stroke: 0.4pt + c-line,
    inset: 6pt,
    ..header,
    ..body,
  )
}

// ---------- platform matrix table ----------
// platforms: list of column ids
// rows: list of (feature, results: dict platform-id -> status)
#let platform-matrix(rows, platforms) = {
  let header = ([*Feature*],) + platforms.map(p => [*#p*])
  let body = ()
  for r in rows {
    let row = ([#r.feature],)
    for p in platforms {
      let cell = r.results.at(p, default: "-")
      row = row + (status-cell(cell),)
    }
    body = body + row
  }
  table(
    columns: (1fr,) + platforms.map(_ => auto),
    align: (left,) + platforms.map(_ => center + horizon),
    fill: (col, row) => if row == 0 { c-orange.lighten(80%) } else if calc.odd(row) { white } else { c-bg-soft },
    stroke: 0.4pt + c-line,
    inset: 6pt,
    ..header,
    ..body,
  )
}

// ---------- main report function ----------
#let report(
  // metadata
  project: "<Project Name>",
  document-title: "Test Matrix Report",
  version: "1.0",
  date: datetime.today().display("[day]/[month]/[year]"),
  author: "Ayodia QA Team",
  customer: "<Customer Name>",
  logo: "../assets/ayodia-logo.png",
  // executive summary
  summary: (
    total-requirements: 0,
    total-scenarios: 0,
    coverage-percent: 0,
    pass: 0,
    fail: 0,
    pending: 0,
  ),
  scope-in: (),
  scope-out: (),
  test-types: (),
  // matrices
  coverage: none,         // (rows, scenario-cols)
  combination: none,      // (cols, rows)
  platform: none,         // (rows, platforms)
  notes: none,
  body,
) = {
  // ----- page setup -----
  set page(
    paper: "a4",
    margin: (x: 2cm, y: 2.4cm),
    header: context {
      if counter(page).get().first() > 1 {
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(size: 8pt, fill: c-mute)[#project — #document-title],
          image(logo, height: 18pt),
        )
        v(-6pt)
        line(length: 100%, stroke: 0.6pt + c-line)
      }
    },
    footer: context {
      grid(
        columns: (1fr, auto, 1fr),
        align: (left + horizon, center + horizon, right + horizon),
        text(size: 8pt, fill: c-mute)[© Ayodia • #date],
        text(size: 8pt, fill: c-mute)[
          หน้า #counter(page).display() / #context counter(page).final().first()
        ],
        text(size: 8pt, fill: c-mute)[Confidential],
      )
    },
  )
  // Thai shaping: ใช้ Sukhumvit Set (มี shaping ครบ) เป็นหลัก,
  // fallback ไปยัง font อื่นเมื่อ glyph ไม่พบ (เช่น emoji, English)
  set text(
    font: ("Sukhumvit Set", "Sarabun", "Helvetica", "Arial"),
    size: 10pt,
    fill: c-ink,
    lang: "th",
  )
  set par(justify: true, leading: 0.7em)
  show heading: set text(fill: c-ink)

  // ----- cover page -----
  page(margin: (x: 2cm, y: 2.5cm), {
    v(1.2cm)
    align(center, image(logo, width: 4cm))
    v(0.4cm)
    align(center, text(size: 10pt, fill: c-mute, weight: "regular")[AYODIA Quality Assurance])
    v(2.5cm)
    align(center, text(size: 28pt, weight: "bold", fill: c-ink, document-title))
    v(0.4cm)
    align(center, text(size: 16pt, fill: c-orange, weight: "bold", project))
    v(0.6cm)
    align(center, line(length: 30%, stroke: 1.5pt + c-red))
    v(2.5cm)

    align(center, box(
      width: 70%,
      fill: c-bg-soft,
      stroke: (left: 3pt + c-orange),
      inset: 14pt,
      radius: 3pt,
      align(left, table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 4pt, y: 6pt),
        [*ลูกค้า / Customer:*], [#customer],
        [*เวอร์ชัน / Version:*], [#version],
        [*วันที่ / Date:*], [#date],
        [*จัดทำโดย / Prepared by:*], [#author],
      )),
    ))

    place(bottom + center, dy: -0.2cm, text(size: 8pt, fill: c-mute)[
      เอกสารฉบับนี้เป็นทรัพย์สินของ Ayodia • For authorized recipient only
    ])
  })

  // ----- table of contents -----
  outline(title: text(size: 14pt, weight: "bold", "สารบัญ / Table of Contents"), depth: 2, indent: auto)
  pagebreak()

  // ----- executive summary -----
  h-section("1. สรุปผู้บริหาร / Executive Summary",
    subtitle: "ภาพรวมของ test coverage และสถานะการทดสอบ")

  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    column-gutter: 8pt,
    row-gutter: 8pt,
    kpi-tile("Requirements", str(summary.total-requirements), color: c-orange),
    kpi-tile("Test Scenarios", str(summary.total-scenarios), color: c-red),
    kpi-tile("Coverage", str(summary.coverage-percent) + "%", color: c-pass),
    kpi-tile("Pass / Fail / Pending",
      str(summary.pass) + " / " + str(summary.fail) + " / " + str(summary.pending),
      color: c-yellow),
  )

  v(0.6cm)

  if scope-in.len() > 0 or scope-out.len() > 0 {
    h-section("2. ขอบเขตการทดสอบ / Test Scope")
    grid(
      columns: (1fr, 1fr),
      column-gutter: 12pt,
      [
        *In Scope* \
        #for s in scope-in [
          • #s \
        ]
      ],
      [
        *Out of Scope* \
        #for s in scope-out [
          • #s \
        ]
      ],
    )
  }

  if test-types.len() > 0 {
    h-section("3. ประเภทการทดสอบ / Test Types")
    table(
      columns: (auto, 1fr, auto),
      align: (left, left, center),
      stroke: 0.4pt + c-line,
      inset: 6pt,
      fill: (col, row) => if row == 0 { c-orange.lighten(80%) } else { white },
      [*Type*], [*Description*], [*Count*],
      ..for t in test-types {
        ([#t.name], [#t.desc], [#t.count])
      }
    )
  }

  if coverage != none {
    pagebreak()
    h-section("4. Coverage Matrix — Requirement × Scenario",
      subtitle: "ตารางตรวจสอบว่า requirement แต่ละข้อถูกครอบด้วย test scenario ใดบ้าง")
    coverage-matrix(coverage.rows, coverage.scenarios)
    v(0.3cm)
    text(size: 8pt, fill: c-mute)[
      *คำอธิบาย:* ✓ = ครอบคลุม / Covered, - = ไม่ครอบคลุม / Not covered, PASS/FAIL/PENDING = ผลทดสอบ
    ]
  }

  if combination != none {
    pagebreak()
    h-section("5. Combination Matrix — Pairwise Input",
      subtitle: "ครอบคลุมการรวมของ input parameter (pairwise)")
    combination-matrix(combination.cols, combination.rows)
  }

  if platform != none {
    pagebreak()
    h-section("6. Platform Matrix — Feature × Platform",
      subtitle: "ครอบคลุมความเข้ากันได้กับ browser / OS / device")
    platform-matrix(platform.rows, platform.platforms)
  }

  if notes != none {
    h-section("7. หมายเหตุ / Notes")
    notes
  }

  // ----- sign-off page -----
  pagebreak()
  h-section("8. การลงนามรับรอง / Sign-off")

  v(0.4cm)
  text(size: 10pt)[
    เอกสารฉบับนี้สรุปผลการทดสอบและความครอบคลุมของ test matrix สำหรับโครงการ
    *#project* เวอร์ชัน *#version* ลงวันที่ *#date* —
    ผู้ลงนามด้านล่างยืนยันว่าได้ตรวจทานและรับทราบเนื้อหาในเอกสารนี้แล้ว
  ]

  v(1.2cm)

  let sig-block(role-th, role-en) = box(
    width: 100%,
    [
      #v(2.4cm)
      #line(length: 100%, stroke: 0.6pt + c-ink)
      #v(0.2cm)
      #text(size: 9pt, fill: c-mute)[
        #role-th / #role-en \
        ชื่อ / Name: #h(0.4cm) #box(width: 6cm, repeat[.]) \
        วันที่ / Date: #h(0.4cm) #box(width: 6cm, repeat[.])
      ]
    ],
  )

  grid(
    columns: (1fr, 1fr),
    column-gutter: 24pt,
    sig-block("ผู้ทดสอบ", "QA Engineer"),
    sig-block("หัวหน้าทีม QA", "QA Lead"),
  )

  v(0.6cm)

  grid(
    columns: (1fr, 1fr),
    column-gutter: 24pt,
    sig-block("ตัวแทนโครงการ", "Project Manager"),
    sig-block("ตัวแทนลูกค้า", "Customer Representative"),
  )

  body
}
