---
name: perf-typst-report
description: สร้าง Performance Test Report แบบ PDF ที่สวยงาม-เป็นทางการ-สั้น (~5-6 หน้า) สำหรับส่งลูกค้าที่ไม่ใช่ technical — รับ k6 JSON summary + NFR + customer info → typst template ที่ใช้ Ayodia branding (cover, verdict banner, KPI tiles, traffic-light NFR table, bottleneck cards ภาษาคนปกติ, sign-off) → typst compile → PDF. แบ่ง section ชัดเจน Exec Summary / NFR / Findings / Conclusion. Trigger เมื่อ user ขอ perf report PDF, typst perf report, "สร้าง perf report สวยๆ", "ส่งลูกค้า perf report", "k6 to PDF", "client-ready perf report", "perf report ทางการ", "render perf report typst". Maps to SDP §5.3.1 P12 — Perf Report (client-facing variant; complement to test-report-writer mode=perf which is markdown internal).
---

# Performance Typst Report Generator

> **คำย่อ (NFR / TPS / p95 / SLA / VUs / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

แปลง **k6 raw log** + **NFR** + **customer info** → **PDF formal performance report** ส่งลูกค้าได้ทันที

**Effort savings:** ~70% (เทียบ manual draft + format Word/PowerPoint) — จาก ~6 ชม. → ~1.5 ชม.

**2 mode (เลือก template):**
- **`mode=client` (default)** — `templates/perf-report.typ` — Ayodia branded 8-page compact (verdict banner / KPI tiles / traffic-light NFR / bottleneck cards) สำหรับลูกค้าเอกชน CTO/PO
- **`mode=kmutnb`** — `templates/perf-report-kmutnb.typ` — Government-style 14+ pages เลียน format KMUTNB JMeter report สำหรับหน่วยงานราชการ/มหาวิทยาลัย ที่บังคับ layout เฉพาะ (Tools / API List / Server Resource graphs / Glossary / สรุปผลแบบ narrative) ดูคู่มือเตรียม graphs ที่ [`references/perf-report-kmutnb-template.md`](../../references/perf-report-kmutnb-template.md)

**Key rules:**
- ใช้ภาษาแบบผสม — **คำอธิบาย / bullet / bottleneck = ภาษาไทยธุรกิจ** ("รายงานช้า", "ผู้ใช้รอคอย"), แต่ **KPI labels และ metric headers = ทับศัพท์ industry-standard** (RPS, Response Time, Error Rate, VUs, p95) เพราะคำพวกนี้แม้ลูกค้า non-tech ใน IT context ก็คุ้น
- **Verdict banner** สีชัด (Pass=เขียว / Conditional=ส้ม / Fail=แดง) อยู่บนสุดของ Exec Summary
- **NFR table** ใช้ traffic-light — fail row highlight สีแดง อ่าน 5 วิรู้ผลทันที
- บีบให้ **5-6 หน้ารวม cover** — ลูกค้าไม่อ่านยาว
- ใช้ shared `lib.typ` (Ayodia branding) — ไม่ duplicate style code
- **ห้าม** ใส่ raw stack trace / IP / customer PII ใน body (ถ้าจำเป็นย้าย Appendix/แนบไฟล์)

**Output structure (~8 หน้า):**
```
─── สำหรับลูกค้า (Client-facing) ──────────────────────
Page 1: Cover (logo + project + customer + doc-id)
Page 2: สารบัญ (TOC)
Page 3: Executive Summary (verdict + 4 KPI tiles + 3 bullets + workload)
Page 4: NFR Evaluation (per-endpoint, traffic-light)
Page 5: Findings & Recommendations (bottleneck cards + Must/Should/Nice)

─── สำหรับ Dev / TL / Architect ────────────────────────
Page 6: Technical Details — Detailed metrics + Stress Test breaking point
Page 7: Technical Details — Soak (memory trend) + Specific Tuning Scripts (SQL/config)

─── สรุปท้าย ───────────────────────────────────────────
Page 8: Conclusion + Next Steps + Sign-off
```

**ลูกค้าอ่าน page 3-5 + 8 ก็เข้าใจครบแล้ว** — Tech Section page 6-7 มี marker ระบุชัดว่า "สำหรับทีม Dev — ลูกค้าอาจข้ามได้" เพื่อไม่ให้ตกใจ

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 12 — Perf Report (client deliverable variant)

| สถานการณ์ | ใช้ skill ไหน + mode |
|-----------|---------------------|
| ส่ง **PDF ลูกค้าเอกชน** (CTO/PO) — compact 8 หน้า | **`perf-typst-report`** mode=client (default) |
| ส่ง **PDF ราชการ/มหาวิทยาลัย** — KMUTNB government format | **`perf-typst-report`** mode=kmutnb |
| ส่ง markdown ให้ TL/PM internal | `test-report-writer` (mode=perf) |
| ยังไม่ได้ analyze raw → bottleneck | `perf-result-analyzer` ก่อน — feed เข้า skill นี้ |
| ยังไม่ได้ run test | `perf-test-generator` ก่อน |
| Threshold fail → เปิด defect ให้ Dev | `bug-report-writer` |

### Boundary กับ `perf-result-analyzer` — สำคัญ

**`perf-typst-report` คือ pure renderer** — *ไม่ใช่* analyzer

- **`perf-result-analyzer`** = parse + analyze (k6 / JMeter / Gatling) → identify top 3 bottleneck, hypothesis (USE method), tuning checklist, breaking point logic
- **`perf-typst-report`** = รับ analysis output (จาก analyzer หรือ hand-crafted) → render เป็น PDF สวยๆ พร้อม chart + branding

**Workflow ที่แนะนำ:**
```
[k6 raw] → perf-result-analyzer → analysis.md (insights)
                                       ↓
                             perf-typst-report → PDF
```

**ถ้า skip analyzer ได้ไหม?** ได้ — AI จะ inline-analyze ใน data block แต่จะ flag ว่า:
> ⚠ analyzed-inline — สำหรับ deep insight (USE method, multi-tool support) แนะนำ run `perf-result-analyzer` แยก

**ทำไมแยก 2 skill ไม่รวม?**
1. analyzer รองรับ k6 / **JMeter** / **Gatling** — typst-report เฉพาะ k6 (เพราะ branded layout fix)
2. analyzer = pure analytical (markdown), reuse ได้กับ tool/audience อื่น
3. typst-report = pure presentation (visual + branding) — เปลี่ยน design ไม่กระทบ analyze logic
4. Single Responsibility — ตัวใดเปลี่ยน scope ไม่กระทบอีกตัว

**คู่กับ test-report-writer ยังไง?**
- `test-report-writer` mode=perf = markdown internal (มี Estimate vs Actual + AI Effort Savings KPI)
- `perf-typst-report` = PDF client-facing (ตัด KPI/internal section ออก, เน้น verdict + ภาษาธุรกิจ + chart)
- ทำทั้งคู่ได้ — markdown สำหรับ team retrospective + PDF สำหรับลูกค้า

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| k6 JSON summary | ✅ | `reports/results-*.json` จาก k6 (`--summary-export`) |
| NFR per endpoint | ✅ | p(95) target, RPS target, Error % target |
| Customer info | ✅ | ชื่อลูกค้า / project / scope / doc-id |
| Test period | ✅ | YYYY-MM-DD → YYYY-MM-DD |
| Workload metadata | ✅ | per test type — **executor** (constant-vus / ramping-vus / constant-arrival-rate / ramping-arrival-rate) + **load model** ("500 VUs" หรือ "100 → 2,000 RPS") + duration + total requests |
| Stress test result | ⚠️ | load level table → identify breaking point (สำหรับ Tech section) |
| Soak test result | ⚠️ | memory/heap trend per hour (สำหรับ Tech section — set `soak: none` ถ้าไม่ได้ run) |
| Specific tuning ideas | ⚠️ | SQL/config/code snippet พร้อม expected impact (Dev จะเอาไปใช้ตรงๆ) |
| Bottleneck analysis | ⚠️ | ถ้าไม่มี → AI generate จาก raw แต่จะ flag เป็น "hypothesis" |
| Verdict | ⚠️ | pass / conditional / fail — ถ้าไม่ระบุ AI infer จาก NFR pass rate |
| Logo path (custom) | ⚠️ | default = Ayodia logo จาก `references/typst-templates/assets/` |
| `project-context.md` | ⚠️ | NFR override / customer naming convention |

**KMUTNB mode เพิ่มเติม (mode=kmutnb):**
| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| API list + Thai descriptions | ✅ | paste จาก SRS / OpenAPI — AI ห้าม generate description เอง |
| Server list (N servers) | ✅ | per server: IP, OS, Time zone, CPU cores, RAM |
| **CPU graph PNG ต่อ server** | ✅ | export จาก Grafana / Atop / Performance Monitor → วางใน `graphs/cpu-<server>.png` |
| **Memory graph PNG ต่อ server** | ✅ | เหมือนกัน → `graphs/mem-<server>.png` |
| Memory % stats ต่อ server | ✅ | Linux: used/free/buffers/cached/dirty/slabmem/swapfree • Windows: available-mb/committed-gb |
| **Response Time graph PNG (overall)** | ✅ | export จาก Grafana / xk6-dashboard → `graphs/response-time-all-endpoints.png` |
| Summary Report rows (JMeter schema) | ✅ | per endpoint: Label / Samples / Avg / Min / Max / Std Dev / Err % / Throughput / KB/s / Avg Bytes |
| Conclusion bullets (4 ข้อตาม KMUTNB) | ✅ | Error %, Response Time avg, Throughput, CPU/Memory observation |

**ดูคู่มือเตรียม graphs (Pre-Test Setup Checklist):** [`references/perf-report-kmutnb-template.md`](../../references/perf-report-kmutnb-template.md) §3 Pre-Test Setup

**Load Model — รองรับทั้ง 2 executor:**
| k6 executor | Load model string ใน data block |
|-------------|--------------------------------|
| `constant-vus` | `"500 VUs"` |
| `ramping-vus` | `"100 → 1,500 VUs"` |
| `constant-arrival-rate` | `"100 RPS"` |
| `ramping-arrival-rate` | `"100 → 2,000 RPS"` |

### Visual Evidence — กราฟและ output (k6-only mode = default)

**Skill นี้ทำงานแบบ k6-only เป็น default** — ไม่ต้องพึ่ง Grafana/APM/Server (หลายทีม QA ไม่ได้เข้า monitoring stack ของ Dev)

**Evidence ที่ render จาก k6 data ล้วน** (อัตโนมัติ — ไม่ต้องเตรียมรูป):
| Evidence | อยู่หน้า | วาดจาก k6 |
|---------|---------|----------|
| Response Time bar chart (per endpoint) | NFR section | `http_req_duration{name:X}.p(95)` vs NFR target — แท่งเขียว/แดง + เส้น target |
| Stress Test load curve (vertical bars) | Tech Section | `stress-levels[].p95` — สีเขียว/ส้ม/แดงตาม error rate |
| Soak Memory trend (vertical bars) | Tech Section | `soak.rows[].value` — แท่งสีส้มแสดง heap growth |
| **k6 Console Output** (terminal block) | Tech Section | paste raw output จาก `k6 run` — แสดง threshold ✓/✗, RPS, iterations, VUs, duration |
| **k6 Thresholds Table** | Tech Section | `thresholds: { ... }` ที่ define ใน script — table 4 col (Threshold / Expected / Actual / Status) |
| **HTTP Status Code Breakdown** (stacked bars) | Tech Section | `http_reqs{name:X,status:Y}` per endpoint — สัดส่วน 2xx vs 4xx/5xx |

**ทำไม k6 evidence อย่างเดียวพอ?**
- `k6 console output` = proof ว่า run จริง + threshold result → ลูกค้า verify ได้ทันที
- `HTTP status breakdown` = root cause sketch (5xx เยอะที่ endpoint ไหน → ที่นั่นมีปัญหา)
- `Threshold table` = pass/fail per metric แบบ machine-evaluated (ไม่ใช่ subjective)
- `Auto-generated charts` = visualize p95/load/memory ครบ — เห็นปัญหาทันทีโดยไม่ต้องอ่านตัวเลข

**Optional add-on — ถ้าทีมมี monitoring access:**
| รูป | ใช้เมื่อ | วิธีเพิ่ม |
|-----|---------|--------|
| Grafana Dashboard snapshot | ทีม Dev/Ops ให้ access เข้า Grafana | save รูปที่ `outputs/perf/assets/`, ใช้ `image()` ใส่ใน custom block ก่อน sign-off |
| APM Trace screenshot | ทีมมี Datadog/NewRelic/Jaeger | เหมือนกัน — ใส่หลัง HTTP Status Breakdown |
| Server Resource graph | ทีมมี CloudWatch/Cloud Monitoring access | optional |

ดู [`references/tester-capture-guide.md`](references/tester-capture-guide.md) — มีทั้ง k6-only mode (default) + full mode (with monitoring screenshots)

**k6 input format:**
```bash
# วิธี export raw จาก k6
k6 run --summary-export=results-load.json script.js

# AI จะ parse:
# .metrics["http_req_duration{name:login}"]["p(95)"] → 450
# .metrics["http_req_failed{name:login}"]["rate"] → 0.003
```

**ถ้ามี `perf-result-analyzer` output แล้ว** → AI ใช้ bottleneck/recommendation จากนั้นได้เลย (ไม่ต้องเดาใหม่)

---

## 4. Outputs — สิ่งที่ได้

**Format:** Typst source (`.typ`) → compile เป็น PDF

**Templates (เลือกตาม mode):**
- `mode=client` (default) → [`templates/perf-report.typ`](templates/perf-report.typ) — 8 pages Ayodia branded
- `mode=kmutnb` → [`templates/perf-report-kmutnb.typ`](templates/perf-report-kmutnb.typ) — 14+ pages government format

**File naming:**
- Source: `perf_report_<scope>_<YYYYMMDD>.typ` (client mode) / `perf_report_kmutnb_<scope>_<YYYYMMDD>.typ` (kmutnb mode)
- PDF: เปลี่ยน suffix `.typ` → `.pdf`

**Compile command:**
```bash
typst compile \
  --root /path/to/qa_ai_skill \
  perf_report_<scope>_<YYYYMMDD>.typ \
  outputs/perf/<scope>_<YYYYMMDD>.pdf
```

**ทำไมต้อง `--root`?** เพราะ template `#import` lib.typ จาก `references/typst-templates/` (3 levels up) — Typst ป้องกันอ่านไฟล์นอก project root โดย default

**ตัวอย่าง output (visual):**
- หน้า 3 — Verdict banner สีส้ม (Conditional) + 4 KPI cards (Capacity / Avg Response / Pass Rate / Error Rate) + 3 bullets + workload table
- หน้า 4 — NFR table 8 endpoints — fail row (search, report) highlight แดง + status badge "ไม่ผ่าน"
- หน้า 5 — Bottleneck cards 2 ใบ (เส้นแดงซ้าย) + Must/Should/Nice list
- หน้า 6 — Verdict banner ซ้ำ + 4-row next-steps table + sign-off table 4 roles

---

## 5. Process — ขั้นตอน

### Step 1: Read Input
1. อ่าน k6 JSON (`results-*.json`) — extract per-endpoint p(95), TPS, error rate
2. อ่าน NFR (จาก Test Plan / `project-context.md`)
3. อ่าน customer info + test period
4. ถ้ามี `perf_analysis_*.md` (จาก `perf-result-analyzer`) → ใช้ bottleneck/recommendation จากนั้นเลย

### Step 2: Ask User (ถ้าขาด)
- ลูกค้าชื่ออะไร? (ใช้ทั้งบนปก + body)
- Doc-ID format? (default: `PERF-RPT-<SCOPE>-<YEAR>-<NUM>`)
- ภาษาในรายงาน — TH default (rendered with Sarabun font in lib.typ)
- มี logo ลูกค้าไหม? (ถ้ามีต้องวางที่ assets/)

### Step 3: Compute Verdict
- Pass rate = endpoint pass / total
- **Verdict rule:**
  - `pass` ถ้า fail = 0 endpoint AND error rate < threshold
  - `conditional` ถ้า fail ≤ 30% AND no Critical endpoint fail
  - `fail` ถ้า fail > 30% OR Critical endpoint (login/payment) fail

### Step 4: Terminology — เก็บทับศัพท์ในส่วนไหน, แปลในส่วนไหน

**เก็บทับศัพท์ (industry-standard)** — ใช้ใน **KPI tile labels, table headers, units**:
- `RPS` (Requests Per Second) / `TPS`
- `Response Time` / `p95` / `p99`
- `Error Rate`
- `VUs` (Virtual Users) — ใส่ "Concurrent Users" cuanlong-form ก็ได้
- `Throughput`

**แปลเป็นไทยธุรกิจ** — ใช้ใน **bullets, bottleneck explanation, recommendation, ผลกระทบต่อผู้ใช้**:
| Tech term | คำอธิบายไทย (ใช้ใน body) |
|-----------|-----------------------|
| Breaking point | ขีดจำกัดของระบบ |
| Memory leak | การรั่วไหลของหน่วยความจำ |
| 504 Gateway Timeout | ระบบภายในตอบช้าเกินกำหนด |
| DB index missing | ฐานข้อมูลค้นหาช้าเพราะไม่มี Index |
| Cache hit ratio | สัดส่วนข้อมูลที่อ่านจากแคช |

หลักง่าย ๆ — **คำที่อยู่ใน NFR/SLA contract = ทับศัพท์** (ลูกค้าเซ็นมาแล้ว) **คำที่ AI generate เป็นคำอธิบาย = แปลไทย**

### Step 5: Generate `.typ` File
- Copy `templates/perf-report.typ` → `outputs/perf/perf_report_<scope>_<date>.typ`
- Replace `#let data = (...)` block ด้วยข้อมูลจริง
- ตรวจ string ที่มี comma/special char — escape ให้ถูก

### Step 6: Compile + Verify
```bash
typst compile --root <repo-root> <file>.typ <out>.pdf
```
- ถ้า error → debug syntax (ปกติเกิดจาก quote/special char ใน data block)
- เปิด PDF check:
  - [ ] หน้า 3 (Exec Summary) **ลงในหน้าเดียว** (verdict + KPI + bullets + workload)
  - [ ] หน้า 4 (NFR) ไม่มี orphan row หลุดไปหน้าถัดไป
  - [ ] Verdict banner สีตรง (pass=เขียว, conditional=ส้ม, fail=แดง)

### Step 7: Save + Summary
- ระบุ verdict + page count + จำนวน endpoint pass/fail
- Flag ตัวเลขที่ user ควร verify (เช่น TPS ที่ AI parse จาก k6 ผิด unit ได้ — ms vs s)

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have (Client-facing pages 3-5, 8)
- [ ] Cover มี customer name + project + doc-id + date ครบ
- [ ] Executive Summary ลงในหน้าเดียว (verdict + KPI + bullets + workload)
- [ ] Verdict banner สีถูก (pass/conditional/fail)
- [ ] KPI tile labels ใช้ทับศัพท์ industry-standard (RPS / Response Time / Error Rate / VUs)
- [ ] NFR table มี **traffic-light** — fail row highlight แดง
- [ ] Bottleneck card อย่างน้อย 1 ใบ ถ้ามี endpoint fail (ถ้าทุก endpoint pass ให้ใส่ "ไม่พบจุดที่ต้องปรับปรุง")
- [ ] Recommendation แบ่ง 3 ระดับ (Must / Should / Nice) — **ภาษาไทยธุรกิจ**
- [ ] Next-steps table มี timeline + action ชัด
- [ ] Sign-off table 4 roles (QA Lead / TL / PM / Customer)
- [ ] รวม **≤ 8 หน้า** (cover + TOC + 4 client + 2 tech)

### Must Have (Tech Section pages 6-7 — สำหรับ Dev)
- [ ] Banner ระบุ "สำหรับทีม Dev" (ลูกค้า skip ได้)
- [ ] Detailed metrics table ครบทุก percentile (avg/min/med/p90/p95/p99/max + RPS + Err% + HTTP error breakdown)
- [ ] Stress test load levels + **Breaking Point** ระบุชัด (เป็น callout)
- [ ] Soak section (ถ้ามี) — memory trend + observation
- [ ] Specific Tuning ทุกใบมี: target / action / **runnable snippet** (SQL/config/code) / expected impact

### Must Have (Visual Evidence — k6-only mode)
- [ ] **Response Time bar chart** ใน NFR section (auto-generated) — fail bars ต้องเป็นสีแดง + ทะลุ NFR target marker
- [ ] **Stress Test bar chart** (auto-generated) — สีไล่จากเขียว → ส้ม → แดง ตาม error rate
- [ ] **Soak memory chart** (auto-generated) ถ้ามี soak data — แสดง trend ขึ้น/ลง
- [ ] **k6 Console Output** terminal block — paste full output จาก `k6 run` (มี threshold ✓/✗ + final metrics + VUs + iterations)
- [ ] **k6 Thresholds table** — ทุก threshold ต้องมี Expected vs Actual + status badge (ผ่าน/ไม่ผ่าน)
- [ ] **HTTP Status Code Breakdown** (stacked bars per endpoint) — เห็นสัดส่วน 2xx vs error
- [ ] (Optional) ถ้าทีมมี Grafana/APM screenshots → ใส่เพิ่มหลัง HTTP Status Breakdown ได้

### Nice to Have
- [ ] Stress test breaking point ระบุไว้ใน Findings (ถ้ามี)
- [ ] Soak test memory observation (ถ้ามี)
- [ ] Logo ลูกค้าบน cover (ถ้ามี)
- [ ] Appendix แนบ raw k6 result link

### Red Flags (Reject)
- ❌ ตัวเลขไม่ตรงกับ raw k6 JSON
- ❌ Verdict = "pass" แต่มี endpoint fail NFR
- ❌ Tech Section มี SQL/config snippet ที่ **run ไม่ได้จริง** (syntax error, fake table name)
- ❌ Tuning snippet ไม่มี expected impact (Dev ไม่รู้ว่า worth ทำไหม)
- ❌ Stress section ไม่ระบุ Breaking Point
- ❌ เกิน 10 หน้า (เกินเป้า — แสดงว่า data block ใหญ่เกิน, ต้อง compact)
- ❌ NFR table ไม่ highlight fail row (อ่านผลไม่ทันที)
- ❌ ใส่ PII / customer IP / raw stack trace ใน body หลัก (ย้ายเข้า Tech Section ได้, แต่ยัง redact PII เสมอ)

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ⚠️ **Unit ผิด** — k6 อาจ output เวลาเป็น ms หรือ s ขึ้นกับ metric → verify ก่อน fill (`http_req_duration` = ms; tag-derived อาจ s)
- ⚠️ **Verdict bias** — AI มักให้ "conditional" เมื่อไม่แน่ใจ → rule ใน Step 3 ต้อง strict
- ⚠️ **Bottleneck hypothesis** — AI ไม่เห็น DB schema/architecture → flag เป็น "สาเหตุที่คาดว่า" ไม่ใช่ "สาเหตุ"
- ⚠️ **Typst escape** — ถ้า customer name มี `"` หรือ `#` ต้อง escape ก่อนใส่ใน `.typ`
- ❌ AI **ห้าม** approve Go-Live โดยอัตโนมัติ — verdict เป็น recommendation ลูกค้า/PM ตัดสินสุดท้าย

**ข้อห้าม:**
- ❌ ใส่ raw stack trace / SQL query / IP ใน body — ไป Appendix
- ❌ Copy ตัวเลขจาก raw โดยไม่แปลง unit ให้สม่ำเสมอ (ทุก response time = ms)
- ❌ เขียน recommendation generic ("optimize DB") — ต้อง specific (`CREATE INDEX idx_xxx ON tbl_yyy(col_zzz)`)
- ❌ เปลี่ยน Ayodia branding (color/logo) โดยไม่ผ่าน user — ใช้ `lib.typ` defaults
- ❌ Skip cover/TOC — formal report ต้องมี

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `perf-test-generator` — k6 script → run → raw result JSON
- `perf-result-analyzer` — bottleneck + recommendation (best chain — feed bottleneck cards เข้า skill นี้ตรงๆ)
- Test Plan (NFR + scope)
- `project-context.md` (customer info / NFR override)

**Downstream:**
- [ลูกค้า] — รับ PDF
- `bug-report-writer` — ถ้า fail endpoint → เปิด defect ให้ Dev
- `test-report-writer` (mode=perf) — internal markdown version (parallel, ไม่ใช่ replace)

**Workflow ตัวอย่าง:**
```
perf-test-generator → [k6 run] → results-load.json
                                       ↓
                         perf-result-analyzer → perf_analysis.md (bottleneck + reco)
                                       ↓
                ┌──────────────────────┴──────────────────────┐
                ↓                                              ↓
   perf-typst-report → PDF ส่งลูกค้า          test-report-writer (mode=perf) → MD internal
                ↓                                              ↓
         [ลูกค้า approve]                              [TL/PM review + retro]
                ↓
         (Conditional/Fail) → bug-report-writer → [Dev fix] → re-test loop
```

---

## ตัวอย่าง: K6 JSON → Data Block

**k6 raw (`results-load.json`):**
```json
{
  "metrics": {
    "http_req_duration{name:login}": {
      "values": {"avg": 120, "p(95)": 450, "p(99)": 800}
    },
    "http_req_failed{name:login}": {"values": {"rate": 0.003}},
    "http_reqs{name:login}": {"values": {"rate": 85.2}}
  }
}
```

**→ Data block ใน `.typ`:**
```typ
nfr-rows: (
  (name: "เข้าสู่ระบบ", endpoint: "POST /auth/login",
   p95: "450", nfr-p95: "≤ 600", tps: "85", nfr-tps: "≥ 80",
   err: "0.3", nfr-err: "≤ 1", status: "pass"),
  ...
)
```

**Mapping rule:**
- `http_req_duration` → `p95` (round to integer ms)
- `http_reqs.rate` → `tps` (round)
- `http_req_failed.rate × 100` → `err` (% with 1 decimal)
- `status = "pass"` ถ้า p95 ≤ NFR p95 AND tps ≥ NFR tps AND err ≤ NFR err

ดู [`examples/`](examples/) สำหรับตัวอย่างเต็ม

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- [`references/typst-templates/lib.typ`](../../references/typst-templates/lib.typ) — shared Ayodia branding (cover, qa-table, badges, sign-off)
- [`references/tester-capture-guide.md`](references/tester-capture-guide.md) — guide สำหรับ tester: k6-only mode (default — ไม่ต้องแคปอะไร, paste k6 output พอ) + optional full mode (Grafana/APM/Server)
- `templates/perf-report.typ` — main template (มี chart helpers + image-placeholder ฝังในตัว)
- `examples/` — sample k6 → typst conversion
- External: [Typst documentation](https://typst.app/docs/), k6 metrics reference, Brendan Gregg's USE Method
