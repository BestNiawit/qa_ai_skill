---
name: xpath-finder
description: Workflow ช่วยหา XPath ที่ robust จาก HTML snippet / URL / screenshot จริง — output เป็น Robot Framework locator พร้อม primary + fallback + ระบุจุดเปราะ
type: reference
---

# XPath Finder Workflow

> ใช้คู่กับ [robot-test-generator SKILL.md](../SKILL.md) ตอนต้องหา locator ให้ element ที่ยังไม่มี `data-test-id` หรือ HTML ซับซ้อน

## 1. เมื่อไหร่ใช้ workflow นี้

- Dev ยังไม่ใส่ `data-test-id` → ต้อง fallback ไปทางอื่นแบบไม่เปราะ
- Element อยู่ใน table/list/nested component → ต้องใช้ axes
- Text เป็นภาษาไทย/อังกฤษ → ต้อง interpolate translation
- เจอ `<span>` ซ้อน `<button>` / `<div>` ครอบ input → pattern ที่ Recorder จับไม่ดี
- เคย flaky เพราะ index เปลี่ยน → ต้องทำ XPath ให้ stable

---

## 2. Input — ที่ต้องให้ผู้ใช้

| Input | Required | ตัวอย่าง |
|-------|:--------:|----------|
| HTML snippet ของ element + ~2 ระดับ parent | ✅ (preferred) | paste จาก DevTools → Copy outerHTML |
| หรือ URL หน้าเว็บ + element description | ⚠️ fallback | "ปุ่ม บันทึก ที่หน้า assessment year" |
| หรือ screenshot + annotation | ⚠️ สุดท้าย | ใช้เมื่อเข้า URL ไม่ได้ |
| Element goal (คลิก/อ่าน/assert) | ✅ | "คลิกปุ่ม submit" |
| Page/feature context | ✅ | "LOGIN page, submit button" |
| Translation key (ถ้า UI text) | ⚠️ | `login_page.submit_label` |
| LANG ที่ต้อง support | ⚠️ | en/th (default: ทั้งคู่) |

**ถ้าผู้ใช้ให้แค่ URL:**
- ถาม element description + บอกว่าถ้ามี HTML snippet จะแม่นกว่า
- ไม่ fetch URL เองโดยไม่ถาม (อาจเป็น internal app)

---

## 3. Process — ขั้นตอนหา XPath

### Step 1: Parse HTML — ดึง signal ทั้งหมด

| Signal | Priority | หมายเหตุ |
|--------|:--------:|----------|
| `data-test-id` / `data-testid` / `data-cy` | 1 | ถ้ามี → จบเลย |
| `id` (stable, ไม่ใช่ generated hash) | 2 | เช็ค `id="mat-input-0"` = ❌ generated |
| `name` attribute (input/form) | 3 | |
| `aria-label` / `role` | 4 | |
| `placeholder` (ถ้าไม่เปลี่ยนตามภาษา) | 5 | ⚠️ ส่วนใหญ่เปลี่ยน → ใช้ i18n |
| Visible text + `normalize-space()` | 6 | ต้อง wrap translation |
| Unique class (ไม่ใช่ utility) | 7 | `class="btn-submit"` ✅, `class="mt-2 px-4"` ❌ |
| Position ใน parent | 8 | ใช้เมื่อไม่มีทางอื่น + ต้อง `[last()]` / semantic |

### Step 2: สร้าง candidate 2-3 ตัว

- **Primary** — robust ที่สุด
- **Fallback 1** — ถ้า primary attribute หาย
- **Fallback 2** — สำหรับ debug / XPath แบบ human-readable

### Step 3: ตรวจ fragility

เช็ค 5 ข้อ ถ้าเจอ → warn user:

1. ❌ Absolute path (`/html/body/...`) — break ถ้า DOM เปลี่ยน
2. ❌ Index ตายตัว `[1]`, `[2]` — break ถ้า order เปลี่ยน → ใช้ `[last()]` หรือ semantic filter
3. ❌ Generated class/id (`_ngcontent-xyz-123`, `mat-input-0`) — break ทุก build
4. ❌ Hardcoded UI text — break เมื่อเปลี่ยนภาษา → ต้อง interpolate translation
5. ❌ `//*` + class ยาว — ช้าและ ambiguous

### Step 4: Wrap เป็น Robot variable

```robot
${<PAGE>_<ELEMENT>_<TYPE>_LOCATOR}    xpath=<primary>
```

### Step 5: แนะนำ dev (ถ้า fragile)

ถ้าต้อง fallback ไปทาง visible-text เพราะไม่มี attribute stable → แนะนำ dev เพิ่ม `data-test-id` พร้อม suggested name

---

## 4. Output Format — ส่งกลับ user

```markdown
## Element: <description>

### Primary (แนะนำ)
\`\`\`robot
${LOGIN_SUBMIT_BUTTON_LOCATOR}    xpath=//button[@data-test-id='login-submit']
\`\`\`
**Reason:** ใช้ `data-test-id` — stable ที่สุด, ไม่ผูกกับ UI/DOM/ภาษา

### Fallback 1
\`\`\`robot
${LOGIN_SUBMIT_BUTTON_LOCATOR}    xpath=//button[normalize-space()='${login_page['submit_label']}']
\`\`\`
**Reason:** ถ้า test-id หาย ใช้ visible text + translation interpolation
**⚠️ ต้อง:** เพิ่ม key `login_page.submit_label` ใน `translations/{en,th}/translations.yaml`

### Fallback 2
\`\`\`robot
xpath=//form[@name='loginForm']//button[@type='submit']
\`\`\`
**Reason:** scope ด้วย form + type — ถ้าหน้ามีหลายปุ่ม

### Fragility Warnings
- ⚠️ ไม่พบ `data-test-id` → **แนะนำ dev เพิ่ม** `data-test-id="login-submit"` ที่ `<button>` นี้
- ⚠️ `class="btn btn-primary mt-2"` เป็น utility classes → อย่าใช้

### HTML ที่วิเคราะห์
\`\`\`html
<form name="loginForm">
  <button type="submit" class="btn btn-primary">Login</button>
</form>
\`\`\`
```

---

## 5. Pattern Cookbook — กรณีเจอบ่อย

### 5.1 Label-Input pair (ไม่มี `for`)
```html
<div>
  <label>Email</label>
  <input type="email">
</div>
```
```robot
# หา input ที่อยู่หลัง label 'Email'
xpath=//label[normalize-space()='${form.email_label}']/following-sibling::input
# หรือ ancestor กลับมา
xpath=//label[normalize-space()='${form.email_label}']/..//input
```

### 5.2 Table row โดย key column
```html
<tr><td>superayodia</td><td><button>Edit</button></tr>
```
```robot
# Edit button ของ row ที่ username = superayodia
xpath=//tr[td[normalize-space()='${TC_SAV_SC_001['username']}']]//button[normalize-space()='${table.edit_label}']
```

### 5.3 Button ที่มี icon + text
```html
<button><svg>...</svg><span>Submit</span></button>
```
```robot
# ใช้ .// เพื่อ search descendant
xpath=//button[.//span[normalize-space()='${form.submit_label}']]
```

### 5.4 Dialog / Modal scope
```robot
# scope ด้วย role=dialog ป้องกันชน element ข้างหลัง modal
xpath=//*[@role='dialog']//button[normalize-space()='${confirm_dialog.ok_label}']
```

### 5.5 Dropdown option (PrimeNG/Material)
```robot
# option อยู่นอก parent dropdown ใน DOM (portal) → query แบบ global
xpath=//li[@role='option' and normalize-space()='{{option_text}}']
```

### 5.6 Last row / dynamic list
```robot
# ใช้ last() แทน index ตายตัว
xpath=(//tbody/tr)[last()]
```

### 5.7 Case-insensitive text (ถ้า backend คืน text ที่ case ต่าง)
```robot
xpath=//button[translate(normalize-space(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='login']
```

### 5.8 Multi-language ด้วย `or`
```robot
xpath=//button[normalize-space()='${btn.submit_en}' or normalize-space()='${btn.submit_th}']
```
**ถ้า project ใช้ `${LANG}` แล้ว** → interpolate ตัวเดียวพอ ไม่ต้อง `or`

---

## 6. Anti-patterns — ห้ามแนะนำ

| Anti-pattern | ทำไมห้าม | ทางแก้ |
|--------------|----------|-------|
| `/html/body/div[2]/div/form/button` | absolute, break ง่าย | ใช้ semantic filter |
| `//button[1]` | index ตายตัว | ใช้ `[last()]` หรือ filter อื่น |
| `//*[@class='mat-input-0']` | generated class | หา attribute stable อื่น |
| `//button[text()='Login']` | hardcode, fail ที่ภาษาอื่น | `normalize-space()='${i18n_key}'` |
| `//div[contains(@class,'btn-primary mt-2 px-4')]` | utility class, ไม่ unique | ใช้ role/data-test-id |
| XPath ข้าม iframe/shadow-DOM | XPath ข้ามไม่ได้ | ต้อง switch frame ก่อน + `ui_keywords` |

---

## 7. Quick Prompt Template — สำหรับ user

ถ้า user อยากใช้ workflow นี้ เขียนแบบนี้:

```
ช่วยหา xpath ให้หน่อย:
- Element: ปุ่ม submit ที่หน้า login
- Page context: LOGIN, feature=authentication
- HTML:
<form name="loginForm">
  <button type="submit" class="btn btn-primary">
    <span>เข้าสู่ระบบ</span>
  </button>
</form>
- Translation key มีอยู่: login_page.submit_label = "เข้าสู่ระบบ"/"Login"
```

output ที่ AI จะตอบกลับ = format ตามข้อ 4

---

## 8. Integration กับ robot-test-generator

ใช้ workflow นี้ก่อน **Step 3.1** (สร้าง locator file) ของ SKILL.md:

```
SKILL.md Step 2 (เช็ค asset) — locator file มีอยู่แล้ว?
    ├── มี → append
    └── ไม่มี → ใช้ xpath-finder workflow → สร้าง locator file
```

Output XPath จาก workflow นี้ → paste เข้า `resources/locators/<feature>_locator.robot` ได้ตรง ๆ
