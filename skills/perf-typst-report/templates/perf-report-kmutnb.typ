// ================================================================
// perf-report-kmutnb.typ — Performance Test Report (Government Edition)
// ================================================================
// Layout เลียนแบบ format KMUTNB / รายงานราชการทั่วไป:
//   - Header: ชื่อรายงาน (ขวา) + logo มุมขวาบน + เส้นน้ำเงินใต้
//   - Footer: เลขหน้าในกล่องสีน้ำเงินมุมขวาล่าง
//   - ไม่มี cover page / ไม่มี TOC (เริ่ม "Scenario" ทันที)
//   - หัวข้อย่อย bold สีน้ำเงิน
//   - Server Resource section รองรับ N server (loop) + แปะ PNG กราฟ
//   - Summary Report schema = JMeter Aggregate (Label/Samples/Avg/Min/Max/Std Dev/Err%/Throughput/KB-s/Avg Bytes)
//
// Compile:
//   typst compile perf-report-kmutnb.typ ../outputs/perf/<scope>_<date>.pdf
//
// วิธีใช้:
//   1. แก้ค่าใน #let data = (...) ให้ตรงกับโปรเจกต์จริง (ปกติ AI fill ให้)
//   2. วางไฟล์ PNG กราฟใน ./graphs/ (CPU/Memory ต่อ server + Response Time overall)
//   3. compile → PDF ตาม layout KMUTNB (15+ หน้าตาม server count)
// ================================================================

#import "../../../references/typst-templates/lib.typ": *

// ---------- DATA (แก้ตรงนี้) ----------
#let data = (
  // ── Header / Footer info ──────────────────────────────────────
  org-name:  "<ชื่อหน่วยงาน / บริษัท>",
  org-logo:  none,  // ใส่ path เช่น "assets/customer-logo.png" หรือ none
  doc-title: "รายงานผลการทดสอบประสิทธิภาพระบบ (Performance Test)",
  doc-id:    "PERF-RPT-<SCOPE>-<YYYY>-001",

  // ── Scenario ──────────────────────────────────────────────────
  scenario: (
    concurrent-users: "300",
    duration-min:     "60",
    time-window:      "12 กันยายน 2567 เวลา 16:04 น. - 17:06 น.",
  ),

  // ── Tools ที่ใช้ในการทดสอบ ────────────────────────────────────
  tools: (
    (
      name: "k6",
      desc: "เครื่องมือโอเพ่นซอร์สสำหรับทดสอบโหลดและประสิทธิภาพระบบ เช่น เว็บ แอป API หรือฐานข้อมูล โดยมันสามารถจำลองผู้ใช้จำนวนมากพร้อมกัน วัด Response Time, Throughput, Error Rate และสร้างรายงานการทดสอบของระบบได้",
    ),
    (
      name: "node_exporter + Prometheus + Grafana",
      desc: "ชุดเครื่องมือสำหรับเก็บและแสดงกราฟ CPU / Memory / Disk / Network ต่อ server แบบ realtime ใช้บน Linux",
    ),
    (
      name: "Performance Monitor (Windows Server)",
      desc: "เครื่องมือสำหรับตรวจสอบและวิเคราะห์ประสิทธิภาพของระบบใช้ใน Windows Server และ Windows OS",
    ),
  ),

  // ── รายการ API ที่ใช้ทดสอบ ────────────────────────────────────
  apis: (
    (no: "1",  url: "/api/Authenticate/login",
       desc: "ส่งข้อมูล user และ password เพื่อรับ JWT Token เพื่อใช้ในการเรียกใช้งาน API อื่นๆ"),
    (no: "2",  url: "/api/operatingBudget/pendingProcess?pageNumber=&pageSize=",
       desc: "ดึงข้อมูลรายการเอกสารในรูปแบบ pagination"),
    (no: "3",  url: "/api/OperatingUnit/lookup",
       desc: "ข้อมูลรายการหน่วยปฏิบัติ"),
    // เพิ่มแถวตาม API ที่ทดสอบจริง
  ),

  // ── ผลลัพธ์ที่ต้องการ (NFR — narrative ตรงจาก SRS) ──────────
  nfr-text: "ระบบต้องรองรับการใช้งานพร้อมกันได้ไม่น้อยกว่า 300 sessions ต่อวินาที " +
            "ภายใต้ภาระงานปกติระบบต้องมีเวลาตอบสนองของงาน ไม่เกิน 30 วินาที " +
            "ในช่วงภาระงานสูงสุด ระบบต้องมีเวลาตอบสนองของงาน ไม่เกิน 1 นาที",

  // ── ผลการทดสอบ — per server (loop) ────────────────────────────
  // เพิ่ม/ลด server block ตาม architecture จริง
  servers: (
    (
      name:      "Webserver 1",
      ip:        "172.16.212.77",
      os:        "Ubuntu 24.04",
      timezone:  "Coordinated Universal Time (UTC)",
      cpu:       "4",
      ram:       "16 GiB",
      cpu-graph:    "graphs/cpu-webserver1.png",
      cpu-graph-note: "กราฟนี้แสดงการใช้ CPU แบบรวมทุกคอร์ โดยเครื่องมีทั้งหมด 4 คอร์ดังนั้นค่าสูงสุดที่สามารถแสดงได้จะเท่ากับ 400% (100% × 4 คอร์)",
      mem-graph:    "graphs/mem-webserver1.png",
      mem-stats:    (used: "63.47", free: "36.52", buffers: "2.01", cached: "42.36", dirty: "0.017", slabmem: "2.22", swapfree: "100.0"),
    ),
    (
      name:      "Webserver 2",
      ip:        "172.16.212.78",
      os:        "Ubuntu 24.04",
      timezone:  "Coordinated Universal Time (UTC)",
      cpu:       "4",
      ram:       "16 GiB",
      cpu-graph:    "graphs/cpu-webserver2.png",
      cpu-graph-note: "กราฟนี้แสดงการใช้ CPU แบบรวมทุกคอร์ โดยเครื่องมีทั้งหมด 4 คอร์ดังนั้นค่าสูงสุดที่สามารถแสดงได้จะเท่ากับ 400% (100% × 4 คอร์)",
      mem-graph:    "graphs/mem-webserver2.png",
      mem-stats:    (used: "70.73", free: "29.26", buffers: "1.74", cached: "49.48", dirty: "0.019", slabmem: "2.42", swapfree: "100.0"),
    ),
    (
      name:      "Background Job",
      ip:        "172.16.212.79",
      os:        "Ubuntu 24.04",
      timezone:  "Coordinated Universal Time (UTC)",
      cpu:       "4",
      ram:       "32 GiB",
      cpu-graph:    "graphs/cpu-bgjob.png",
      cpu-graph-note: "กราฟนี้แสดงการใช้ CPU แบบรวมทุกคอร์ โดยเครื่องมีทั้งหมด 4 คอร์ดังนั้นค่าสูงสุดที่สามารถแสดงได้จะเท่ากับ 400% (100% × 4 คอร์)",
      mem-graph:    "graphs/mem-bgjob.png",
      mem-stats:    (used: "23.43", free: "76.56", buffers: "1.34", cached: "15.62", dirty: "0.006", slabmem: "0.93", swapfree: "100.0"),
    ),
    (
      name:      "Report Service",
      ip:        "172.16.212.76",
      os:        "Windows Server 2022",
      timezone:  "Pacific Daylight Time (PT)",
      cpu:       "8",
      ram:       "16 GiB",
      cpu-graph:    "graphs/cpu-report.png",
      cpu-graph-note: "กราฟ CPU Usage Over Time จาก Performance Monitor — ค่าเป็น % รวมทุก core",
      mem-graph:    "graphs/mem-report.png",
      mem-stats:    none,  // Windows ใช้ Available MB / Committed GB แทน — ใช้ mem-stats-windows
      mem-stats-windows: (available-mb: "11033.54", committed-gb: "5.05"),
    ),
    (
      name:      "Database",
      ip:        "172.16.212.74",
      os:        "Ubuntu 24.04",
      timezone:  "Coordinated Universal Time (UTC)",
      cpu:       "8",
      ram:       "32 GiB",
      cpu-graph:    "graphs/cpu-db.png",
      cpu-graph-note: "กราฟนี้แสดงการใช้ CPU แบบรวมทุกคอร์ โดยเครื่องมีทั้งหมด 8 คอร์ดังนั้นค่าสูงสุดที่สามารถแสดงได้จะเท่ากับ 800% (100% × 8 คอร์)",
      mem-graph:    "graphs/mem-db.png",
      mem-stats:    (used: "38.87", free: "61.12", buffers: "1.74", cached: "8.38", dirty: "0.00", slabmem: "0.64", swapfree: "100.0"),
    ),
  ),

  // ── Response Time Graph (overall — แปะรูปจาก Grafana / xk6-dashboard) ──
  response-time-graph: "graphs/response-time-all-endpoints.png",
  response-time-narrative: "Response Time Graph เป็นกราฟที่แสดงเวลาการตอบกลับของ API ตั้งแต่ช่วงเวลาเริ่มต้นทดสอบจนถึงจบการทดสอบ โดยดูช่วงเวลาในแกน X และเวลาในการตอบกลับเป็น มิลลิวินาทีในแกน Y เส้นสีต่างๆ จากแทน API ที่ตอบสนองในช่วงเวลาการทดสอบ",

  // ── Summary Report — JMeter-schema เทียบเท่า ──────────────────
  // ทุกตัวเลขเป็น string เพื่อรองรับ comma-formatted (เช่น "5,400")
  summary-rows: (
    (label: "Login_pp",                   samples: "3",      avg: "798",  min: "656", max: "882",  std-dev: "73.50",  err-pct: "0.00%", throughput: "1.0/min",   recv-kb: "0.02",   sent-kb: "0.01",  avg-bytes: "2,188.3"),
    (label: "JMX223 Sampler",             samples: "2",      avg: "117",  min: "0",   max: "234",  std-dev: "117.00", err-pct: "0.00%", throughput: "0.0/min",   recv-kb: "0.00",   sent-kb: "0.01",  avg-bytes: "0"),
    (label: "PurposeProcurement pendi…",  samples: "2,011",  avg: "165",  min: "143", max: "569",  std-dev: "47.42",  err-pct: "0.00%", throughput: "53.6/min",  recv-kb: "16.07",  sent-kb: "1.49",  avg-bytes: "19,693.8"),
    // เพิ่มแถวตาม endpoint จริง
    (label: "TOTAL",                      samples: "56,848", avg: "256",  min: "—",   max: "—",    std-dev: "—",      err-pct: "0.00%", throughput: "15.29/sec", recv-kb: "216.48", sent-kb: "65.69", avg-bytes: "14,497.1"),
  ),

  // ── สรุปผลการทดสอบ (Conclusion bullets — narrative paragraphs) ──
  conclusion-bullets: (
    "Error % = 0.00% ใน request ทั้งหมด ซึ่งแสดงให้เห็นว่าระบบจัดการ request ทั้งหมดได้สำเร็จโดยไม่มี Error",
    "Response Times เฉลี่ยโดยรวมของคำขอทั้งหมดคือ 256 มิลลิวินาที ซึ่งบ่งบอกถึงการใช้เวลาตอบสนองได้อย่างรวดเร็วจาก Server",
    "Throughput ค่าเฉลี่ยในแต่ละ API ส่วนใหญ่อยู่ที่ 15.29 ต่อวินาที แสดงถึงระบบสามารถจัดการ request ได้อย่างมีประสิทธิภาพ",
    "ผลการใช้งาน CPU และ Memory สอดคล้องกับการทดสอบ load แม้จะมีการใช้ Memory สูงใน Server Object Stored แต่เป็นการนำไปเพิ่ม Buffers และ Cached ซึ่งไม่ใช่ปัญหา เพราะ Linux สามารถคืนพื้นที่เหล่านี้ให้ process ได้เมื่อจำเป็น และ Swap Free ในทุก server 100% แปลว่ายังไม่ต้องพึ่ง swap ทำให้ประสิทธิภาพยังไม่มีการลดลงในการทำงาน",
  ),
  conclusion-final: "สรุปการทดสอบ Performance Test Concurrent 300 User ระบบสามารถตอบสนอง request ได้ โดยไม่มี Error และใช้เวลาตอบสนองต่ำกว่า 30 วินาทีในช่วงปกติ และไม่เกิน 1 นาทีในช่วง peak load",

  // ── ภาคผนวก (optional — ปิดด้วย show-appendix: false ถ้าลูกค้าไม่ขอ) ──
  show-appendix: true,
  estimate-actual: (
    (phase: "Script Prep",       est: "16 hr", act: "14 hr", var: "-12%", note: "AI generate k6 ได้ช่วย"),
    (phase: "Run Load+Stress",   est: "5 hr",  act: "5 hr",  var: "0%",   note: ""),
    (phase: "Analysis + Report", est: "8 hr",  act: "4 hr",  var: "-50%", note: "AI-assisted"),
  ),
  ai-savings: (
    (artifact: "Perf Test Plan",        ai: "30 min", review: "3.5 hr", total: "4 hr",  baseline: "8 hr",  savings: "50%"),
    (artifact: "k6 Scripts",            ai: "1 hr",   review: "13 hr",  total: "14 hr", baseline: "16 hr", savings: "13%"),
    (artifact: "Bottleneck Analysis",   ai: "20 min", review: "2 hr",   total: "2.3 hr",baseline: "4 hr",  savings: "42%"),
    (artifact: "Perf Report",           ai: "20 min", review: "1.7 hr", total: "2 hr",  baseline: "8 hr",  savings: "75%"),
  ),
  signoff-roles: ("QC Lead", "TL / Architect", "DevOps", "PM"),
)


// ================================================================
// ----------------- ข้างล่างนี้ไม่ต้องแก้ปกติ -----------------
// ================================================================

// ── Page setup + header/footer ที่เลียน KMUTNB ──────────────────
#let kmutnb-primary = rgb("#1e3a5f")  // navy เดียวกับ Ayodia primary

#set text(
  font: ("Sarabun", "TH Sarabun New", "Helvetica"),
  size: 11pt,
  lang: "th",
)
#set par(
  justify: true,
  leading: 0.85em,
  spacing: 1.0em,
  first-line-indent: 1em,
)
#set block(spacing: 1.0em)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, x: 2.2cm),
  header: context {
    set text(size: 9pt, fill: kmutnb-primary)
    grid(
      columns: (1fr, auto),
      align: (right + horizon, right + horizon),
      column-gutter: 8pt,
      data.doc-title,
      if data.org-logo != none { image(data.org-logo, height: 0.9cm) } else [],
    )
    line(length: 100%, stroke: 1.2pt + kmutnb-primary)
  },
  header-ascent: 25%,
  footer: context {
    set text(size: 9pt)
    align(right,
      box(
        fill: kmutnb-primary,
        inset: (x: 10pt, y: 4pt),
        radius: 1pt,
        text(fill: white, weight: "bold", counter(page).display()),
      )
    )
  },
  footer-descent: 20%,
)

// ── Custom heading style (KMUTNB-like — bold สีน้ำเงิน) ─────────
#show heading.where(level: 1): it => block(sticky: true, {
  v(8pt)
  text(size: 14pt, weight: "bold", fill: kmutnb-primary, it.body)
  v(4pt)
})
#show heading.where(level: 2): it => block(sticky: true, {
  v(6pt)
  text(size: 12pt, weight: "bold", fill: kmutnb-primary, it.body)
  v(2pt)
})
#show heading.where(level: 3): it => block(sticky: true, {
  v(4pt)
  text(size: 11pt, weight: "bold", fill: kmutnb-primary, it.body)
  v(2pt)
})

// ── Caption แบบ KMUTNB (จัดกลาง, ตัวหนา ใต้รูป/ตาราง) ──────────
#let kmutnb-caption(body) = align(center, text(weight: "bold", size: 10.5pt, body))

// ── Image with caption ──────────────────────────────────────────
#let captioned-image(path, caption, width: 90%) = block(breakable: false, {
  align(center, image(path, width: width))
  v(2pt)
  kmutnb-caption(caption)
})

// ── ตารางข้อมูล server (key/value 2 col) ────────────────────────
#let server-info-table(s) = table(
  columns: (35%, 65%),
  stroke: 0.5pt + ayodia-border,
  inset: (x: 8pt, y: 6pt),
  [#text(weight: "bold", s.name)], [#s.ip],
  [OS],        [#s.os],
  [Time],      [#s.timezone],
  [CPU],       [#s.cpu],
  [Ram],       [#s.ram],
)

// ── ตาราง Memory % (Linux) ──────────────────────────────────────
#let mem-percent-table(stats) = table(
  columns: 7 * (1fr,),
  align: center + horizon,
  stroke: 0.5pt + ayodia-border,
  inset: (x: 4pt, y: 8pt),
  [used], [free], [buffers], [cached], [dirty], [slabmem], [swapfree],
  [#stats.used], [#stats.free], [#stats.buffers], [#stats.cached], [#stats.dirty], [#stats.slabmem], [#stats.swapfree],
)

// ── ตาราง Memory (Windows — Available MB / Committed GB) ───────
#let mem-windows-table(stats) = table(
  columns: 2 * (1fr,),
  align: center + horizon,
  stroke: 0.5pt + ayodia-border,
  inset: (x: 4pt, y: 8pt),
  [Available Memory (MB)], [Committed Memory (GB)],
  [#stats.available-mb],   [#stats.committed-gb],
)

// ────────────────────────────────────────────────────────────────
// ───────────────────── DOCUMENT BODY ────────────────────────────
// ────────────────────────────────────────────────────────────────

// Title — จัดกลางหน้าแรก (ไม่ใช่ heading เพราะไม่อยากให้เข้า outline)
#align(center, text(size: 16pt, weight: "bold", fill: kmutnb-primary, data.doc-title))

#v(14pt)

// ─── Scenario ───────────────────────────────────────────────────
= Scenario

#table(
  columns: (1fr, 1fr, 2fr),
  align: center + horizon,
  stroke: 0.5pt + ayodia-border,
  inset: (x: 8pt, y: 8pt),
  fill: (_, y) => if y == 0 { ayodia-bg },
  [*จำนวน Concurrent (User)*], [*ระยะเวลา (Min)*], [*ช่วงเวลา*],
  [#data.scenario.concurrent-users], [#data.scenario.duration-min], [#data.scenario.time-window],
)

#v(10pt)

// ─── Tools ที่ใช้ในการทดสอบ ─────────────────────────────────────
= Tool ที่ใช้ในการทดสอบ

#for (i, t) in data.tools.enumerate() [
  #par(first-line-indent: 0pt)[
    *#(i + 1). #t.name* คือ #t.desc
  ]
  #v(4pt)
]

// ─── รายการ API ที่ใช้ทดสอบ ─────────────────────────────────────
= รายการ API ที่ใช้ทดสอบ

#table(
  columns: (auto, 2.2fr, 2fr),
  align: (center + horizon, left + horizon, left + horizon),
  stroke: 0.5pt + ayodia-border,
  inset: (x: 6pt, y: 6pt),
  fill: (_, y) => if y == 0 { ayodia-bg },
  [*NO.*], [*URL*], [*รายละเอียด*],
  ..data.apis.map(a => (
    [#a.no],
    raw(a.url),
    [#a.desc],
  )).flatten()
)

#v(10pt)

// ─── ผลลัพธ์ที่ต้องการ ──────────────────────────────────────────
= ผลลัพธ์ที่ต้องการ

#par[#data.nfr-text]

#v(6pt)

// ─── ผลการทดสอบ — per server ────────────────────────────────────
#if data.servers.len() > 0 [
= ผลการทดสอบ

#for s in data.servers [
  #server-info-table(s)
  #v(8pt)

  #captioned-image(s.cpu-graph, "กราฟแสดงการใช้งาน CPU")

  #v(4pt)
  #par(first-line-indent: 0pt)[
    #text(weight: "bold", "หมายเหตุ:") #s.cpu-graph-note
  ]

  #v(8pt)

  #captioned-image(s.mem-graph, "กราฟแสดงการใช้งาน Memory")

  #v(4pt)

  #if s.at("mem-stats", default: none) != none [
    #mem-percent-table(s.mem-stats)
    #v(4pt)
    #kmutnb-caption("ตารางเปอร์เซ็นเฉลี่ยการใช้งาน Memory")
  ] else if s.at("mem-stats-windows", default: none) != none [
    #mem-windows-table(s.mem-stats-windows)
    #v(4pt)
    #kmutnb-caption("ตารางเปอร์เซ็นเฉลี่ยการใช้งาน Memory")
  ]

  #v(14pt)
]
]

// ─── k6 Test Result (Response Time Graph + Summary Report) ──────
= k6 Test Result

#if data.response-time-graph != none [
  #captioned-image(data.response-time-graph, "Response Time Graph", width: 100%)
  #v(6pt)
]

#par[#data.response-time-narrative]

#v(8pt)

#table(
  columns: 11 * (auto,),
  align: (left, right, right, right, right, right, right, right, right, right, right),
  stroke: 0.4pt + ayodia-border,
  inset: (x: 4pt, y: 4pt),
  fill: (_, y) => if y == 0 { ayodia-bg },
  ..([Label], [\# Samples], [Average], [Min], [Max], [Std. Dev.], [Error %], [Throughput], [Recv KB/s], [Sent KB/s], [Avg. Bytes]).map(h => text(weight: "bold", size: 8pt, h)),
  ..data.summary-rows.map(r => {
    let is-total = lower(r.label) == "total"
    let style = if is-total { (weight: "bold",) } else { (:) }
    (
      text(size: 8pt, weight: if is-total {"bold"} else {"regular"}, r.label),
      text(size: 8pt, r.samples),
      text(size: 8pt, r.avg),
      text(size: 8pt, r.min),
      text(size: 8pt, r.max),
      text(size: 8pt, r.std-dev),
      text(size: 8pt, r.err-pct),
      text(size: 8pt, r.throughput),
      text(size: 8pt, r.recv-kb),
      text(size: 8pt, r.sent-kb),
      text(size: 8pt, r.avg-bytes),
    )
  }).flatten()
)

#v(4pt)
#kmutnb-caption("Summary Report")

// ─── อธิบายหัวตารางและผลการทดสอบ ────────────────────────────────
= อธิบายหัวตารางและผลการทดสอบ

#par(first-line-indent: 0pt)[
  *1. Label* — ชื่อของ Sampler หรือ API ที่ถูกทดสอบ
]
#par(first-line-indent: 0pt)[
  *2. \# Samples* — จำนวน request (sample) ที่ส่งไปทั้งหมด
]
#par(first-line-indent: 0pt)[
  *3. Average (ms)* — เวลาเฉลี่ยที่ API ตอบสนอง (Response Time) หน่วยเป็น มิลลิวินาที
]
#par(first-line-indent: 0pt)[
  *4. Min / Max (ms)* — Response Time ที่เร็ว/ช้าที่สุดของ API
]
#par(first-line-indent: 0pt)[
  *5. Std. Dev.* — ส่วนเบี่ยงเบนมาตรฐาน — ค่าสูงแสดงว่า Response Time ไม่นิ่ง
]
#par(first-line-indent: 0pt)[
  *6. Error %* — สัดส่วนของ request ที่ error เทียบกับทั้งหมด — 0% หมายถึงไม่มี request ล้มเหลว
]
#par(first-line-indent: 0pt)[
  *7. Throughput* — อัตรา request ที่ประมวลผลได้ (ต่อวินาทีหรือต่อนาที — ดูหน่วยในตาราง)
]
#par(first-line-indent: 0pt)[
  *8. Recv KB/sec* — ปริมาณข้อมูลที่ฝั่ง client ได้รับต่อวินาที
]
#par(first-line-indent: 0pt)[
  *9. Sent KB/sec* — ปริมาณข้อมูลที่ฝั่ง client ส่งออกไปต่อวินาที
]
#par(first-line-indent: 0pt)[
  *10. Avg. Bytes* — ขนาดเฉลี่ยของ response (byte) ที่ได้จาก API
]
#par(first-line-indent: 0pt)[
  *11. p95 / p99* (เพิ่มเติมจาก k6 — JMeter Aggregate ไม่มี) — ค่า percentile ที่ 95% / 99% ของ Response Time ใช้ตัดสินใจ NFR ส่วนใหญ่
]

// ─── สรุปผลการทดสอบ ──────────────────────────────────────────────
= สรุปผลการทดสอบ

#for (i, b) in data.conclusion-bullets.enumerate() [
  #par(first-line-indent: 0pt)[
    *#(i + 1).* #b
  ]
  #v(2pt)
]

#v(6pt)

#par[#data.conclusion-final]

// ─── ภาคผนวก (optional — ปิดได้ด้วย show-appendix: false) ───────
#if data.show-appendix [
  #pagebreak()

  = ภาคผนวก ก. — Estimate vs Actual

  #table(
    columns: (1.4fr, auto, auto, auto, 2fr),
    align: (left, right, right, right, left),
    stroke: 0.5pt + ayodia-border,
    inset: (x: 8pt, y: 6pt),
    fill: (_, y) => if y == 0 { ayodia-bg },
    ..([Phase], [Estimated], [Actual], [Variance], [Note]).map(h => text(weight: "bold", h)),
    ..data.estimate-actual.map(e => (
      [#e.phase], [#e.est], [#e.act], [#e.var], [#e.note],
    )).flatten()
  )

  #v(10pt)

  = ภาคผนวก ข. — AI Effort Savings (KPI)

  #table(
    columns: (1.4fr, auto, auto, auto, auto, auto),
    align: (left, right, right, right, right, right),
    stroke: 0.5pt + ayodia-border,
    inset: (x: 8pt, y: 6pt),
    fill: (_, y) => if y == 0 { ayodia-bg },
    ..([Artifact], [AI Draft], [Human Review], [Total], [Baseline], [Savings %]).map(h => text(weight: "bold", h)),
    ..data.ai-savings.map(a => (
      [#a.artifact], [#a.ai], [#a.review], [#a.total], [#a.baseline], [#a.savings],
    )).flatten()
  )

  #v(14pt)

  = ภาคผนวก ค. — การอนุมัติ (Sign-off)

  #signoff-table(data.signoff-roles)
]
