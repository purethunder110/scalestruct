# Listen locally
listen-address  0.0.0.0:8118

# Accept origin-form (intercepted) requests from HAProxy
accept-intercepted-requests 1

# Be quiet-ish
loglevel 3
toggle 1
enable-remote-toggle 0
forwarded-connect-retries  0

# Convert HTTP → SOCKS5 (to Tailscale userspace proxy)
# The trailing dot is required by Privoxy syntax.
forward-socks5t   /   127.0.0.1:1055   .
