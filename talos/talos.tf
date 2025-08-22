# Declare the system extensions we want to include
data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = [
      "nut-client",
      "iscsi-tools",
    ]
  }
}

# Get the schematic id that includes the desired extensions
resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info[*].name
        }
      }
    }
  )
}

# Get the image URL that includes the desired extensions
data "talos_image_factory_urls" "this" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = "metal"
  architecture  = "amd64"
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controlplane" {
  for_each         = var.controlplanes
  cluster_name     = var.cluster_name
  cluster_endpoint = var.endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version
  config_patches = [
    file("${path.module}/files/cluster-scheduling.yaml"),
    file("${path.module}/files/cluster-subnets.yaml"),
    file("${path.module}/files/cluster-cni.yaml"),
    templatefile("${path.module}/files/cluster-common.yaml", {
      hostname      = each.key
      install_disk  = each.value.install_disk
      interface     = each.value.interface
      ip            = each.value.ip
      netmask       = var.netmask
      gateway       = var.gateway
      installer_url = data.talos_image_factory_urls.this.urls.installer
    }),
    templatefile("${path.module}/files/nut.yaml", {
      upsmon_host = var.upsmon_host
      upsmon_user = var.upsmon_user
      upsmon_pass = var.upsmon_pass
    }),
  ]
}

data "talos_machine_configuration" "worker" {
  for_each         = var.workers
  cluster_name     = var.cluster_name
  cluster_endpoint = var.endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version
  config_patches = [
    file("${path.module}/files/cluster-subnets.yaml"),
    file("${path.module}/files/cluster-cni.yaml"),
    templatefile("${path.module}/files/cluster-common.yaml", {
      hostname      = each.key
      install_disk  = each.value.install_disk
      interface     = each.value.interface
      ip            = each.value.ip
      netmask       = var.netmask
      gateway       = var.gateway
      installer_url = data.talos_image_factory_urls.this.urls.installer
    }),
    templatefile("${path.module}/files/nut.yaml", {
      upsmon_host = var.upsmon_host
      upsmon_user = var.upsmon_user
      upsmon_pass = var.upsmon_pass
    }),
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.controlplanes : v.ip]
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each                    = var.controlplanes
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane[each.key].machine_configuration
  node                        = each.key
  endpoint                    = each.value.ip
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = var.workers
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.key].machine_configuration
  node                        = each.key
  endpoint                    = each.value.ip
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.controlplanes : k][0]
  endpoint             = [for k, v in var.controlplanes : v.ip][0]

  depends_on = [
    talos_machine_configuration_apply.controlplane,
  ]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.controlplanes : k][0]
  endpoint             = [for k, v in var.controlplanes : v.ip][0]

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}

resource "local_file" "talosconfig" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = var.talosconfig_path
  file_permission = "0644"
}

resource "local_file" "kubeconfig" {
  content         = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename        = var.kubeconfig_path
  file_permission = "0644"
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes  = [for k, v in var.controlplanes : v.ip]
  endpoints            = [for k, v in var.controlplanes : v.ip]
  worker_nodes         = [for k, v in var.workers : v.ip]

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}
