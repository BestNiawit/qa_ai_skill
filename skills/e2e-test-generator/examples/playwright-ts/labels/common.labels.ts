/**
 * Common UI labels (Thai).
 *
 * - จัดกลุ่มตามประเภทของ interaction (action / nav / form)
 * - ใช้ใน locator + assertion ห้าม hardcode string ใน page/test
 * - รองรับ bilingual: สร้าง en.labels.ts แล้ว switch ที่ labels/index.ts
 */
export const LABELS = {
  // Generic actions
  save: 'บันทึก',
  cancel: 'ยกเลิก',
  confirm: 'ยืนยัน',
  delete: 'ลบ',
  edit: 'แก้ไข',
  add: 'เพิ่ม',
  addItem: 'เพิ่มรายการ',
  search: 'ค้นหา',
  next: 'ถัดไป',
  previous: 'ย้อนกลับ',

  // Auth
  loginSubmit: 'เข้าสู่ระบบ',

  // Navigation
  settings: 'ตั้งค่า',
  recruitmentSystem: 'ระบบสมัครงาน',
  pmsSystem: 'ระบบประเมินผลพนักงาน',
  assessmentAndVision: 'การประเมินและวิสัยทัศน์',
} as const;

export type LabelKey = keyof typeof LABELS;
