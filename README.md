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

## Machinery

| Name    | Role           | Specs                     |
| ------- | -------------- | ------------------------- |
| ash     | TrueNas Server | Supermicro SYS-5018A-FTN4 |
| cherry  | Control Plane  | Supermicro SYS-5018A-FTN4 |
| hickory | Worker         | Supermicro SYS-5018A-FTN4 |
| maple   | Worker         | Supermicro SYS-5018A-FTN4 |

## Helpful Resources

These links helped set this repo up and define how a lot of it works:

- [acaciochinato/talos-linux-terrafor](mhttps://github.com/acaciochinato/talos-linux-terraform)
