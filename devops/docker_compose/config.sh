#!/bin/sh

set -e

. devops/docker_compose/.env

COMPOSE_FILE=$COMPOSE_FILE \
ARG_USER_UID=$ARG_USER_UID \
ARG_USER_GID=$ARG_USER_GID \
  docker compose config
