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

## 2. Test Scenario

| จำนวน VUs (Concurrent) | Duration (min) | ช่วงเวลา |
|-----------------------:|---------------:|----------|
| 500 | 30 | YYYY-MM-DD HH:MM → HH:MM (Time zone) |

> **NFR ต้นฉบับ** (copy จาก SRS / Test Plan §NFR):
> "ระบบรองรับการใช้งานพร้อมกันไม่น้อยกว่า 300 VUs — Response Time ≤ 30s ในภาระงานปกติ, ≤ 60s ในช่วง peak — Error Rate ≤ 1% ทุก endpoint"

---

## 3. Tools Used

| Tool | Purpose |
|------|---------|
| **k6** (Grafana Labs) | Load generator + metric collector — สร้าง VUs, วัด Response Time, Throughput (RPS), Error Rate, p95/p99 |
| **Prometheus + Grafana** *(หรือ `xk6-dashboard`)* | Real-time dashboard + export กราฟ Response Time / RPS / Error Rate per endpoint |
| **node_exporter** *(Linux)* / **windows_exporter** *(Windows)* | เก็บ CPU / Memory / Disk / Network ต่อ server ส่งเข้า Prometheus |
| **Atop** *(Linux ทางเลือก)* | Process-level CPU/Memory แบบ realtime — ใช้คู่ในกรณี Prometheus ไม่ครอบคลุม |

> **ถ้าโปรเจกต์ใช้ JMeter** ให้แทนที่ k6 ด้วย JMeter — schema ของ Summary Report เทียบเท่ากัน (Label / Samples / Avg / Min / Max / Std Dev / Error % / Throughput / Received KB/sec / Sent KB/sec / Avg Bytes) แต่ JMeter Aggregate Report **ไม่มี p99** ส่วน k6 มี

---

## 4. API List under Test

| # | Method | URL | รายละเอียด |
|--:|--------|-----|------------|
| 1 | POST | `/api/Authenticate/login` | ส่ง user/password เพื่อรับ JWT Token สำหรับเรียก API อื่น |
| 2 | GET | `/api/operatingBudget/pendingProcess?pageNumber=&pageSize=` | ดึงเอกสารแบบ pagination |
| 3 | GET | `/api/OperatingUnit/lookup` | ข้อมูลรายการหน่วยปฏิบัติ |
| ... | ... | ... | ... |

> **AI ไม่ generate descriptions เอง** — paste จาก API doc / OpenAPI spec / SRS Functional Requirement หรือ k6 script `endpoints` config มาให้

---

## 5. Server Resource Usage (ตอน Test รัน)

> **ต้อง capture metrics ก่อน test เริ่ม** — node_exporter/windows_exporter → Prometheus หรือ Atop dump CSV
> Export กราฟจาก Grafana panel เป็น PNG แล้วแปะแต่ละ subsection
> เพิ่ม/ลด server section ตาม architecture จริง

### 5.1 Webserver 1

| Field | Value |
|-------|-------|
| IP | 172.16.x.x |
| OS | Ubuntu 24.04 |
| Time zone | UTC |
| CPU | 4 cores |
| RAM | 16 GiB |

#### CPU Usage

![CPU Webserver 1](./graphs/cpu-webserver1.png)

> หมายเหตุ: กราฟแสดง CPU แบบรวมทุก core — เครื่อง 4 cores → max = 400% (100% × 4)

#### Memory Usage

![Memory Webserver 1](./graphs/mem-webserver1.png)

| used (%) | free (%) | buffers (%) | cached (%) | dirty (%) | slabmem (%) | swap_free (%) |
|---------:|---------:|------------:|-----------:|----------:|------------:|--------------:|
| 63.47 | 36.52 | 2.01 | 42.36 | 0.017 | 2.22 | 100.0 |

### 5.2 Webserver 2
*(repeat block — IP/OS/CPU/RAM table + CPU graph + Memory graph + average table)*

### 5.3 Background Job
*(repeat block)*

### 5.4 Report Service *(Windows Server)*
*(repeat block — ใช้ Performance Monitor / windows_exporter)*

### 5.5 Database
*(repeat block)*

---

## 6. Test Result — NFR Evaluation per Endpoint

> Schema เทียบเท่า JMeter Summary Report + เพิ่ม **p95/p99** (k6 มีในตัว, JMeter Aggregate Report ไม่มี p99)

| Endpoint | Samples | Avg (ms) | Min | Max | p95 | p99 | Std Dev | RPS | Error % | Sent KB/s | Recv KB/s | NFR p95 | Status |
|----------|--------:|---------:|----:|----:|----:|----:|--------:|----:|--------:|----------:|----------:|--------:|:------:|
| POST /auth/login | 5,400 | 720 | 80 | 1,800 | 950 | 1,200 | 230 | 3.0 | 0.0% | 0.05 | 1.20 | ≤1000ms | ✅ Pass |
| GET /reports/summary | 1,200 | 2,800 | 400 | 8,500 | **5,200** | **7,000** | 1,400 | 0.7 | **2.1%** | 0.04 | 28.50 | ≤2000ms | ❌ Fail |
| ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |
| **TOTAL** | **56,848** | **256** | — | — | — | — | — | **15.29** | **0.00%** | **65.69** | **216.48** | — | — |

**Overall:** ❌ X endpoints fail NFR

> 📈 **กราฟ Response Time over time per endpoint** (เทียบเท่า JMeter Response Time Graph) — export จาก Grafana / `xk6-dashboard`:
>
> ![Response Time Graph](./graphs/response-time-all-endpoints.png)

---

## 7. Stress Test — Metric per Load Level

| Concurrent Users | Avg | p95 | RPS | Error % | Note |
|-----------------:|----:|----:|----:|--------:|------|
| 100 | 200ms | 500ms | 85 | 0.1% | OK |
| 500 | 400ms | 900ms | 280 | 0.3% | OK (target load) |
| 1000 | 800ms | 2200ms | 450 | 1.5% | ⚠️ Degradation |
| 1500 | **2500ms** | **6000ms** | 520 | **8.2%** | ❌ Breaking point |

**Breaking Point:** ~1200 concurrent users (Error Rate > 5%)

---

## 8. Soak Test (Memory Leak Check)

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

## 9. Bottleneck Analysis (จาก `perf-result-analyzer`)

### 9.1 Top Slowest Transactions
1. **GET /employees?q=** — p95 = 2800ms (NFR ≤1000ms)
   - Hypothesis: DB full-table scan (no index on `tbl_employee.name`)
2. **GET /reports/summary** — p95 = 3500ms (NFR ≤2000ms)
   - Hypothesis: Large aggregation (SUM, GROUP BY) ไม่มี caching

### 9.2 Error Hotspot
- **GET /employees?q=** — Error Rate 2.1% (504 Gateway Timeout)
  - Hypothesis: Upstream timeout 5s, บาง query > 5s

---

## 10. Tuning Recommendation

### 10.1 Must Fix (Block Go-Live)
1. **DB Index:** `CREATE INDEX idx_emp_name ON tbl_employee(name)` — คาดลด p95 จาก 2800ms → ~300ms
2. **Redis Cache:** Cache `/reports/summary` response — TTL 5 นาที

### 10.2 Should Fix (Post Go-Live)
1. Upstream timeout: 5s → 10s (mitigate 504)
2. Pagination `/reports/detail` — จำกัด 100 rows/page
3. Investigate heap leak (4-hour soak เพิ่ม 240 MB)

### 10.3 Nice to Have
1. CDN for static assets
2. Read replica DB สำหรับ `/reports/*`
3. Horizontal scaling plan (จาก breaking point 1200 → target 2000+)

---

## 11. Metric Glossary

> สำหรับ reader ที่ไม่คุ้นกับ k6/JMeter — labels ใช้ทับศัพท์ industry-standard ตาม NFR/SLA

| Metric | นิยาม | k6 metric ต้นทาง |
|--------|-------|------------------|
| **Samples** | จำนวน request ที่ยิงไปทั้งหมดต่อ endpoint | `http_reqs{name:...}` count |
| **Avg (Response Time)** | เวลาเฉลี่ยที่ server ตอบกลับ (ms) | `http_req_duration` avg |
| **Min / Max** | Response Time ที่เร็ว/ช้าที่สุด | `http_req_duration` min / max |
| **p95** | 95% ของ request เร็วกว่าค่านี้ — ตัด outlier ออก ใช้ตัดสินใจ NFR ส่วนใหญ่ | `http_req_duration` p(95) |
| **p99** | 99% percentile — ดู worst-case experience ของ user 1 ใน 100 | `http_req_duration` p(99) |
| **Std Dev** | ส่วนเบี่ยงเบนมาตรฐาน — สูง = response time ไม่นิ่ง | คำนวณจาก raw samples |
| **Error %** | สัดส่วน request ที่ fail (HTTP 4xx/5xx / timeout) | `http_req_failed` rate |
| **Throughput / RPS / TPS** | จำนวน request ที่ระบบ process ได้ต่อวินาที | `http_reqs` rate |
| **Sent KB/sec** | data ที่ client ส่งออกต่อวินาที | `data_sent` rate |
| **Received KB/sec** | data ที่ client รับเข้าต่อวินาที | `data_received` rate |
| **Avg. Bytes** | response size เฉลี่ย | `data_received` / `http_reqs` |
| **VUs (Virtual Users)** | จำนวน concurrent user จำลอง | `vus` |
| **NFR (Non-Functional Requirement)** | เกณฑ์ performance ที่เซ็นกับลูกค้า | `thresholds` config ใน k6 |

---

## 12. Estimate vs Actual (Hours)

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

## 13. AI Effort Savings (KPI)

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

## 14. Conclusion + Recommendation

### 14.1 Conclusion
- ❌ **Not Ready for Go-Live** — 2 endpoints fail NFR
- ⚠️ Breaking point 1200 VUs — เพียงพอสำหรับ current user (peak ~800) แต่ margin น้อย
- ⚠️ Soak: suspected memory leak (ยัง observe ต่อ)
- ✅ Variance -33% (ดีกว่าแผน), AI savings 38% (ต่ำกว่าเป้า 50% — k6 script ต้อง customize)

### 14.2 Recommendation
1. **Immediate:** implement Must Fix (DB index + Redis cache) — estimate 2-3 วัน
2. **Re-test:** run Load + Stress ใหม่หลัง tuning
3. **If re-test pass:** Go-Live — Defer Should Fix to Maintenance Phase
4. **Monitor:** post Go-Live — heap usage, upstream 504 rate, search latency

---

## 15. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QC Lead | | | |
| TL / Architect | | | |
| DevOps | | | |
| PM | | | |

**Attachments:**
- Raw result: `reports/results-load-<ts>.json`, `results-stress-<ts>.json`, `results-soak-<ts>.json`
- Grafana dashboard: <link>
- Server resource graphs: `./graphs/cpu-*.png`, `./graphs/mem-*.png`
- Analysis detail: `perf_analysis_<scope>_<YYYYMMDD>.md`
