resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    templatefile("${path.module}/templates/control-plane.yml", {}),
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    templatefile("${path.module}/templates/worker.yml", {}),
  ]
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each                    = var.control_planes
  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration

  config_patches = [
    templatefile("${path.module}/templates/common.yml", {
      install_disk = each.value.install_disk
      interface    = each.value.interface
      ip           = each.value.ip
      netmask      = var.netmask
      gateway      = var.gateway
      hostname     = each.key
      nameservers  = var.nameservers
      vip          = var.vip
    }),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = var.workers
  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration

  config_patches = [
    templatefile("${path.module}/templates/common.yml", {
      install_disk = each.value.install_disk
      interface    = each.value.interface
      ip           = each.value.ip
      netmask      = var.netmask
      gateway      = var.gateway
      hostname     = each.key
      nameservers  = var.nameservers
      vip          = ""
    }),
  ]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = values(var.control_planes)[0].ip

  depends_on = [
    talos_machine_configuration_apply.controlplane,
    talos_machine_configuration_apply.worker,
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in var.control_planes : v.ip]
}

resource "local_file" "talosconfig" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = "files/talosconfig.yml"
  file_permission = "0644"
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = values(var.control_planes)[0].ip

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}

resource "local_file" "kubeconfig" {
  content         = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename        = "files/kubeconfig.yml"
  file_permission = "0644"
}

data "talos_cluster_health" "this" {
  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes  = [for k, v in var.control_planes : v.ip]
  endpoints            = [for k, v in var.control_planes : v.ip]
  worker_nodes         = [for k, v in var.workers : v.ip]

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}
