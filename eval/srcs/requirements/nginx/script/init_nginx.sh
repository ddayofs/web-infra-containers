# !/bin/bash

echo "Starting Nginx in foreground..."
# exec nginx -g 'daemon off;'
exec "$@"