data "sops_file" "secrets" {
  source_file = "${path.module}/sops/secrets.enc.yml"
}
