# resource "cloudflare_dns_record" "argocd" {
#   zone_id = var.cloudflare_zone_id
#   name    = "argocd"
#   content = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
# }

# resource "cloudflare_zero_trust_tunnel_cloudflared_config" "argocd" {
#   tunnel_id  = var.cloudflare_tunnel_id
#   account_id = var.cloudflare_account_id

#   config = {
#     ingress = [
#       {
#         hostname = "argocd.${var.cloudflare_zone}"
#         service  = "https://argocd-server.argocd.svc.cluster.local:443"
#         origin_request = {
#           no_tls_verify = true
#         }
#       },
#       {
#         service = "http_status:404"
#       },
#     ]
#   }
# }

# resource "cloudflare_zero_trust_access_policy" "allow_emails" {
#   account_id = var.cloudflare_account_id
#   name       = "Allow email addresses"
#   decision   = "allow"

#   include = [
#     {
#       email = {
#         email = var.cloudflare_email
#       }
#     },
#   ]
# }

# resource "cloudflare_zero_trust_access_application" "argocd" {
#   account_id = var.cloudflare_account_id
#   type       = "self_hosted"
#   name       = "Access application for argocd.${var.cloudflare_zone}"
#   domain     = "argocd.${var.cloudflare_zone}"

#   policies = [
#     {
#       id         = cloudflare_zero_trust_access_policy.allow_emails.id
#       precedence = 1
#     },
#   ]
# }
