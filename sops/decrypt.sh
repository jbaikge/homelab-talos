#!/usr/bin/env bash

DIR=$(dirname "$0")
FILE_PREFIXES=(
    kubeconfig
    secrets
    talosconfig
)

for PREFIX in "${FILE_PREFIXES[@]}"; do
    INPUT_PATH="$DIR/$PREFIX.enc.yml"
    OUTPUT_PATH="$DIR/$PREFIX.yml"
    sops decrypt --output "$OUTPUT_PATH" "$INPUT_PATH"
done
