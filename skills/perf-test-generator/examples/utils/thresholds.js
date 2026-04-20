/**
 * Build k6 thresholds object — merge global + per-endpoint.
 *
 * Per-endpoint thresholds use k6 tag-based syntax:
 *   'http_req_duration{name:health}': ['p(95)<200']
 *
 * Requires request tagging via HttpClient `{ name: 'endpoint' }`.
 */
export function buildThresholds(cfg) {
  const thresholds = Object.assign({}, cfg.thresholds || {});
  thresholds['custom_error_rate'] = thresholds['custom_error_rate'] || ['rate<0.01'];

  const endpoints = cfg.endpointThresholds || {};
  for (const [endpoint, metrics] of Object.entries(endpoints)) {
    for (const [metric, values] of Object.entries(metrics)) {
      const key = `${metric}{name:${endpoint}}`;
      thresholds[key] = values;
    }
  }

  return thresholds;
}

export const thresholdPresets = {
  strict: {
    http_req_duration: ['p(95)<300', 'p(99)<800'],
    http_req_failed:   ['rate<0.005'],
  },
  standard: {
    http_req_duration: ['p(95)<500', 'p(99)<1500'],
    http_req_failed:   ['rate<0.01'],
  },
  relaxed: {
    http_req_duration: ['p(95)<1000', 'p(99)<3000'],
    http_req_failed:   ['rate<0.05'],
  },
};
