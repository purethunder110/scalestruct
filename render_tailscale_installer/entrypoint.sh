#!/bin/bash

# Start tailscaled in the background
tailscaled --state=/tmp/tailscale.state &

# Wait a few seconds for tailscaled to initialize
sleep 2

# Connect to Tailscale network using auth key
tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname render-web

# Start nginx in foreground
nginx -g 'daemon off;'
