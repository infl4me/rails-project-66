start:
	docker compose up --build

load-fixtures:
	docker compose exec -e RAILS_ENV=test app rails db:fixtures:load

tests:
	docker compose exec -e RAILS_ENV=test app bundle exec rspec

console:
	docker compose exec app rails c
