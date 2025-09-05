global
    log stdout format raw local0
    maxconn 2048

defaults
    log     global
    option  httplog
    timeout connect 5s
    timeout client  30s
    timeout server  30s

frontend http_in
    bind *:80
    mode http

    acl is_testbed path_beg /testbed/
    use_backend privoxy_testbed if is_testbed
    default_backend privoxy_default

backend privoxy_testbed
    mode http
    http-request set-path %[path,regsub(^/testbed/,/)]
    server privoxy1 127.0.0.1:8118

backend privoxy_default
    mode http
    errorfile 503 /etc/haproxy/errors/503.http
