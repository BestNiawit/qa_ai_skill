// QA AI Skills — Pre-Workshop Setup Guide (~10 นาที)
// ส่งล่วงหน้าให้ผู้เข้าร่วมติดตั้ง Claude Code + plugin มาก่อนวันงาน
// Build: typst compile --root . slides/pre-install.typ slides/pre-install.pdf

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
        #box(baseline: 3pt, image(logo-path, height: 0.6cm))#h(5pt)QA AI Skills · Pre-Workshop Setup
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
#let kbd(t) = box(fill: ayodia-bg, stroke: 0.4pt + ayodia-border,
  inset: (x: 5pt, y: 2pt), radius: 2pt,
  text(font: "Menlo", size: 10pt, t))

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

#let step-card(num, title, body) = block(
  width: 100%,
  fill: ayodia-bg,
  stroke: (left: 3pt + ayodia-accent),
  radius: 3pt,
  inset: 12pt,
  [
    #grid(columns: (auto, 1fr), column-gutter: 12pt, align: (left + horizon, left + horizon),
      text(size: 22pt, weight: "bold", fill: ayodia-accent, str(num)),
      text(weight: "bold", size: 13pt, fill: ayodia-primary, title),
    )
    #v(4pt)
    #body
  ],
)

// ================================================================
// Slide 1 — Title
// ================================================================

#align(center + horizon)[
  #image(logo-path, width: 4cm)
  #v(8pt)
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "PRE-WORKSHOP SETUP")
  #v(28pt)
  #text(size: 46pt, weight: "bold", fill: ayodia-primary, "ติดตั้งก่อน · เร็วกว่า")
  #v(6pt)
  #text(size: 20pt, fill: ayodia-muted, "10 นาที · 4 ขั้นตอน · เสร็จก่อนวัน workshop")
  #v(36pt)
  #text(size: 13pt, fill: ayodia-muted)[QA AI Skills Workshop · v1.0 · 8 พฤษภาคม 2569]
]

#pagebreak()

// ================================================================
// Slide 2 — Why setup ก่อน
// ================================================================

= ทำไมต้องติดตั้งก่อน

#v(6pt)

#grid(columns: (1.3fr, 1fr), column-gutter: 22pt, align: (top, top),
  [
    #text(size: 14pt)[
      วัน workshop มี 60 นาทีให้ลงมือทำ — ถ้าทุกคนเริ่ม install ตอนนั้น
      หมดไปกับ download / network / debug version ไม่ทันได้ลอง skill จริง
    ]
    #v(12pt)

    #text(weight: "bold", size: 13pt, fill: ayodia-accent, "✅ ถ้าเตรียมก่อน")
    #v(4pt)
    - มาถึง ลอง skill ได้ใน 5 นาที
    - มีเวลาทำ Lab ครบทุกตัว
    - เจอปัญหาจริงๆ น้อย — Lead ช่วยทันใน session

    #v(10pt)

    #text(weight: "bold", size: 13pt, fill: tier-1, "❌ ถ้ามาติดตั้งวันงาน")
    #v(4pt)
    - download `npm install` 5-10 นาที
    - ติด permission / proxy / version mismatch
    - ทำ Lab ไม่ทัน · ต้อง catch-up ทีหลัง
  ],
  [
    #info-box("⏱️ เวลาที่ใช้", tier-3, [
      #text(size: 11pt)[
        - *ทำตอนนี้:* ~10 นาที (one-time)
        - *รวมในวัน workshop:* ~5 นาที verify
      ]
    ])
    #v(10pt)
    #info-box("🆘 ติดปัญหา", ayodia-accent, [
      #text(size: 11pt)[
        ทักใน Slack \#qa-ai-skill ทีม Lead ดูแลก่อนวัน workshop
      ]
    ])
    #v(10pt)
    #info-box("📅 Deadline", tier-2, [
      #text(size: 11pt)[
        เสร็จก่อน *เย็นวันก่อน workshop 1 วัน* · ทีมจะส่ง reminder อีกที
      ]
    ])
  ],
)

#pagebreak()

// ================================================================
// Slide 3 — Pre-flight checklist
// ================================================================

= สิ่งที่ต้องเตรียม · 4 หมวด

#v(6pt)

#grid(columns: (1fr, 1fr), column-gutter: 18pt, row-gutter: 10pt,

  info-box("💻 Software", ayodia-primary, [
    #text(size: 11pt)[
      - Node.js ≥ 18
      - Python 3
      - Git
      - Editor: VS Code / Cursor / ที่ถนัด
      - macOS / Linux / Windows + WSL
    ]
  ]),

  info-box("🔑 Account", ayodia-accent, [
    #text(size: 11pt)[
      - Anthropic / Claude account *(ทำใหม่ได้ฟรี)*
      - GitLab account ที่มีสิทธิ์ ayodia-tester-teams
      - SSH key หรือ HTTPS credential สำหรับ git clone
    ]
  ]),

  info-box("📦 ติดตั้ง", tier-2, [
    #text(size: 11pt)[
      - Claude Code CLI
      - Plugin `qa-ai-skill`
      - (ทำตามสไลด์ถัดไป step 1-4)
    ]
  ]),

  info-box("🧪 Verify", tier-3, [
    #text(size: 11pt)[
      - Login Claude สำเร็จ
      - `/plugins` เห็น `qa-ai-skill`
      - `/help` เห็นรายการ skill
    ]
  ]),
)

#v(8pt)

#align(center, block(
  fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 5pt,
  inset: 12pt, width: 90%,
  text(size: 11pt)[
    💡 ใช้คำสั่งใน 4 สไลด์ถัดไป copy-paste ได้เลย — ถ้าทำตามครบ ผ่านแน่นอน
  ],
))

#pagebreak()

// ================================================================
// Slide 4 — Step 1: Install CLI + login
// ================================================================

= Step 1 · Install Claude Code CLI

#v(4pt)

#step-card("1.1", "Install ผ่าน npm",
  raw(block: true, lang: "bash",
"npm install -g @anthropic-ai/claude-code"))

#v(8pt)

#step-card("1.2", "Verify version",
  [
    #raw(block: true, lang: "bash", "claude --version")
    #v(4pt)
    #text(size: 11pt)[
      ต้องได้ version ที่รองรับ `/plugin` (ใหม่พอสมควร) · ถ้า command not found → ตรวจ npm path / npm prefix
    ]
  ])

#v(8pt)

#step-card("1.3", "Login Anthropic",
  [
    #raw(block: true, lang: "bash",
"claude
# ครั้งแรกจะให้ login → กด link เปิด browser → login Anthropic account")
    #v(4pt)
    #text(size: 11pt)[
      ถ้ายังไม่มี account — สร้างฟรีที่ https://claude.ai · ใช้อีเมลบริษัทได้
    ]
  ])

#pagebreak()

// ================================================================
// Slide 5 — Step 2: Clone repo
// ================================================================

= Step 2 · Clone repo qa_ai_skill

#v(4pt)

#step-card("2.1", "เลือกที่อยู่ repo",
  [
    #text(size: 11pt)[
      แนะนำ `~/Documents/GitHub/` (เพื่อให้ตรงสไลด์ workshop) · ใส่ที่อื่นก็ได้แต่ต้องจำ path
    ]
    #raw(block: true, lang: "bash",
"mkdir -p ~/Documents/GitHub
cd ~/Documents/GitHub")
  ])

#v(8pt)

#step-card("2.2", "Clone (private repo)",
  [
    #raw(block: true, lang: "bash",
"git clone https://gitlab.ayodiacompany.com/ayodia-tester-teams/qa_ai_skill.git")
    #v(4pt)
    #text(size: 11pt)[
      ถ้าเจอ *Permission denied* / *401* → ยังไม่มี GitLab access — *ทักทีม Lead ขอ access ก่อน*
    ]
  ])

#v(8pt)

#step-card("2.3", "Verify clone",
  [
    #raw(block: true, lang: "bash",
"cd qa_ai_skill
ls
# ต้องเห็น: README.md  skills/  docs/  references/  .claude-plugin/")
  ])

#pagebreak()

// ================================================================
// Slide 6 — Step 3: Add marketplace + install plugin
// ================================================================

= Step 3 · Add Marketplace + Install Plugin

#v(4pt)

#step-card("3.1", "เปิด Claude Code",
  raw(block: true, lang: "bash", "claude"))

#v(6pt)

#step-card("3.2", "Add marketplace (ใน Claude session)",
  [
    #raw(block: true, lang: "text",
"/plugin marketplace add ~/Documents/GitHub/qa_ai_skill")
    #v(2pt)
    #text(size: 11pt, fill: ayodia-muted)[
      💡 ใช้ `~/...` ได้ Claude expand path เอง · ที่ถูก: `~/Documents/...` (เป็น 1 token เลย)
    ]
    #v(2pt)
    #text(size: 11pt)[
      ถ้าสำเร็จเห็น: `Successfully added marketplace: ayodia-qa`
    ]
  ])

#v(6pt)

#step-card("3.3", "Install plugin + reload",
  [
    #raw(block: true, lang: "text",
"/plugin install qa-ai-skill@ayodia-qa
/reload-plugins")
    #v(2pt)
    #text(size: 11pt, fill: tier-1, weight: "bold")[
      ⚠️ อย่าลืม `/reload-plugins` — มีคนพลาดข้อนี้บ่อย ของไม่ขึ้นจน reload
    ]
  ])

#pagebreak()

// ================================================================
// Slide 7 — Step 4: Verify
// ================================================================

= Step 4 · Verify ติดตั้งสำเร็จ

#v(6pt)

#step-card("4.1", "เช็ค plugin installed",
  [
    #raw(block: true, lang: "text", "/plugins")
    #v(2pt)
    #text(size: 11pt)[
      ไป tab *Installed* ต้องเห็น `qa-ai-skill · ayodia-qa`
    ]
  ])

#v(8pt)

#step-card("4.2", "เช็ค skill list",
  [
    #raw(block: true, lang: "text", "/help")
    #v(2pt)
    #text(size: 11pt)[
      ส่วน Skills ต้องเห็น (อย่างน้อย): \
      `test-case-writer` · `bug-report-writer` · `requirement-analyzer` · `test-plan-writer` · ...
    ]
  ])

#v(8pt)

#step-card("4.3", "ลอง trigger skill",
  [
    #raw(block: true, lang: "text", "/bug-report-writer")
    #v(2pt)
    #text(size: 11pt)[
      ถ้า Claude ขอ input bug ได้ = พร้อม! · ไม่ต้องใส่อะไรจริง — กด ESC ปิดแล้วปิด Claude ได้เลย
    ]
  ])

#pagebreak()

// ================================================================
// Slide 8 — Troubleshooting
// ================================================================

= ติดปัญหา · เจอบ่อย 4 เคส

#v(4pt)

#table(
  columns: (1.2fr, 1fr, 1.4fr),
  inset: 8pt,
  align: (left + top, left + top, left + top),
  stroke: 0.4pt + ayodia-border,
  fill: (col, row) => if row == 0 { ayodia-primary } else { none },
  table.header(
    text(fill: white, weight: "bold", size: 11pt, "อาการ"),
    text(fill: white, weight: "bold", size: 11pt, "สาเหตุ"),
    text(fill: white, weight: "bold", size: 11pt, "วิธีแก้"),
  ),
  text(size: 10pt, font: "Menlo", "command not found: claude"),
  text(size: 10pt, "npm path ไม่อยู่ใน $PATH"),
  text(size: 10pt, [เช็ค `npm config get prefix` แล้ว add `<prefix>/bin` เข้า PATH]),

  text(size: 10pt, font: "Menlo", "/plugin command not found"),
  text(size: 10pt, "Claude Code version เก่า"),
  text(size: 10pt, [`npm install -g @anthropic-ai/claude-code@latest`]),

  text(size: 10pt, font: "Menlo", "Path does not exist"),
  text(size: 10pt, [path ผิด · พิมพ์ `<you>` ตามตัวอักษร · ไม่ได้ clone repo]),
  text(size: 10pt, [`cd ~/Documents/GitHub/qa_ai_skill && pwd` เอา path มาใช้]),

  text(size: 10pt, font: "Menlo", "Permission denied / 401 ตอน clone"),
  text(size: 10pt, "ไม่มี GitLab access ของ ayodia-tester-teams"),
  text(size: 10pt, "ทักทีม Lead ขอ access ในกลุ่ม Slack #qa-ai-skill"),
)

#v(10pt)

#info-box("🛟 ติดปัญหานอกเหนือจากนี้", ayodia-accent, [
  #text(size: 11pt)[
    Slack #kbd("#qa-ai-skill") · DM ทีม Tester Lead · *แปะ screenshot error + ขั้นตอนที่ทำ* — ทีมตอบเร็วขึ้น
  ]
])

#pagebreak()

// ================================================================
// Slide 9 — Final checklist + end
// ================================================================

#align(center + horizon)[
  #text(size: 11pt, fill: ayodia-accent, weight: "bold", tracking: 3pt, "DONE!")
  #v(20pt)
  #text(size: 40pt, weight: "bold", fill: ayodia-primary, "Ready for Workshop")
  #v(20pt)

  #align(center, block(
    fill: ayodia-bg, stroke: 0.5pt + ayodia-border, radius: 6pt,
    inset: 20pt, width: 70%,
    align(left)[
      #text(weight: "bold", size: 14pt, fill: ayodia-primary, "✅ ก่อนวัน workshop เช็คอันนี้:")
      #v(8pt)
      #text(size: 12pt)[
        - #kbd("claude --version") ได้ version ออกมา
        - #kbd("ls ~/Documents/GitHub/qa_ai_skill") เห็นไฟล์ในโฟลเดอร์
        - ใน Claude พิมพ์ #kbd("/plugins") เห็น `qa-ai-skill` ใน Installed
        - ใน Claude พิมพ์ #kbd("/help") เห็นรายชื่อ skill หลายตัว
      ]
    ],
  ))

  #v(20pt)
  #text(size: 14pt, fill: ayodia-muted)[
    เจอกันวัน workshop · ขอบคุณที่เตรียมตัวมาก่อน 🙏
  ]
  #v(8pt)
  #text(size: 11pt, fill: ayodia-muted)[
    ติดปัญหา · ทัก Slack \#qa-ai-skill ก่อนวันงาน
  ]
]
