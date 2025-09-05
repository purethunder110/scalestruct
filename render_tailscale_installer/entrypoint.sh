#!/bin/bash
set -e

# Start tailscaled in background
tailscaled --tun=userspace-networking --state=/tmp/tailscale.state &
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

# Start Caddy (foreground)
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
