/**
 * RPS-based scenarios — constant-arrival-rate / ramping-arrival-rate.
 *
 * Use when SLO is expressed in throughput (e.g. "API must handle 200 req/s").
 */

export function rpsScenario(cfg, name = 'rps_test') {
  const rps = cfg.rps;
  return {
    [name]: {
      executor: 'constant-arrival-rate',
      rate: rps.rate,
      timeUnit: rps.timeUnit || '1s',
      duration: rps.duration,
      preAllocatedVUs: rps.preAllocatedVUs,
      maxVUs: rps.maxVUs,
      tags: cfg.tags || {},
    },
  };
}

export function rampingRpsScenario(cfg, stages, name = 'ramping_rps_test') {
  const rps = cfg.rps;
  return {
    [name]: {
      executor: 'ramping-arrival-rate',
      startRate: stages[0]?.target || rps.rate,
      timeUnit: rps.timeUnit || '1s',
      stages: stages,
      preAllocatedVUs: rps.preAllocatedVUs,
      maxVUs: rps.maxVUs,
      tags: cfg.tags || {},
    },
  };
}
