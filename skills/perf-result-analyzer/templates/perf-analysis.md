# Performance Analysis — <Scope>

| Field | Value |
|-------|-------|
| Date | YYYY-MM-DD |
| Analyst | <QC / TL> |
| Raw Data Source | `<k6 JSON / JMeter CSV / Gatling stats>` |
| Reference Plan | `PERF_PLAN_<SCOPE>_v1.0` |

---

## 1. Test Metadata

| Field | Value |
|-------|-------|
| Test Type | Load / Stress / Soak / Spike |
| Duration | 30 min |
| Executor | ramping-vus / constant-arrival-rate |
| Peak Load | 500 VUs / 200 RPS |
| Total Requests | 450,000 |
| Total Errors | 1,350 (0.3%) |
| Environment | <env name + scale factor> |

---

## 2. Per-Endpoint Analysis

| # | Endpoint | Count | Avg | p(50) | p(95) | p(99) | TPS | Error % | NFR p95 | NFR TPS | NFR Err | Status |
|---|----------|------:|----:|------:|------:|------:|----:|--------:|--------:|--------:|--------:|:------:|
| 1 | POST /auth/login | 50,000 | 120 | 100 | 450 | 800 | 85 | 0.3% | ≤600ms | ≥80 | ≤1% | ✅ Pass |
| 2 | GET /employees?q= | 120,000 | 350 | 250 | **2800** | 4500 | 45 | 2.1% | ≤1000ms | ≥50 | ≤1% | ❌ Fail |
| 3 | POST /leave | 30,000 | 250 | 200 | 600 | 900 | 30 | 0.5% | ≤800ms | ≥30 | ≤1% | ✅ Pass |
| 4 | PATCH /leave/approve | 25,000 | 230 | 180 | 550 | 850 | 25 | 0.2% | ≤800ms | ≥20 | ≤1% | ✅ Pass |
| 5 | GET /reports/summary | 15,000 | 800 | 600 | **3500** | 5500 | 10 | 1.8% | ≤2000ms | ≥15 | ≤1% | ❌ Fail |
| 6 | GET /dashboard | 60,000 | 180 | 150 | 350 | 500 | 100 | 0.1% | ≤500ms | ≥80 | ≤1% | ✅ Pass |

**Summary:** 4/6 Pass — 2 Fail (search, report)

---

## 3. Stress Test — Metric per Load Level

| Concurrent Users | Avg | p(95) | TPS | Error % | CPU % | Memory % | Note |
|-----------------:|----:|------:|----:|--------:|------:|---------:|------|
| 100 | 200ms | 500ms | 85 | 0.1% | 25% | 45% | OK |
| 500 | 400ms | 900ms | 280 | 0.3% | 55% | 60% | OK (target) |
| 800 | 600ms | 1500ms | 400 | 0.8% | 75% | 70% | OK approaching limit |
| 1000 | 800ms | 2200ms | 450 | 1.5% | 88% | 78% | ⚠️ Degradation |
| 1200 | 1500ms | 4000ms | 500 | 3.2% | 95% | 82% | ⚠️ Near breaking |
| 1500 | **2500ms** | **6000ms** | 520 | **8.2%** | 99% | 88% | ❌ Breaking point |

**Breaking Point:** ~1200 VUs (error rate jumps > 5%)

**Observation:** CPU saturates ก่อน Memory — **CPU-bound**

---

## 4. Bottleneck Analysis

### 4.1 Top Slowest Transactions (sort by p(95) DESC)

#### #1 GET /reports/summary — p(95)=3500ms (NFR ≤2000ms, fail by +1500ms)
- **Count:** 15,000 requests, 1.8% error
- **Hypothesis:**
  - Large aggregation query — no caching layer
  - Multiple JOIN to `tbl_leave`, `tbl_user`, `tbl_department`
- **Evidence:** APM shows 85% of time spent in DB query
- **Recommendation:** Redis cache + TTL 5 min

#### #2 GET /employees?q= — p(95)=2800ms (NFR ≤1000ms, fail by +1800ms)
- **Count:** 120,000 requests, 2.1% error (504 timeout)
- **Hypothesis:**
  - No DB index on `tbl_employee.name` → full table scan
  - As `tbl_employee` grows → query time increases linearly
- **Evidence:** DB slow query log shows table scan; row count = 50,000
- **Recommendation:** `CREATE INDEX idx_emp_name ON tbl_employee(name)`

### 4.2 Error Hotspot

| Endpoint | Error % | Error Code Breakdown | Hypothesis |
|----------|--------:|---------------------|------------|
| GET /employees?q= | 2.1% | 504 (95%), 500 (5%) | Upstream timeout; search > 5s |
| GET /reports/summary | 1.8% | 503 (70%), 500 (30%) | Thread pool exhaustion |

---

## 5. Soak Test (4 hours @ 300 VUs)

| Hour | Heap Used | Old Gen | Full GC Count | Avg Response |
|-----:|----------:|--------:|--------------:|-------------:|
| 0 | 512 MB | 200 MB | 0 | 220ms |
| 1 | 580 MB | 250 MB | 2 | 225ms |
| 2 | 640 MB | 290 MB | 3 | 230ms |
| 3 | 700 MB | 335 MB | 4 | 245ms |
| 4 | 750 MB | 370 MB | 5 | 260ms |

**Observation:**
- Heap growth rate: ~60 MB/hour (suspicious — normal cache ไม่ควรโต linear)
- Response time increase: +40ms over 4 hours (acceptable at this scale)
- Full GC count: increasing → indication of heap pressure

**Hypothesis:** Possible memory leak — ต้อง heap dump + analyze objects

---

## 6. Spike Test (100 → 2000 RPS burst)

| Time | Target RPS | Actual TPS | p(95) | Error % |
|------|-----------:|-----------:|------:|--------:|
| 0s | 100 | 98 | 400ms | 0.1% |
| 10s | 1000 | 950 | 800ms | 0.5% |
| 15s (peak) | 2000 | 1650 | **3500ms** | **12%** |
| 20s | 1000 | 985 | 700ms | 0.3% |
| 30s | 100 | 99 | 380ms | 0.1% |

**Observation:**
- Peak ใช้ได้ แต่ degradation ชัด — 15% request ไม่ผ่าน
- Recover ไว (within 5s หลัง burst จบ)
- **Not fatal แต่ควรปรับ** — e.g., auto-scaling, request queuing

---

## 7. Tuning Recommendation (prioritized)

### 7.1 Must Fix (Block Go-Live)
| # | Action | Expected Impact | Effort |
|---|--------|----------------|--------|
| 1 | `CREATE INDEX idx_emp_name ON tbl_employee(name)` | p(95) search: 2800ms → ~300ms | S (1 hr) |
| 2 | Redis cache `/reports/summary` (TTL 5 min) | p(95) report: 3500ms → ~200ms (cache hit) | M (1 day) |

### 7.2 Should Fix (Post Go-Live)
| # | Action | Expected Impact | Effort |
|---|--------|----------------|--------|
| 3 | Upstream timeout: 5s → 10s | 504 error rate: 2% → <0.5% | S (30 min) |
| 4 | Investigate heap leak (heap dump analysis) | Prevent long-term stability issue | L (2-3 days) |
| 5 | Request queue at app level (handle spike) | Spike: 12% err → <3% | M (1-2 days) |

### 7.3 Nice to Have
| # | Action | Expected Impact | Effort |
|---|--------|----------------|--------|
| 6 | CDN for static assets | Reduce dashboard latency ~50ms | M |
| 7 | Read replica DB สำหรับ `/reports/*` | Horizontal scale reporting | L |
| 8 | Auto-scaling policy (HPA) | Absorb 2x peak | L |

---

## 8. Conclusion

- ❌ **Not Ready for Go-Live** — 2 endpoints fail NFR + breaking point margin เล็ก
- ⚠️ **Memory leak suspected** — ต้อง investigate ก่อน Go-Live หรือ accept risk + rollback plan
- ✅ **System scalable** ถึง ~1200 concurrent users (ตรงกับ peak estimate 800 — margin 50%)

## 9. Next Steps

1. Dev implement Must Fix (#1, #2) — target 2-3 วัน
2. Re-test: Load + Stress หลัง tuning
3. Parallel: Heap dump investigation (Should Fix #4)
4. If re-test pass + no critical leak → Go-Live
5. Post Go-Live: monitor heap trend, upstream 504, search latency

---

## References
- Raw data: `<path>`
- APM screenshots: `<path>`
- DB slow query log: `<path>`
- Heap dump (if available): `<path>`
