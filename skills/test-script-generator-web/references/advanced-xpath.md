# Advanced XPath — Cheat Sheet

> หลัก: **locator ต้องเฉพาะเจาะจง + ทนต่อการเปลี่ยน DOM + ไม่พึ่ง index**

---

## 1. Priority Order (ใช้อันบนก่อน)

1. **`data-test-id` / `data-testid`** — ดีที่สุด เพราะทีม dev ตั้งใจให้ test ใช้
   ```xpath
   //input[@data-test-id='primeng-input-username']
   //button[@data-testid='btn-submit']
   ```

2. **ARIA role + accessible name** — ทน a11y-compliant + i18n-friendly
   ```xpath
   //*[@role='button' and @aria-label=$LABEL_SAVE]
   //*[@role='combobox' and @aria-labelledby=$form_label_id]
   //*[@role='dialog' and @aria-modal='true']
   ```

3. **Semantic HTML + attribute**
   ```xpath
   //input[@type='email' and @name='email']
   //label[@for='username']/following-sibling::input
   ```

4. **Label-driven + relationship**
   ```xpath
   //label[normalize-space()=$LABEL_USERNAME]/following-sibling::input
   //fieldset[.//legend[normalize-space()=$LABEL_ADDRESS]]//input[@name='zipcode']
   ```

5. **Class `contains()`** — ใช้ได้แต่เป็น fallback (class ของ UI framework เปลี่ยนง่าย)
   ```xpath
   //div[contains(@class,'p-dialog')]//button[@data-test-id='confirm']
   ```

---

## 2. Axes — ใช้แทน index

| แทนที่จะ | ให้ใช้ |
|----------|--------|
| `[1]` ต่อจาก parent | `parent::<tag>` / `ancestor::<tag>` |
| `[1]` หลัง sibling | `following-sibling::<tag>` / `preceding-sibling::<tag>` |
| เลือก child ตาม label ข้างๆ | `//label[...]/following-sibling::input` |
| เลือก element ใน section | `//section[.//h2[normalize-space()=$title]]//<tag>` |
| เลือก row ในตาราง | `//tbody//tr[.//td[normalize-space()=$cell_text]]` |
| เลือก cell ใน row + คอลัมน์ | `//tr[.//td[normalize-space()=$row_key]]//td[@data-col='name']` |

---

## 3. ฟังก์ชันที่ควรรู้

### `normalize-space()` (ใช้เสมอสำหรับ text)
```xpath
//button[normalize-space()=$LABEL_SAVE]           ← ตัด whitespace รอบๆ
//span[normalize-space()='Log In']                 ← ตรงแน่นอน
//div[normalize-space(text())=$label]              ← เฉพาะ direct text node
```

`text()='Log In'` vs `normalize-space()='Log In'`:
- `text()='Log In'` → fail ถ้า DOM มี `" Log In "` (space)
- `normalize-space()=...` → ทน whitespace variation

### `contains()` — partial match
```xpath
//button[contains(normalize-space(),$LABEL_PARTIAL)]   ← text มีบางส่วน
//div[contains(@class,'p-dialog')]                     ← class multi-value
//a[contains(@href,$url_fragment)]                     ← URL partial
```

### Compound predicate — หลาย attribute
```xpath
//input[@data-test-id='primeng-input-name' and @aria-required='true']
//button[@role='button' and normalize-space()=$LABEL_SAVE and not(@disabled)]
```

### `starts-with()`, `string-length()`, `not()`
```xpath
//input[starts-with(@id,'formly_')]
//button[not(@disabled) and normalize-space()=$LABEL_NEXT]
//tr[.//td[string-length(normalize-space())>0]]
```

### Union `|`
```xpath
//button[normalize-space()=$label] | //button[.//span[normalize-space()=$label]]
```
ใช้เมื่อ button อาจเป็น direct text หรือ wrap ใน span

---

## 4. Pattern แก้เคสยอดฮิต

### A. เลือก cell ในแถวที่มี key เฉพาะ
```xpath
❌ //table//tr[2]//td[3]
✅ //tr[.//td[normalize-space()=$row_key]]//td[@data-col='amount']
✅ //tr[.//td[normalize-space()=$row_key]]//td[count(../th[normalize-space()=$col_header]/preceding-sibling::th)+1]
```

### B. เลือกปุ่มใน dialog เท่านั้น
```xpath
❌ //button[normalize-space()=$LABEL_CONFIRM]          ← หลัง dialog + หน้าหลัง อาจเจอ 2 ตัว
✅ //*[@role='dialog' and @aria-modal='true']//button[normalize-space()=$LABEL_CONFIRM]
✅ //div[contains(@class,'p-dialog')]//button[normalize-space()=$LABEL_CONFIRM]
```

### C. เลือกปุ่มใน row เดียวกับ item
```xpath
❌ //tr[.//td[normalize-space()=$name]]//button[@aria-label=$LABEL_EDIT][1]
✅ //tr[.//td[normalize-space()=$name]]//button[@aria-label=$LABEL_EDIT]
```
(row scope ทำให้ unique อยู่แล้ว — ถ้ายังเจอหลายตัว แปลว่า DOM มี edit button หลายตัวใน row ต้องเช็ค class/icon)

### D. เลือก input หลัง label
```xpath
❌ //label[normalize-space()=$label]/../input
✅ //label[normalize-space()=$label]/following-sibling::input
✅ //label[normalize-space()=$label]/following::input[1]   ← ถ้า label ไม่ใช่ sibling โดยตรง (ยอม index)
✅ //input[@id=//label[normalize-space()=$label]/@for]      ← ดีที่สุด ใช้ for attribute
```

### E. Dropdown option
```xpath
✅ //li[@role='option' and normalize-space()=$option_text]
✅ //li[@role='option' and @aria-label=$option_label]
✅ //*[@role='listbox']//li[normalize-space()=$option_text]   ← scope ใน listbox
```

### F. Popup / Toast / Snackbar
```xpath
✅ //*[@role='alert' and contains(normalize-space(),$expected_msg)]
✅ //div[contains(@class,'swal2-popup')]//*[normalize-space()=$expected_msg]
```

### G. Checkbox / Radio ที่มี label
```xpath
❌ //input[@type='checkbox'][3]
✅ //label[normalize-space()=$option]//input[@type='checkbox']
✅ //*[@role='checkbox' and @aria-label=$option]
```

---

## 5. Multi-language safe

ถ้า XPath ต้องรู้ text → **ส่ง text มาจาก constant** ไม่ใช่ฝัง:

```ts
// ❌ ผูกภาษา
page.locator("//button[normalize-space()='บันทึก']")

// ✅ ผ่าน constant
import { LABELS } from '../labels/th.labels';
page.locator(`//button[normalize-space()='${LABELS.save}']`)

// ✅ สลับภาษาได้
import { LABELS } from `../labels/${process.env.LANG ?? 'th'}.labels`;
```

---

## 6. Debug Tip

ตอนเจอ flaky click:
1. เปิด DevTools Console → `$x("your xpath")` → ต้อง return **array length = 1**
2. ถ้า length > 1 → locator ไม่ unique → แก้ scope (dialog/row/section)
3. ถ้า length = 0 → DOM ยังไม่ render → ไม่ใช่ปัญหา XPath, เช็ค wait

---

## 7. XPath Performance

- `//tag` เร็วพอสำหรับ E2E tests ส่วนใหญ่
- ถ้า DOM ใหญ่มาก (>5000 nodes) → ใช้ scope เฉพาะ `//app-root/...` หรือ `//*[@role='main']//...`
- Predicate ที่เช็ค attribute ตรงๆ เร็วกว่า `contains()` — ใช้ตรงๆ ถ้าได้
