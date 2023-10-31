#!/bin/sh

set -e

cp -i config/database.yml.sample config/database.yml && \
  sed -i "s/127.0.0.1/dockerhost/g" config/database.yml

cp -i .env.sample .env && \
  sed -i "s/localhost/dockerhost/g" .env

