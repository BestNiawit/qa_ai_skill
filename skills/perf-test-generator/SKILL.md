---
name: perf-test-generator
description: สร้าง k6 performance test (smoke / load / stress / soak / spike) + HTTP client wrapper + per-endpoint thresholds + RPS หรือ VUs load model + report (JSON/HTML) ตาม pattern ของ k6-perf-test-ayodia (config-driven, tag-based thresholds, Grafana/Prometheus-ready). Trigger เมื่อ user ขอเขียน performance test, load test, stress test, k6 script, "write k6 test", "generate load test", "เขียน k6", "สร้าง performance test", "perf test", "soak test", "spike test". Maps to SDP §5.3.1 (Process 10 — เตรียม Perf Script).
---

# Performance Test Generator (k6)

> **คำย่อ (NFR / TPS / RPS / VU / p95 / SDP / ...):** ดู [qa-onboarding §Glossary](../../docs/qa-onboarding.md#-คำย่อ-glossary--เช็คก่อนอ่าน-skillmd)

## 1. Purpose — เป้าหมาย

สร้าง k6 performance test ตาม pattern **k6-perf-test-ayodia** — config-driven + tag-based thresholds + load-model-agnostic

**Framework:** k6 ≥ 0.45 + Node.js (สำหรับ npm scripts) + Prometheus/Grafana (optional) + k6 Cloud (optional)

**Effort savings:** ~50% (SDP §5.3.4) — จาก 2 วัน → 1 วัน

---

## 2. When to Use — เมื่อไหร่ใช้

**SDP Process:** §5.3.1 Process 10 — เตรียม Perf Script

| สถานการณ์ | ใช้ skill ไหน |
|-----------|-------------|
| k6 performance test | **`perf-test-generator`** (skill นี้) |
| JMeter/Gatling | (ยังไม่รองรับ — manual) |
| Perf Test Plan (ก่อนเขียน script) | `test-plan-writer` (mode=perf) |
| วิเคราะห์ผลหลังรัน | `perf-result-analyzer` |
| เขียน Perf Report | `test-report-writer` (mode=perf) |
| Functional E2E | `e2e-test-generator` / `robot-test-generator` |

---

## 3. Inputs — สิ่งที่ต้องเตรียม

| Input | Required | หมายเหตุ |
|-------|:--------:|----------|
| Target service + base URL | ✅ | dev/staging/prod |
| Test type | ✅ | smoke / load / stress / soak / spike |
| Endpoints | ✅ | method + path + expected status + SLO |
| Load model | ✅ | RPS หรือ VUs (ดู §Load Model ด้านล่าง) |
| Auth flow | ⚠️ | token/credential ถ้ามี |
| Test data | ⚠️ | users, products, IDs (fixture) |
| `project-context.md` | ⚠️ | NFR, SLO, Workload Model |

**Canonical Reference Repo:** `/Users/nirawit/Documents/GitHub/k6-perf-test-ayodia`

---

## 4. Outputs — สิ่งที่ได้

**Project Layout:**
```
<project>/
├── package.json                  ← npm scripts
├── scripts/run.sh                ← CLI runner
├── config/
│   ├── default.js                ← load model, RPS/VUs, thresholds, tags
│   └── dev.js / staging.js / prod.js
├── scenarios/
│   ├── rps.js                    ← rpsScenario() / rampingRpsScenario()
│   └── vus.js                    ← rampingVusScenario() / constantVusScenario()
├── tests/
│   ├── smoke.test.js             ← 1 VU × 30s
│   ├── load.test.js
│   ├── stress.test.js
│   └── <feature>.test.js
├── utils/
│   ├── httpClient.js             ← wrapper (baseUrl + headers + tags)
│   ├── check.js                  ← checkResponse / checkJsonResponse
│   └── thresholds.js             ← buildThresholds + presets
├── data/testData.json
└── reports/
    ├── summary.js                ← handleSummary → JSON + HTML
    └── report-template.md
```

### Load Model

| Model | Executor | ใช้เมื่อ | คุม |
|-------|----------|--------|-----|
| **VUs** (default) | `ramping-vus` / `constant-vus` | simulate concurrent users | จำนวน user พร้อมกัน |
| **RPS** | `constant-arrival-rate` / `ramping-arrival-rate` | SLO-based ("ต้องทน X req/s") | throughput |

Switch ผ่าน `LOAD_MODEL=rps|vus` env var

### Test Types

| Type | Config | เป้าหมาย |
|------|--------|----------|
| **smoke** | 1 VU × 30s | Sanity — รันก่อน load/stress |
| **load** | stages ค่าปกติ / RPS ปกติ | Simulate production traffic |
| **stress** | 3x normal + sustained peak | หา breaking point |
| **soak** | target ปกติ + duration > 1 hr | Memory leak, resource exhaustion |
| **spike** | ramping พุ่งเร็ว แล้วตกไว | sudden burst response |

⚠️ **stress/soak/spike** → non-prod only ยกเว้นมี approval

---

## 5. Process — ขั้นตอน

### Step 1: ระบุ scope
- Target service + base URL + env
- Test type
- Endpoints + SLO
- Load model (RPS vs VUs — ดูกฎ §Load Model)
- Auth
- Test data

### Step 2: เช็ค asset (ห้ามสร้างซ้ำ)
- [ ] `utils/httpClient.js`, `utils/check.js`, `utils/thresholds.js` มีแล้ว? → reuse
- [ ] `scenarios/{rps,vus}.js` มีแล้ว? → reuse
- [ ] `config/<env>.js` มี base URL + thresholds? → append endpoint ใหม่
- [ ] `data/testData.json` มี user/endpoint? → append

### Step 3: สร้าง/แก้ไฟล์ตาม order
1. อัปเดต `config/<env>.js` → base URL + `endpointThresholds`
2. อัปเดต `data/testData.json` → users + endpoints (password: `[REDACTED]`)
3. สร้าง `tests/<feature>.test.js`
4. อัปเดต `package.json` → เพิ่ม npm script

### Step 4: Verify
```bash
k6 run -e ENV=dev tests/<feature>.test.js    # smoke first
npm run test:load
npm run test:stress
```

### Step 5: ดู report
- Console real-time
- `reports/results-<timestamp>.json` / `.html`
- Grafana (ถ้ามี): `K6_PROMETHEUS_RW_SERVER_URL=...`

---

## 6. Quality Gate — Checklist ก่อนส่ง

### Must Have (7 กฎเหล็ก)
- [ ] ใช้ `HttpClient` wrapper (ไม่ใช้ `k6/http` ตรง)
- [ ] ทุก request มี `{ name: '...' }` tag
- [ ] Threshold อยู่ใน `config/<env>.js` (ไม่ hardcode ใน test)
- [ ] ใช้ `checkResponse` / `checkJsonResponse` (ไม่ใช้ raw `check()`)
- [ ] `cfg.tags.testType` = `smoke` / `load` / `stress` ตรงกับไฟล์
- [ ] มี `sleep()` ระหว่าง request (ยกเว้น constant-arrival-rate)
- [ ] Test data อยู่ใน `data/*.json` (ไม่ hardcode credential)
- [ ] Export `handleSummary` → JSON + HTML report
- [ ] Smoke test ผ่านก่อน load/stress
- [ ] Per-endpoint threshold ครบทุก endpoint ใหม่

### Red Flags (Reject)
- ❌ `http.get(url)` ตรง — ต้อง `client.get(path, { name })`
- ❌ request ไม่มี `name` tag — per-endpoint threshold ใช้ไม่ได้
- ❌ Threshold hardcode ใน test
- ❌ รัน stress/soak/spike บน prod โดยไม่มี approval
- ❌ Password/token จริงใน `data/testData.json`

---

## 7. AI Guardrails — ข้อควรระวัง

อ้างอิง: [`references/ai-guardrails.md`](../../references/ai-guardrails.md)

**Skill-specific:**
- ❌ AI อาจใช้ **k6 feature version เก่า** (deprecated API) → ตรวจกับ k6 ≥ 0.45
- ❌ AI อาจ **ตั้ง threshold เกินจริง** ถ้าไม่รู้ baseline → ให้ Production Log / existing baseline
- ❌ AI อาจ **hardcode credential** ถ้าไม่ระมัดระวัง → ใช้ `[REDACTED]`

**ข้อห้าม:**
- ❌ รัน stress/soak/spike บน prod โดยไม่มี approval
- ❌ ไม่มี `sleep` — CPU ของ agent โดน waste
- ❌ แยก threshold ตาม env ไม่ได้ → ใช้ `config/<env>.js` override

---

## 8. Chain — เชื่อมกับ skills อื่น

**Upstream:**
- `test-plan-writer` (mode=perf) — Perf Test Plan (Workload Model, NFR) → feed เข้า skill นี้
- `test-case-writer` — endpoint + SLO จาก TC → feed เข้า skill นี้
- API Spec (Swagger/OpenAPI)

**Downstream:**
- `perf-result-analyzer` — raw result (JSON/CSV) → bottleneck analysis
- `test-report-writer` (mode=perf) — Perf Test Report
- `bug-report-writer` — threshold fail → defect

**Workflow ตัวอย่าง:**
```
NFR + API Spec → test-plan-writer → perf-test-generator → [run k6]
                                                            └→ perf-result-analyzer → test-report-writer
                                                                                     └→ bug-report-writer (ถ้า fail)
```

---

## 7 กฎเหล็ก — Detail

### 1. HttpClient wrapper
```js
// ❌ ผิด
import http from 'k6/http';
const res = http.get('https://api.example.com/health');

// ✅ ถูก
import { HttpClient } from '../utils/httpClient.js';
const client = new HttpClient(cfg);
const res = client.get('/health', { name: 'health' });
```

### 2. Tag endpoint
```js
client.get('/api/v1/products', { name: 'products' });
client.post('/login', body, { name: 'login' });
```

### 3. Threshold ใน config
```js
// config/prod.js
endpointThresholds: {
  health: { http_req_duration: ['p(95)<100', 'p(99)<200'] },
  login:  { http_req_duration: ['p(95)<600', 'p(99)<1500'] },
}
```

### 4. checkResponse wrapper
```js
// ❌ ผิด
check(res, { 'status 200': (r) => r.status === 200 });

// ✅ ถูก
checkResponse(res, { status: 200, maxDuration: 500, name: 'GET /health' });
```

### 5. Sleep
- smoke: `sleep(1)`
- load: `sleep(0.5)`
- stress: `sleep(0.3)`
- constant-arrival-rate: ไม่ต้อง (k6 จัดการเอง)

### 6. Test data
```js
let testData = {};
try { testData = JSON.parse(open('../data/testData.json')); } catch (_) {}
```

### 7. handleSummary
```js
import { handleSummary as summary } from '../reports/summary.js';
export { summary as handleSummary };
```

---

## Threshold Reference (Default SLO)

| Metric | Strict | Standard | Relaxed |
|--------|--------|----------|---------|
| `http_req_duration` p(95) | < 300 ms | < 500 ms | < 1000 ms |
| `http_req_duration` p(99) | < 800 ms | < 1500 ms | < 3000 ms |
| `http_req_failed` rate | < 0.5% | < 1% | < 5% |
| `custom_error_rate` | < 0.5% | < 1% | < 5% |

```js
import { thresholdPresets } from '../utils/thresholds.js';
cfg.thresholds = thresholdPresets.strict;
```

---

## Grafana/Prometheus + k6 Cloud

```bash
K6_PROMETHEUS_RW_SERVER_URL=http://localhost:9090/api/v1/write \
K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM=true \
npm run test:load
```

Grafana dashboard ID [19665](https://grafana.com/grafana/dashboards/19665-k6-prometheus/) — filter `project`, `env`, `testType`, `name`

```bash
K6_CLOUD_TOKEN=... npm run test:load
```

---

## GitLab CI

3 stages: `validate` → `performance_test` → `collect_report`

Variables: `TEST_TYPE`, `ENV`, `LOAD_MODEL`, `BASE_URL`, `RPS`, `VUS`, `DURATION`

**Rule:** threshold fail = warning (ไม่ block) เพื่อเก็บ artifact

---

## References
- [`references/ai-guardrails.md`](../../references/ai-guardrails.md)
- [`references/sdp-mapping.md`](../../references/sdp-mapping.md)
- [`references/load-model-decision.md`](references/load-model-decision.md)
- [`references/threshold-design.md`](references/threshold-design.md)
- [`examples/`](examples/) — config, scenarios, utils, tests, data
