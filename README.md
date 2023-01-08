### Hexlet tests and linter status:
[![Actions Status](https://github.com/infl4me/rails-project-66/workflows/hexlet-check/badge.svg)](https://github.com/infl4me/rails-project-66/actions)
[![ci](https://github.com/infl4me/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/infl4me/rails-project-66/actions/workflows/ci.yml)

[Demo](http://94.31.193.27)

### Run app
`docker compose up`

# Overview
Web app pet project to play with rails and simple-ish devops (more below)

### Rails app
A project that helps to automatically monitor the quality of github repositories. It tracks changes and runs them through various analysis tools. Then generates reports and sends them to the user.

### Server setup
- Prerequisites: Ubuntu server, docker swarm
- Nginx, postgres and rails run in docker containers. Nginx configs and swarm docker-compose files can be found in `.swarm` directory

### CI/CD
- Commit to the main branch triggers ci
- The app is containerized and deployed to the docker hub
- The new container is checked with tests and linters
- The new container is deployed to the server with zero downtime via ssh and docker swarm
