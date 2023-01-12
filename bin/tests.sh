#!/bin/bash
set -e

# wait until container entrypoint is done
sleep 5

docker compose -f docker-compose-tests.yml exec app bundle exec rspec
docker compose -f docker-compose-tests.yml exec app bundle exec rubocop
