#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /var/www/current/tmp/pids/server.pid ]; then
  rm -f /var/www/current/tmp/pids/server.pid
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
