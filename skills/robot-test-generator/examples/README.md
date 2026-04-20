# Examples — athm_automation Pattern

ไฟล์ในโฟลเดอร์นี้คือตัวอย่าง **ย่อ** ของ pattern ที่ใช้ใน `athm_automation` — อ้างอิงเพื่อ generate ไฟล์ใหม่ให้ style ตรงกัน

## โครงสร้าง

```
examples/
├── testcases/
│   └── TC_EXAMPLE_SC_001.robot          ← test case เต็ม (positive + negative)
├── keywords/
│   ├── page/example_page.robot           ← page object (interact + wait, NO assertion)
│   ├── feature/example_keywords.robot    ← feature workflow (compose page keywords)
│   └── common/ui_keywords.robot          ← wait + retry wrappers (snippet)
├── resources/
│   ├── imports.robot                     ← central imports — test case ดึงไฟล์นี้อันเดียว
│   ├── locators/example_locator.robot    ← locator file (centralized)
│   ├── testdata/testdata.yaml            ← test data keyed by TC ID
│   └── translations/
│       ├── en/translations.yaml          ← English UI labels
│       └── th/translations.yaml          ← Thai UI labels
├── config/
│   └── dev.yaml                          ← environment config
└── .robocop                              ← linter config
```

## Mapping ไปยัง repo จริง

| Example | Real location ใน athm_automation |
|---------|----------------------------------|
| `testcases/TC_EXAMPLE_SC_001.robot` | `testcases/ui/<feature>/TC_<PREFIX>_SC_<NUM>.robot` |
| `keywords/page/example_page.robot` | `keywords/ui/page/<feature>_page.robot` |
| `keywords/feature/example_keywords.robot` | `keywords/ui/feature/<feature>_keywords.robot` |
| `keywords/common/ui_keywords.robot` | `keywords/ui/common/ui_keywords.robot` |
| `resources/imports.robot` | `resources/imports.robot` |
| `resources/locators/example_locator.robot` | `resources/locators/<feature>_locator.robot` |
| `resources/testdata/testdata.yaml` | `resources/testdata/ui/testdata.yaml` |
| `resources/translations/{en,th}/translations.yaml` | `resources/translations/{en,th}/translations.yaml` |
| `config/dev.yaml` | `config/environments/dev.yaml` |

## Key patterns ที่ตัวอย่างนี้แสดง

1. **3-tier POM** — test → feature keyword → page keyword → locator + ui_keywords wrapper
2. **Translation interpolation** — locator ใช้ `${example_page['submit_label']}` แทน hardcode
3. **Dynamic locator** — `{{menu}}` placeholder แทนที่ตอน runtime
4. **Central imports** — test case import `imports.robot` ไฟล์เดียว
5. **Test data YAML** — keyed by TC ID, access ผ่าน `${TC_EXAMPLE_SC_001['username']}`
6. **Wait wrappers** — ทุก action ใช้ `ui_keywords.*` ไม่เรียก SeleniumLibrary ตรง
7. **Robocop compliant** — disable rules เฉพาะจุดพร้อมเหตุผล
