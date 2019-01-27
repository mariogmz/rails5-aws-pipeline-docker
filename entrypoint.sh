#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /src/tmp/pids/server.pid ]; then
  rm -f /src/tmp/pids/server.pid
fi

cd $RAILS_ROOT
bundle exec rake db:create db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
