# Threshold Design — SLO ที่ใช้งานได้จริง

เปลี่ยน SLO → k6 threshold ที่ fail ตรงจุด + ไม่ false alarm

---

## TL;DR

1. **Threshold = SLO ของ test ไม่ใช่ production**
2. **แยก global vs per-endpoint** — ให้ endpoint ช้าๆ (reporting) ไม่ drag ตัวที่ต้องเร็ว (health check)
3. **ใช้ p(95) + p(99)** ไม่ใช่ avg — long tail เจ็บจริง
4. **fail-rate ≤ 1%** เป็น baseline ส่วนใหญ่; **< 0.5%** ถ้า mission-critical

---

## Metrics หลักที่ควรตั้ง

| Metric | ความหมาย | Preset Standard |
|--------|---------|-----------------|
| `http_req_duration` | total request time (DNS + TCP + TLS + waiting + receiving) | `p(95)<500`, `p(99)<1500` |
| `http_req_waiting` | TTFB (Time To First Byte) — ตัด network | `p(95)<400` |
| `http_req_failed` | rate ของ status ≥ 400 หรือ connection error | `rate<0.01` |
| `http_reqs` | throughput (req/s) | `rate>100` (SLO) |
| `iterations` | rate ของ iteration completion | — |
| `vus` | concurrent VUs | — |
| **custom** `custom_error_rate` | จาก `checkResponse()` failure | `rate<0.01` |

---

## Level ของ Threshold

### Level 1 — Global (baseline)
ใช้กับทุก endpoint — จับปัญหา system-wide

```js
// config/default.js
thresholds: {
  http_req_duration: ['p(95)<500', 'p(99)<1500'],
  http_req_failed:   ['rate<0.01'],
},
```

### Level 2 — Per-Endpoint (specific SLO)
ใช้ tag-based threshold — แต่ละ endpoint มี SLO ของตัวเอง

```js
// config/prod.js
endpointThresholds: {
  health:    { http_req_duration: ['p(95)<100', 'p(99)<200'] },    // must be fast
  login:     { http_req_duration: ['p(95)<800', 'p(99)<2000'] },   // bcrypt = slow
  search:    { http_req_duration: ['p(95)<400'] },
  checkout:  { http_req_duration: ['p(95)<1000', 'p(99)<3000'] },  // payment gateway
  reporting: { http_req_duration: ['p(95)<5000'] },                // async OK
},
```

Request ต้อง tag ด้วย `name`:
```js
client.get('/health',   { name: 'health' });
client.post('/login',   body, { name: 'login' });
```

### Level 3 — Scenario-Specific
ใช้ scenario tag เพื่อแยก load vs stress

```js
thresholds: {
  'http_req_duration{scenario:load}':   ['p(95)<500'],
  'http_req_duration{scenario:stress}': ['p(95)<2000'],   // ผ่อนใน stress
}
```

---

## Preset Tiers (จาก `utils/thresholds.js`)

```js
export const thresholdPresets = {
  strict: {
    http_req_duration: ['p(95)<300', 'p(99)<800'],
    http_req_failed:   ['rate<0.005'],
  },
  standard: {
    http_req_duration: ['p(95)<500', 'p(99)<1500'],
    http_req_failed:   ['rate<0.01'],
  },
  relaxed: {
    http_req_duration: ['p(95)<1000', 'p(99)<3000'],
    http_req_failed:   ['rate<0.05'],
  },
};
```

**ใช้เมื่อ:**
- **strict** — mission-critical endpoint (health, heartbeat, payment confirmation)
- **standard** — endpoint ปกติ (CRUD, search, profile)
- **relaxed** — endpoint หนัก (reporting, export, aggregation)

---

## Absoluste vs Relative Threshold

### Absolute (fail ตาม number ตรงๆ)
```js
http_req_duration: ['p(95)<500']
```

### Abort — stop test ถ้า fail
```js
thresholds: {
  http_req_failed: [{ threshold: 'rate<0.05', abortOnFail: true }],
},
```
ใช้เมื่อ error rate เกิน 5% = system พัง ให้หยุด

### Delay abort (รอดู long-running test)
```js
{ threshold: 'rate<0.05', abortOnFail: true, delayAbortEval: '1m' }
```

---

## หา threshold ที่ใช้ได้จริง (workflow)

### 1. Baseline run — ไม่มี threshold
รัน smoke + load บน dev **โดยไม่ตั้ง threshold** — ได้ p(95), p(99) จริง

```bash
k6 run -e ENV=dev tests/load.test.js
# ดู result: p(95)=230ms, p(99)=540ms
```

### 2. Set threshold ที่ **20% เผื่อ**
```js
// baseline p(95)=230ms → threshold p(95)<280ms (≈20% higher)
// baseline p(99)=540ms → threshold p(99)<650ms
```

### 3. Validate บน staging
ถ้า staging fail → threshold ไม่ realistic, ต้องปรับ

### 4. Lock threshold ใน prod config + monitor trend
Alert ถ้า 3 runs ล่าสุด p(95) increasing 10%+

---

## Anti-patterns

### ❌ Threshold ที่หย่อนเกินไป
```js
http_req_duration: ['p(95)<10000']   // 10s — ใครๆ ก็ผ่าน
```
→ test ผ่านตลอด แต่ผู้ใช้จริงทิ้งระบบไปแล้ว

### ❌ ตั้ง avg แทน percentile
```js
http_req_duration: ['avg<500']   // ← หลอกโดย short response จำนวนมาก
```
Long tail (p(95), p(99)) คือคนที่เจ็บจริง

### ❌ ไม่แยก global vs per-endpoint
→ reporting endpoint (5s) drag health check ให้ fail ด้วย

### ❌ Threshold ไม่ update ตาม SLO เปลี่ยน
→ SLO team ลดจาก 500ms → 300ms แต่ test ยัง 500ms → bug หลุด prod

### ❌ ไม่ tag → per-endpoint threshold ไม่ทำงาน
```js
client.get('/products');   // ไม่มี { name } — tag:name default = URL → ใช้ SLO ไม่ได้
```

---

## Threshold + CI/CD

### GitLab CI — allow fail แต่เก็บ report
```yaml
performance_test:
  script: ./scripts/run.sh ${TEST_TYPE} ${ENV}
  allow_failure: true                      # ← threshold fail = warning
  artifacts:
    when: always                           # ← เก็บ report แม้ fail
    paths: [reports/]
```

### GitHub Actions — fail build ถ้า threshold fail
```yaml
- run: k6 run tests/load.test.js
  # k6 exit 99 ถ้า threshold fail → step fail โดยอัตโนมัติ
```

---

## SLO → Threshold Mapping

| SLO statement (business) | k6 threshold |
|--------------------------|--------------|
| "API ต้องตอบใน 500ms 95% ของเวลา" | `http_req_duration: ['p(95)<500']` |
| "ต้อง uptime 99.9%" (= error rate ≤ 0.1%) | `http_req_failed: ['rate<0.001']` |
| "Health check ต้องเร็วกว่า 100ms" | `http_req_duration{name:health}: ['p(95)<100']` |
| "รับ peak 500 req/s โดย error ≤ 1%" | `http_req_failed: ['rate<0.01']` + RPS executor rate=500 |
| "Login ต้องตอบใน 2s แม้ตอน peak" | `http_req_duration{name:login}: ['p(99)<2000']` |
