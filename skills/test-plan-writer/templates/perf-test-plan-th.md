# Performance Test Plan — <Module/Scope>

| Field | Value |
|-------|-------|
| Document ID | `PERF_PLAN_<SCOPE>_v1.0` |
| Version | 1.0 |
| Date | YYYY-MM-DD |
| Author | <QC Lead + TL> |
| Reviewer | <TL / DevOps / Architect> |
| Approver | <PM> |

---

## 1. Objective
<ต้องการยืนยันว่าระบบรับ load ตาม NFR ก่อน Go-Live>

## 2. Scope

### 2.1 In-Scope
- Business Flow 1: Login → Search Employee → Create Leave → View Dashboard
- Business Flow 2: Admin: Login → View Report → Export Excel

### 2.2 Out-of-Scope
- Internal admin tools (ใช้โดย < 5 คน)
- Third-party service (testing ด้วย mock)

## 3. Entry Criteria
1. Functional SIT ผ่านแล้ว
2. Perf Test Environment พร้อม (ขนาดเท่า production หรือ scale factor ชัดเจน)
3. Test Data prepared (dummy users, records)
4. Monitoring tools ready (Grafana, APM)

## 4. Exit Criteria
1. ทุก Endpoint ผ่าน NFR
2. ไม่มี S1 Critical Bottleneck ที่ block Go-Live
3. Tuning Recommendation ที่ Must Fix แก้เสร็จ + re-test ผ่าน

## 5. Workload Model

### 5.1 Load Model
- **Mode:** <RPS / VUs>
- **Rationale:** ถ้า SLO = "ต้องรับ X req/s" → RPS; ถ้า "X concurrent users" → VUs

### 5.2 User Distribution
<จาก Production Log หรือประมาณการ>

| User Type | % | Concurrent (peak) | Think Time |
|-----------|---|-------------------|-----------|
| Employee | 70% | 350 | 3-5s |
| Manager | 20% | 100 | 5-10s |
| Admin | 10% | 50 | 10-20s |
| **Total** | 100% | **500** | - |

### 5.3 Scenarios

| Scenario | Test Type | Load | Duration |
|----------|-----------|------|----------|
| Smoke | smoke | 1 VU × 30s | 30s |
| Normal Load | load | 500 VUs / 200 RPS | 30 min |
| Peak Load | load | 1000 VUs / 400 RPS | 15 min |
| Stress | stress | 1500 VUs ramping | 45 min |
| Soak | soak | 300 VUs | 4 hours |
| Spike | spike | 100 → 2000 RPS | 30s burst |

## 6. Performance Metrics + NFR

| Metric | NFR Target |
|--------|-----------|
| Response Time (p95) | ≤ 3 วินาที |
| Response Time (p99) | ≤ 5 วินาที |
| Throughput | ≥ 200 TPS |
| Error Rate | ≤ 1% |
| CPU Utilization | ≤ 80% |
| Memory Usage | ≤ 85% |

### 6.1 Per-Endpoint Threshold

| Endpoint | p(95) | p(99) | TPS | Error % |
|----------|-------|-------|-----|---------|
| POST /auth/login | ≤ 600ms | ≤ 1500ms | ≥ 80 | ≤ 1% |
| GET /employees?q= | ≤ 1000ms | ≤ 2000ms | ≥ 50 | ≤ 1% |
| POST /leave | ≤ 800ms | ≤ 2000ms | ≥ 30 | ≤ 1% |
| GET /reports/summary | ≤ 2000ms | ≤ 5000ms | ≥ 15 | ≤ 1% |

## 7. Test Environment

| รายการ | รายละเอียด |
|-------|-----------|
| App Server | <spec: CPU, RAM, disk> |
| DB Server | <spec + version> |
| Load Generator | <k6/JMeter location + spec> |
| Network | <bandwidth, latency> |
| Monitoring | Grafana + Prometheus + APM |

**Scale factor vs Production:** <1:1 or documented ratio>

## 8. Tool + Script
- **Load Test Tool:** k6 ≥ 0.45 (or JMeter / Gatling)
- **Script Repo:** `<path>`
- **Config:** `config/<env>.js`
- **Data:** `data/testData.json`

## 9. Roles & Responsibilities

| Role | Responsibility |
|------|---------------|
| QC Lead | Plan, execute, analyze |
| TL/Architect | Review Workload Model, approve Tuning |
| DevOps | Provision env, monitoring |
| Dev | Implement Tuning |
| PM | Sign-off |

## 10. Schedule

> Perf test effort ไม่ based on TC sizing (ไม่มี TC count ตรง) — ใช้ Scenario-based estimate + Buffer `qa-standards.md §4`
> Track Actual vs Estimate ใน `sprint-tracking-th.csv`

### 10.1 Effort Breakdown (hrs)

| Phase | Estimate Formula | Hours |
|-------|------------------|------:|
| Script Prep | 2 hr × endpoints | <hr> |
| Smoke + Baseline | 2 hr | 2 |
| Load Test | duration + 30% setup | <hr> |
| Stress Test | duration + 30% setup | <hr> |
| Soak Test | duration + 30% setup | <hr> |
| Analysis + Report | 8 hr | 8 |
| Tuning + Re-test | Script Prep × 0.5 | <hr> |
| **SubTotal** | | **<hr>** |
| Buffer | SubTotal × 0.20 | <hr> |
| **Total** | | **<hr>** |

### 10.2 Calendar Schedule

| Phase | Start | End | Duration |
|-------|-------|-----|----------|
| Script Prep | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Smoke + Baseline | YYYY-MM-DD | YYYY-MM-DD | <day> |
| Load Test | YYYY-MM-DD | YYYY-MM-DD | <day> |
| Stress Test | YYYY-MM-DD | YYYY-MM-DD | <day> |
| Soak Test | YYYY-MM-DD | YYYY-MM-DD | <day> |
| Analysis + Report | YYYY-MM-DD | YYYY-MM-DD | <days> |
| Tuning + Re-test | YYYY-MM-DD | YYYY-MM-DD | <days> |

## 11. Risk & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Env ไม่เท่า prod | High | High | Document scale factor, extrapolate result |
| Test data ไม่สมจริง | Medium | High | Use production-like dataset (masked) |
| Load generator เป็น bottleneck | Medium | High | Monitor LG CPU/network; distributed load if needed |
| รบกวน env อื่น | Medium | Medium | รันนอกเวลาทำงาน; notify team |

## 12. Defect Management
> ใช้ S1-S4 ตาม `references/qa-standards.md §1`

- Threshold fail → defect ใน Jira พร้อม raw result + analysis
- Severity mapping (Perf-specific):
  - **S1 Critical**: NFR fail > 50% endpoints หรือ service crash / memory leak
  - **S2 Major**: NFR fail single endpoint + no workaround
  - **S3 Minor**: NFR fail minor endpoint / low priority
  - **S4 Cosmetic**: variance ภายใน ±5% ของ NFR

## 13. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QC Lead | | | |
| TL | | | |
| DevOps | | | |
| PM | | | |
