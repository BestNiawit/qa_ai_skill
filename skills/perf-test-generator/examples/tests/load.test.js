/**
 * Load Test — simulate expected production traffic.
 *   LOAD_MODEL=vus  → ramping-vus (default)
 *   LOAD_MODEL=rps  → constant-arrival-rate
 */
import { sleep } from 'k6';
import { rpsScenario } from '../scenarios/rps.js';
import { rampingVusScenario } from '../scenarios/vus.js';
import { HttpClient } from '../utils/httpClient.js';
import { checkResponse, checkJsonResponse } from '../utils/check.js';
import { buildThresholds } from '../utils/thresholds.js';

const ENV = __ENV.ENV || 'dev';
const cfg = require(`../config/${ENV}.js`).default;   // eslint-disable-line
cfg.tags.testType = 'load';

const loadModel = __ENV.LOAD_MODEL || cfg.loadModel || 'vus';
const scenarios =
  loadModel === 'rps'
    ? rpsScenario(cfg, 'load_rps')
    : rampingVusScenario(cfg, 'load_vus');

export const options = {
  scenarios,
  thresholds: buildThresholds(cfg),
  tags: cfg.tags,
};

const client = new HttpClient(cfg);

let testData = {};
try { testData = JSON.parse(open('../data/testData.json')); }
catch (_) { /* testData.json is optional */ }

export default function () {
  const healthRes = client.get('/health', { name: 'health' });
  checkResponse(healthRes, { status: 200, maxDuration: 500, name: 'GET /health' });
  sleep(0.5);

  const user = testData.users
    ? testData.users[Math.floor(Math.random() * testData.users.length)]
    : { username: 'testuser', password: 'testpass' };

  const loginRes = client.post('/login', user, { name: 'login' });
  checkJsonResponse(loginRes, { status: 200, name: 'POST /login' });
  sleep(0.5);
}
