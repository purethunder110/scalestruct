#!/bin/sh
set -e

# Start Tailscale daemon
/usr/sbin/tailscaled --state=/tmp/tailscale.state --socket=/tmp/tailscaled.sock &
sleep 2

# Bring tailscale up (auth once with a key or interactive)
tailscale up --authkey=${TAILSCALE_AUTHKEY:-} --hostname=render-proxy

# Start HAProxy in foreground
exec haproxy -f /etc/haproxy/haproxy.cfg -db
