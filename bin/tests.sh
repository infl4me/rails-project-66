#!/bin/bash
set -e

# wait until container entrypoint is done
sleep 5

until curl localhost:3000; do sleep 1; done

docker compose -f docker-compose-tests.yml exec -e FIXTURES_PATH=spec/fixtures app rails db:fixtures:load
docker compose -f docker-compose-tests.yml exec app bundle exec rspec
docker compose -f docker-compose-tests.yml exec app bundle exec rubocop
