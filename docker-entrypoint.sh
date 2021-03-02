#!/bin/sh
set -ex

if [ ! -d /app/tmp/pids ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir -p /app/tmp/pids
fi

if [ ! -d /app/log ]; then
  mkdir -p /app/log
  touch /app/log/development-batch.log
  touch /app/log/development.log
fi

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

bundle check || bundle install --jobs=4 --retry=3

echo "Running migrations..."
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
bundle exec rails s -b 0.0.0.0
