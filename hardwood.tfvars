cluster_name = "grove"
domain       = "hardwood.cloud"
endpoint     = "https://grove.hardwood.cloud:6443"
vip          = "10.100.6.224"
nameservers  = ["1.1.1.1", "9.9.9.9"]
gateway      = "10.100.6.1"
netmask      = 24
control_planes = {
  "cherry" = {
    ip           = "10.100.6.40"
    interface    = "enp0s20f0"
    install_disk = "/dev/nvme0n1"
  }
}
workers = {
  "hickory" = {
    ip           = "10.100.6.44"
    interface    = "enp0s20f0"
    install_disk = "/dev/nvme0n1"
  }
  "maple" = {
    ip           = "10.100.6.48"
    interface    = "enp0s20f0"
    install_disk = "/dev/nvme0n1"
  }
}
