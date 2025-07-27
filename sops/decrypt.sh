#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

for FILE in $DIR/*.enc.yml; do
    sops decrypt --output "${FILE/.enc.yml/.dec.yml}" "$FILE"
done
