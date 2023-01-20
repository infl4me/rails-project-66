start:
	docker compose up --build

test:
	docker compose exec -e RAILS_ENV=test app bundle exec rspec

lint:
	docker compose exec -e RAILS_ENV=test app bundle exec rubocop

slim-lint:
	docker compose exec -e RAILS_ENV=test app bundle exec slim-lint app/views/

console:
	docker compose exec app rails c

bash:
	docker compose exec -it app bash

.PHONY: test
