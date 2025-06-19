module.exports = {
  // 1) Keep your existing rewrites
  rewrites() {
    return [
      {
        source: '/doc',
        destination: '/doc/index.html',
      },
    ];
  },

  // 2) Add a headers() section that applies CORS headers to anything under /js/
  async headers() {
    return [
      {
        // This matches all files under /js/, including iframe.umd.js, widget.js, cusdis.es.js, etc.
        source: '/js/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
          { key: 'Access-Control-Allow-Methods', value: 'GET, OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type' },
        ],
      },
      // (Optional) If you need to allow preflight on your API routes as well, add this:
      // {
      //   source: '/api/:path*',
      //   headers: [
      //     { key: 'Access-Control-Allow-Origin', value: '*' },
      //     { key: 'Access-Control-Allow-Methods', value: 'GET, POST, OPTIONS' },
      //     { key: 'Access-Control-Allow-Headers', value: 'Authorization, Content-Type' },
      //   ],
      // },
    ];
  },
};
