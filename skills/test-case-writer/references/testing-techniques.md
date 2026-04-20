# Testing Techniques Reference

สรุปเทคนิคการออกแบบ test case มาตรฐาน (ISTQB) — ใช้เป็น reference สำหรับ skill `test-case-writer`

---

## 1. Equivalence Partitioning (ECP)

**หลักการ:** แบ่ง input ออกเป็นกลุ่มๆ ที่คาดว่าระบบจะปฏิบัติเหมือนกัน → เลือก 1 ค่าจากแต่ละกลุ่มมาทดสอบ (พอ)

**ใช้เมื่อ:** มี input field ที่มีหลายค่าให้กรอก

**ตัวอย่าง:** อายุที่กรอกได้ 18-60
- กลุ่ม Valid: 18, 19, ..., 60 → เลือก `30`
- กลุ่ม Invalid (ต่ำ): < 18 → เลือก `15`
- กลุ่ม Invalid (สูง): > 60 → เลือก `70`
- กลุ่ม Invalid (ไม่ใช่เลข): → เลือก `"abc"`

→ ใช้แค่ 4 test case แทนการ test ทุกค่า

---

## 2. Boundary Value Analysis (BVA)

**หลักการ:** test ค่าที่อยู่ขอบเขต — เพราะ bug มักเกิดที่ขอบ

**ใช้เมื่อ:** input มีช่วงค่า (range)

**ตัวอย่าง:** อายุ 18-60
ทดสอบ: `17, 18, 19, 59, 60, 61`

**Pattern:** `min-1, min, min+1, max-1, max, max+1`

มักใช้คู่กับ ECP

---

## 3. Decision Table

**หลักการ:** สร้างตารางของเงื่อนไข (condition) × ผลลัพธ์ (action) → ทดสอบทุก combination

**ใช้เมื่อ:** มีหลาย business rule รวมกัน

**ตัวอย่าง:** ส่วนลด
| เงื่อนไข | C1 | C2 | C3 | C4 |
|---------|----|----|----|----|
| เป็น member | Y | Y | N | N |
| ซื้อ > 1000 บาท | Y | N | Y | N |
| **ผลลัพธ์: ส่วนลด** | 20% | 10% | 5% | 0% |

→ 4 test case ครอบทุก rule

---

## 4. State Transition Testing

**หลักการ:** ทดสอบการเปลี่ยน state ของ object → ตรวจ valid transition + invalid transition

**ใช้เมื่อ:** object มี state (draft → submitted → approved → published)

**ทดสอบ:**
- ✅ Valid transition: draft → submitted
- ❌ Invalid transition: draft → published (ข้าม submitted ไม่ได้)
- 🔁 Self loop: draft → draft (edit แล้ว save)

---

## 5. Use Case Testing

**หลักการ:** ทดสอบตาม end-to-end user flow (use case) ตั้งแต่ต้นจนจบ

**ใช้เมื่อ:** ต้องการ verify ว่า feature ทำงานเป็นระบบ ไม่ใช่แค่ unit

**ตัวอย่าง:** "ผู้ใช้สั่งซื้อสินค้า"
1. login → 2. browse → 3. add to cart → 4. checkout → 5. pay → 6. รับ confirmation

ครอบทั้ง main flow + alternate flow (เช่น จ่ายไม่ผ่าน) + exception flow

---

## 6. Error Guessing

**หลักการ:** ใช้ประสบการณ์ของ tester คาดเดา edge case ที่ developer มักลืม

**Edge case ยอดฮิต:**
- Empty / null / undefined
- Whitespace นำ/ตาม (`" john "`)
- Special characters (`<script>`, emoji, unicode RTL)
- ค่ายาวมาก (10,000 ตัวอักษร)
- Concurrent action (2 user แก้ record เดียวกัน)
- Network fail / timeout / slow connection
- Token expired ระหว่างใช้งาน
- Browser back/forward, refresh กลางทาง
- ทำงานข้าม timezone / DST

**ใช้เมื่อ:** เพิ่มหลังจากใช้เทคนิคอื่นแล้ว เพื่อจับ bug ที่เทคนิคอื่นไม่ครอบ

---

## 7. Pairwise Testing (Optional — เมื่อ combination ระเบิด)

**หลักการ:** เมื่อมี parameter หลายตัว แต่ละตัวมีหลายค่า → ใช้ algorithm สร้าง subset ที่ครอบทุก *คู่* ของค่า แทน combination ทั้งหมด

**ใช้เมื่อ:** test browser × OS × language มี 50+ combinations
→ ลดเหลือ ~10 cases ที่ครอบ defect ส่วนใหญ่

Tool: PICT, AllPairs, hexawise

---

## เลือก Technique อย่างไร

| ลักษณะ Requirement | Technique หลัก | Technique เสริม |
|--------------------|---------------|-----------------|
| Input field (text/number/date) | ECP + BVA | Error Guessing |
| Business rule หลายเงื่อนไข | Decision Table | — |
| Workflow / lifecycle | State Transition | Use Case |
| End-to-end feature | Use Case | Error Guessing |
| Cross-browser/device matrix | Pairwise | — |
| Critical feature ที่เสี่ยง bug | + Error Guessing เสมอ | — |

**กฎทั่วไป:** ECP + BVA = พื้นฐานทุก field, Decision Table = ทุก business rule, Error Guessing = เพิ่มเสมอ
