#!/bin/sh

set -e

docker volume rm -f app_risk_app_local app_risk_postgresql_data
docker image rm -f app_risk-app