#!/usr/bin/env bash

set -ex

VERSION="v3.1.0"
URL="https://github.com/alexpfau/calendar-card-pro/releases/download/${VERSION}/calendar-card-pro.js"
FILENAME=$(basename "$URL")
DIR=/config/www

kubectl --namespace home-assistant exec home-assistant-6954bb44b-9l4q6 -- sh -c "mkdir -p $DIR && wget -O $DIR/$FILENAME $URL"
