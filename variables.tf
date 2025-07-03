variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "domain" {
  type        = string
  description = "Cluster domain"
}

variable "nameservers" {
  type        = list(string)
  description = "Exactly two nameservers"
}

variable "gateway" {
  type        = string
  description = "Networok gateway for nodes"
}

variable "netmask" {
  type        = number
  description = "Netmask after slash (ex: 24)"
}

variable "control_planes" {
  type = map(object({
    ip           = string
    interface    = string
    install_disk = string
  }))
  description = "Map of hostname -> details"
}

variable "workers" {
  type = map(object({
    ip           = string
    interface    = string
    install_disk = string
  }))
  description = "Map of hostname -> details"
}

variable "endpoint" {
  type        = string
  description = "Talos cluster endpoint: https://(domain/ip):6443"
}

variable "vip" {
  type        = string
  description = "VIP for the Master Nodes and address for the Metallb to expose a LoadBalancer IP"
}
