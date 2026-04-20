/**
 * Test data — keyed by TC ID.
 * - Password / PII: use env var, never commit real value.
 */
export const UI_TEST_DATA = {
  TC_LOGIN_001: {
    username: 'superayodia',
    password: process.env.TEST_PASSWORD ?? '[REDACTED]',
  },

  TC_SAV_SC_001: {
    username: 'superayodia',
    password: process.env.TEST_PASSWORD ?? '[REDACTED]',
    assessmentYearValid: '2027',
    assessmentYearText: 'สวัสดี',
    assessmentYearSpecial: '@@++**',
  },

  TC_ANNOUNCEMENT_001: {
    username: 'superayodia',
    password: process.env.TEST_PASSWORD ?? '[REDACTED]',
    professionalExperiences:
      'Experienced in collaborating with cross-functional teams, improving workflows, and delivering high-quality results.',
    yearsOfExperience: '5',
    languageDescription: 'พูด อ่าน เขียน ภาษาอังกฤษได้ดี',
  },
} as const;
