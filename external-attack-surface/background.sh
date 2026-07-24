#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
LAB_ROOT="/opt/interactive-lab"
TARGET_IP="10.10.10.20"

mkdir -p "$LAB_ROOT" /root/engagement /root/answers
rm -f "$LAB_ROOT/.ready"

apt-get update -qq
apt-get install -y -qq nmap curl netcat-openbsd iproute2 >/var/log/interactive-lab-packages.log 2>&1

ip addr add "${TARGET_IP}/32" dev lo 2>/dev/null || true

if ! grep -q "target.securewithme.local" /etc/hosts; then
  echo "${TARGET_IP} target.securewithme.local target" >> /etc/hosts
fi

cat > /root/engagement/scope.txt <<'EOF'
SECUREWITHME AUTHORISED ASSESSMENT
=================================
Assessment type : External attack-surface discovery
Approved target : target.securewithme.local
Target alias     : target
Target IP        : 10.10.10.20
Testing window   : Current disposable lab session only

No other hosts, domains or IP addresses are authorised.
EOF

cat > /usr/local/bin/lab-submit <<'EOF'
#!/bin/bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: lab-submit <hostname|ports|web-version|hidden-path|service|flag> <answer>"
  exit 1
fi

key="$1"
shift

case "$key" in
  hostname|ports|web-version|hidden-path|service|flag) ;;
  *)
    echo "Unknown task key: $key"
    exit 1
    ;;
esac

mkdir -p /root/answers
printf '%s\n' "$*" > "/root/answers/$key"
echo "Answer saved for: $key"
EOF
chmod +x /usr/local/bin/lab-submit

cat > "$LAB_ROOT/web_server.py" <<'PY'
#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HOST = "10.10.10.20"
PORT = 80

class Handler(BaseHTTPRequestHandler):
    server_version = "Apache/2.4.49"
    sys_version = ""

    def _send(self, status, body, content_type="text/html; charset=utf-8"):
        payload = body.encode()
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(payload)))
        self.send_header("X-Environment", "training-only")
        self.end_headers()
        self.wfile.write(payload)

    def do_HEAD(self):
        if self.path in ("/", "/robots.txt", "/backup-console/", "/backup-console/readme.txt"):
            self._send(200, "")
        else:
            self._send(404, "")

    def do_GET(self):
        if self.path == "/":
            self._send(200, """<!doctype html>
<html>
<head><title>Northstar Logistics</title></head>
<body>
<h1>Northstar Logistics</h1>
<p>Customer operations portal.</p>
<p>Environment: training-only</p>
</body>
</html>""")
        elif self.path == "/robots.txt":
            self._send(
                200,
                "User-agent: *\nDisallow: /backup-console/\n",
                "text/plain; charset=utf-8",
            )
        elif self.path in ("/backup-console", "/backup-console/"):
            self._send(
                200,
                """<!doctype html>
<html>
<head><title>Backup Console</title></head>
<body>
<h1>Backup Console</h1>
<p>Migration notes are available in <a href="/backup-console/readme.txt">readme.txt</a>.</p>
</body>
</html>""",
            )
        elif self.path == "/backup-console/readme.txt":
            self._send(
                200,
                """LEGACY BACKUP MIGRATION NOTE
============================
Service: legacy file transfer
Port: 2121/tcp
Username: analyst
Temporary password: BLUE-ORBIT-72

The service is retained only for the migration window.
Replace it with an encrypted transfer mechanism.
""",
                "text/plain; charset=utf-8",
            )
        else:
            self._send(404, "<h1>404 Not Found</h1>")

    def log_message(self, fmt, *args):
        return

server = ThreadingHTTPServer((HOST, PORT), Handler)
server.serve_forever()
PY

cat > "$LAB_ROOT/api_server.py" <<'PY'
#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json

HOST = "10.10.10.20"
PORT = 8080

class Handler(BaseHTTPRequestHandler):
    server_version = "SecureAPI/1.4"
    sys_version = ""

    def do_GET(self):
        if self.path == "/health":
            payload = json.dumps({
                "status": "ok",
                "environment": "training-only",
                "service": "asset-api"
            }).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)
        else:
            payload = b'{"error":"not found"}'
            self.send_response(404)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)

    def log_message(self, fmt, *args):
        return

server = ThreadingHTTPServer((HOST, PORT), Handler)
server.serve_forever()
PY

cat > "$LAB_ROOT/legacy_ftp.py" <<'PY'
#!/usr/bin/env python3
import socketserver

HOST = "10.10.10.20"
PORT = 2121
USERNAME = "analyst"
PASSWORD = "BLUE-ORBIT-72"
FLAG = "SWM{attack_surface_mapped}"

class Handler(socketserver.StreamRequestHandler):
    def send_line(self, text):
        self.wfile.write((text + "\r\n").encode())
        self.wfile.flush()

    def handle(self):
        authenticated = False
        accepted_user = False
        self.send_line("220 LegacyFTP 1.0 training service ready")

        while True:
            raw = self.rfile.readline()
            if not raw:
                break

            line = raw.decode(errors="ignore").strip()
            if not line:
                continue

            command, _, argument = line.partition(" ")
            command = command.upper()
            argument = argument.strip()

            if command == "USER":
                accepted_user = argument == USERNAME
                if accepted_user:
                    self.send_line("331 Username accepted, password required")
                else:
                    self.send_line("530 Unknown user")
            elif command == "PASS":
                if accepted_user and argument == PASSWORD:
                    authenticated = True
                    self.send_line("230 Login successful")
                else:
                    self.send_line("530 Authentication failed")
            elif command == "SYST":
                self.send_line("215 UNIX Type: L8")
            elif command == "FEAT":
                self.send_line("211-Features")
                self.send_line(" UTF8")
                self.send_line("211 End")
            elif command == "HELP":
                self.send_line("214 Commands: USER PASS SYST FEAT RETR QUIT")
            elif command == "RETR":
                if not authenticated:
                    self.send_line("530 Login with USER and PASS first")
                elif argument.lower() == "flag.txt":
                    self.send_line("150 Opening plaintext transfer")
                    self.send_line(FLAG)
                    self.send_line("226 Transfer complete")
                else:
                    self.send_line("550 File unavailable")
            elif command == "QUIT":
                self.send_line("221 Goodbye")
                break
            else:
                self.send_line("500 Unknown command")

class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True

with Server((HOST, PORT), Handler) as server:
    server.serve_forever()
PY

chmod +x "$LAB_ROOT"/*.py

nohup python3 "$LAB_ROOT/web_server.py" >"$LAB_ROOT/web.log" 2>&1 &
echo $! > "$LAB_ROOT/web.pid"

nohup python3 "$LAB_ROOT/api_server.py" >"$LAB_ROOT/api.log" 2>&1 &
echo $! > "$LAB_ROOT/api.pid"

nohup python3 "$LAB_ROOT/legacy_ftp.py" >"$LAB_ROOT/ftp.log" 2>&1 &
echo $! > "$LAB_ROOT/ftp.pid"

for _ in $(seq 1 30); do
  if curl -fsS --max-time 2 "http://${TARGET_IP}/" >/dev/null \
    && curl -fsS --max-time 2 "http://${TARGET_IP}:8080/health" >/dev/null \
    && nc -z -w 2 "$TARGET_IP" 2121; then
    touch "$LAB_ROOT/.ready"
    exit 0
  fi
  sleep 1
done

echo "Lab services failed to start" >&2
exit 1
