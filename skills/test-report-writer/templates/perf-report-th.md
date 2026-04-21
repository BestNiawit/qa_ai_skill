# Performance Test Report — <Module/Scope>

| Field | Value |
|-------|-------|
| Document ID | `PERF_REPORT_<SCOPE>_v1.0` |
| Date | YYYY-MM-DD |
| Test Period | YYYY-MM-DD → YYYY-MM-DD |
| Author | <QC Lead + TL> |
| Reviewer | <Architect> |
| Approver | <PM> |
| Reference Plan | `PERF_PLAN_<SCOPE>_v1.0` |

---

## 1. Executive Summary

<สรุป: Ready / Not Ready สำหรับ Go-Live + จำนวน endpoint pass/fail>

ตัวอย่าง:
> Perf Test สำหรับ Leave Management เสร็จสิ้น ณ 2026-04-30
> ทดสอบ Load (500 VUs × 30 min), Stress (up to 1500), Soak (300 VUs × 4h)
> Pass 6/8 endpoint — Fail 2 endpoint (search, report)
>
> **Recommendation:** ❌ Not Ready — แก้ DB index + Redis cache ก่อน re-test

---

## 2. Workload Summary

| Test Type | Executor | Workload | Duration | Total Requests |
|-----------|----------|----------|---------:|---------------:|
| Smoke | constant-vus | 1 VU | 30s | 30 |
| Load | ramping-vus | 500 VUs | 30 min | 450,000 |
| Stress | ramping-vus | 100 → 1500 VUs | 45 min | 800,000 |
| Soak | constant-vus | 300 VUs | 4 hours | 1,800,000 |
| Spike | ramping-arrival-rate | 100 → 2000 RPS | 30s burst | 30,000 |

---

## 3. NFR Evaluation per Endpoint

| Endpoint | p(95) | NFR p95 | Throughput | NFR TPS | Error % | NFR Err | Status |
|----------|------:|--------:|-----------:|--------:|--------:|--------:|:------:|
| POST /auth/login | 450ms | ≤600ms | 85 TPS | ≥80 | 0.3% | ≤1% | ✅ Pass |
| GET /employees?q= | **2800ms** | ≤1000ms | 45 TPS | ≥50 | 2.1% | ≤1% | ❌ Fail |
| POST /leave | 600ms | ≤800ms | 30 TPS | ≥30 | 0.5% | ≤1% | ✅ Pass |
| PATCH /leave/approve | 550ms | ≤800ms | 25 TPS | ≥20 | 0.2% | ≤1% | ✅ Pass |
| GET /leave/history | 800ms | ≤1000ms | 40 TPS | ≥30 | 0.4% | ≤1% | ✅ Pass |
| GET /reports/summary | **3500ms** | ≤2000ms | 10 TPS | ≥15 | 1.8% | ≤1% | ❌ Fail |
| GET /reports/detail | 1800ms | ≤2000ms | 12 TPS | ≥10 | 0.7% | ≤1% | ✅ Pass |
| GET /dashboard | 350ms | ≤500ms | 100 TPS | ≥80 | 0.1% | ≤1% | ✅ Pass |

**Overall:** ❌ 2 endpoints fail NFR (search, report)

---

## 4. Stress Test — Metric per Load Level

| Concurrent Users | Avg | p(95) | TPS | Error % | Note |
|-----------------:|----:|------:|----:|--------:|------|
| 100 | 200ms | 500ms | 85 | 0.1% | OK |
| 500 | 400ms | 900ms | 280 | 0.3% | OK (target load) |
| 1000 | 800ms | 2200ms | 450 | 1.5% | ⚠️ Degradation |
| 1500 | **2500ms** | **6000ms** | 520 | **8.2%** | ❌ Breaking point |

**Breaking Point:** ~1200 concurrent users (error rate > 5%)

---

## 5. Soak Test (Memory Leak Check)

| Hour | Heap Used | Old Gen | GC Pauses |
|------|----------:|--------:|----------:|
| 0 | 512 MB | 200 MB | 5 |
| 1 | 580 MB | 250 MB | 8 |
| 2 | 640 MB | 290 MB | 10 |
| 3 | 700 MB | 335 MB | 12 |
| 4 | 750 MB | 370 MB | 15 |

**Observation:** Heap กำลังเพิ่มขึ้นช้าๆ — possible memory leak
**Recommendation:** ต้องตรวจ heap dump เพิ่มเติม, แต่ยังไม่ block Go-Live

---

## 6. Bottleneck Analysis (จาก `perf-result-analyzer`)

### 6.1 Top Slowest Transactions
1. **GET /employees?q=** — p(95)=2800ms (NFR ≤1000ms)
   - Hypothesis: DB full-table scan (no index on `tbl_employee.name`)
2. **GET /reports/summary** — p(95)=3500ms (NFR ≤2000ms)
   - Hypothesis: Large aggregation (SUM, GROUP BY) no caching

### 6.2 Error Hotspot
- **GET /employees?q=** — 2.1% error (504 Gateway Timeout)
  - Hypothesis: Upstream timeout at 5s, some queries > 5s

---

## 7. Tuning Recommendation

### 7.1 Must Fix (Block Go-Live)
1. **DB Index:** `CREATE INDEX idx_emp_name ON tbl_employee(name)` — คาดลด p(95) จาก 2800ms → ~300ms
2. **Redis Cache:** Cache `/reports/summary` response — TTL 5 นาที

### 7.2 Should Fix (Post Go-Live)
1. Upstream timeout: 5s → 10s (mitigate 504)
2. Pagination `/reports/detail` — จำกัด 100 rows/page
3. Investigate heap leak (4-hour soak เพิ่ม 240 MB)

### 7.3 Nice to Have
1. CDN for static assets
2. Read replica DB สำหรับ `/reports/*`
3. Horizontal scaling plan (from stress breaking point 1200 → target 2000+)

---

## 8. Estimate vs Actual (Hours)

> qa-standards §4

| Phase | Estimated | Actual | Variance | Note |
|-------|----------:|-------:|---------:|------|
| Script Prep | 16 hr | 14 hr | -12% | AI generate k6 ได้ช่วย |
| Load Test | 2 hr | 2 hr | 0% | |
| Stress Test | 3 hr | 3 hr | 0% | |
| Soak Test | 5 hr | 5 hr | 0% | |
| Analysis + Report | 8 hr | 4 hr | -50% | AI-assisted |
| Tuning + Re-test | 8 hr | — | — | pending |
| **Total (so far)** | **42 hr** | **28 hr** | **-33%** | AI ช่วยเยอะ |

---

## 9. AI Effort Savings (KPI)

> qa-standards §6

| Artifact | AI Draft | Human Review | Total | Baseline | Savings |
|----------|---------:|-------------:|------:|---------:|--------:|
| Perf Test Plan | 30 min | 3.5 hr | 4 hr | 8 hr | **50%** ✅ |
| k6 Scripts (8 endpoints) | 1 hr | 13 hr | 14 hr | 16 hr | **13%** ⚠️ |
| Bottleneck Analysis | 20 min | 2 hr | 2.3 hr | 4 hr | **42%** ✅ |
| Perf Report (this doc) | 20 min | 1.7 hr | 2 hr | 8 hr | **75%** ✅ |
| **Total** | | | **22.3 hr** | **36 hr** | **38%** |

**Note:** k6 script savings ต่ำเพราะ customize parameterization เยอะ — target revise ถ้า pattern reuse ได้

---

## 10. Conclusion + Recommendation

### 10.1 Conclusion
- ❌ **Not Ready for Go-Live** — 2 endpoints fail NFR
- ⚠️ Breaking point 1200 VUs — เพียงพอสำหรับ current user (peak ~800) แต่ margin น้อย
- ⚠️ Soak: suspected memory leak (ยัง observe ต่อ)
- ✅ Variance -33% (ดีกว่าแผน), AI savings 38% (ต่ำกว่าเป้า 50% — k6 script ต้อง customize)

### 10.2 Recommendation
1. **Immediate:** implement Must Fix (DB index + Redis cache) — estimate 2-3 วัน
2. **Re-test:** run Load + Stress ใหม่หลัง tuning
3. **If re-test pass:** Go-Live — Defer Should Fix to Maintenance Phase
4. **Monitor:** post Go-Live — heap usage, upstream 504 rate, search latency

---

## 11. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QC Lead | | | |
| TL / Architect | | | |
| DevOps | | | |
| PM | | | |

**Attachments:**
- Raw result: `reports/results-load-<ts>.json`, `results-stress-<ts>.json`, `results-soak-<ts>.json`
- Grafana dashboard: <link>
- Analysis detail: `perf_analysis_<scope>_<YYYYMMDD>.md`
