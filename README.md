# Hardwood Cluster

This is a home lab with Talos Linux and Kubernetes to replace the existing home lab with just an Arch Linux machine running Podman and systemd.

## Installation

1. Set up USB drives with the script in `tools/setup-usb.sh`
2. Set up DHCP leases with correct IPs and match them up to the ones in the tfvars file
3. Plug drives into machines
4. Boot machines
5. On a management machine, run `nix-shell` to install dependencies and set up the environment
6. Run `tofu apply` to initialize Talos and Flux CD
7. Generate an age key with `age-keygen -o age.agekey`
8. Add the public key from stdout to .sops.yaml
9. Add the secret to kubernetes with `cat age.agekey | kubectl create secret generic sops-age --namespace=flux-system --from-file=age.agekey=/dev/stdin`
10. Wait for Flux to pick up the changes in the repository?

## Hardware

| Device                    | Count | OS Disk | Data Disk | RAM  | OS          | Purpose               |
| ------------------------- | ----: | ------- | --------- | ---- | ----------- | --------------------- |
| Supermicro SYS-5018A-FTN4 | 4     | 1TB     | None      | 16GB | Talos Linux | 3x Control, 1x Worker |
| Supermicro SYS-5019C-WR   | 1     | 512GB   | 4x4TB     | 32GB | TrueNAS     | Storage               |

## Helpful Resources

These links helped set this repo up and define how a lot of it works:

- [acaciochinato/talos-linux-terraform](https://github.com/acaciochinato/talos-linux-terraform)
- [toboshii/home-ops](https://github.com/toboshii/home-ops)
- [Talos Kubernetes on Proxmox using OpenTofu](https://blog.stonegarden.dev/articles/2024/08/talos-proxmox-tofu/)
- [linucksrox:gist](https://gist.github.com/linucksrox/2879046995953ad3bc097183864832dc)
- [sunsided/epimelitis](https://github.com/sunsided/epimelitis)
