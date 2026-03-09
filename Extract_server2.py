from http.server import BaseHTTPRequestHandler, HTTPServer


class BlackholeHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        # Read metadata from your C headers
        filename = self.headers.get('X-File', 'unknown')
        key = self.headers.get('X-Key', 'none')

        # Determine how much data is coming
        content_length = int(self.headers.get('Content-Length', 0))

        print(f"📥 Swallowing: {filename}")
        print(f"🔑 Key Received: {key}")

        # Drain the data in 64KB chunks into the void
        remaining = content_length
        while remaining > 0:
            chunk_size = min(remaining, 64 * 1024)
            self.rfile.read(chunk_size)  # Read but don't store
            remaining -= chunk_size

        # Send 200 OK so the C code continues
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Void confirmed.')


if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8000), BlackholeHandler)
    print("Void is open on port 8000... (Ctrl+C to stop)")
    server.serve_forever()