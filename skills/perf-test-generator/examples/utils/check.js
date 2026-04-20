import { check } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate    = new Rate('custom_error_rate');
const responseTime = new Trend('custom_response_time', true);

/**
 * Verify HTTP response and record custom metrics.
 * Always prefer this over raw `check()` — it pushes custom_error_rate
 * so thresholds stay consistent across test files.
 */
export function checkResponse(res, opts = {}) {
  const status = opts.status || 200;
  const label  = opts.name || 'response';

  const checks = {};
  checks[`${label} status is ${status}`] = (r) => r.status === status;

  if (opts.maxDuration) {
    checks[`${label} duration < ${opts.maxDuration}ms`] = (r) =>
      r.timings.duration < opts.maxDuration;
  }

  if (opts.bodyContains) {
    checks[`${label} body contains "${opts.bodyContains}"`] = (r) =>
      r.body && r.body.includes(opts.bodyContains);
  }

  const passed = check(res, checks);
  errorRate.add(!passed);
  responseTime.add(res.timings.duration);
  return passed;
}

export function checkJsonResponse(res, opts = {}) {
  const label = opts.name || 'json response';

  const baseChecks = {
    [`${label} status is ${opts.status || 200}`]: (r) =>
      r.status === (opts.status || 200),
    [`${label} has JSON content-type`]: (r) =>
      r.headers['Content-Type'] &&
      r.headers['Content-Type'].includes('application/json'),
  };

  const passed = check(res, baseChecks);
  errorRate.add(!passed);
  responseTime.add(res.timings.duration);
  return passed;
}
