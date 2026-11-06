// Minimal static file server for Hostinger Node.js hosting (no dependencies).
const http = require('http');
const fs = require('fs');
const path = require('path');

const ROOT = __dirname;
const PORT = process.env.PORT || 3000;

const TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.txt': 'text/plain; charset=utf-8',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
};

// Never serve server-side / private files.
const BLOCKED = /^\/(backend|api|supabase|node_modules|\.git)(\/|$)|\.(sql|py|pyc|md)$|^\/(package(-lock)?\.json|server\.js|vercel\.json|requirements\.txt|\.gitattributes|design-system\.txt)$/i;

function send(res, status, body, type) {
  res.writeHead(status, { 'Content-Type': type || 'text/plain; charset=utf-8' });
  res.end(body);
}

http.createServer((req, res) => {
  let urlPath;
  try {
    urlPath = decodeURIComponent(new URL(req.url, 'http://x').pathname);
  } catch {
    return send(res, 400, 'Bad request');
  }
  if (urlPath === '/') urlPath = '/index.html';
  if (BLOCKED.test(urlPath)) return send(res, 404, 'Not found');

  const filePath = path.normalize(path.join(ROOT, urlPath));
  if (!filePath.startsWith(ROOT)) return send(res, 403, 'Forbidden');

  fs.stat(filePath, (err, stat) => {
    let target = filePath;
    if (!err && stat.isDirectory()) target = path.join(filePath, 'index.html');
    else if (err && !path.extname(filePath)) target = filePath + '.html';

    fs.readFile(target, (err2, data) => {
      if (err2) {
        return fs.readFile(path.join(ROOT, 'index.html'), (e3, home) =>
          e3 ? send(res, 404, 'Not found') : send(res, 404, home, TYPES['.html']));
      }
      send(res, 200, data, TYPES[path.extname(target).toLowerCase()] || 'application/octet-stream');
    });
  });
}).listen(PORT, () => console.log(`Server running on port ${PORT}`));
