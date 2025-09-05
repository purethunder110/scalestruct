#!/bin/sh

# set -e

# # Start Tailscale daemon
# tailscaled --tun=userspace-networking \
#   --socks5-server=localhost:1055 \
#   --state=/tmp/tailscale.state &

# sleep 2

# # Bring tailscale up (auth once with a key or interactive)
# tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname render-web --accept-dns=false

# sleep 3
# # checking tailscale status
# tailscale status

# # Start HAProxy in foreground
# exec haproxy -f /etc/haproxy/haproxy.cfg -db
set -eu

# ---- Defaults from env ----
: "${PORT:=8080}"                       # Render usually injects PORT; fallback to 8080 locally
: "${TESTBED_PREFIX:=/testbed/}"        # Path prefix to expose
: "${TESTBED_DEST:=100.88.146.20:80}"   # Tailscale private target host:port
: "${TS_HOSTNAME:=edge-proxy}"          # How this node shows up in Tailscale
: "${TAILSCALE_AUTH_KEY:?Set TAILSCALE_AUTH_KEY env var for headless login}"

echo "[entrypoint] PORT=$PORT"
echo "[entrypoint] TESTBED_PREFIX=$TESTBED_PREFIX"
echo "[entrypoint] TESTBED_DEST=$TESTBED_DEST"
echo "[entrypoint] TS_HOSTNAME=$TS_HOSTNAME"

# ---- Render Privoxy config ----
sed -e "s|127.0.0.1:1055|127.0.0.1:1055|g" \
    /etc/privoxy/config.tpl > /etc/privoxy/config

# ---- Render HAProxy config ----
# Escape slashes in prefix for regex usage
ESC_PREFIX=$(printf '%s' "$TESTBED_PREFIX" | sed 's/[.[\*^$(){}+?|/]/\\&/g')
sed -e "s|\${PORT}|${PORT}|g" \
    -e "s|\${TESTBED_PREFIX}|${ESC_PREFIX}|g" \
    -e "s|\${TESTBED_DEST}|${TESTBED_DEST}|g" \
    /etc/haproxy/haproxy.cfg.tpl > /etc/haproxy/haproxy.cfg

echo "[entrypoint] Generated /etc/haproxy/haproxy.cfg:"
sed 's/^/  /' /etc/haproxy/haproxy.cfg

echo "[entrypoint] Generated /etc/privoxy/config:"
sed 's/^/  /' /etc/privoxy/config

# ---- Start everything under supervisord ----
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
