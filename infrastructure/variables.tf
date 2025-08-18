# Backend Bucket Configuration

variable "r2_bucket_name" {
  description = "The name of the R2 bucket used for storing Terraform state files."
  type        = string
}

variable "r2_access_key_id" {
  description = "The access key ID for the R2 bucket."
  type        = string
}

variable "r2_secret_access_key" {
  description = "The secret access key for the R2 bucket."
  type        = string
}

variable "r2_endpoint" {
  description = "The endpoint for the R2 bucket used for storing Terraform state files."
  type        = string
}

# Talos Configuration

variable "talos_version" {
  description = "Talos version to deploy"
  type        = string
  default     = "v1.10.6"
}

variable "talosconfig_path" {
  description = "Full path to talosconfig"
  type        = string
}

variable "kubeconfig_path" {
  description = "Full path to kubeconfig"
  type        = string
}

# Cluster Configuration

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "endpoint" {
  description = "Talos cluster endpoint: https://(domain/ip):6443"
  type        = string
}

variable "gateway" {
  description = "Network gateway for nodes"
  type        = string
}

variable "netmask" {
  description = "Netmask after slash (ex: 24)"
  type        = number
}

variable "controlplanes" {
  description = "Map of hostname -> details"
  type = map(object({
    ip           = string
    interface    = string
    install_disk = string
  }))
}

variable "workers" {
  description = "Map of hostname -> details"
  type = map(object({
    ip           = string
    interface    = string
    install_disk = string
  }))
}

# NUT (upsmon)

variable "upsmon_host" {
  description = "Host of NUT server"
  type        = string
}

variable "upsmon_user" {
  description = "NUT server username"
  type        = string
}

variable "upsmon_pass" {
  description = "NUT server password"
  type        = string
}

# Cloudflare

variable "cloudflare_token" {
  description = "Cloudflare token with the following permissions: Account - Cloudflare Tunnel - Edit; Account - Access: Apps and Policies - Edit; Zone - DNS - Edit"
  type        = string
  sensitive   = true
}

variable "cloudflared_tunnel_token" {
  description = "Cloudflared token for Talos system extension. Create in the web interface at Zero-Trust > Networks > Tunnels > Create Cloudflare Tunnel"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_id" {
  description = "Cloudflare tunnel ID"
  type        = string
}

variable "cloudflare_zone" {
  description = "Domain used to expose services to the Internet"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "Email address for your Cloudflare account"
  type        = string
  sensitive   = true
}
