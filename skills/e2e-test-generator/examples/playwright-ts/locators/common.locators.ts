/**
 * Shared XPath locator patterns.
 *
 * - ทุก function รับ text เป็น parameter — caller ต้องส่ง constant จาก labels/
 * - ใช้ advanced XPath: no index, relationship/attribute scoped
 * - ถ้า pattern ใหม่ถูกใช้ ≥2 page → เพิ่มที่นี่ ห้าม duplicate ใน page class
 */

/** Navigation menu item — sidebar / top nav */
export const menuItem = (label: string): string =>
  `//nav//a[.//span[normalize-space()='${label}']] | //*[@role='menuitem' and .//span[normalize-space()='${label}']]`;

/** Dialog / modal by heading text */
export const dialogByTitle = (title: string): string =>
  `//*[@role='dialog' and .//*[self::h1 or self::h2 or self::h3 or self::h4][normalize-space()='${title}']]`;

/** Active modal dialog (any) */
export const activeDialog = (): string =>
  `//*[@role='dialog' and @aria-modal='true']`;

/** Button by visible label — รองรับทั้ง direct text และ wrap ใน span */
export const buttonByLabel = (label: string): string =>
  `//button[normalize-space()='${label}'] | //button[.//*[normalize-space()='${label}']]`;

/** Table row by cell content (scoped to tbody) */
export const tableRowByCell = (cellText: string): string =>
  `//tbody//tr[.//td[normalize-space()='${cellText}']]`;

/** Table header by label */
export const tableHeader = (label: string): string =>
  `//table//th[normalize-space()='${label}']`;

/** Dropdown option by visible text or aria-label */
export const dropdownOption = (label: string): string =>
  `//li[@role='option' and (@aria-label='${label}' or normalize-space()='${label}')] | //*[@role='listbox']//*[normalize-space()='${label}']`;

/** Toast / alert / popup message (supports ARIA alert + swal2) */
export const alertMessage = (text: string): string =>
  `//*[@role='alert' and contains(normalize-space(),'${text}')] | //div[contains(@class,'swal2-popup')]//*[normalize-space()='${text}']`;

/** Form label → following input (for attribute preferred) */
export const inputByLabel = (label: string): string =>
  `//input[@id=//label[normalize-space()='${label}']/@for] | //label[normalize-space()='${label}']/following-sibling::input`;

/** Checkbox/radio by label */
export const checkboxByLabel = (label: string): string =>
  `//*[@role='checkbox' and @aria-label='${label}'] | //label[normalize-space()='${label}']//input[@type='checkbox']`;
