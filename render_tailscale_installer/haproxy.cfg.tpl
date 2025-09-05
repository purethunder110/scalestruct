global
    daemon
    maxconn 2048
    log stdout format raw local0

defaults
    mode http
    timeout connect 5s
    timeout client  60s
    timeout server  60s
    option httplog
    option dontlognull

# ---------------- Frontend ----------------
frontend http_in
    bind *:${PORT}
    mode http

    # Path prefix we want to expose (e.g. /testbed/)
    acl is_testbed path_beg ${TESTBED_PREFIX}

    # Strip the prefix before forwarding to the backend
    http-request set-path %[path,regsub(^${TESTBED_PREFIX},/)]

    use_backend privoxy_testbed if is_testbed
    default_backend tailscale_default

# ---------------- Backends ----------------

# This backend sends HTTP traffic to Privoxy (which will convert to SOCKS5 → Tailscale)
backend privoxy_testbed
    mode http

    # VERY IMPORTANT: tell Privoxy (and thus Tailscale) where to go.
    # We do this by setting the Host header to the private Tailscale dest host:port.
    http-request set-header Host ${TESTBED_DEST}

    # Optionally add X-Forwarded-* headers for your app's logs
    http-request add-header X-Forwarded-Proto https if { ssl_fc }
    http-request add-header X-Forwarded-Proto http  if !{ ssl_fc }
    http-request add-header X-Forwarded-For %[src]

    # Privoxy is local
    server privoxy 127.0.0.1:8118 check

backend tailscale_default
    mode http
    http-request set-header Content-Type text/plain
    http-request set-header Cache-Control no-cache
    http-response set-status 503
    http-response set-header Content-Type text/plain
    http-response set-header Cache-Control no-cache
    http-response set-body "No route here. Try ${TESTBED_PREFIX}\n"
