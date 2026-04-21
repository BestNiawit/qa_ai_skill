---
name: perf-result-analyzer
description: วิเคราะห์ผล Performance Test จาก raw data (k6 JSON summary, JMeter Aggregate CSV, Gatling stats) — คำนวณ Avg/p95/p99 Response Time, Throughput (TPS), Error Rate per endpoint + เทียบกับ NFR (Pass/Fail) + ระบุ Bottleneck (transaction ช้าที่สุด, error เกิดตรงไหน) + Recommendation (tuning DB/caching/infra). Trigger เมื่อ user ขอ analyze perf result, performance analysis, bottleneck analysis, "วิเคราะห์ผล load test", "analyze k6 result", "analyze JMeter result", "bottleneck analysis", "tuning recommendation". Maps to SDP §5.3.1 (Process 11 — วิเคราะห์ผล Perf Test).
---

# Performance Result Analyzer

> **คำย่อ (NFR / TPS / p95 / p99 / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

วิเคราะห์ raw result จาก load test tool (k6/JMeter/Gatling) → Bottleneck + NFR Evaluation + Tuning Recommendation

**Effort savings:** ~50% (SDP §5.3.4) — QC ไม่ต้อง build analysis table เอง

**Output:**
- Per-endpoint table: Avg / p95 / p99 / Throughput / Error Rate vs NFR → Pass/Fail
- Stress Test table: Metric at each concurrent users level
- Bottleneck: top 3 slowest transactions + error hotspot
- Tuning Recommendation: DB query / Caching / Infra / Code optimization

**รองรับ format:**
- **k6** JSON summary (`reports/results-*.json`)
- **JMeter** Aggregate Report CSV
- **Gatling** stats JSON / Global Stats
- **Generic CSV** (columns: endpoint, avg_ms, p95_ms, p99_ms, throughput, error_pct)

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 11 — วิเคราะห์ผล Perf Test

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| วิเคราะห์ผล k6/JMeter/Gatling | **`perf-result-analyzer`** (skill นี้) |
| ยังไม่ได้ run test | `perf-test-generator` ก่อน |
| อยากสรุปเป็น Report ส่ง TL | `test-report-writer` (mode=perf) — รับ input จาก skill นี้ |
| Threshold fail → เปิด defect | `bug-report-writer` |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Raw result file | ✅ | k6 JSON / JMeter CSV / Gatling stats |
| NFR (per endpoint หรือ global) | ✅ | p(95), p(99), Throughput, Error Rate |
| Test metadata | ✅ | test type (load/stress/soak/spike), duration, concurrent users / RPS |
| Business context | ⚠️ | Transaction criticality (login > search > report) |
| Production baseline | ⚠️ | สำหรับ compare relative improvement |
| `project-context.md` | ⚠️ | architecture, DB type, caching layer, infra |

**NFR Example:**
```
- p(95) Response Time ≤ 3 วินาที
- p(99) Response Time ≤ 5 วินาที
- Throughput ≥ 100 TPS
- Error Rate ≤ 1%
```

---

## 4. Outputs — สิ่งที่ได้

**Format:** Markdown analysis report (ส่งต่อให้ `test-report-writer`)

**Template:** [`templates/perf-analysis.md`](templates/perf-analysis.md)

**File naming:** `perf_analysis_<scope>_<YYYYMMDD>.md`

**Structure:**
```
# Performance Analysis — <Scope>
## Test Metadata
- Test type: Load / Stress / Soak / Spike
- Duration, Concurrent Users / RPS, Total Requests

## Per-Endpoint Analysis
| Endpoint | Avg | p(95) | p(99) | TPS | Error % | NFR p95 | NFR TPS | NFR Err | Status |
|----------|-----|-------|-------|-----|---------|---------|---------|---------|--------|
| /login   | 120 | 450   | 800   | 85  | 0.3%    | ≤600ms  | ≥80     | ≤1%     | ✅ Pass |
| /search  | 350 | 2800  | 4500  | 45  | 2.1%    | ≤1000ms | ≥50     | ≤1%     | ❌ Fail |

## Stress Test — Metric per Load Level
| Concurrent Users | Avg | p(95) | TPS | Error % | Note |
|------------------|-----|-------|-----|---------|------|
| 50  | 200  | 500  | 45  | 0.1% | OK |
| 100 | 350  | 900  | 80  | 0.5% | OK |
| 200 | 800  | 2500 | 95  | 3.2% | ⚠️ degradation |
| 400 | ...  | ...  | ...  | ... | ❌ breaking point |

## Bottleneck
### Top 3 Slowest Transactions
1. **GET /api/search** — p(95)=2800ms — fails NFR (≤1000ms)
   - Hypothesis: DB query without index / N+1 query
2. **POST /api/report/generate** — p(95)=3500ms — fails NFR (≤2000ms)
   - Hypothesis: Large aggregation, no caching
3. ...

### Error Hotspot
- **GET /api/search** — Error Rate 2.1% (mostly 504 Gateway Timeout)
  - Hypothesis: Upstream timeout at 5s, some queries > 5s

## Recommendations
### Must Fix (Block Go-Live)
1. **Add DB index** on `tbl_product.name` — reduce search p(95) จาก 2800ms → ~300ms (คาด)
2. **Enable Redis cache** สำหรับ /api/report — TTL 5min

### Should Fix (Post Go-Live)
1. Increase upstream timeout จาก 5s → 10s (mitigate 504)
2. Add CDN สำหรับ static assets

### Nice to Have
1. Consider read replica DB (horizontal scale)

## Conclusion
- **Ready for Go-Live:** ❌ ไม่พร้อม — ต้องแก้ 2 Must Fix ก่อน
- **Re-test required:** ใช่ (หลัง add DB index + Redis cache)
```

---

## 5. Process — ขั้นตอน

### Step 1: Parse Raw Data

**k6 JSON summary:**
```js
// reports/results-<timestamp>.json
{
  "metrics": {
    "http_req_duration{name:login}": {"avg": 120, "p(95)": 450, "p(99)": 800},
    "http_req_failed{name:login}": {"rate": 0.003},
    ...
  }
}
```

**JMeter Aggregate CSV:**
```csv
Label,# Samples,Average,Median,90% Line,95% Line,99% Line,Min,Max,Error %,Throughput,Received KB/sec,Sent KB/sec
/login,1000,120,115,400,450,800,50,1200,0.3%,85/sec,12.5,3.2
```

**Gatling stats JSON:**
```json
{
  "contents": {
    "login": {"stats": {"mean": 120, "percentiles95": 450, ...}}
  }
}
```

### Step 2: Compute per-endpoint metrics
- Avg, p(50), p(95), p(99) response time
- Throughput (TPS, req/s)
- Error Rate (%)
- Request count

### Step 3: Compare vs NFR
สำหรับแต่ละ endpoint — เทียบกับ NFR threshold → Pass/Fail

### Step 4: Identify Bottleneck

**Algorithm:**
1. **Slowest transactions**: sort by p(95) DESC, take top 3 ที่ > NFR threshold
2. **Error hotspot**: sort by error_rate DESC, take top 3 ที่ > 1%
3. **Correlation**: ถ้า slow endpoint มี high error → hypothesis "timeout"
4. **Stress test pattern**: หา "breaking point" — level ที่ error rate jump > 5%

### Step 5: Generate Hypothesis

| Pattern | Hypothesis |
|---------|-----------|
| p(95) ช้าแต่ Avg ปกติ | Tail latency — GC pause / DB lock spike |
| p(95) + Avg ช้าทั้งคู่ | Systematic — query without index / N+1 |
| Error rate สูง + 504/502 | Upstream timeout / circuit breaker |
| Error rate สูง + 500 | App error — check app log |
| Throughput drop เมื่อ VUs เพิ่ม | Saturation — CPU/Memory/Connection pool |
| Memory leak pattern (soak) | Heap grow over time — review object lifecycle |

### Step 6: Recommend Tuning

**Checklist common tunings:**
- [ ] DB index (missing index on WHERE/JOIN)
- [ ] N+1 query (use eager loading / batch)
- [ ] Caching (Redis/Memcached for hot read)
- [ ] CDN (static assets)
- [ ] Connection pool size
- [ ] Thread pool / worker count
- [ ] Upstream timeout
- [ ] Compression (gzip/brotli)
- [ ] Pagination (avoid N rows)

### Step 7: Save + Summary
- Must Fix count
- Re-test required: Yes/No
- Ready for Go-Live: Yes/Conditional/No

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have
- [ ] Per-endpoint table มี Pass/Fail column เทียบ NFR
- [ ] Bottleneck ≥ 1 ตัว ถ้ามี endpoint fail (ถ้าไม่ fail ไม่ต้องบังคับ)
- [ ] Hypothesis สำหรับแต่ละ bottleneck
- [ ] Recommendation แยกเป็น Must / Should / Nice
- [ ] Conclusion: Ready / Not Ready / Conditional
- [ ] ตัวเลขตรงกับ raw data (sample verify 2-3 row)

### Nice to Have
- [ ] Stress Test — breaking point identified
- [ ] Soak Test — memory trend graph (ถ้ามี)
- [ ] Compare vs Production baseline

### Red Flags (Reject)
- ❌ ตัวเลขไม่ตรงกับ raw file
- ❌ ไม่เทียบกับ NFR (skip Pass/Fail)
- ❌ Recommendation ไม่ specific ("optimize DB" → ควรระบุ column/query/index)
- ❌ Conclusion = Ready แต่มี endpoint fail NFR

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ⚠️ **AI อาจคำนวณ p95/p99 ผิด** ถ้า raw data unit ไม่ตรง (ms vs s) → verify unit ก่อน
- ⚠️ **AI อาจ Hallucinate Hypothesis** (เดาว่า "DB slow" โดยไม่มี evidence) → ต้อง flag เป็น "hypothesis" ไม่ใช่ "fact"
- ❌ AI ไม่ควร **approve Go-Live** ถ้ามี endpoint fail NFR โดยไม่มี Waiver

**ข้อห้าม:**
- ❌ เดา infrastructure/architecture ถ้า user ไม่ระบุ (`project-context.md`)
- ❌ Copy tuning recommendation generic (ต้อง map กับ bottleneck จริง)
- ❌ ใส่ผลลัพธ์จริง (customer name, IP) ใน analysis → redact

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `perf-test-generator` — k6 script → raw result JSON
- JMeter / Gatling run output (external)
- NFR document

**Downstream:**
- `test-report-writer` (mode=perf) — ใช้ analysis นี้เป็น content
- `bug-report-writer` — ถ้า endpoint fail NFR → defect
- [Dev team] — Tuning Recommendation → implement

**Workflow ตัวอย่าง:**
```
perf-test-generator → [k6 run] → results-xxx.json
                                       ↓
                         perf-result-analyzer → perf_analysis.md
                                       ↓
                         test-report-writer (mode=perf) → perf_test_report.md
                                       ↓
                         [TL review] → Go / No-Go
                                ↓
                          (No-Go) → bug-report-writer → [Dev fix] → re-test
```

---

## Example: NFR Evaluation Table

```
| Endpoint         | p(95)  | NFR     | Throughput | NFR   | Error % | NFR    | Status |
|------------------|--------|---------|------------|-------|---------|--------|--------|
| /auth/login      | 450ms  | ≤600ms  | 85 TPS     | ≥80   | 0.3%    | ≤1%    | ✅ Pass |
| /employees?q=    | 2800ms | ≤1000ms | 45 TPS     | ≥50   | 2.1%    | ≤1%    | ❌ Fail |
| /leave (POST)    | 600ms  | ≤800ms  | 30 TPS     | ≥25   | 0.5%    | ≤1%    | ✅ Pass |
| /reports/summary | 3500ms | ≤2000ms | 10 TPS     | ≥15   | 1.8%    | ≤1%    | ❌ Fail |
```

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- `templates/perf-analysis.md`
- External: k6 docs (metrics), JMeter Aggregate Report, Brendan Gregg's USE Method, Google SRE book (SLO/SLI)
