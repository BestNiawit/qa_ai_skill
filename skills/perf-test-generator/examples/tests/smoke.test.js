/**
 * Smoke Test — minimal-load sanity check (1 VU × 30s).
 * Run this BEFORE every larger test to catch obvious failures early.
 */
import { sleep } from 'k6';
import { constantVusScenario } from '../scenarios/vus.js';
import { HttpClient } from '../utils/httpClient.js';
import { checkResponse, checkJsonResponse } from '../utils/check.js';
import { buildThresholds } from '../utils/thresholds.js';

const ENV = __ENV.ENV || 'dev';
const cfg = require(`../config/${ENV}.js`).default;   // eslint-disable-line

cfg.constantVus = { vus: 1, duration: '30s' };
cfg.tags.testType = 'smoke';

export const options = {
  scenarios: constantVusScenario(cfg, 'smoke'),
  thresholds: buildThresholds(cfg),
  tags: cfg.tags,
};

const client = new HttpClient(cfg);

export default function () {
  const healthRes = client.get('/health', { name: 'health' });
  checkResponse(healthRes, { status: 200, name: 'GET /health' });
  sleep(1);

  const loginRes = client.post(
    '/login',
    { username: 'testuser', password: 'testpass' },
    { name: 'login' },
  );
  checkJsonResponse(loginRes, { status: 200, name: 'POST /login' });
  sleep(1);
}
