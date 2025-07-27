terraform {
  required_version = ">= 1.10.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
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
}

provider "kubernetes" {
  config_path = "./sops/kubeconfig.dec.yml"
}

provider "kubectl" {
  config_path = "./sops/kubeconfig.dec.yml"
}

provider "helm" {
  kubernetes = {
    config_path = "./sops/kubeconfig.dec.yml"
  }
}

provider "local" {}

provider "sops" {}

provider "talos" {}
