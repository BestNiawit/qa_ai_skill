# Load Model Decision — RPS vs VUs

เลือก load model ให้ตรงกับคำถามทาง business

---

## TL;DR

| คำถาม | ใช้ |
|-------|-----|
| "ระบบรับ X req/s ได้มั้ย?" | **RPS** |
| "ระบบรับ X concurrent users ได้มั้ย?" | **VUs** |
| ต้องการ **smoke / sanity check** | **VUs** (constant-vus = 1) |
| ต้องการ **soak test** | **VUs** (constant-vus + long duration) |
| ต้องการ **spike test** (sudden burst) | **RPS** (ramping-arrival-rate) |
| ต้องการ **stress test** (หา breaking point) | ได้ทั้งคู่ (VUs + aggressive ramp / RPS 3x normal) |
| Frontend ทดสอบ user journey | **VUs** |
| Backend API SLO ทดสอบ throughput | **RPS** |

---

## RPS — Requests Per Second

**Executor**: `constant-arrival-rate` / `ramping-arrival-rate`

**ข้อดี:**
- **คุม throughput ตายตัว** — ไม่ว่า API ช้าแค่ไหน k6 จะส่งตาม rate ที่กำหนด
- ตรงกับ SLO ส่วนใหญ่ที่เขียนเป็น "X req/s"
- ไม่ depend กับ response time — ช้าแค่ไหนก็ยังส่งอยู่

**ข้อเสีย:**
- ถ้า API ช้ามาก → queue เยอะ → เกิด `dropped_iterations` ต้องเพิ่ม `maxVUs`
- ไม่สะท้อน "user experience" — user จริงรอ response แล้วถึงยิงต่อ

**Config pattern:**
```js
// config/dev.js
rps: {
  rate: 200,               // 200 req/s
  timeUnit: '1s',
  duration: '1m',
  preAllocatedVUs: 50,     // k6 จองไว้ล่วงหน้า
  maxVUs: 200,             // เพดาน scale up ถ้า rate ไม่ทัน
}
```

**ใช้ตอน:**
- ทดสอบ SLO เช่น "checkout API ต้อง handle 500 req/s ได้ p(95)<800ms"
- Integration test กับ rate limiter / circuit breaker
- Capacity planning: "ถ้าเราอยากรับ peak 1000 req/s ต้อง provision เท่าไหร่?"

---

## VUs — Virtual Users

**Executor**: `ramping-vus` / `constant-vus`

**ข้อดี:**
- **คุม concurrency** (จำนวน user พร้อมกัน)
- สะท้อน real user — user 1 คน iterate loop → sleep → iterate
- Iteration rate = VUs / avg(iteration_duration) — auto-adjust ถ้า API ช้า

**ข้อเสีย:**
- Throughput จริงขึ้นกับ response time — ถ้า API ช้าลง throughput ก็ตก
- ยาก map SLO ตายตัว (ต้องคำนวณ: "50 VUs × 2 req/iter × 0.5s sleep = 100 req/s โดยประมาณ")

**Config pattern:**
```js
// config/dev.js
vus: {
  stages: [
    { duration: '30s', target: 10 },   // ramp up
    { duration: '1m',  target: 50 },   // sustain
    { duration: '30s', target: 0 },    // ramp down
  ],
}
```

**ใช้ตอน:**
- User journey test — login → browse → add to cart → checkout
- Smoke test (1 VU → `constantVus`)
- Soak test (ต่ำ แต่รันนาน ดู memory leak)

---

## Decision Tree

```
SLO เขียนเป็นอะไร?
├── "X req/s" / "throughput X" / "peak traffic X req/s"
│   → RPS (constant-arrival-rate / ramping-arrival-rate)
│
├── "X concurrent users" / "X users online" / "session count"
│   → VUs (ramping-vus / constant-vus)
│
├── "response p(95) < Xms at Y load"
│   ├── Y เป็น req/s → RPS
│   └── Y เป็น users → VUs
│
└── ไม่มี SLO ชัด
    └── VUs default (เริ่มจาก 10 → 50 → 100)
```

---

## Override จาก CLI

```bash
# Switch โดยไม่ต้องแก้ config
LOAD_MODEL=rps ./scripts/run.sh load staging
LOAD_MODEL=vus ./scripts/run.sh load staging

# Override ค่า RPS mode
LOAD_MODEL=rps RPS=500 DURATION=10m ./scripts/run.sh load prod

# Override ค่า VUs mode
LOAD_MODEL=vus VUS=100 DURATION=5m ./scripts/run.sh load staging
```

---

## Anti-patterns

### ❌ ใช้ VUs เพื่อคุม throughput
```js
// "ต้องการ 200 req/s ใช้ VUs = 200"   ← ผิด!
```
ถ้า response 500ms → 200 VUs × 2 iter/s = 400 req/s (ไม่ใช่ 200)
ถ้า response 2s → 200 VUs × 0.5 iter/s = 100 req/s (ไม่ใช่ 200)
**→ ใช้ RPS**

### ❌ ใช้ RPS เพื่อคุม concurrency
```js
// "ต้องการ 50 users พร้อมกัน ใช้ rate=50"   ← ผิด!
```
RPS ไม่ cap concurrency — ถ้า API ช้า k6 จะ spawn VUs เพิ่มถึง maxVUs
**→ ใช้ VUs**

### ❌ `preAllocatedVUs` น้อยเกินไปใน RPS
```js
rps: { rate: 500, preAllocatedVUs: 10 }   // ← k6 จะ warn + spawn เพิ่ม
```
Rule of thumb: `preAllocatedVUs ≥ rate × avg(response_time_sec) × 1.5`
เช่น rate=500, response=300ms → pre = 500 × 0.3 × 1.5 ≈ 225

### ❌ ไม่มี ramp-up/ramp-down ใน stress test
```js
vus: { stages: [{ duration: '5m', target: 500 }] }   // ← server shock
```
ควร ramp up ค่อยๆ:
```js
vus: {
  stages: [
    { duration: '1m',  target: 50 },
    { duration: '2m',  target: 150 },
    { duration: '3m',  target: 300 },
    { duration: '1m',  target: 300 },   // sustain peak
    { duration: '2m',  target: 0 },     // ramp down
  ]
}
```
