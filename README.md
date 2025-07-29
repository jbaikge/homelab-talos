# Hardwood Cluster

This is a home lab with Talos Linux and Kubernetes to replace the existing home lab with just an Arch Linux machine running Podman and systemd.

The settings from OS to container are managed with Terraform and deployed with OpenTofu.

## Installation

1. Set up USB drives with the script in `tools/setup-usb.sh`
2. Set up DHCP leases with correct IPs and match them up to the ones in the tfvars file
3. Plug drives into machines
4. Boot machines
5. On a management machine, run `nix-shell` to install dependencies and set up the environment
6. Run `tofu apply`

## Hardware

| Device                    | Count  | OS Disk | Data Disk | RAM  | OS          | Purpose       |
| ------------------------- | -----: | ------- | --------- | ---- | ----------- | ------------- |
| Supermicro SYS-5018A-FTN4 | 1      | 128GB   | 2x4TB     | 16GB | TrueNAS     | Data Storage  |
| Supermicro SYS-5018A-FTN4 | 1      | 128GB   | None      | 16GB | Talos Linux | Control Plane |
| Supermicro SYS-5018A-FTN4 | 2      | 128GB   | None      | 16GB | Talos Linux | Worker        |

## Helpful Resources

These links helped set this repo up and define how a lot of it works:

- [acaciochinato/talos-linux-terraform](https://github.com/acaciochinato/talos-linux-terraform)
