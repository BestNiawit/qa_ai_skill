/**
 * VUs-based scenarios — constant-vus / ramping-vus.
 *
 * Use when SLO is expressed in concurrency (e.g. "system supports 500 concurrent users").
 */

export function rampingVusScenario(cfg, name = 'vus_test') {
  return {
    [name]: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: cfg.vus.stages,
      gracefulRampDown: '10s',
      tags: cfg.tags || {},
    },
  };
}

export function constantVusScenario(cfg, name = 'constant_vus_test') {
  return {
    [name]: {
      executor: 'constant-vus',
      vus: cfg.constantVus.vus,
      duration: cfg.constantVus.duration,
      tags: cfg.tags || {},
    },
  };
}
