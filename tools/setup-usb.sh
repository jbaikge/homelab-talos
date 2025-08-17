#!/usr/bin/env bash

set -ex

if [ -z "$1" ]; then
    echo "This tool assumes Ventoy is already set up on the USB drives"
    echo "referenced in the arguments"
    echo
    echo "Usage: $0 /dev/sdX [/dev/sdX ...]"
    exit 1
fi

STAGING_DIR=/tmp/talos
VERSION="v1.10.6"
IMAGE_URL="https://github.com/siderolabs/talos/releases/download/${VERSION}/metal-amd64.iso"
IMAGE_FILE="talos-${VERSION}.iso"
IMAGE_PATH="$STAGING_DIR/$IMAGE_FILE"
DISKS=( ${@:1} )
VENTOY_CONFIG="$STAGING_DIR/ventoy.json"
TALOS_KEY_URL="https://factory.talos.dev/secureboot/signing-cert.pem"
TALOS_KEY_PATH="$STAGING_DIR/talos-secure-boot.pem"
EFI_MOUNT_DIR="$STAGING_DIR/ventoy-efi"
ISO_MOUNT_DIR="$STAGING_DIR/ventoy-iso"

mkdir -p $STAGING_DIR

cat <<EOF > $VENTOY_CONFIG
{
  "control": [
    { "VTOY_MENU_TIMEOUT": "10" },
    { "VTOY_DEFAULT_IMAGE": "/$IMAGE_FILE" },
    { "VTOY_SECONDARY_TIMEOUT": "10" }
  ]
}
EOF

if [ ! -f "$IMAGE_PATH" ]; then
    curl "$IMAGE_URL" --output "$IMAGE_PATH"
fi

if [ ! -f "$TALOS_KEY_PATH" ]; then
    curl "$TALOS_KEY_URL" --output "$TALOS_KEY_PATH"
fi

mkdir -p "$EFI_MOUNT_DIR" "$ISO_MOUNT_DIR"

for I in ${!DISKS[@]}; do
    DISK=${DISKS[$I]}
    ISO_PART=${DISK}1
    EFI_PART=${DISK}2

    mount $EFI_PART "$EFI_MOUNT_DIR"
    cp -v "$TALOS_KEY_PATH" "$EFI_MOUNT_DIR"
    umount "$EFI_MOUNT_DIR"

    mount $ISO_PART "$ISO_MOUNT_DIR"
    cp -v "$IMAGE_PATH" "$ISO_MOUNT_DIR"
    mkdir -p "$ISO_MOUNT_DIR/ventoy"
    cp -v "$VENTOY_CONFIG" "$ISO_MOUNT_DIR/ventoy"
    umount "$ISO_MOUNT_DIR"
done

rmdir "$EFI_MOUNT_DIR" "$ISO_MOUNT_DIR"
