#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

bundle exec rails db:create db:migrate
bundle exec rails assets:precompile
bundle exec rails s -b 0.0.0.0 -p 3000
