#!/bin/bash

# Start tailscaled in userspace networking mode (no TUN/iptables required)
tailscaled --tun=userspace-networking --state=/tmp/tailscale.state &

# Wait a few seconds for tailscaled to initialize
sleep 2

# Connect to Tailscale using auth key
tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname render-web --accept-dns=false

# Start nginx in foreground
nginx -g 'daemon off;'
