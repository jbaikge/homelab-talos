terraform {
  required_version = ">= 1.10.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.8"
    }
  }
}

provider "kubernetes" {
  config_path = "./kubeconfig.yaml"
}

provider "helm" {
  kubernetes = {
    config_path = "./kubeconfig.yaml"
  }
}

provider "local" {}

provider "talos" {}
