import http from 'k6/http';

/**
 * Thin wrapper around k6/http.
 * - Auto-applies baseUrl + default headers + default tags
 * - `{ name }` option → k6 URL grouping tag for per-endpoint thresholds
 *
 * Usage:
 *   const client = new HttpClient(cfg);
 *   client.get('/health', { name: 'health' });
 *   client.post('/login', payload, { name: 'login' });
 */
export class HttpClient {
  constructor(cfg, defaultHeaders = {}) {
    this.baseUrl = cfg.baseUrl.replace(/\/+$/, '');
    this.defaultHeaders = Object.assign(
      { 'Content-Type': 'application/json' },
      defaultHeaders,
    );
    this.defaultTags = cfg.tags || {};
  }

  _params(opts = {}) {
    const tags = Object.assign({}, this.defaultTags, opts.tags || {});
    if (opts.name) tags.name = opts.name;
    return {
      headers: Object.assign({}, this.defaultHeaders, opts.headers || {}),
      tags,
      timeout: opts.timeout || '30s',
    };
  }

  get(path, opts = {}) {
    return http.get(`${this.baseUrl}${path}`, this._params(opts));
  }

  post(path, body, opts = {}) {
    const payload = typeof body === 'string' ? body : JSON.stringify(body);
    return http.post(`${this.baseUrl}${path}`, payload, this._params(opts));
  }

  put(path, body, opts = {}) {
    const payload = typeof body === 'string' ? body : JSON.stringify(body);
    return http.put(`${this.baseUrl}${path}`, payload, this._params(opts));
  }

  patch(path, body, opts = {}) {
    const payload = typeof body === 'string' ? body : JSON.stringify(body);
    return http.patch(`${this.baseUrl}${path}`, payload, this._params(opts));
  }

  del(path, opts = {}) {
    return http.del(`${this.baseUrl}${path}`, null, this._params(opts));
  }
}
