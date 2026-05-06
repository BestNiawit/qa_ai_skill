# KMUTNB-style Performance Test Report — คู่มือการเตรียมและประกอบรายงาน

> สำหรับ Perf Test ที่ต้องส่งหน่วยงานราชการ / ลูกค้าที่คุ้นกับ format JMeter government-style
> (อ้างอิง: `รายงานผลการทดสอบประสิทธิภาพระบบ_KMUTNB.pdf`)

---

## 1. เมื่อไหร่ใช้คู่มือนี้

ใช้เมื่อ deliverable ของโปรเจกต์คือ **PDF/Markdown รายงาน Perf Test** ที่ต้องมีโครงสร้างแบบ:

- มี Tools Used + API List + Server Resource graphs ต่อ server (5+ servers)
- มี Summary Report ตาม schema JMeter (Label / Samples / Avg / Min / Max / Std Dev / Error % / Throughput / KB/sec / Avg Bytes)
- มี Column Glossary อธิบาย metric

ไม่ใช่ทุก Perf Test ต้องการ format นี้ — internal team อาจใช้ Grafana dashboard + `test-report-writer` mode=perf ก็พอ

---

## 2. Section-by-Section Ownership Matrix

| § | Section ใน KMUTNB report | ใครเป็นคนทำ | Source |
|--:|--------------------------|-------------|--------|
| 1 | Executive Summary | `test-report-writer` mode=perf | template §1 |
| 2 | Test Scenario (VUs/Duration/Time) | `test-report-writer` | template §2 + จาก k6 config |
| 3 | Tools Used | `test-report-writer` | template §3 (static text) |
| 4 | API List under Test | **Manual paste** | API doc / OpenAPI spec / SRS Functional |
| 5 | NFR (ผลลัพธ์ที่ต้องการ) | `test-report-writer` | copy จาก SRS / Test Plan §NFR |
| 6 | Server Resource per server | **External monitoring** | node_exporter / Atop / windows_exporter → Grafana export PNG |
| 7 | NFR Evaluation per Endpoint table | `perf-result-analyzer` → `test-report-writer` | k6 JSON summary |
| 8 | Response Time Graph (line chart) | **External monitoring** | Grafana / xk6-dashboard export PNG |
| 9 | Stress Test per load level | `perf-result-analyzer` | k6 stress run output |
| 10 | Soak Test (memory leak check) | `perf-result-analyzer` + manual heap dump | k6 soak run + APM |
| 11 | Bottleneck Analysis | `perf-result-analyzer` | LLM analysis |
| 12 | Tuning Recommendation | `perf-result-analyzer` | LLM analysis |
| 13 | Metric Glossary | `test-report-writer` | template §11 (static text) |
| 14 | Estimate vs Actual | `test-report-writer` | qa-standards §4 |
| 15 | AI Effort Savings KPI | `test-report-writer` | qa-standards §6 |
| 16 | Conclusion + Recommendation | `test-report-writer` | LLM synthesis |
| 17 | Sign-off | `test-report-writer` | template §15 (เซ็นเอง) |

**สรุป:** AI cover ได้ 14/17 section — อีก 3 section (API List description, Server graphs, Response Time chart) ต้องเตรียมก่อนเริ่มเทส

---

## 3. Pre-Test Setup Checklist (สำคัญมาก)

> **ถ้าไม่เซ็ตก่อนเทส = เก็บข้อมูลไม่ได้ = Server Resource ส่วนหายไปทั้งหมด**

### 3.1 Load Generator
- [ ] ติดตั้ง k6 + setup `endpoints.yaml` ครบทุก API
- [ ] เขียน description ภาษาไทยต่อ endpoint (ไป copy-paste ใน §4 API List)
- [ ] ตั้ง `thresholds` per endpoint ตาม NFR (สำหรับ rule-based Pass/Fail)

### 3.2 Server Monitoring (กราฟ §6)
ถ้าเป็น **Linux servers** (Webserver / Background Job / Database):

```bash
# ติดตั้ง node_exporter ทุก server
apt install prometheus-node-exporter
systemctl enable --now prometheus-node-exporter
```

หรือใช้ **Atop** แทน (เก็บลง disk):

```bash
apt install atop
systemctl enable --now atop  # default เก็บทุก 10 min — ปรับ /etc/default/atop เป็น 1 sec ตอน test
```

ถ้าเป็น **Windows Server** (Report Service):

- ติดตั้ง `windows_exporter` (เลือก collector: `cpu`, `memory`, `os`, `system`)
- หรือใช้ **Performance Monitor** built-in → Data Collector Set → save as CSV

### 3.3 Dashboard + Export
- [ ] Prometheus scrape ทุก server (interval 5s ระหว่าง test)
- [ ] Grafana dashboard 1 อันรวม:
  - **Panel A:** CPU per server (stacked %usr/%sys/%nice/%irq/%softirq)
  - **Panel B:** Memory per server (used/free/buffers/cached/dirty/slabmem/swapfree)
  - **Panel C:** Response Time per endpoint (จาก k6 → Prometheus remote_write หรือ xk6-prometheus-rw output)
  - **Panel D:** RPS + Error Rate per endpoint
- [ ] Test export panel เป็น PNG ก่อนวันเทสจริง (หลายทีมพลาดตรงนี้ — ถึงเวลา export ไม่ออกแล้ว rerun ไม่ทัน)

### 3.4 Storage
- [ ] วาง output folder layout:

```
perf-test-<scope>-<YYYYMMDD>/
├── perf_test_report_<scope>_<YYYYMMDD>.md     ← test-report-writer output
├── perf_analysis_<scope>_<YYYYMMDD>.md         ← perf-result-analyzer output
├── results-load-<ts>.json                      ← raw k6 JSON
├── results-stress-<ts>.json
├── results-soak-<ts>.json
└── graphs/
    ├── cpu-webserver1.png                      ← Grafana export
    ├── mem-webserver1.png
    ├── cpu-webserver2.png
    ├── ... (per server)
    └── response-time-all-endpoints.png
```

---

## 4. Workflow ใช้ skill ลำดับ

```
[1] เตรียมก่อนเทส
    ├── perf-test-generator → k6 scripts
    ├── เซ็ต Prometheus + Grafana + node_exporter (§3.2-3.3)
    └── ทำ §4 API List Thai descriptions ไว้ใน text file

[2] รัน test (Smoke → Load → Stress → Soak [→ Spike])
    ├── k6 run → JSON output
    └── Grafana บันทึก CPU/Memory ตลอด test window

[3] หลังเทส
    ├── Export Grafana panels → ./graphs/*.png (1 ต่อ server CPU + 1 ต่อ server Memory + 1 Response Time overall)
    ├── perf-result-analyzer → perf_analysis_*.md (Bottleneck + Recommendation)
    └── เลือก output:

        (A) Markdown internal/handoff:
            test-report-writer mode=perf
                input: perf_analysis + API List + graphs/ paths + NFR
                output: perf_test_report_*.md (KMUTNB-style markdown)

        (B) PDF KMUTNB government format ส่งราชการตรงๆ:
            perf-typst-report mode=kmutnb
                input: เดียวกับ (A) + Summary Report rows + Conclusion bullets
                template: skills/perf-typst-report/templates/perf-report-kmutnb.typ
                output: perf_report_kmutnb_<scope>_<date>.pdf (~14 pages, A4)

[4] Compile (mode=kmutnb)
    typst compile --root <repo-root> \
      perf_report_kmutnb_<scope>_<date>.typ \
      outputs/perf/<scope>_<date>.pdf
```

**ตัวอย่าง compile** (test ผ่านแล้ว 14 หน้า A4):
```bash
typst compile \
  --root /Users/.../qa_ai_skill \
  /Users/.../perf_report_kmutnb_<scope>_<date>.typ \
  /tmp/out.pdf
# pdfinfo /tmp/out.pdf → Pages: 14, A4
```

---

## 5. Common Gotchas

| ปัญหา | สาเหตุ | กันไว้ก่อน |
|-------|--------|-----------|
| Server Resource graph หายไปจากรายงาน | ลืมเซ็ต node_exporter ก่อนเทส | §3.2 checklist |
| API description ว่างเปล่า | คาดหวังให้ AI generate เอง | AI ห้าม generate description — paste จาก API doc |
| Response Time Graph ไม่มี | ใช้ k6 default output อย่างเดียว ไม่มี time-series | ใช้ `xk6-dashboard` หรือ k6 → Prometheus + Grafana |
| Std Dev ไม่ออกใน k6 default summary | ต้อง enable `summaryStats` หรือ parse JSON เอง | `--summary-stats="avg,min,med,max,p(95),p(99),std"` |
| ตัวเลข Throughput หน่วยไม่ตรง JMeter | k6 รายงาน `req/s` ส่วน JMeter รายงาน `req/min` | แปลงในตาราง — บอกหน่วยให้ชัด (RPS = req/sec) |
| Memory % vs MB ไม่ match KMUTNB | Prometheus default = bytes ส่วน Atop = % | Convert ใน Grafana panel: `(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100` |

---

## 6. Mapping เปรียบเทียบ JMeter ↔ k6 Schema

| JMeter Summary Report | k6 metric | หมายเหตุ |
|-----------------------|-----------|----------|
| Label | tag `name` | ตั้งใน script: `http.get(url, { tags: { name: 'login' } })` |
| # Samples | `http_reqs{name:...}` count | |
| Average | `http_req_duration` avg | |
| Min | `http_req_duration` min | |
| Max | `http_req_duration` max | |
| Std. Dev. | คำนวณจาก raw หรือ enable summaryStats | k6 default ไม่ออก |
| Error % | `http_req_failed` rate | |
| Throughput (req/min) | `http_reqs` rate × 60 | k6 default = req/sec |
| Received KB/sec | `data_received` rate | k6 default = bytes/sec → ÷ 1024 |
| Sent KB/sec | `data_sent` rate | k6 default = bytes/sec → ÷ 1024 |
| Avg. Bytes | `data_received` / `http_reqs` | คำนวณเอง |
| — | **p(95)** | k6 มี, JMeter Aggregate ไม่มี (ต้องใช้ JMeter HTML report) |
| — | **p(99)** | k6 มี, JMeter Aggregate ไม่มี |

---

## 7. Template Section-Header Mapping

| KMUTNB PDF heading (ภาษาไทย) | template heading ในนี้ |
|------------------------------|------------------------|
| Scenario | §2 Test Scenario |
| Tool ที่ใช้ในการทดสอบ | §3 Tools Used |
| รายการ API ที่ใช้ทดสอบ | §4 API List under Test |
| ผลลัพธ์ที่ต้องการ | §5 NFR (อยู่ใน §2 footnote ของ template) |
| ผลการทดสอบ — Webserver/Background/Database/Report Service | §5 Server Resource Usage 5.1-5.5 |
| JMeter Test Result — Response Time Graph | §6 + แนบ `graphs/response-time-all-endpoints.png` |
| Summary Report | §6 NFR Evaluation table |
| อธิบายหัวตารางและผลการทดสอบ | §11 Metric Glossary |
| สรุปผลการทดสอบ | §14 Conclusion + Recommendation |

> เลขใน "template heading" หมายถึง section number ใน `skills/test-report-writer/templates/perf-report-th.md`

---

## References

- Skill ที่เกี่ยวข้อง:
  - `skills/test-report-writer/templates/perf-report-th.md` — markdown KMUTNB-style template
  - `skills/perf-typst-report/templates/perf-report-kmutnb.typ` — Typst KMUTNB government PDF template
  - `skills/perf-result-analyzer/SKILL.md` — Bottleneck + Tuning analysis
  - `skills/perf-test-generator/SKILL.md` — k6 script generation
  - `skills/perf-typst-report/SKILL.md` — render PDF (มี 2 mode: client / kmutnb)
- Standard:
  - `references/qa-standards.md` §4 (Estimate vs Actual) §6 (KPI)
- ตัวอย่าง:
  - `รายงานผลการทดสอบประสิทธิภาพระบบ_KMUTNB.pdf` (reference PDF)
