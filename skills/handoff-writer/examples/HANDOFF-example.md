# HANDOFF — PEA-LV E2E Playwright migration

> **For:** AI ตัวใหม่ที่จะ pick up งานต่อจากนี้
> **From:** AI session เดิม (Claude Opus 4.7, ~85% context used, 2026-05-12 14:30)
> **Skill ที่ใช้อยู่:** [`e2e-test-generator`](../SKILL.md) (framework: Playwright + TS)

---

## 1. งานที่ทำอยู่

แปลง SIT TC ของ feature **Leave Approval Flow** (TC_PEA_LV_010..017) → Playwright E2E specs ตาม Page Object Model

**Working dir:** `/Users/<you>/Documents/GitHub/automation-starter-kit-playwright`

---

## 2. ทำเสร็จแล้ว (อย่าทำซ้ำ)

| Item | Path | Status |
|------|------|--------|
| Page Object — Leave list | `pages/leave-list.page.ts` | ✅ ผ่าน lint + smoke run |
| Page Object — Leave detail | `pages/leave-detail.page.ts` | ✅ |
| Locators (shared) | `locators/common.locators.ts` | ✅ |
| Labels (TH/EN constants) | `labels/leave.labels.ts` | ✅ |
| Spec — TC_PEA_LV_010 (submit happy path) | `tests/leave/submit.spec.ts` | ✅ pass |
| Spec — TC_PEA_LV_011 (boundary: 0 day) | `tests/leave/submit-boundary.spec.ts` | ✅ pass |
| Spec — TC_PEA_LV_012 (negative: overlap) | `tests/leave/submit-overlap.spec.ts` | ✅ pass |

---

## 3. กำลังทำ (ค้างกลางคัน)

**TC_PEA_LV_013 — Manager approval flow (multi-role)** — เขียนได้ ~60%

- File: `tests/leave/approve.spec.ts` (สร้างแล้ว แต่ test body ยังไม่ครบ)
- ปัญหา: locator ของปุ่ม "Approve" ใน manager dashboard ยังไม่ unique — มีปุ่มชื่อเดียวกันใน 3 list view
- **Next AI ต้อง:** เพิ่ม shared locator `MANAGER_APPROVE_BTN_BY_TC_ID` ใน `locators/manager.locators.ts` ที่รับ `tcId` param แล้วใช้ XPath ที่ filter `[contains(@data-tc-id, '{tcId}')]`

---

## 4. ยังไม่ได้แตะ (next batch)

- TC_PEA_LV_014 (cancel after approval)
- TC_PEA_LV_015 (reject + reason)
- TC_PEA_LV_016 (HR override)
- TC_PEA_LV_017 (Status sync delay bug — มี defect PEA-LV-187 อยู่ → spec ต้อง mark `test.fail()` พร้อม comment ลิงก์ defect)

---

## 5. Decisions ที่ตัดสินไปแล้ว (อย่าเสนอใหม่)

| Decision | เหตุผล |
|----------|--------|
| ใช้ Playwright + TS (ไม่ใช่ Cypress) | ทีมเลือกแล้วตอน kickoff — มี POM pattern + parallel run |
| Locator strategy = `data-test-id` attribute เป็นหลัก, XPath เฉพาะกรณี dynamic | คุย dev review แล้ว, BE จะใส่ `data-test-id` ทุก interactive element |
| Test data = fixture JSON ใน `data/leave-fixtures.json` (ไม่ seed DB) | ลด flakiness, run parallel ได้ |
| ไม่ใช้ `test.use({ storageState })` สำหรับ login | session timeout 15 นาที, storageState จะ stale ระหว่าง suite ยาว → ใช้ login helper แทน |
| ภาษา label ใน assertion = constant จาก `labels/*.ts` (ไม่ hardcode string) | ทีมจะรองรับ EN ใน Q3, ไม่อยาก rewrite |

---

## 6. Files ที่แก้/สร้างใน session นี้

```
M  playwright.config.ts                    (เพิ่ม projects: leave-th, leave-en)
M  pages/base.page.ts                      (เพิ่ม captureStep helper)
A  pages/leave-list.page.ts
A  pages/leave-detail.page.ts
A  locators/common.locators.ts
A  labels/leave.labels.ts
A  tests/leave/submit.spec.ts
A  tests/leave/submit-boundary.spec.ts
A  tests/leave/submit-overlap.spec.ts
A  tests/leave/approve.spec.ts             (← ครึ่งทาง, ดู §3)
A  data/leave-fixtures.json
```

---

## 7. Environment / Credentials

- SIT URL: `https://sit-pea-lv.example.com` — set ใน `.env` เป็น `BASE_URL`
- Test user (manager role): `mgr_test_001` — password ใน `.env` เป็น `TEST_PASSWORD_MGR` (`[REDACTED]` ใน HANDOFF)
- Test user (employee role): `emp_test_042` — password env var `TEST_PASSWORD_EMP` (`[REDACTED]`)
- `.env` อยู่ที่ root ของ working dir — gitignored

---

## 8. คำสั่งรันที่ใช้ตรวจของ

```bash
npx playwright test tests/leave/submit.spec.ts --project=leave-th
npx playwright test tests/leave/ --workers=2          # ทั้ง suite
npx playwright show-report                            # หลัง run
```

ถ้า lint:
```bash
npm run lint
```

---

## 9. Reference

- SIT TC source: `docs/sit-tc-leave.md` (TC_PEA_LV_010..017)
- Page Object pattern + locator convention: [`skills/e2e-test-generator/frameworks/playwright-ts.md`](../../e2e-test-generator/frameworks/playwright-ts.md)
- Canonical reference repo: `automation-starter-kit-playwright` (`project-context.md` key `reference_repo`)

---

## 10. คำถามที่ค้าง (next AI ถ้าเจอ ให้ถาม PM/TL ก่อน)

- TC_PEA_LV_017 — ตอน defect PEA-LV-187 fix แล้ว ต้องลบ `test.fail()` ออก. ใครเป็นคน trigger ขั้นนี้? → ยังไม่ตัดสิน
- คาดว่าจะรัน parallel กี่ workers ใน CI? — ตอนนี้ใช้ 2 บน local, CI ยังไม่ตั้ง → ถาม DevOps
