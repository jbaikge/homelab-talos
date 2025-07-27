#!/usr/bin/env bash

set -ex

DIR=$(dirname "$0")
FILES=($DIR/*.enc.yml)

for INPUT in ${FILES[@]}; do
    sops decrypt --output "${INPUT/\.enc/}" "$INPUT"
done
