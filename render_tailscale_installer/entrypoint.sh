#!/bin/sh

set -e

# Start Tailscale daemon
tailscaled \
  --tun=userspace-networking 
  --state=/tmp/tailscale.state &

sleep 2

# Bring tailscale up (auth once with a key or interactive)
tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname render-web --accept-dns=false

sleep 3
# checking tailscale status
tailscale status

# Start Nginx in foreground
exec nginx -g 'daemon off;'