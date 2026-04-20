import { defaultConfig } from './default.js';

const env = Object.assign({}, defaultConfig, {
  baseUrl: __ENV.BASE_URL || 'http://localhost:3000',
  loadModel: __ENV.LOAD_MODEL || defaultConfig.loadModel,

  rps: Object.assign({}, defaultConfig.rps, {
    rate:     parseInt(__ENV.RPS) || defaultConfig.rps.rate,
    duration: __ENV.DURATION     || '1m',
    preAllocatedVUs: parseInt(__ENV.PRE_VUS) || 20,
    maxVUs:   parseInt(__ENV.MAX_VUS) || 100,
  }),

  vus: Object.assign({}, defaultConfig.vus, {
    stages: [
      { duration: '15s', target: 5 },
      { duration: '30s', target: 20 },
      { duration: '15s', target: 0 },
    ],
  }),

  constantVus: {
    vus: parseInt(__ENV.VUS) || 1,
    duration: __ENV.DURATION || '30s',
  },

  tags: Object.assign({}, defaultConfig.tags, { env: 'dev' }),
});

export default env;
