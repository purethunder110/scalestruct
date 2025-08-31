#!/bin/bash
set -e

# Start tailscaled in userspace mode with SOCKS5 proxy
tailscaled --tun=userspace-networking \
  --socks5-server=localhost:1055 \
  --state=/tmp/tailscale.state &

sleep 3

# Connect Tailscale with auth key
tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname render-web --accept-dns=false

# Start Privoxy pointing at Tailscale SOCKS5
privoxy --no-daemon /etc/privoxy/config &

sleep 3
# checking tailscale status
tailscale status


# Start nginx in foreground
nginx -g 'daemon off;'
