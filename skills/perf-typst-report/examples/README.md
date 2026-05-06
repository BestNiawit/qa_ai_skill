# perf-typst-report — Examples

ตัวอย่างการ feed k6 raw → AI → typst → PDF

## ไฟล์ใน folder นี้

| ไฟล์ | คำอธิบาย |
|------|---------|
| `k6-summary-sample.json` | Sample k6 summary export (จาก `k6 run --summary-export=...`) — 8 endpoints, load test 500 VUs × 30 min |

## วิธีใช้ทั้ง flow

### 1. Run k6 + export raw

```bash
k6 run --summary-export=results-load.json script.js
```

### 2. (Optional) Analyze ก่อน

```
"ช่วย analyze k6 result นี้ให้หน่อย: results-load.json + NFR..."
→ skill = perf-result-analyzer → perf_analysis_<scope>.md
```

### 3. Generate Typst Report

```
"สร้าง perf report PDF ส่งลูกค้า — k6 file = results-load.json,
 customer = บริษัท ABC, scope = Leave Management, NFR ตาม Test Plan"
→ skill = perf-typst-report → perf_report_leave_20260430.typ
```

### 4. Compile

```bash
typst compile \
  --root /path/to/qa_ai_skill \
  outputs/perf/perf_report_leave_20260430.typ \
  outputs/perf/perf_report_leave_20260430.pdf
```

## ตัวอย่าง mapping k6 JSON → data block

จาก `k6-summary-sample.json`:

```json
"http_req_duration{name:login}": {
  "values": {"avg": 118.4, "p(95)": 450, "p(99)": 803}
},
"http_req_failed{name:login}": {"values": {"rate": 0.0031}},
"http_reqs{name:login}": {"values": {"rate": 85.2}}
```

→ ใน `templates/perf-report.typ`:

```typ
(name: "เข้าสู่ระบบ", endpoint: "POST /auth/login",
 p95: "450",     // ปัด p(95) = 450ms
 nfr-p95: "≤ 600",
 tps: "85",      // ปัด http_reqs.rate = 85.2
 nfr-tps: "≥ 80",
 err: "0.3",     // 0.0031 × 100 = 0.31%
 nfr-err: "≤ 1",
 status: "pass"  // 450 ≤ 600 ✓ AND 85 ≥ 80 ✓ AND 0.3 ≤ 1 ✓
),
```

## Verdict logic

| Condition | Verdict |
|-----------|---------|
| ทุก endpoint pass + error rate < 1% | `pass` (เขียว) |
| มี endpoint fail ≤ 30% AND ไม่มี Critical (login/payment) fail | `conditional` (ส้ม) |
| Critical endpoint fail OR fail > 30% | `fail` (แดง) |

จาก sample (8 endpoints, 2 fail = 25% — search + report ไม่ใช่ Critical):
→ `verdict: "conditional"` ✅ (ตรงกับ template default)
