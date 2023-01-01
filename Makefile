USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)

dckrbuild:
	docker compose build --build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID}
