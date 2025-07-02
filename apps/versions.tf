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
  }
}

provider "kubernetes" {
  config_path = "../kubeconfig.yaml"
}

provider "helm" {
  kubernetes = {
    config_path = "../kubeconfig.yaml"
  }
}
