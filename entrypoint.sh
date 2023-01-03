#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

bundle exec rails db:migrate
bundle exec rails assets:precompile
bundle exec puma -C config/puma.rb

