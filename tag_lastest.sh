#! /usr/bin/env bash

echo "Building and tagging latest..."

set -ex

USER="klotzandrew"
APP_NAME="superturbowidgetexchange3"

docker-compose build

for NAME in web_api websocket_server frontend
do
  docker tag "${APP_NAME}_${NAME}" "${USER}/${APP_NAME}_${NAME}"
  docker push "${USER}/${APP_NAME}_${NAME}"
done
