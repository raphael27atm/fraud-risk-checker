#!/bin/sh

set -e

. devops/docker_compose/.env

./devops/docker_compose/up.sh
./devops/docker_compose/exec.sh app rails db:drop db:create

COMPOSE_FILE=$COMPOSE_FILE \
ARG_USER_UID=$ARG_USER_UID \
ARG_USER_GID=$ARG_USER_GID \
  cat $1 | docker compose exec -T postgresql psql -U ae_dev -d app_risk_development
COMPOSE_FILE=$COMPOSE_FILE \
ARG_USER_UID=$ARG_USER_UID \
ARG_USER_GID=$ARG_USER_GID \
  cat $1 | docker compose exec -T postgresql psql -U ae_dev -d app_risk_test

./devops/docker_compose/exec.sh app rails db:migrate
