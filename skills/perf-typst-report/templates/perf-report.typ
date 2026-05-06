// ================================================================
// perf-report.typ — Performance Test Report (Client Edition)
// ================================================================
// Compile:
//   typst compile perf-report.typ ../outputs/perf/<scope>_<date>.pdf
//
// วิธีใช้:
//   1. แก้ค่าใน #let data = (...) ให้ตรงกับโปรเจกต์จริง (ปกติ AI fill ให้)
//   2. compile → PDF 4-6 หน้า ส่งลูกค้าได้เลย
// ================================================================

#import "../../../references/typst-templates/lib.typ": *

// ---------- DATA (แก้ตรงนี้) ----------
#let data = (
  // Cover
  customer:    "บริษัท ตัวอย่าง จำกัด (มหาชน)",
  project:     "ระบบบริหารจัดการข้อมูลพนักงาน",
  scope:       "Leave Management API",
  doc-id:      "PERF-RPT-LEAVE-2026-001",
  version:     "1.0",
  date:        "30 เมษายน 2569",
  test-period: "20–28 เมษายน 2569",
  author:      "Ayodia QA Team",
  reviewer:    "TL — สมชาย ทดสอบ",
  approver:    "PM — ลูกค้า",

  // Verdict (Pass / Conditional / Fail)
  verdict:        "conditional",  // pass / conditional / fail
  verdict-text:   "พร้อมขึ้นใช้งานแบบมีเงื่อนไข",
  verdict-detail: "ระบบรองรับโหลดเป้าหมาย (500 ผู้ใช้พร้อมกัน) ได้ตามที่ตกลง แต่มี 2 ฟังก์ชันที่ตอบสนองช้ากว่าเกณฑ์ — แนะนำให้แก้ไขก่อนเปิดใช้งานจริง (คาดใช้เวลา 2-3 วัน)",

  // KPI tiles (4 ตัว — แสดงเป็นการ์ด) — ใช้ทับศัพท์ industry-standard
  kpi: (
    (label: "Max Concurrent Users", value: "1,200", unit: "VUs",  note: "เป้า 1,000 ✓"),
    (label: "Response Time (p95)",  value: "680",   unit: "ms",   note: "เป้า ≤ 1,000 ms ✓"),
    (label: "Throughput",            value: "447",   unit: "RPS",  note: "Avg ตลอด 30 นาที"),
    (label: "Error Rate",            value: "0.7",   unit: "%",    note: "เป้า ≤ 1% ✓"),
  ),

  // Plain-language summary (3 bullets — ห้ามเกิน 4)
  summary-bullets: (
    "ระบบ *รองรับโหลด* ที่ตกลงไว้ได้ — สามารถเปิดให้ผู้ใช้ 1,000 คนใช้งานพร้อมกันโดยไม่มีปัญหา",
    "มี *2 ฟังก์ชันที่ช้ากว่าเป้า* ได้แก่ การค้นหาพนักงาน และ รายงานสรุป — แนะนำปรับฐานข้อมูลก่อนเปิดใช้",
    "*ไม่พบความผิดพลาดร้ายแรง* (ระบบไม่ล่ม, ข้อมูลไม่สูญหาย) — ความเสี่ยงในการเปิดใช้งานต่ำ",
  ),

  // Workload Summary — รองรับทั้ง VUs (ramping-vus / constant-vus) และ RPS (arrival-rate)
  // load = ใส่ string ได้ทั้ง "500 VUs", "100 → 1,500 VUs", "100 → 2,000 RPS"
  workload: (
    (test: "Smoke",  executor: "constant-vus",          load: "1 VU",                duration: "30s",     requests: "30"),
    (test: "Load",   executor: "constant-vus",          load: "500 VUs",             duration: "30 min",  requests: "450,000"),
    (test: "Stress", executor: "ramping-vus",           load: "100 → 1,500 VUs",     duration: "45 min",  requests: "800,000"),
    (test: "Soak",   executor: "constant-vus",          load: "300 VUs",             duration: "4 hours", requests: "1,800,000"),
    (test: "Spike",  executor: "ramping-arrival-rate",  load: "100 → 2,000 RPS",     duration: "30s burst", requests: "60,000"),
  ),

  // NFR Evaluation (per endpoint)
  nfr-rows: (
    (name: "เข้าสู่ระบบ", endpoint: "POST /auth/login",
     p95: "450", nfr-p95: "≤ 600", tps: "85", nfr-tps: "≥ 80",
     err: "0.3", nfr-err: "≤ 1", status: "pass"),
    (name: "ค้นหาพนักงาน", endpoint: "GET /employees?q=",
     p95: "2,800", nfr-p95: "≤ 1,000", tps: "45", nfr-tps: "≥ 50",
     err: "2.1", nfr-err: "≤ 1", status: "fail"),
    (name: "ขอลา", endpoint: "POST /leave",
     p95: "600", nfr-p95: "≤ 800", tps: "30", nfr-tps: "≥ 30",
     err: "0.5", nfr-err: "≤ 1", status: "pass"),
    (name: "อนุมัติคำลา", endpoint: "PATCH /leave/approve",
     p95: "550", nfr-p95: "≤ 800", tps: "25", nfr-tps: "≥ 20",
     err: "0.2", nfr-err: "≤ 1", status: "pass"),
    (name: "ประวัติการลา", endpoint: "GET /leave/history",
     p95: "800", nfr-p95: "≤ 1,000", tps: "40", nfr-tps: "≥ 30",
     err: "0.4", nfr-err: "≤ 1", status: "pass"),
    (name: "รายงานสรุป", endpoint: "GET /reports/summary",
     p95: "3,500", nfr-p95: "≤ 2,000", tps: "10", nfr-tps: "≥ 15",
     err: "1.8", nfr-err: "≤ 1", status: "fail"),
    (name: "รายงานละเอียด", endpoint: "GET /reports/detail",
     p95: "1,800", nfr-p95: "≤ 2,000", tps: "12", nfr-tps: "≥ 10",
     err: "0.7", nfr-err: "≤ 1", status: "pass"),
    (name: "หน้าหลัก", endpoint: "GET /dashboard",
     p95: "350", nfr-p95: "≤ 500", tps: "100", nfr-tps: "≥ 80",
     err: "0.1", nfr-err: "≤ 1", status: "pass"),
  ),

  // Bottleneck (ภาษาลูกค้า)
  bottlenecks: (
    (
      feature: "ค้นหาพนักงาน (Employee Search)",
      observation: "ใช้เวลา 2.8 วินาที (เป้า ≤ 1 วินาที) — ผู้ใช้ 2.1% เจอ Timeout",
      cause: "ฐานข้อมูลค้นหาช้าเพราะไม่มี Index บนคอลัมน์ที่ใช้ค้นหาบ่อย",
      impact: "ผู้ใช้ที่ค้นหาในชั่วโมงเร่งด่วนอาจรอนาน หรือเจอข้อความ Error",
    ),
    (
      feature: "รายงานสรุป (Summary Report)",
      observation: "ใช้เวลา 3.5 วินาที (เป้า ≤ 2 วินาที)",
      cause: "การรวมข้อมูลจากหลายตารางทุกครั้งที่เรียก โดยไม่มีการเก็บผลลัพธ์ชั่วคราว (No Cache)",
      impact: "เมื่อหลายคนเปิดรายงานพร้อมกัน ระบบจะช้าลงและกระทบฟังก์ชันอื่น",
    ),
  ),

  // Recommendations (3 ระดับ)
  must-fix: (
    "เพิ่ม Index บนตารางพนักงานในคอลัมน์ที่ใช้ค้นหา — คาดลดเวลาตอบสนองจาก 2.8 วินาที เหลือ ~0.3 วินาที",
    "เปิดใช้งาน Cache สำหรับรายงานสรุป (เก็บผลลัพธ์ 5 นาที) — คาดลดเวลาจาก 3.5 วินาที เหลือ < 0.5 วินาที",
  ),
  should-fix: (
    "ปรับ Timeout ของระบบภายในจาก 5 วินาที เป็น 10 วินาที เพื่อกัน Error ชั่วคราว",
    "จำกัดจำนวนแถวต่อหน้าในรายงานละเอียด (เพิ่มระบบ Pagination)",
  ),
  nice-to-have: (
    "พิจารณาเพิ่มเซิร์ฟเวอร์ฐานข้อมูลแบบอ่านอย่างเดียว (Read Replica) เมื่อจำนวนผู้ใช้ขยายเกิน 2,000",
    "เพิ่ม CDN สำหรับไฟล์ภาพ/ไอคอน ลดภาระเซิร์ฟเวอร์",
  ),

  // Conclusion + Next steps
  next-steps: (
    (when: "ภายใน 2-3 วัน", action: "ทีมพัฒนาแก้รายการ Must Fix (Index + Cache)"),
    (when: "ภายใน 1 สัปดาห์", action: "ทดสอบซ้ำเฉพาะ 2 ฟังก์ชันที่แก้ไข (ใช้เวลา ~4 ชั่วโมง)"),
    (when: "หลังทดสอบซ้ำผ่าน", action: "อนุมัติเปิดใช้งานจริง (Go-Live)"),
    (when: "หลังเปิดใช้ 30 วัน", action: "ทบทวนผลใช้งานจริง + ทยอยทำ Should Fix"),
  ),

  // ─── Technical Details (สำหรับ Dev) ─────────────────────────────
  // Per-endpoint detailed metrics — ทุก percentile + error breakdown
  detailed-metrics: (
    (endpoint: "POST /auth/login",
     avg: "118", min: "45",   med: "105",   p90: "320",   p95: "450",   p99: "803",   max: "1,287",
     rps: "85.2",  err-pct: "0.31", error-codes: "26 × 504"),
    (endpoint: "GET /employees?q=",
     avg: "1,240", min: "180", med: "1,050", p90: "2,100", p95: "2,800", p99: "4,900", max: "5,400",
     rps: "44.8",  err-pct: "2.14", error-codes: "78 × 504, 17 × 502"),
    (endpoint: "POST /leave",
     avg: "285",   min: "95",  med: "240",   p90: "520",   p95: "600",   p99: "950",   max: "1,102",
     rps: "30.0",  err-pct: "0.50", error-codes: "12 × 500, 3 × 504"),
    (endpoint: "PATCH /leave/approve",
     avg: "240",   min: "80",  med: "210",   p90: "480",   p95: "550",   p99: "870",   max: "950",
     rps: "25.0",  err-pct: "0.20", error-codes: "5 × 500"),
    (endpoint: "GET /leave/history",
     avg: "380",   min: "120", med: "340",   p90: "680",   p95: "800",   p99: "1,100", max: "1,240",
     rps: "40.0",  err-pct: "0.40", error-codes: "16 × 504"),
    (endpoint: "GET /reports/summary",
     avg: "1,820", min: "350", med: "1,650", p90: "2,900", p95: "3,500", p99: "6,200", max: "6,800",
     rps: "10.0",  err-pct: "1.80", error-codes: "12 × 504, 6 × 500"),
    (endpoint: "GET /reports/detail",
     avg: "920",   min: "200", med: "850",   p90: "1,500", p95: "1,800", p99: "2,200", max: "2,400",
     rps: "12.0",  err-pct: "0.70", error-codes: "9 × 504"),
    (endpoint: "GET /dashboard",
     avg: "95",    min: "30",  med: "80",    p90: "250",   p95: "350",   p99: "450",   max: "480",
     rps: "100.0", err-pct: "0.10", error-codes: "10 × 504"),
  ),

  // Stress test — load level vs metrics → identify breaking point
  stress-levels: (
    (load: "100 VUs",   avg: "200",   p95: "500",   rps: "85",  err: "0.1", note: "OK"),
    (load: "500 VUs",   avg: "400",   p95: "900",   rps: "280", err: "0.3", note: "OK (target load)"),
    (load: "1,000 VUs", avg: "800",   p95: "2,200", rps: "450", err: "1.5", note: "⚠ Degradation"),
    (load: "1,200 VUs", avg: "1,500", p95: "4,200", rps: "490", err: "5.1", note: "⚠ Saturation"),
    (load: "1,500 VUs", avg: "2,500", p95: "6,000", rps: "520", err: "8.2", note: "✗ Breaking point"),
  ),
  breaking-point: "~1,200 VUs (error rate เกิน 5% — saturation จาก connection pool)",

  // Soak test — memory/GC observation (set to none ถ้าไม่ได้ run)
  soak: (
    metric: "Heap Used",
    rows: (
      (hour: "0", value: "512 MB", gc-pauses: "5"),
      (hour: "1", value: "580 MB", gc-pauses: "8"),
      (hour: "2", value: "640 MB", gc-pauses: "10"),
      (hour: "3", value: "700 MB", gc-pauses: "12"),
      (hour: "4", value: "750 MB", gc-pauses: "15"),
    ),
    observation: "Heap เพิ่มต่อเนื่อง ~60 MB/ชั่วโมง — suspected memory leak (ต้องดู heap dump เพิ่มเติม)",
  ),

  // ─── k6 Evidence (k6-only mode — ไม่ต้องแคปจาก Grafana/APM/Server) ───
  // k6 console final summary — paste raw output จาก terminal ตอน k6 run จบ
  k6-output: "
     execution: local
        script: leave-load.js
        output: json (results-load.json)

     scenarios: (100.00%) 1 scenario, 500 max VUs, 30m30s max duration
              * load_test: 500 looping VUs for 30m0s

     ✓ status is 200
     ✓ login token returned
     ✗ search response < 1s
       ↳  72% — ✓ 32,400 / ✗ 12,600
     ✗ summary response < 2s
       ↳  35% — ✓ 1,400 / ✗ 2,600

     checks.........................: 87.43% ✓ 412,810   ✗ 59,290
     data_received..................: 4.2 GB  2.3 MB/s
     data_sent......................: 380 MB  211 kB/s
     http_req_blocked...............: avg=2.1ms    p(95)=4.2ms
     http_req_connecting............: avg=1.4ms    p(95)=3.1ms
     http_req_duration..............: avg=485ms    p(95)=1.42s    p(99)=3.85s
       { expected_response:true }...: avg=420ms    p(95)=1.18s    p(99)=2.95s
     http_req_failed................: 0.71%   ✓ 3,184    ✗ 444,816
     http_req_receiving.............: avg=12ms     p(95)=28ms
     http_req_sending...............: avg=0.8ms    p(95)=2.1ms
     http_req_tls_handshaking.......: avg=0s       p(95)=0s
     http_req_waiting...............: avg=472ms    p(95)=1.39s
     http_reqs......................: 448,000  248.9/s
     iteration_duration.............: avg=2.8s     p(95)=4.6s
     iterations.....................: 56,000   31.1/s
     vus............................: 500      min=500    max=500
     vus_max........................: 500      min=500    max=500

running (30m00.4s), 000/500 VUs, 56000 complete and 0 interrupted iterations
load_test ✓ [======================================] 500 VUs  30m0s
",

  // k6 Thresholds — pass/fail summary จาก k6 thresholds block
  k6-thresholds: (
    (name: "http_req_duration{name:login}",     expected: "p(95)<600",  actual: "450ms",   status: "pass"),
    (name: "http_req_duration{name:search}",    expected: "p(95)<1000", actual: "2,800ms", status: "fail"),
    (name: "http_req_duration{name:leave}",     expected: "p(95)<800",  actual: "600ms",   status: "pass"),
    (name: "http_req_duration{name:approve}",   expected: "p(95)<800",  actual: "550ms",   status: "pass"),
    (name: "http_req_duration{name:history}",   expected: "p(95)<1000", actual: "800ms",   status: "pass"),
    (name: "http_req_duration{name:summary}",   expected: "p(95)<2000", actual: "3,500ms", status: "fail"),
    (name: "http_req_duration{name:detail}",    expected: "p(95)<2000", actual: "1,800ms", status: "pass"),
    (name: "http_req_duration{name:dashboard}", expected: "p(95)<500",  actual: "350ms",   status: "pass"),
    (name: "http_req_failed",                   expected: "rate<0.01",  actual: "0.71%",   status: "pass"),
    (name: "checks",                            expected: "rate>0.95",  actual: "87.43%",  status: "fail"),
  ),

  // HTTP Status Code Breakdown — สรุป error code distribution per endpoint (จาก k6 metric)
  http-status-breakdown: (
    (endpoint: "POST /auth/login",        ok: 8494,  err-4xx: 0,   err-5xx: 26,  err-codes: "26 × 504"),
    (endpoint: "GET /employees?q=",       ok: 4380,  err-4xx: 0,   err-5xx: 95,  err-codes: "78 × 504, 17 × 502"),
    (endpoint: "POST /leave",             ok: 2985,  err-4xx: 0,   err-5xx: 15,  err-codes: "12 × 500, 3 × 504"),
    (endpoint: "PATCH /leave/approve",    ok: 2495,  err-4xx: 0,   err-5xx: 5,   err-codes: "5 × 500"),
    (endpoint: "GET /leave/history",      ok: 3984,  err-4xx: 0,   err-5xx: 16,  err-codes: "16 × 504"),
    (endpoint: "GET /reports/summary",    ok: 982,   err-4xx: 0,   err-5xx: 18,  err-codes: "12 × 504, 6 × 500"),
    (endpoint: "GET /reports/detail",     ok: 1191,  err-4xx: 0,   err-5xx: 9,   err-codes: "9 × 504"),
    (endpoint: "GET /dashboard",          ok: 9990,  err-4xx: 0,   err-5xx: 10,  err-codes: "10 × 504"),
  ),

  // Specific tuning — พร้อม SQL/config snippet ให้ Dev ใช้ได้เลย
  specific-tuning: (
    (
      target: "GET /employees?q= (search slow)",
      action: "Add B-tree index on tbl_employee.name",
      snippet: "CREATE INDEX idx_emp_name ON tbl_employee USING btree (name);
ANALYZE tbl_employee;",
      expected: "p95: 2,800ms → ~300ms (estimated 90% reduction)",
    ),
    (
      target: "GET /reports/summary (no caching)",
      action: "Enable Redis cache with TTL",
      snippet: "redis.setex(`report:summary:${dateRange}`, 300, JSON.stringify(result));
// TTL 300s = 5 min — invalidate on new leave entry",
      expected: "p95: 3,500ms → < 500ms (cache hit ratio ~85% expected)",
    ),
    (
      target: "Upstream timeout (504 errors)",
      action: "Increase HAProxy/Nginx upstream timeout",
      snippet: "# nginx.conf
proxy_connect_timeout 10s;
proxy_read_timeout    10s;  # was 5s
proxy_send_timeout    10s;",
      expected: "504 error rate: 2.1% → < 0.5% (cover tail latency)",
    ),
  ),
)


// ================================================================
// ----------------- ข้างล่างนี้ไม่ต้องแก้ปกติ -----------------
// ================================================================

// ---------- helper: verdict banner ----------
#let verdict-banner(kind, headline, detail) = {
  let (color, label, icon) = if kind == "pass" {
    (status-pass, "ผ่านเกณฑ์ พร้อมขึ้นใช้งาน", "✓")
  } else if kind == "conditional" {
    (status-block, "ผ่านแบบมีเงื่อนไข", "!")
  } else {
    (status-fail, "ยังไม่พร้อมขึ้นใช้งาน", "✗")
  }
  block(
    fill: color,
    radius: 6pt,
    inset: 16pt,
    width: 100%,
    breakable: false,
    grid(
      columns: (auto, 1fr),
      column-gutter: 16pt,
      align: (center + horizon, left + horizon),
      // Icon circle
      box(
        width: 48pt, height: 48pt,
        fill: white, radius: 50%,
        align(center + horizon, text(size: 22pt, weight: "bold", fill: color, icon))
      ),
      // Text
      stack(spacing: 6pt,
        text(size: 9pt, weight: "bold", fill: white, tracking: 1pt, upper("ผลการทดสอบโดยรวม")),
        text(size: 16pt, weight: "bold", fill: white, headline),
        text(size: 10pt, fill: white, detail),
      ),
    ),
  )
}

// ---------- helper: KPI tile (4 ใน 1 row) ----------
#let kpi-card(label, value, unit, note) = block(
  fill: ayodia-bg,
  stroke: (left: 3pt + ayodia-accent),
  radius: 4pt,
  inset: 12pt,
  width: 100%,
  breakable: false,
  stack(spacing: 4pt,
    text(size: 8.5pt, fill: ayodia-muted, weight: "bold", upper(label)),
    {
      text(size: 22pt, weight: "bold", fill: ayodia-primary, value)
      h(4pt)
      text(size: 10pt, fill: ayodia-muted, unit)
    },
    text(size: 8.5pt, fill: ayodia-accent, weight: "bold", note),
  )
)

#let kpi-row(items) = grid(
  columns: items.len() * (1fr,),
  column-gutter: 10pt,
  ..items.map(k => kpi-card(k.label, k.value, k.unit, k.note)),
)

// ---------- helper: NFR row with status colored cell ----------
#let nfr-status-cell(s) = {
  let (color, label) = if s == "pass" { (status-pass, "ผ่าน") }
    else if s == "fail" { (status-fail, "ไม่ผ่าน") }
    else { (status-block, "เฝ้าระวัง") }
  align(center, badge(label, fill: color))
}

// ─────────────────────────────────────────────────────────────
// CHART HELPERS (native typst — no external package)
// ─────────────────────────────────────────────────────────────

// Horizontal bar — value vs target (NFR marker shown as vertical line)
#let h-bar(label, value, target, max-val, unit: "ms", label-width: 7em, value-width: 5.5em) = {
  let bar-pct = calc.min(value / max-val, 0.99) * 100%
  let target-pct = calc.min(target / max-val, 0.99) * 100%
  let pass = value <= target
  let color = if pass { status-pass } else { status-fail }
  grid(
    columns: (label-width, 1fr, value-width),
    column-gutter: 6pt,
    align: (left + horizon, left + horizon, right + horizon),
    text(size: 8.5pt, label),
    box(width: 100%, height: 14pt, {
      // baseline track
      place(left + horizon, rect(width: 100%, height: 12pt, fill: rgb("#f1f5f9"), radius: 2pt))
      // value bar
      place(left + horizon, rect(width: bar-pct, height: 12pt, fill: color, radius: 2pt))
      // NFR target marker (vertical line)
      place(left + top, dx: target-pct, line(
        start: (0pt, 0pt), end: (0pt, 14pt),
        stroke: 2pt + ayodia-primary,
      ))
    }),
    text(size: 8.5pt, weight: "bold", fill: if pass { color } else { color }, [#value #unit]),
  )
}

// Vertical bar group — for stress test / soak trend
// data = array of (label, value, color?, note?)
#let v-bar-chart(data, max-val, height: 80pt, label-rotate: 0deg, value-unit: "ms") = {
  let bar-w = 100% / data.len()
  block(
    width: 100%,
    breakable: false,
    {
      // bars
      box(width: 100%, height: height, fill: rgb("#f8fafc"), stroke: (bottom: 1pt + ayodia-border), {
        for (i, d) in data.enumerate() {
          let h-pct = calc.min(d.value / max-val, 0.95)
          let color = d.at("color", default: ayodia-accent)
          place(
            left + bottom,
            dx: i * bar-w + 4pt,
            box(
              width: bar-w - 8pt,
              height: h-pct * height,
              fill: color,
              radius: (top: 2pt),
            ),
          )
          // value label on top of bar
          place(
            left + bottom,
            dx: i * bar-w,
            dy: -(h-pct * height) - 12pt,
            box(width: bar-w, align(center, text(size: 7.5pt, weight: "bold", fill: color, str(d.value)))),
          )
        }
      })
      // x-axis labels
      grid(
        columns: data.len() * (1fr,),
        ..data.map(d => align(center, text(size: 7.5pt, fill: ayodia-muted, d.label))).flatten(),
      )
    }
  )
}

// Terminal-style block — for k6 console output
#let terminal-block(content, title: "k6 console output") = block(
  width: 100%,
  breakable: true,
  stack(spacing: 0pt,
    // Title bar
    block(
      width: 100%,
      fill: rgb("#1e293b"),
      inset: (x: 10pt, y: 5pt),
      radius: (top: 4pt),
      stack(dir: ltr, spacing: 6pt,
        // Mac-style traffic lights
        circle(radius: 4pt, fill: rgb("#ef4444")),
        circle(radius: 4pt, fill: rgb("#eab308")),
        circle(radius: 4pt, fill: rgb("#22c55e")),
        h(8pt),
        text(font: "Menlo", size: 8pt, fill: rgb("#94a3b8"), title),
      ),
    ),
    // Body
    block(
      width: 100%,
      fill: rgb("#0f172a"),
      inset: 10pt,
      radius: (bottom: 4pt),
      text(font: "Menlo", size: 7.5pt, fill: rgb("#e2e8f0"), raw(content)),
    ),
  )
)

// Stacked horizontal bar — OK vs error count (HTTP status breakdown)
#let status-stack-bar(label, ok, err, max-val, label-width: 12em) = {
  let total = ok + err
  let total-pct = calc.min(total / max-val, 0.99) * 100%
  let ok-pct = if total > 0 { ok / total * 100% } else { 0% }
  let err-pct = if total > 0 { err / total * 100% } else { 0% }
  grid(
    columns: (label-width, 1fr, 7em),
    column-gutter: 6pt,
    align: (left + horizon, left + horizon, right + horizon),
    text(size: 8pt, raw(label)),
    box(width: 100%, height: 12pt, {
      place(left + horizon, rect(width: 100%, height: 10pt, fill: rgb("#f1f5f9"), radius: 2pt))
      place(left + horizon, box(width: total-pct, height: 10pt, {
        place(left + horizon, rect(width: ok-pct, height: 10pt, fill: status-pass, radius: (left: 2pt)))
        place(right + horizon, rect(width: err-pct, height: 10pt, fill: status-fail, radius: (right: 2pt)))
      }))
    }),
    {
      text(size: 7.5pt, fill: status-pass, weight: "bold", str(ok))
      text(size: 7.5pt, fill: ayodia-muted, " / ")
      text(size: 7.5pt, fill: if err > 0 { status-fail } else { ayodia-muted }, weight: "bold", str(err))
    },
  )
}

// ================================================================
// ----------------- DOCUMENT BODY -----------------
// ================================================================
#show: qa-doc.with(
  title:    data.project,
  subtitle: data.scope,
  doc-id:   data.doc-id,
  version:  data.version,
  date:     data.date,
  author:   data.author,
  reviewer: data.reviewer,
  approver: data.approver,
  doc-type: "Performance Test Report",
)

// ─────────────────────────────────────────────────────────────
= สรุปสำหรับผู้บริหาร (Executive Summary)
// ─────────────────────────────────────────────────────────────

#verdict-banner(data.verdict, data.verdict-text, data.verdict-detail)

#v(14pt)

== ตัวเลขสำคัญ (Key Numbers)

#kpi-row(data.kpi)

#v(12pt)

== สิ่งที่ลูกค้าควรทราบ (What This Means for You)

#for b in data.summary-bullets [
  - #eval(b, mode: "markup")
]

#v(10pt)

== รูปแบบการทดสอบ (Test Workload)

#text(size: 9pt, fill: ayodia-muted)[
  ช่วงเวลาทดสอบ: *#data.test-period* — รายละเอียดเชิงเทคนิคเพิ่มเติมแนบใน Appendix
]

#v(6pt)

#qa-table(
  columns: (auto, auto, auto, auto, auto),
  header: ([Test], [Executor], [Load Model], [Duration], [Requests]),
  ..data.workload.map(w => (
    text(weight: "bold", w.test),
    text(size: 9pt, fill: ayodia-muted, raw(w.executor)),
    align(center, text(weight: "bold", w.load)),
    align(center, w.duration),
    align(right, w.requests),
  )).flatten()
)

#text(size: 8.5pt, fill: ayodia-muted, style: "italic")[
  VUs = Virtual Users (ผู้ใช้จำลอง) • RPS = Requests Per Second (อัตราส่ง request) — เลือก executor ตาม workload จริง
]

// ─────────────────────────────────────────────────────────────
= ผลการทดสอบเทียบกับเกณฑ์ (NFR Evaluation)
// ─────────────────────────────────────────────────────────────

#text(size: 9.5pt, fill: ayodia-muted)[
  ตารางด้านล่างเทียบผลการทดสอบแต่ละฟังก์ชันกับเกณฑ์ที่ตกลงไว้ใน Test Plan / SLA — สีเขียว = ผ่าน, สีแดง = ไม่ผ่าน
]

#v(6pt)

#qa-table(
  columns: (1.2fr, 1.4fr, auto, auto, auto, auto, auto, auto, auto),
  header: (
    [ฟังก์ชัน], [Endpoint],
    [ตอบสนอง\ (ms)], [เกณฑ์],
    [TPS], [เกณฑ์],
    [Error\ (%)], [เกณฑ์],
    [ผล],
  ),
  ..data.nfr-rows.map(r => (
    text(weight: "bold", r.name),
    raw(r.endpoint),
    align(right, if r.status == "fail" {
      text(weight: "bold", fill: status-fail, r.p95)
    } else { r.p95 }),
    align(right, text(size: 9pt, fill: ayodia-muted, r.nfr-p95)),
    align(right, r.tps),
    align(right, text(size: 9pt, fill: ayodia-muted, r.nfr-tps)),
    align(right, r.err),
    align(right, text(size: 9pt, fill: ayodia-muted, r.nfr-err)),
    nfr-status-cell(r.status),
  )).flatten()
)

#v(6pt)

#let pass-count = data.nfr-rows.filter(r => r.status == "pass").len()
#let total-count = data.nfr-rows.len()
#let fail-count  = total-count - pass-count

#block(
  fill: ayodia-bg,
  inset: 10pt,
  radius: 3pt,
  text(size: 10pt)[
    *ภาพรวม:* ผ่านเกณฑ์ #pass-count / #total-count ฟังก์ชัน
    #if fail-count > 0 [— ไม่ผ่าน *#fail-count ฟังก์ชัน* (ดูรายละเอียดส่วนถัดไป)]
  ]
)

#v(12pt)

#let nfr-max = calc.max(..data.nfr-rows.map(r => float(r.p95.replace(",", ""))))
#let nfr-axis-max = nfr-max * 1.1  // 10% headroom

#block(
  breakable: false,
  width: 100%,
  stack(spacing: 6pt,
    heading(level: 2, "Response Time vs Target (Visual)"),
    text(size: 9pt, fill: ayodia-muted)[
      แท่งสี = p95 actual (เขียว=ผ่าน, แดง=ไม่ผ่าน) • เส้นแนวตั้งสีน้ำเงิน = NFR target
    ],
    block(
      inset: (x: 4pt, y: 6pt),
      fill: rgb("#fafbfc"),
      stroke: 0.5pt + ayodia-border,
      radius: 3pt,
      width: 100%,
      stack(spacing: 6pt,
        ..data.nfr-rows.map(r => h-bar(
          r.name,
          float(r.p95.replace(",", "")),
          float(r.nfr-p95.replace("≤ ", "").replace(",", "")),
          nfr-axis-max,
          unit: "ms",
        ))
      )
    ),
  )
)

// ─────────────────────────────────────────────────────────────
= จุดที่ต้องปรับปรุง + ข้อเสนอแนะ (Findings & Recommendations)
// ─────────────────────────────────────────────────────────────

== ฟังก์ชันที่ตอบสนองช้ากว่าเกณฑ์

#for (i, b) in data.bottlenecks.enumerate() [
  #block(
    breakable: false,
    stroke: (left: 3pt + status-fail),
    fill: rgb("#fef2f2"),
    inset: 12pt,
    radius: 3pt,
    width: 100%,
    above: 8pt,
    stack(spacing: 6pt,
      text(size: 11pt, weight: "bold", fill: ayodia-primary)[#(i + 1). #b.feature],
      grid(
        columns: (auto, 1fr),
        column-gutter: 8pt,
        row-gutter: 4pt,
        text(size: 9pt, fill: ayodia-muted, weight: "bold", "สังเกต:"),    text(size: 10pt, b.observation),
        text(size: 9pt, fill: ayodia-muted, weight: "bold", "สาเหตุ:"),   text(size: 10pt, b.cause),
        text(size: 9pt, fill: ayodia-muted, weight: "bold", "ผลกระทบ:"), text(size: 10pt, b.impact),
      )
    )
  )
]

== ข้อเสนอแนะ (Recommendations)

=== ต้องแก้ก่อนเปิดใช้งาน (Must Fix)
#for r in data.must-fix [
  - #r
]

=== ควรแก้หลัง Go-Live (Should Fix)
#for r in data.should-fix [
  - #r
]

=== ทำเมื่อมีโอกาส (Nice to Have)
#for r in data.nice-to-have [
  - #r
]

// ─────────────────────────────────────────────────────────────
= ข้อมูลเชิงเทคนิค (Technical Details — สำหรับทีม Dev)
// ─────────────────────────────────────────────────────────────

#block(
  fill: rgb("#eef2ff"),
  stroke: (left: 3pt + rgb("#4338ca")),
  inset: 8pt,
  radius: 3pt,
  text(size: 9pt)[
    *สำหรับทีม Dev / TL / Architect* — section นี้เก็บ percentile breakdown, error code, breaking point, memory observation และ tuning script พร้อมใช้ — ลูกค้าอาจข้ามได้
  ]
)

== Detailed Per-Endpoint Metrics

#text(size: 9pt, fill: ayodia-muted)[ทุก response time = ms • RPS = Requests Per Second • Error % = http_req_failed.rate × 100]

#v(4pt)

#qa-table(
  columns: (1.4fr, auto, auto, auto, auto, auto, auto, auto, auto, auto, 1.2fr),
  header: ([Endpoint], [avg], [min], [med], [p90], [p95], [p99], [max], [RPS], [Err%], [HTTP Errors]),
  ..data.detailed-metrics.map(m => (
    raw(m.endpoint),
    align(right, text(size: 8.5pt, m.avg)),
    align(right, text(size: 8.5pt, m.min)),
    align(right, text(size: 8.5pt, m.med)),
    align(right, text(size: 8.5pt, m.p90)),
    align(right, text(size: 8.5pt, weight: "bold", m.p95)),
    align(right, text(size: 8.5pt, m.p99)),
    align(right, text(size: 8.5pt, m.max)),
    align(right, text(size: 8.5pt, m.rps)),
    align(right, text(size: 8.5pt, m.err-pct)),
    text(size: 8pt, fill: ayodia-muted, m.error-codes),
  )).flatten()
)

== Stress Test — Breaking Point

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  align: (left + horizon, left),

  // Left: data table
  qa-table(
    columns: (auto, auto, auto, auto, auto),
    header: ([Load], [avg], [p95], [RPS], [Err%]),
    ..data.stress-levels.map(s => (
      text(weight: "bold", size: 9pt, s.load),
      align(right, text(size: 9pt, s.avg)),
      align(right, text(size: 9pt, s.p95)),
      align(right, text(size: 9pt, s.rps)),
      align(right, text(size: 9pt, s.err)),
    )).flatten()
  ),

  // Right: chart (p95 vs load)
  block(breakable: false, {
    text(size: 8.5pt, fill: ayodia-muted)[p95 Response Time vs Load (ms)]
    v(4pt)
    let stress-max = calc.max(..data.stress-levels.map(s => float(s.p95.replace(",", ""))))
    v-bar-chart(
      data.stress-levels.map(s => (
        label: s.load,
        value: float(s.p95.replace(",", "")),
        color: if float(s.err) > 5 { status-fail }
              else if float(s.err) > 1 { status-block }
              else { status-pass },
      )),
      stress-max * 1.1,
      height: 70pt,
    )
    v(4pt)
    text(size: 7.5pt, fill: ayodia-muted)[
      เขียว = error < 1% • ส้ม = degradation • แดง = breaking
    ]
  }),
)

#v(6pt)

#block(
  fill: rgb("#fef2f2"),
  stroke: (left: 3pt + status-fail),
  inset: 8pt,
  radius: 3pt,
  text(size: 10pt)[*Breaking Point:* #data.breaking-point]
)

#if data.soak != none [
  == Soak Test — Memory Trend (4 hours)

  #block(breakable: false, {
    grid(
      columns: (auto, 1fr),
      column-gutter: 14pt,
      align: (left + top, left + top),

      qa-table(
        columns: (auto, auto, auto),
        header: ([Hour], [#data.soak.metric], [GC Pauses]),
        ..data.soak.rows.map(r => (
          align(center, text(size: 9pt, r.hour)),
          align(right, text(size: 9pt, r.value)),
          align(right, text(size: 9pt, r.gc-pauses)),
        )).flatten()
      ),

      // Memory trend chart — extract numeric value from "512 MB" → 512
      {
        text(size: 8.5pt, fill: ayodia-muted)[Heap Used trend (MB) — แท่งสูงขึ้น = memory growth]
        v(4pt)
        let soak-vals = data.soak.rows.map(r =>
          float(r.value.replace(" MB", "").replace(",", ""))
        )
        let soak-max = calc.max(..soak-vals)
        v-bar-chart(
          data.soak.rows.zip(soak-vals).map(((r, val)) => (
            label: "h" + r.hour,
            value: val,
            color: rgb("#d97706"),  // amber — caution
          )),
          soak-max * 1.1,
          height: 65pt,
        )
      }
    )
    v(8pt)
    block(
      fill: rgb("#fef3c7"),
      stroke: (left: 3pt + rgb("#d97706")),
      inset: 10pt,
      radius: 3pt,
      width: 100%,
      text(size: 9.5pt)[*Observation:* #data.soak.observation]
    )
  })
]

== Evidence — k6 Run Output

#text(size: 9pt, fill: ayodia-muted)[
  Output ที่ k6 print ออกมาตอน run จบ — proof ของการทดสอบจริง (ดูครบทุก threshold + check + metric)
]

#v(6pt)

#terminal-block(data.k6-output, title: "$ k6 run leave-load.js --summary-export=results-load.json")

#v(10pt)

== k6 Thresholds — Pass/Fail Summary

#text(size: 9pt, fill: ayodia-muted)[
  Threshold ที่กำหนดใน k6 script (`thresholds: { ... }`) — k6 จะ exit code 99 ถ้าไม่ผ่าน
]

#v(6pt)

#qa-table(
  columns: (2.2fr, 1.2fr, auto, auto),
  header: ([Threshold], [Expected], [Actual], [Status]),
  ..data.k6-thresholds.map(t => (
    raw(t.name),
    align(center, text(font: "Menlo", size: 8.5pt, t.expected)),
    align(right, text(weight: "bold",
      fill: if t.status == "fail" { status-fail } else { status-pass },
      t.actual)),
    nfr-status-cell(t.status),
  )).flatten()
)

#v(10pt)

== HTTP Status Code Breakdown

#text(size: 9pt, fill: ayodia-muted)[
  สัดส่วน 2xx (เขียว) vs 4xx/5xx (แดง) ต่อ endpoint — จาก k6 metric `http_reqs{name:X,status:Y}`
]

#v(6pt)

#block(
  breakable: false,
  inset: (x: 4pt, y: 8pt),
  fill: rgb("#fafbfc"),
  stroke: 0.5pt + ayodia-border,
  radius: 3pt,
  width: 100%,
  {
    let max-total = calc.max(..data.http-status-breakdown.map(r => r.ok + r.err-4xx + r.err-5xx))
    stack(spacing: 5pt,
      ..data.http-status-breakdown.map(r => status-stack-bar(
        r.endpoint,
        r.ok,
        r.err-4xx + r.err-5xx,
        max-total,
      )),
      v(4pt),
      text(size: 7.5pt, fill: ayodia-muted, style: "italic")[
        เขียว = 2xx OK • แดง = 4xx/5xx error • ตัวเลขขวา = OK count / Error count
      ],
    )
  }
)

#v(8pt)

#block(
  fill: ayodia-bg,
  inset: 8pt,
  radius: 3pt,
  width: 100%,
  text(size: 8.5pt, fill: ayodia-muted)[
    *HTTP Error Detail per Endpoint:* #data.http-status-breakdown.filter(r => r.err-4xx + r.err-5xx > 0).map(r =>
      r.endpoint + " → " + r.err-codes
    ).join(" • ")
  ]
)

== Specific Tuning Scripts

#for (i, t) in data.specific-tuning.enumerate() [
  #block(
    breakable: false,
    stroke: (left: 3pt + ayodia-accent),
    fill: ayodia-bg,
    inset: 10pt,
    radius: 3pt,
    width: 100%,
    above: 8pt,
    stack(spacing: 6pt,
      grid(
        columns: (auto, 1fr),
        column-gutter: 8pt,
        text(size: 10pt, weight: "bold", fill: ayodia-primary)[#(i + 1). #t.action],
        align(right, text(size: 8.5pt, fill: ayodia-muted, style: "italic", t.target)),
      ),
      block(
        fill: rgb("#0f172a"),
        inset: 8pt,
        radius: 3pt,
        width: 100%,
        text(font: "Menlo", size: 8.5pt, fill: rgb("#e2e8f0"), raw(t.snippet))
      ),
      text(size: 9pt)[*Expected impact:* #t.expected],
    )
  )
]

// ─────────────────────────────────────────────────────────────
= สรุปและขั้นตอนถัดไป (Conclusion & Next Steps)
// ─────────────────────────────────────────────────────────────

== ข้อสรุป

#verdict-banner(data.verdict, data.verdict-text, data.verdict-detail)

#v(10pt)

== แผนการดำเนินการที่แนะนำ

#qa-table(
  columns: (auto, 1fr),
  header: ([ระยะเวลา], [การดำเนินการ]),
  ..data.next-steps.map(n => (
    text(weight: "bold", fill: ayodia-accent, n.when),
    n.action,
  )).flatten()
)

#v(14pt)

== การอนุมัติ (Sign-off)

#signoff-table(("QA Lead", "Technical Lead", "Project Manager", "ลูกค้า / Customer"))

#v(20pt)

#text(size: 8.5pt, fill: ayodia-muted, style: "italic")[
  เอกสารนี้จัดทำเพื่อสรุปผลการทดสอบสมรรถนะ (Performance Test) ของระบบ #data.scope สำหรับ #data.customer
  รายละเอียดเชิงเทคนิค (raw k6 JSON, threshold export, individual run logs) สามารถขอเพิ่มเติมจากทีม QA ได้
]
