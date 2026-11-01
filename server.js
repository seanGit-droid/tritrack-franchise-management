import http from 'node:http';
import { readFile } from 'node:fs/promises';
import { extname, join, normalize } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('.', import.meta.url));
const port = process.env.PORT || 3000;
const records = [
  { franchise: 'FR-2024-00128', owner: 'Juan Dela Cruz', driver: 'Pedro Santos', plate: 'ABC 1234', expiry: '31 Oct 2026', status: 'For renewal' },
  { franchise: 'FR-2024-00129', owner: 'Luz Ramos', driver: 'Ben Ramos', plate: 'ABC 1235', expiry: '31 Oct 2026', status: 'Active' },
  { franchise: 'FR-2024-00084', owner: 'Ana Garcia', driver: 'Leo Garcia', plate: 'ABC 1084', expiry: '31 Oct 2026', status: 'For renewal' },
  { franchise: 'FR-2024-00073', owner: 'Ramon Lopez', driver: 'Mark Lopez', plate: 'ABC 1073', expiry: '31 Oct 2027', status: 'Active' }
];
const contentTypes = { '.html':'text/html; charset=utf-8', '.css':'text/css; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.svg':'image/svg+xml', '.json':'application/json', '.sql':'text/plain; charset=utf-8' };
const server = http.createServer(async (req, res) => {
  if (req.url === '/api/health') return send(res, 200, { ok: true, database: 'tritrack_db_prc', mode: 'demo' });
  if (req.url === '/api/dashboard') return send(res, 200, { metrics: { attention: 12, renewals: 5, motorChanges: 5, transfers: 5 }, records });
  const pathname = decodeURIComponent((req.url || '/').split('?')[0]);
  const safe = normalize(pathname === '/' ? '/index.html' : pathname).replace(/^([.][.][/\\])+/, '');
  try { const body = await readFile(join(root, safe)); res.writeHead(200, { 'Content-Type': contentTypes[extname(safe)] || 'application/octet-stream' }); res.end(body); }
  catch { res.writeHead(404, {'Content-Type':'text/plain'}); res.end('Not found'); }
});
function send(res, code, data) { res.writeHead(code, {'Content-Type':'application/json'}); res.end(JSON.stringify(data)); }
server.listen(port, '0.0.0.0', () => console.log(`TriTrack running on port ${port}`));
