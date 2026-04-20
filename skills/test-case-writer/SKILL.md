---
name: test-case-writer
description: เขียน test case จาก requirement document (PRD, spec, user story) ให้ครอบคลุมและอ่านง่าย ใช้ testing techniques มาตรฐาน (Equivalence Partitioning, Boundary Value Analysis, Decision Table, State Transition, Use Case, Error Guessing) รองรับ output ภาษาไทยและอังกฤษ. Trigger เมื่อ user ส่ง requirement file/PRD/spec/user story และขอให้เขียน test case, test scenario, test plan, หรือ "write test cases", "create test scenarios".
---

# Test Case Writer

## เป้าหมาย
แปลง requirement → test case ที่:
- **ครอบคลุม** — ทุก requirement, ทุก scenario (positive/negative/boundary/edge)
- **อ่านง่าย** — tester คนไหนก็ทำตามได้, expected ไม่กำกวม
- **มี traceability** — รู้ว่า test case ไหนคุม requirement ข้อไหน
- **ใช้ technique เหมาะกับปัญหา** — ไม่ใช่เขียนเดามั่ว

## ขั้นตอน

### 1. เตรียมข้อมูล
1. อ่าน requirement file ให้จบทั้งไฟล์ก่อน (อย่าเขียนทันที)
2. สรุป feature/business rule ที่จะทดสอบ
3. ระบุ scope: ทำอะไร / ไม่ทำอะไร
4. **ถาม user** ถ้ายังไม่รู้:
   - ภาษา output: ไทย หรือ English?
   - Format: Markdown table หรือ CSV?
   - Priority scheme: High/Med/Low หรือ P0/P1/P2?

### 2. เลือก Testing Techniques
อ่าน `references/testing-techniques.md` แล้วเลือกตามประเภทของ logic:

| ลักษณะ Requirement | Technique ที่ควรใช้ |
|---------------------|---------------------|
| Input field (เลข, ข้อความ, วันที่) | **ECP + BVA** |
| มีหลายเงื่อนไขรวมกัน (if A และ B แล้ว...) | **Decision Table** |
| มี state เปลี่ยน (draft → submitted → approved) | **State Transition** |
| End-to-end flow ของ user | **Use Case Testing** |
| Logic ซับซ้อน เสี่ยง edge case | **Error Guessing** เพิ่ม |

### 3. แตก Scenario
สำหรับแต่ละ feature ต้องมีอย่างน้อย:
- ✅ **Positive** — happy path ทำงานถูกต้อง
- ❌ **Negative** — input ผิด, ไม่มีสิทธิ์, validation error
- 📏 **Boundary** — ค่าขอบเขต (min, min-1, min+1, max-1, max, max+1)
- 🎯 **Edge** — null, empty, special char, concurrent, network fail

### 4. เขียนตาม Template
ใช้ `templates/test-case-th.md` หรือ `templates/test-case-en.md` ตามภาษาที่เลือก

แต่ละ test case ต้องมี:
- **ID** — TC-XXX (เรียง running)
- **Title** — สั้น บอกสิ่งที่ทดสอบ
- **Priority** — High/Med/Low
- **Technique** — ECP/BVA/Decision Table/...
- **Type** — Positive/Negative/Boundary/Edge
- **Precondition** — สถานะก่อนเริ่ม
- **Steps** — เป็นข้อๆ reproduce ได้
- **Expected Result** — ระบุชัด ไม่ใช้คำกำกวม ("ทำงานถูก" ❌ "แสดง popup ข้อความ 'บันทึกสำเร็จ'" ✅)
- **Test Data** — ข้อมูลที่ใช้ (ถ้ามี)

### 5. สร้าง Coverage Matrix
ท้ายไฟล์ใส่ตาราง requirement ↔ test case เพื่อให้เห็นว่าครอบคลุม

### 6. บันทึกไฟล์
File name: `testcases_<feature>_<YYYYMMDD>.md` (หรือ `.csv`)

## Quality Checklist (เช็คก่อนส่ง user)
- [ ] ครอบคลุมทุก requirement (ดู coverage matrix)
- [ ] มี Positive + Negative + Boundary ครบทุก feature สำคัญ
- [ ] Steps ชัดเจน — tester คนใหม่อ่านแล้วทำตามได้
- [ ] Expected Result เฉพาะเจาะจง (กี่วินาที, ข้อความอะไร, status code อะไร)
- [ ] ระบุ Technique ที่ใช้ในแต่ละ TC
- [ ] ภาษาตรงตามที่ user เลือก ไม่ปนกัน

## ข้อห้าม
- ❌ อย่าเขียน test case โดยไม่อ่าน requirement ทั้งหมดก่อน
- ❌ อย่าใช้ expected กำกวม เช่น "ทำงานปกติ", "แสดงผลถูกต้อง"
- ❌ อย่าทำ steps รวบ — แยกเป็นขั้นๆ
- ❌ อย่าลืม negative case (มือใหม่มักลืม)
