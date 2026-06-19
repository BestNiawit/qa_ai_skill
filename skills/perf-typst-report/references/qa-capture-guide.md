# QA Capture Guide — Evidence สำหรับ perf-typst-report

> Skill นี้รองรับ 2 mode: **k6-only (default — ไม่ต้องแคปรูป)** และ **Full mode (เสริมด้วย Grafana/APM/Server)** ถ้าทีมมี monitoring access

## Mode 1: k6-only (Default — แนะนำ)

**ใช้เมื่อ:** ทีม QA ไม่ได้เข้า Grafana/APM/Cloud monitoring ของ Dev (case ส่วนใหญ่)

**ต้องเตรียม:** แค่ **2 อย่างเท่านั้น** — ทั้งคู่จาก k6:

### A. k6 JSON summary (raw data)
```bash
k6 run --summary-export=results-load.json script.js
```
→ ส่งไฟล์ `results-load.json` ให้ AI parse → fill `nfr-rows` / `detailed-metrics` / `http-status-breakdown` ใน data block อัตโนมัติ

### B. k6 console final output (terminal text)
ตอน `k6 run` จบ — copy ทั้ง block ที่ขึ้นใน terminal (ตั้งแต่ `execution: local` จนถึง `running (...)` line)

วาง paste เข้าไปใน data block:
```typ
k6-output: "
   execution: local
      script: leave-load.js
      ...
   ✓ status is 200
   ✗ search response < 1s
     ↳  72% — ✓ 32,400 / ✗ 12,600
   ...
   http_req_duration..............: avg=485ms  p(95)=1.42s
   http_req_failed................: 0.71%   ✓ 3,184  ✗ 444,816
   ...
   running (30m00.4s), 000/500 VUs
",
```

→ template จะ render เป็น **terminal-style block** (ดำ/เขียว เหมือน iTerm2) ใน Tech Section

### ทำไม 2 อย่างนี้พอ?
- JSON → ตัวเลขทุก endpoint + percentile ครบ → render charts (Response Time, Stress, HTTP status) ได้หมด
- Console output → proof ว่า run จริง + threshold result + iteration count → ลูกค้า verify ได้
- รวมกันแล้วลูกค้าเห็น: ตัวเลข, แนวโน้ม, error breakdown, threshold pass/fail — ครบ "credibility loop" โดยไม่ต้องพึ่ง screenshot

---

## Mode 2: Full mode (เสริมด้วย Grafana/APM/Server)

**ใช้เมื่อ:** ทีมมี access เข้า monitoring stack + ต้องการ visual proof เพิ่ม (high-stakes report เช่น Go-Live decision)

### B1. Grafana Dashboard — ระหว่าง Peak Load

**เมื่อไหร่:** ระหว่างที่ k6 run อยู่ (peak phase) — load test 30 min, แคปนาทีที่ 15-25

**แคปอะไร:** CPU / Memory / Network I/O / DB connection pool / Active VUs

**Tool:** Grafana → "Share" → "Snapshot" หรือ "Save dashboard as PDF"

**Save:** `outputs/perf/assets/grafana-snapshot-<scope>.png` (PNG 1600×900)

### B2. APM Trace — Slowest Transaction

**เมื่อไหร่:** หลัง test เสร็จ → ดู trace ที่ p99 / max latency

**แคปอะไร:** breakdown ของ slowest transaction — HTTP request line + DB query span + external HTTP + function trace

**Tool ที่ใช้บ่อย:**
| Tool | วิธีหา trace ช้าสุด |
|------|--------------------|
| Datadog APM | Traces → Filter duration > Xms → Click |
| NewRelic | APM → Distributed Tracing → Sort by duration |
| Jaeger | Search → tag `http.status_code=200` + sort duration desc |
| Elastic APM | APM → Services → Slowest Transactions |

**Save:** `outputs/perf/assets/apm-trace-<endpoint>.png`

### B3. Server Resource Utilization

**เมื่อไหร่:** ระหว่างทดสอบ (timeline ทั้งช่วง — เห็น baseline → peak → cooldown)

**แคปอะไร:** CPU % per core / Memory used / Disk I/O / Network bandwidth

**Tool:**
| Source | วิธีแคป |
|--------|--------|
| AWS | CloudWatch → EC2 metrics → 1 hour view |
| GCP | Cloud Monitoring → VM Instance dashboard |
| Azure | Azure Monitor → VM Insights |
| Linux self-host | `dstat`/`glances` หรือ Grafana node-exporter |
| Kubernetes | k9s metrics หรือ k8s dashboard |

**Save:** `outputs/perf/assets/server-resource-<scope>.png`

### วิธี attach รูป (Full mode)
ใส่ block ใหม่ใน template หลัง HTTP Status Breakdown:
```typ
== Monitoring Evidence (Optional)
#stack(spacing: 10pt,
  block(stack(spacing: 4pt,
    image("../assets/grafana-snapshot-leave.png", width: 100%),
    align(center, text(size: 8.5pt, fill: oned-muted, style: "italic",
      "Grafana ระหว่าง peak load (500 VUs × 30 min) — peak CPU 78%, Memory 4.2/8 GB")),
  )),
  // ทำซ้ำกับ APM + Server
)
```

---

## ข้อควรระวัง (ทั้ง 2 modes)

- **k6 console** — copy ทั้ง block, อย่าตัด threshold lines ออก (✓/✗ คือ key proof)
- **ห้ามใส่ PII / customer IP / hostname จริง** ใน screenshot (Full mode) — blur/redact ก่อนใส่
- **ห้ามใส่ password/API key** ที่อาจติดมาใน screenshot (พบบ่อยใน DB connection string)
- **timestamp** ต้องเห็นใน screenshot เสมอ — ลูกค้าต้องเช็คได้ว่าตรงกับช่วงทดสอบ
- รูปขนาดใหญ่เกิน → typst จะ render เต็ม column width อัตโนมัติ ไม่ต้อง resize

---

## รูปเสริม (optional add-on)

| รูป | เมื่อใช้ |
|-----|---------|
| Slow query log (DB) | ถ้า hypothesis = DB slow → snapshot ของ pg_stat_statements / slow query log |
| GC log | ถ้า soak test → memory issue |
| Load balancer metrics | ถ้ามี LB → request distribution per backend |
