#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

for FILE in $DIR/*.dec.yml; do
    sops encrypt --output "${FILE/.dec.yml/.enc.yml}" "$FILE"
done
