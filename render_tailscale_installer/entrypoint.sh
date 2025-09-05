#!/bin/bash
set -e

# Start tailscaled in background
tailscaled --tun=userspace-networking --state=/tmp/tailscale.state &
sleep 2

# Bring up tailscale
tailscale up --authkey "${TAILSCALE_AUTH_KEY}" --hostname render-web --accept-dns=false

# Start Caddy (foreground)
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
