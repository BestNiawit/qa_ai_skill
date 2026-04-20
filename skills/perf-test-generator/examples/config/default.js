/**
 * Default configuration — shared across all environments.
 * Environment-specific files (dev.js, staging.js, prod.js) override these values.
 *
 * Override order: default → env-specific → ENV variables
 */

export const defaultConfig = {
  baseUrl: 'http://localhost:3000',

  // "rps" → constant-arrival-rate  |  "vus" → ramping-vus
  loadModel: 'vus',

  rps: {
    rate: 50,
    timeUnit: '1s',
    duration: '1m',
    preAllocatedVUs: 50,
    maxVUs: 200,
  },

  vus: {
    stages: [
      { duration: '30s', target: 10 },
      { duration: '1m',  target: 50 },
      { duration: '30s', target: 0 },
    ],
  },

  constantVus: {
    vus: 1,
    duration: '30s',
  },

  // Global thresholds — baseline SLO
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1500'],
    http_req_failed:   ['rate<0.01'],
  },

  // Per-endpoint thresholds — keys must match `{ name }` tag used in HttpClient
  endpointThresholds: {
    health: { http_req_duration: ['p(95)<200', 'p(99)<400'] },
    login:  { http_req_duration: ['p(95)<800', 'p(99)<2000'] },
  },

  tags: {
    project: 'k6-perf',
    testType: 'default',
  },

  prometheus: {
    enabled: false,
    remoteWriteUrl: 'http://localhost:9090/api/v1/write',
  },

  cloud: {
    enabled: false,
    projectId: '',
  },
};
