# Integration Points — <Feature Name>

> **จุดประสงค์:** list จุดเชื่อมระหว่าง feature ใหม่กับระบบเดิม — **เป็นจุดที่เจอบั๊กบ่อยที่สุด** เพราะ dev โฟกัสกับ feature ใหม่แต่ลืมว่ามันแตะอะไรเดิม
> **Rule:** ถ้าตอบว่า "feature นี้ standalone ไม่แตะอะไรเดิม" → ต้องถาม Dev ยืนยัน **ห้ามเดา**

---

## Meta

| Field | Value |
|-------|-------|
| **Feature** | เช่น Register with Middle Name |
| **Base system** | เช่น PMS Core (Register, Profile, User Directory) |
| **QA** | เช่น คุณ... |
| **Dev confirmed?** | ⬜ Yes / ⬜ No (ถ้า No → ใส่ `[Assumption: ...]` ที่ทุก integration point) |
| **Created** | YYYY-MM-DD |

---

## Classification ของ Integration

| Type | ความหมาย | ตัวอย่าง |
|------|---------|---------|
| **Upstream (ใหม่ ← เก่า)** | ฟีเจอร์ใหม่ **อ่าน** ข้อมูลจากของเก่า | อ่าน session, อ่าน permission, อ่าน existing profile |
| **Downstream (ใหม่ → เก่า)** | ฟีเจอร์ใหม่ **เขียน** ข้อมูล/event ที่ของเก่าใช้ | เขียน user table, fire event, invalidate cache |
| **Shared surface** | ฟีเจอร์ใหม่ใช้ component/endpoint/column เดียวกับของเก่า | UI component ร่วม, DB column ร่วม, API endpoint ร่วม |

---

## Integration Point IP-01 — <ตั้งชื่อ>

| Attribute | Value |
|-----------|-------|
| **Type** | Downstream (ใหม่ → เก่า) |
| **Description** | Feature ใหม่เขียน `middle_name` เข้า `users` table ที่ของเก่าอ่านอยู่แล้ว |
| **Direction / Data contract** | Register API → INSERT users(first_name, **middle_name**, last_name, ...) |
| **Affected existing components** | Profile page, User Directory, Header greeting, Comment system (ทุกจุดที่แสดงชื่อ) |
| **Failure modes ที่เป็นไปได้** | 1. DB migration ไม่รัน → column ไม่มี → INSERT fail<br>2. Existing user (middle_name=NULL) แสดงผลแตกใน Profile / Directory<br>3. Join query เดิมใช้ `SELECT *` — อาจ break ถ้า column ลำดับเปลี่ยน |
| **Test ideas** | - Register new user → verify ทุกหน้าที่แสดงชื่อ<br>- Existing user (ก่อน feature deploy) → verify ไม่ break<br>- Query DB โดยตรง + เช็คว่า NULL ไม่ทำ UI crash |
| **Oracle** | Baseline: profile display pattern เดิม (2-word name) |
| **Risk** | 🔴 Critical — affect existing users |

---

## Integration Point IP-02 — <ตั้งชื่อ>

| Attribute | Value |
|-----------|-------|
| **Type** | Shared surface |
| **Description** | Profile page component ใช้ same `<NameDisplay>` component กับทุกที่อื่นในระบบ (header, comment, admin list) |
| **Direction / Data contract** | `<NameDisplay user={user}>` — prop shape เพิ่ม field `middle_name` |
| **Affected existing components** | Header greeting, Comment author, Admin user list, Email template (ถ้าใช้ "Hi {{name}}") |
| **Failure modes ที่เป็นไปได้** | 1. Admin list แสดงชื่อสั้นจะตัดเกิน — layout พัง<br>2. Email template hardcode "Hi {{first_name}} {{last_name}}" — middle_name หายไป<br>3. Mobile app ที่ใช้ same API ไม่ parse field ใหม่ — crash/empty |
| **Test ideas** | - Visual regression ทุกจุดที่ใช้ `<NameDisplay>`<br>- ส่ง test email — verify template render ชื่อครบ 3 คำ<br>- Test mobile app (iOS + Android) ถ้า share backend |
| **Oracle** | Baseline: ถ้ามี `<NameDisplay>` ทดสอบไม่ได้ → ต้อง request design mockup |
| **Risk** | 🟠 High — visible to end user |

---

## Integration Point IP-03 — <ตั้งชื่อ>

| Attribute | Value |
|-----------|-------|
| **Type** | Upstream (ใหม่ ← เก่า) |
| **Description** | Register validation ใช้ `validate_name()` ฟังก์ชันเดียวกับ first_name/last_name |
| **Direction / Data contract** | `validate_name(str) -> bool` — ฟังก์ชันเดิม รองรับ unicode, reject special char |
| **Affected existing components** | first_name, last_name validation behavior เดิม |
| **Failure modes ที่เป็นไปได้** | 1. ถ้า Dev แก้ `validate_name()` เพิ่ม rule สำหรับ middle_name — rule รั่วไปที่ first/last ด้วย<br>2. Regex ใหม่ยาวเกิน → performance hit ที่ field อื่น |
| **Test ideas** | - Regression test first_name + last_name หลัง deploy<br>- Performance: validation latency < 10ms per call |
| **Oracle** | Baseline: first_name/last_name test suite เดิม (รัน regression) |
| **Risk** | 🟡 Medium — contained risk |

---

## Quick Red Flag Checklist

ตรวจว่า integration point พวกนี้คิดถึงแล้วมั้ย — ถ้าตอบ "ไม่แน่ใจ" ให้ถาม Dev:

- [ ] **Database schema:** มี migration ไหม? existing rows default value?
- [ ] **API response shape:** field ใหม่อยู่ใน response? client ทุกเวอร์ชันรับได้?
- [ ] **Search / filter / sort:** field ใหม่ถูก index? search เดิมยัง work?
- [ ] **Export / Import:** CSV/Excel export มี column ใหม่? import template compatible?
- [ ] **Cache invalidation:** แก้ field → cache เดิมถูก invalidate?
- [ ] **Event / notification:** trigger event ที่มีคนฟัง? payload shape เปลี่ยน?
- [ ] **Permission / RBAC:** ใครอ่าน/เขียน field ใหม่ได้บ้าง? PII?
- [ ] **Audit log / analytics:** track field ใหม่?
- [ ] **Email / SMS template:** ใช้ field ใหม่?
- [ ] **Mobile app / 3rd-party SDK:** ใช้ API เดียวกัน?
- [ ] **Admin panel:** admin แก้ field ใหม่ได้ไหม?
- [ ] **Localization / i18n:** label ใหม่แปล้ครบทุกภาษา?

---

## Summary

- **จำนวน Integration Point:** 3
- **Critical:** IP-01 (DB + display chain)
- **High:** IP-02 (shared component)
- **Medium:** IP-03 (shared validator)
- **ต้องถาม Dev:** ___ (ใส่ item ที่ Dev ยังไม่ confirm)
- **Red Flag Checklist completed:** __/12
