/**
 * Stress Test — push system beyond normal load to find breaking points.
 * Aggressive ramp-up with sustained peak, then ramp down.
 *
 * ⚠️  Run against non-prod unless you have explicit approval.
 */
import { sleep } from 'k6';
import { rpsScenario } from '../scenarios/rps.js';
import { rampingVusScenario } from '../scenarios/vus.js';
import { HttpClient } from '../utils/httpClient.js';
import { checkResponse, checkJsonResponse } from '../utils/check.js';
import { buildThresholds } from '../utils/thresholds.js';

const ENV = __ENV.ENV || 'dev';
const cfg = require(`../config/${ENV}.js`).default;   // eslint-disable-line
cfg.tags.testType = 'stress';

// Override with aggressive stages
cfg.vus.stages = [
  { duration: '1m',  target: 50 },
  { duration: '2m',  target: 150 },
  { duration: '3m',  target: 300 },   // peak
  { duration: '1m',  target: 300 },   // sustain
  { duration: '2m',  target: 0 },     // ramp down
];

cfg.rps.rate     = parseInt(__ENV.RPS) || cfg.rps.rate * 3;
cfg.rps.duration = __ENV.DURATION || '5m';
cfg.rps.maxVUs   = cfg.rps.maxVUs * 2;

const loadModel = __ENV.LOAD_MODEL || cfg.loadModel || 'vus';
const scenarios =
  loadModel === 'rps'
    ? rpsScenario(cfg, 'stress_rps')
    : rampingVusScenario(cfg, 'stress_vus');

export const options = {
  scenarios,
  thresholds: buildThresholds(cfg),
  tags: cfg.tags,
};

const client = new HttpClient(cfg);

export default function () {
  const healthRes = client.get('/health', { name: 'health' });
  checkResponse(healthRes, { status: 200, name: 'GET /health' });
  sleep(0.3);

  const loginRes = client.post(
    '/login',
    { username: 'stressuser', password: 'stresspass' },
    { name: 'login' },
  );
  checkJsonResponse(loginRes, { status: 200, name: 'POST /login' });
  sleep(0.3);
}
