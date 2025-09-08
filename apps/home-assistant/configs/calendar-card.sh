#!/usr/bin/env bash

set -ex

VERSION="v3.1.0"
URL="https://github.com/alexpfau/calendar-card-pro/releases/download/${VERSION}/calendar-card-pro.js"
FILENAME=$(basename "$URL")

curl --silent --location --output "$FILENAME" "$URL"
