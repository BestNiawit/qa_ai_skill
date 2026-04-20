---
name: perf-test-generator
description: สร้าง k6 performance test (smoke / load / stress / soak / spike) + HTTP client wrapper + per-endpoint thresholds + RPS หรือ VUs load model + report (JSON/HTML) ตาม pattern ของ k6-perf-test-ayodia (config-driven, tag-based thresholds, Grafana/Prometheus-ready). Trigger เมื่อ user ขอเขียน performance test, load test, stress test, k6 script, "write k6 test", "generate load test", "เขียน k6", "สร้าง performance test", "perf test", "soak test", "spike test".
---

# Performance Test Generator (k6)

สร้าง k6 performance test script ตาม pattern ของ [`k6-perf-test-ayodia`](https://github.com/ayodia/k6-perf-test-ayodia) — **config-driven + tag-based thresholds + load-model-agnostic**

---

## Canonical Reference Repo
`/Users/nirawit/Documents/GitHub/k6-perf-test-ayodia`

**ก่อนเขียนโค้ดใหม่:** ถ้า user ทำงานใน repo นั้น อ่านไฟล์ที่ใกล้เคียงที่สุดก่อน (เช่น generate `orders.test.js` → อ่าน `load.test.js` + `smoke.test.js` ก่อน) เพื่อ match style ให้เป๊ะ

ถ้าไม่ได้อยู่ใน repo นั้น → ใช้ไฟล์ใน [`examples/`](examples/) ของ skill นี้เป็น reference

---

## Framework
- **k6** ≥ 0.45
- **Node.js** (สำหรับ `npm run` scripts เท่านั้น; k6 ไม่ต้องใช้ Node runtime)
- ES modules (`import`, `export`)
- Prometheus/Grafana output ผ่าน `experimental-prometheus-rw`
- k6 Cloud ผ่าน `K6_CLOUD_TOKEN`

---

## Project Layout

```
<project>/
├── package.json                  ← npm scripts (test:smoke, test:load, test:stress, test:<env>, test:<model>)
├── scripts/
│   └── run.sh                    ← CLI runner รับ args: <test> <env> <load_model> + ENV overrides
├── config/
│   ├── default.js                ← defaults (load model, RPS/VUs, thresholds, tags, prometheus/cloud)
│   ├── dev.js / staging.js / prod.js   ← override per env
├── scenarios/
│   ├── rps.js                    ← rpsScenario() + rampingRpsScenario()
│   └── vus.js                    ← rampingVusScenario() + constantVusScenario()
├── tests/
│   ├── smoke.test.js             ← 1 VU × 30s, sanity check
│   ├── load.test.js              ← normal traffic (RPS หรือ VUs)
│   ├── stress.test.js            ← breaking-point discovery
│   └── <feature>.test.js         ← per-service test
├── utils/
│   ├── httpClient.js             ← HttpClient class — wrap k6/http, auto baseUrl + headers + tags
│   ├── check.js                  ← checkResponse() + checkJsonResponse() + custom metrics
│   └── thresholds.js             ← buildThresholds() + thresholdPresets (strict/standard/relaxed)
├── data/
│   └── testData.json             ← users + endpoints (ห้าม commit password จริง)
└── reports/
    ├── summary.js                ← handleSummary → JSON + HTML
    └── report-template.md        ← formal report template
```

---

## เลือก Load Model

| Load Model | Executor | ใช้ตอน | คุม |
|------------|----------|--------|-----|
| **VUs** (default) | `ramping-vus` / `constant-vus` | simulate concurrent users, realistic user journey | จำนวน user พร้อมกัน |
| **RPS** | `constant-arrival-rate` / `ramping-arrival-rate` | SLO-based test (เช่น "ต้องทน 200 req/s") | throughput (req/s) ไม่ว่าต้องใช้กี่ VUs |

**กฎ:**
- ถ้า SLO เขียนว่า "ต้องรับ X req/s" → ใช้ **RPS**
- ถ้า SLO เขียนว่า "ต้องรองรับ X concurrent users" → ใช้ **VUs**
- Smoke test → ใช้ **constant-vus** (1 VU × สั้น ๆ)

Switch ได้จาก `LOAD_MODEL=rps|vus` env var

---

## Test Types

| Type | Config override | เป้าหมาย |
|------|-----------------|----------|
| **smoke** | 1 VU × 30s | Sanity check endpoint ยังมีชีวิต — รันก่อน load/stress เสมอ |
| **load** | stages ค่าปกติ / RPS ปกติ | Simulate production traffic |
| **stress** | stages 3x normal + sustained peak | หา breaking point |
| **soak** | `ramping-vus` target ปกติ + duration > 1 hr | Memory leak / resource exhaustion |
| **spike** | `ramping-arrival-rate` พุ่งเร็ว แล้วตกไว | ดู system ตอบสนอง sudden burst |

⚠️ **stress/soak/spike** → รัน non-prod เท่านั้น ยกเว้นมี approval

---

## 7 กฎเหล็ก (ทุก test file)

### 1. ใช้ `HttpClient` wrapper ไม่ใช้ `k6/http` ตรง
```js
// ❌ ผิด
import http from 'k6/http';
const res = http.get('https://api.example.com/health');

// ✅ ถูก
import { HttpClient } from '../utils/httpClient.js';
const client = new HttpClient(cfg);
const res = client.get('/health', { name: 'health' });
```
เหตุผล: wrapper auto baseUrl + headers + tags + timeout

### 2. Tag endpoint ด้วย `{ name: '...' }` เสมอ
```js
client.get('/api/v1/products', { name: 'products' });   // ← tag = products
client.post('/login', body, { name: 'login' });          // ← tag = login
```
เหตุผล: per-endpoint threshold ทำงานบน tag นี้

### 3. Threshold ตั้งใน `config/<env>.js` ไม่ hardcode ใน test
```js
// config/prod.js
endpointThresholds: {
  health: { http_req_duration: ['p(95)<100', 'p(99)<200'] },
  login:  { http_req_duration: ['p(95)<600', 'p(99)<1500'] },
},
```
ใน test:
```js
import { buildThresholds } from '../utils/thresholds.js';
export const options = { scenarios, thresholds: buildThresholds(cfg) };
```

### 4. ใช้ `checkResponse` / `checkJsonResponse` — ไม่ใช้ raw `check()`
```js
// ❌ ผิด
check(res, { 'status 200': (r) => r.status === 200 });

// ✅ ถูก
checkResponse(res, { status: 200, maxDuration: 500, name: 'GET /health' });
```
เหตุผล: wrapper push custom metric (`custom_error_rate`, `custom_response_time`)

### 5. Sleep ระหว่าง request
- **smoke**: `sleep(1)` — กึ่ง idle user
- **load**: `sleep(0.5)` — realistic pace
- **stress**: `sleep(0.3)` — hammer
- **ห้าม** no-sleep ยกเว้น test constant-arrival-rate (k6 จัดการเอง)

### 6. Test data ใน `data/*.json` — ห้าม hardcode credential
```js
let testData = {};
try {
  testData = JSON.parse(open('../data/testData.json'));
} catch (_) { /* optional */ }

const user = testData.users
  ? testData.users[Math.floor(Math.random() * testData.users.length)]
  : { username: 'testuser', password: 'testpass' };
```
**ห้าม commit password จริง** ใน `testData.json` — ใช้ placeholder

### 7. Export `handleSummary` → JSON + HTML report
```js
import { handleSummary as summary } from '../reports/summary.js';
export { summary as handleSummary };
```

---

## ขั้นตอนเมื่อ user ขอ generate

### Step 1: ระบุ scope
ถาม user ถ้ายังไม่ชัด:
- **Target service** + base URL + environments (dev/staging/prod)
- **Test type**: smoke / load / stress / soak / spike
- **Endpoints**: method + path + expected status + SLO
- **Load model**: RPS หรือ VUs?
  - ถ้า SLO เป็น "X req/s" → RPS
  - ถ้า SLO เป็น "X concurrent users" → VUs
- **Auth required?** → token/credential flow
- **Test data**: มี fixture ยัง? (users, products, IDs)

### Step 2: เช็ค asset ที่มีอยู่ (**ห้ามสร้างซ้ำ**)
- [ ] `utils/httpClient.js`, `utils/check.js`, `utils/thresholds.js` มีอยู่แล้ว? → reuse
- [ ] `scenarios/{rps,vus}.js` มีอยู่แล้ว? → reuse
- [ ] `config/<env>.js` มี base URL + thresholds แล้ว? → append endpoint ใหม่
- [ ] `data/testData.json` มี user/endpoint อยู่แล้ว? → append

### Step 3: สร้าง/แก้ไฟล์ตาม order
1. อัปเดต `config/<env>.js` → base URL + `endpointThresholds` สำหรับ endpoint ใหม่
2. อัปเดต `data/testData.json` → users + endpoints (password: `[REDACTED]`)
3. สร้าง `tests/<feature>.test.js` (ดู example ใน `examples/tests/`)
4. อัปเดต `package.json` → เพิ่ม npm script ถ้าจำเป็น

### Step 4: Verify
```bash
# Smoke first (มักจะเร็วสุด)
k6 run -e ENV=dev tests/<feature>.test.js

# จากนั้น load/stress
npm run test:load
npm run test:stress
```

### Step 5: ดู report
- Console: real-time
- `reports/results-<timestamp>.json` — ข้อมูล raw
- `reports/results-<timestamp>.html` — dashboard
- Grafana (ถ้ามี): `K6_PROMETHEUS_RW_SERVER_URL=...`

---

## Threshold Reference (Default SLO)

| Metric | Strict | Standard | Relaxed |
|--------|--------|----------|---------|
| `http_req_duration` p(95) | < 300 ms | < 500 ms | < 1000 ms |
| `http_req_duration` p(99) | < 800 ms | < 1500 ms | < 3000 ms |
| `http_req_failed` rate | < 0.5% | < 1% | < 5% |
| `custom_error_rate` | < 0.5% | < 1% | < 5% |

ใช้จาก `utils/thresholds.js`:
```js
import { thresholdPresets } from '../utils/thresholds.js';
cfg.thresholds = thresholdPresets.strict;   // หรือ .standard / .relaxed
```

---

## Per-Endpoint Threshold Pattern

```js
// config/prod.js
endpointThresholds: {
  health:    { http_req_duration: ['p(95)<100', 'p(99)<200'] },
  login:     { http_req_duration: ['p(95)<800', 'p(99)<2000'] },
  products:  { http_req_duration: ['p(95)<300', 'p(99)<800'] },
  checkout:  { http_req_duration: ['p(95)<1000', 'p(99)<3000'] },
},
```

`buildThresholds(cfg)` จะแปลงเป็น tag-based k6 threshold:
```js
{
  'http_req_duration{name:health}':   ['p(95)<100', 'p(99)<200'],
  'http_req_duration{name:login}':    ['p(95)<800', 'p(99)<2000'],
  // ...
}
```

Request ต้อง tag ด้วย `name` ตรงกับ key:
```js
client.get('/health',    { name: 'health' });
client.post('/login',    body, { name: 'login' });
client.get('/api/v1/products',  { name: 'products' });
```

---

## Integration — Grafana/Prometheus + k6 Cloud

### Prometheus remote-write
```bash
K6_PROMETHEUS_RW_SERVER_URL=http://localhost:9090/api/v1/write \
K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM=true \
npm run test:load
```
Import [k6 Grafana dashboard ID 19665](https://grafana.com/grafana/dashboards/19665-k6-prometheus/) — filter ได้ตาม `project`, `env`, `testType`, `name` (endpoint)

### k6 Cloud
```bash
K6_CLOUD_TOKEN=your-token npm run test:load
# หรือรันทั้งหมดบน cloud:
k6 cloud tests/load.test.js
```

---

## GitLab CI (reference)

Pipeline 3 stages: `validate` → `performance_test` → `collect_report`

รับ variables จาก UI ตอน Run Pipeline:
- `TEST_TYPE` = smoke / load / stress (default `load`)
- `ENV` = dev / staging / prod (default `dev`)
- `LOAD_MODEL` = vus / rps (default `vus`)
- `BASE_URL`, `RPS`, `VUS`, `DURATION` — override

**Rule:**
- **threshold fail = warning** (ไม่ block pipeline) เพื่อให้เก็บ artifact ได้เสมอ
- artifact: JSON + HTML report

---

## Quality Checklist (ก่อนจบงาน)

- [ ] ใช้ `HttpClient` wrapper (ไม่ใช้ `k6/http` ตรง)
- [ ] ทุก request มี `{ name: '...' }` tag
- [ ] Threshold อยู่ใน `config/<env>.js` (ไม่ hardcode ใน test)
- [ ] ใช้ `checkResponse` / `checkJsonResponse` (ไม่ใช้ raw `check()`)
- [ ] `cfg.tags.testType` = `smoke` / `load` / `stress` ตรงกับไฟล์
- [ ] มี `sleep()` ระหว่าง request (ยกเว้น constant-arrival-rate)
- [ ] Test data อยู่ใน `data/*.json` (ไม่ hardcode credential)
- [ ] Export `handleSummary` → JSON + HTML report
- [ ] Smoke test ผ่านก่อน load/stress
- [ ] Per-endpoint threshold ตั้งครบทุก endpoint ใหม่

---

## ข้อห้าม

- ❌ `http.get(url)` ตรง — ต้อง `client.get(path, { name })`
- ❌ request ที่ไม่มี `name` tag — threshold per-endpoint จะ match ไม่ได้
- ❌ Threshold hardcode ใน test — ต้องอยู่ใน `config/<env>.js`
- ❌ `check()` ตรงจาก k6 — ใช้ wrapper ที่ update `custom_error_rate`
- ❌ Password/token จริงใน `data/testData.json` — ใช้ placeholder
- ❌ รัน stress/soak/spike บน prod โดยไม่มี approval
- ❌ ไม่มี `sleep` — จะกิน CPU ของ k6 agent ทิ้ง
- ❌ แยก threshold ตาม env ไม่ได้ — ใช้ `config/<env>.js` override

---

## Integration กับ skills อื่น

- **Input**: ถ้ามี `test-case-writer` output ที่มี endpoint + SLO → feed เข้า skill นี้
- **Output**: ถ้า test ล้มเหลว (threshold fail / timeout) → ใช้ `bug-report-writer` เขียน defect พร้อม JSON/HTML report
- **ต่อจาก E2E**: `e2e-test-generator` สำหรับ functional; `perf-test-generator` สำหรับ performance — คนละ dimension

---

## ไฟล์อ้างอิง

- [`examples/config/default.js`](examples/config/default.js) — base config
- [`examples/config/dev.js`](examples/config/dev.js) — env override
- [`examples/scenarios/rps.js`](examples/scenarios/rps.js) — RPS executors
- [`examples/scenarios/vus.js`](examples/scenarios/vus.js) — VUs executors
- [`examples/utils/httpClient.js`](examples/utils/httpClient.js) — HTTP wrapper
- [`examples/utils/check.js`](examples/utils/check.js) — response verification
- [`examples/utils/thresholds.js`](examples/utils/thresholds.js) — threshold builder + presets
- [`examples/data/testData.json`](examples/data/testData.json) — test data
- [`examples/tests/smoke.test.js`](examples/tests/smoke.test.js) — smoke example
- [`examples/tests/load.test.js`](examples/tests/load.test.js) — load example
- [`examples/tests/stress.test.js`](examples/tests/stress.test.js) — stress example
- [`references/load-model-decision.md`](references/load-model-decision.md) — เลือก RPS vs VUs
- [`references/threshold-design.md`](references/threshold-design.md) — ออกแบบ SLO/threshold ที่ดี
