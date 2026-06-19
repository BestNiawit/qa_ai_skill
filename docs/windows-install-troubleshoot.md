# Windows · Install Troubleshoot Cheat Sheet

> 1 หน้า ใช้แก้ปัญหาตอน `/plugin marketplace add` + `/plugin install` บน Windows
>
> ⚠️ ถ้าน้องๆ ติด → **รัน Step 0 diagnostic ก่อน** แล้ว paste output ทั้ง 3 บรรทัดส่งกลับมา ก่อนทักว่า "ลงไม่ได้"

---

## Step 0 · Diagnostic (รันก่อนทุกครั้งที่ติด)

เปิด **PowerShell** (กด Win+R → พิมพ์ `powershell` → Enter) แล้วรัน 3 คำสั่งนี้ paste output ทั้งหมดส่งกลับ:

```powershell
node --version
claude --version
git --version
```

**Expected:**
- `node` ≥ v18
- `claude` ต้องได้ version ออกมา ไม่ใช่ "is not recognized"
- `git` ต้องได้ version

ถ้าตัวไหนได้ **"is not recognized as an internal or external command"** → ตัวนั้นยังไม่ install หรือ PATH ไม่ถูก → ดู Top Error #1 / #2

---

## Top 10 Errors บน Windows (จัดเรียงจากที่เจอบ่อย)

### 🔴 Error #1 · `claude : The term 'claude' is not recognized...`

**สาเหตุ:** npm install ติดตั้งแล้ว แต่ PATH ของ npm global ไม่ถูก add เข้า Windows PATH

**Fix:**

```powershell
# 1. หา prefix ของ npm
npm config get prefix
# จะได้: C:\Users\<you>\AppData\Roaming\npm  (ปกติ)

# 2. เพิ่ม path นี้เข้า PATH (สิทธิ์ user ก็พอ ไม่ต้อง admin)
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Users\$env:USERNAME\AppData\Roaming\npm", "User")

# 3. ปิด PowerShell แล้วเปิดใหม่ → ลอง claude --version อีกที
```

---

### 🔴 Error #2 · `npm install -g @anthropic-ai/claude-code` → Permission denied / EACCES

**สาเหตุ:** ติดตั้ง Node.js แบบที่ default prefix ต้อง admin

**Fix (ไม่ต้อง admin):**

```powershell
# ตั้ง prefix เป็น user-level
mkdir "$env:USERPROFILE\.npm-global"
npm config set prefix "$env:USERPROFILE\.npm-global"

# เพิ่มเข้า PATH (User scope)
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$env:USERPROFILE\.npm-global", "User")

# ปิดเปิด PowerShell ใหม่ แล้ว install ใหม่
npm install -g @anthropic-ai/claude-code
```

---

### 🔴 Error #3 · `/plugin marketplace add ~/Documents/...` → Path does not exist

**สาเหตุ:** `~` ไม่ทำงานใน Windows PowerShell (เป็น Bash syntax) **และ** Windows ใช้ `\` ไม่ใช่ `/`

**Fix — ใช้ absolute path เต็ม + backslash:**

```powershell
# 1. หา path ที่ clone ไว้
cd $env:USERPROFILE\Documents\GitHub\qa_ai_skill
pwd                              # → คัด output ที่ได้
# เช่น: C:\Users\Somsri\Documents\GitHub\qa_ai_skill

# 2. ใน Claude session ใส่ path นี้:
> /plugin marketplace add C:\Users\Somsri\Documents\GitHub\qa_ai_skill
```

⚠️ **หลีกเลี่ยง:**
- `~/Documents/...` (Bash syntax ไม่ทำงาน Windows)
- พิมพ์ `<you>` ตามตัวอักษร — ต้องแทนเป็น username จริง
- Path ที่มี **OneDrive sync** เช่น `C:\Users\You\OneDrive\Documents\...` → backup file lock อาจ block git ได้ → clone ที่ `C:\Users\You\Documents\GitHub\` (นอก OneDrive) ปลอดภัยกว่า

---

### 🔴 Error #4 · Path มี space → ลั่นกลางทาง

ถ้า username มี space (เช่น `John Doe`) → path มี space

**Fix — ใส่ quote:**

```
> /plugin marketplace add "C:\Users\John Doe\Documents\GitHub\qa_ai_skill"
```

---

### 🔴 Error #5 · `/plugin` command not found

**สาเหตุ:** Claude Code version เก่าเกินไป

**Fix:**

```powershell
npm install -g @anthropic-ai/claude-code@latest
claude --version             # ตรวจ version หลัง update
```

แล้วเปิด Claude session ใหม่ → ลอง `/plugin` อีกครั้ง

---

### 🔴 Error #6 · `git clone https://gitlab.onedcompany.com/...` → Authentication failed / 401

**สาเหตุ:** Windows ไม่มี Git credential setup หรือยังไม่มี GitLab access

**Fix:**

1. **เช็ค access ก่อน:** เปิด browser ไป https://gitlab.onedcompany.com/oned-qa-teams/qa_ai_skill → login ได้มั้ย? ถ้า 404 = ยังไม่มี access → **ทักทีม Lead ขอ access ก่อน**
2. ถ้า browser เข้าได้แต่ clone fail:
   - install [Git for Windows](https://git-scm.com/download/win) (มี Credential Manager auto)
   - หรือใช้ Personal Access Token: GitLab → User Settings → Access Tokens → สร้าง token → clone ด้วย:
     ```powershell
     git clone https://oauth2:<token>@gitlab.onedcompany.com/oned-qa-teams/qa_ai_skill.git
     ```

---

### 🔴 Error #7 · Installed plugin แล้ว แต่ `/help` ไม่เห็น skill

**สาเหตุ:** ลืม reload

**Fix:**

```
> /reload-plugins
```

ใน Claude session ปัจจุบัน

---

### 🔴 Error #8 · `Invalid schema ... plugins.0.source: Invalid input`

**สาเหตุ:** repo version เก่า (marketplace.json schema เปลี่ยน)

**Fix:**

```powershell
cd $env:USERPROFILE\Documents\GitHub\qa_ai_skill
git pull
```

แล้วใน Claude:
```
> /plugin marketplace update oned-qa
> /reload-plugins
```

---

### 🟡 Error #9 · Antivirus block npm install

อาการ: npm install ค้าง > 2 นาที หรือบอก network error ตอน fetch packages

**Fix:**
- ปิด antivirus ชั่วคราว (Defender / Bitdefender / McAfee) แล้วลอง install ใหม่
- หรือ whitelist folder `%USERPROFILE%\AppData\Roaming\npm` ใน antivirus
- ถ้าอยู่หลัง proxy บริษัท: `npm config set proxy <proxy_url>`

---

### 🟡 Error #10 · ติด corporate VPN — clone ช้า/หลุด

**Fix:**
- ลอง clone ตอน off VPN ถ้าทำได้
- หรือ shallow clone: `git clone --depth 1 <url>`

---

## ✅ Final Verification (ผ่าน 4 ข้อนี้ = พร้อม workshop)

```powershell
# 1. Claude ใช้งานได้
claude --version

# 2. Folder clone อยู่จริง
cd $env:USERPROFILE\Documents\GitHub\qa_ai_skill
ls
# ต้องเห็น: README.md, skills/, docs/, .claude-plugin/

# 3. ใน Claude session
claude
> /plugins
# tab Installed ต้องเห็น: qa-ai-skill · oned-qa

> /help
# ต้องเห็น skill: test-case-writer, bug-report-writer, ...
```

---

## 🛟 ติดอยู่ — ส่งอะไรมา?

ถ้าทำตามด้านบนแล้วยังไม่ผ่าน — paste **3 อย่างนี้** ใน Slack \#qa-ai-skill หรือ DM QA Lead:

1. **Output ของ Step 0 diagnostic** (3 commands)
2. **Error message** ตัวเต็ม (screenshot หรือ paste text)
3. **ที่ขั้นไหน** (เช่น "ตอนพิมพ์ /plugin marketplace add")

→ ทีมจะวิเคราะห์ได้ใน 1-2 นาที โดยไม่ต้องเดา

---

## 💡 Quick Tips สำหรับ Lead ที่ดูแลน้อง

- **ก่อน workshop:** ขอให้น้อง run Step 0 diagnostic ส่งมา 1-2 วันก่อนวันงาน → จับ error ตั้งแต่เนิ่นๆ ไม่ทำหน้างานพังในห้อง
- **ถ้าจะแก้ครั้งเดียวจบ:** สร้าง **shared Windows machine image** (VM/Container) ที่มี Node + Claude + repo + plugin ติดตั้งครบ → น้องเอาไป run ผ่าน Remote Desktop / VirtualBox
- **Path ปัญหา 70%:** ถ้าเจอ error ที่ปลายทาง path → 70% เป็นเพราะ `~/` หรือ `<you>` หรือ space → ลอง absolute path เต็ม + quote ก่อนเสมอ

---

## หน้าถัดไป (ถ้าต้องการ)

หลังผ่าน install:
- ดู [docs/qa-onboarding.md](qa-onboarding.md) — Quick Start ใช้ skill ตัวแรก
- ดู [docs/how-to-sit-uat.md](how-to-sit-uat.md) — 10 steps พิมพ์อะไรให้ AI
- ดู [slides/sharing-session.pdf](../slides/sharing-session.pdf) — Workshop walkthrough
