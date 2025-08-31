#!/bin/sh
set -e

# Start Tailscale daemon
tailscaled --tun=userspace-networking \
  --socks5-server=localhost:1055 \
  --state=/tmp/tailscale.state &

sleep 2

# Bring tailscale up (auth once with a key or interactive)
tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname render-web --accept-dns=false

sleep 3
# checking tailscale status
tailscale status

# Start HAProxy in foreground
exec haproxy -f /etc/haproxy/haproxy.cfg -db
