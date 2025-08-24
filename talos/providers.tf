terraform {
  required_version = ">= 1.10.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.8"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.6.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.2"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.8"
    }
  }

  # https://developers.cloudflare.com/terraform/advanced-topics/remote-backend/
  backend "s3" {
    bucket                      = var.r2_bucket_name
    key                         = "talos/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    access_key                  = var.r2_access_key_id
    secret_key                  = var.r2_secret_access_key
    endpoints                   = { s3 = var.r2_endpoint }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "flux" {
  kubernetes = {
    config_path = local_file.kubeconfig.filename
  }
  git = {
    url    = "https://github.com/${var.github_organization}/${var.github_repository}.git"
    branch = "main"
    http = {
      username = var.github_username
      password = var.github_token
    }
  }
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "local" {}

provider "sops" {}

provider "talos" {}
