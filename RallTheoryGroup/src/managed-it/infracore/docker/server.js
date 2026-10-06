const http = require('node:http');
const port = 3000;

http.createServer((req, res) => {
  res.writeHead(req.url === '/' || req.url === '/health' ? 200 : 404,
    { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(req.url === '/health'
    ? { status: 'healthy' }
    : { service: 'InfraCore', version: '1.0.0' }));
}).listen(port, '0.0.0.0', () => {
  console.log(`InfraCore listening on port ${port}`);
});
