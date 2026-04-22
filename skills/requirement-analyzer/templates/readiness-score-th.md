# Requirement Readiness Score — {{Module Title}}

**Module ID:** `{{MODULE_ID}}`
**Source BRD:** `{{path/to/brd.md}}` (version/date: {{...}})
**Analyzed by:** QA AI (requirement-analyzer skill) — {{YYYY-MM-DD}}
**Reviewer ที่แนะนำ:** {{PM/BA name}}

---

## Overall Readiness

> **Score: {{X}}/8 → {{Ready / Needs-clarification / Not-ready}}**

**กฎการแปลผล:**
- **Ready (7-8):** → ไป `test-case-writer` ได้ (แต่ยังควรส่ง PM/BA confirm Assumptions)
- **Needs-clarification (4-6):** → **ต้องรอ PM/BA ตอบ Open Questions** ใน `pm_confirmation_*.md` ก่อนเริ่ม TC
- **Not-ready (0-3):** → **หยุด** — PM/BA ต้อง rewrite BRD ก่อน (ชี้ gap ใน Criteria ที่ Fail)

---

## 8 Criteria Evaluation

| # | Criterion | Status | Evidence / Gap |
|---|-----------|:------:|----------------|
| 1 | **Actor / Role** ชัดเจน | {{✅/⚠️/❌}} | {{ยกตัวอย่าง quote จาก BRD หรือ "ไม่ระบุ role"}} |
| 2 | **Main Flow** มี step ได้ | {{✅/⚠️/❌}} | {{จำนวน step หรือ "มีแต่ประโยค narrative"}} |
| 3 | **Alt Flow / Error Handling** ระบุ | {{✅/⚠️/❌}} | {{error case ที่มี / ไม่มี}} |
| 4 | **Acceptance Criteria** วัดได้ | {{✅/⚠️/❌}} | {{AC ที่มี หรือ "เขียนแค่ 'ทำงานถูกต้อง'"}} |
| 5 | **Business Rules** ครบ | {{✅/⚠️/❌}} | {{formula/constraint ที่ระบุ}} |
| 6 | **Data / Input format** | {{✅/⚠️/❌}} | {{field name+type+length ระบุไหม}} |
| 7 | **NFR** (perf/security/compat) | {{✅/⚠️/❌}} | {{p95 / error rate / HTTPS etc.}} |
| 8 | **Out-of-scope** ระบุ | {{✅/⚠️/❌}} | {{กัน scope creep ชัดไหม}} |

**Scoring:** ✅ = 1 pt, ⚠️ = 0.5 pt, ❌ = 0 pt → **Total: {{X}}/8**

---

## Top Gaps (เรียงความสำคัญ)

> กรอกเฉพาะ criterion ที่ ⚠️ หรือ ❌ — ใช้เป็น input ของ PM Confirmation Doc Open Questions

1. **{{Criterion ที่ Fail}}** — gap: {{รายละเอียด}} — **impact:** {{ถ้าไม่ clarify จะกระทบ TC coverage อย่างไร}}
2. ...

---

## Recommended Next Step

- [ ] {{เลือก 1}} — **Ready** → เริ่ม `test-plan-writer` + `test-case-writer` ได้เลย (แนบ Assumption list ให้ tester รับรู้)
- [ ] {{เลือก 1}} — **Needs-clarification** → ส่ง [`pm_confirmation_{{module_id}}_{{date}}.md`](pm_confirmation_{{module_id}}_{{date}}.md) ให้ PM/BA confirm ภายใน {{deadline}}
- [ ] {{เลือก 1}} — **Not-ready** → ประชุม requirement clarification กับ PM/BA ก่อน rewrite BRD section: {{ระบุ section}}

---

## Artifacts Generated

- [`normalized_req_{{module_id}}_{{date}}.md`](normalized_req_{{module_id}}_{{date}}.md) — Normalized FR spec สำหรับ feed `test-case-writer`
- [`pm_confirmation_{{module_id}}_{{date}}.md`](pm_confirmation_{{module_id}}_{{date}}.md) — Document ส่งให้ PM/BA review
