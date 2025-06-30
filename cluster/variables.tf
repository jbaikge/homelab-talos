variable "root_domain" {
  description = "Root domain of cluster"
  type        = string
  default     = "hardwood.cloud"
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "grove"
}

variable "nodes" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      ip_address   = string
    }))
    workers = map(object({
      install_disk = string
      ip_address   = string
    }))
  })
  default = {
    controlplanes = {
      # ash is currently in use as a TrueNAS node
      # "ash" = {
      #   install_disk = "/dev/sda"
      #   ip_address   = "10.100.6.36"
      # },
      "cherry" = {
        install_disk = "/dev/nvme0n1"
        ip_address   = "10.100.6.40"
      },
    }
    workers = {
      "hickory" = {
        install_disk = "/dev/nvme0n1"
        ip_address   = "10.100.6.44"
      },
      "maple" = {
        install_disk = "/dev/nvme0n1"
        ip_address   = "10.100.6.48"
      },
    }
  }
}
