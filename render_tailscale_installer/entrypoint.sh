#!/bin/bash
set -e

# Start tailscaled in background
tailscaled --tun=userspace-networking --state=/tmp/tailscale.state --outbound-http-proxy-listen=127.0.0.1:1055 &
sleep 2

# Bring up tailscale
tailscale up --authkey "${TAILSCALE_AUTH_KEY}" --hostname render-web --accept-dns=false
# Wait until tailscale has a route
until tailscale status --json | grep '"Peer":'; do
  echo "Waiting for Tailscale to connect..."
  sleep 2
done

# Debug: show status
tailscale status

tailscale netcheck

# Optionally verify that the peer is reachable (replace IP)
# until tailscale ping -c 1 100.88.156.14 >/dev/null 2>&1; do
#   echo "waiting for tailnet peer..."
#   sleep 2
# done

ss -ltnp | grep 1055

# curl -v -x http://127.0.0.1:1055 http://100.88.156.14/

# Start HAProxy (it will bind to ${PORT})
exec haproxy -f /etc/haproxy/haproxy.cfg -db
