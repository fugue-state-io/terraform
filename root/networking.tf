resource "digitalocean_vpc" "fugue-state-vpc" {
  name   = "fugue-state-vpc"
  region = "nyc3"
  timeouts {}
}
# resource "digitalocean_domain" "pong-roulette-com" {
#   depends_on = [ data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer ]
#   name = "pong-roulette.com"
# }
# resource "digitalocean_record" "a-pong-roulette-com" {
#   depends_on = [ data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer ]
#   domain = digitalocean_domain.pong-roulette-com.id
#   type   = "A"
#   name   = "*"
#   value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
# }
# resource "digitalocean_record" "at-pong-roulette-com" {
#   domain = digitalocean_domain.pong-roulette-com.id
#   type   = "A"
#   name   = "@"
#   value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
# }
# resource "digitalocean_domain" "zudell-io" {
#   depends_on = [ data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer ]
#   name = "zudell.io"
# }
# resource "digitalocean_record" "a-zudell-io" {
#   depends_on = [ data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer ]
#   domain = digitalocean_domain.zudell-io.id
#   type   = "A"
#   name   = "*"
#   value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
# }
# resource "digitalocean_record" "at-zudell-io" {
#   domain = digitalocean_domain.zudell-io.id
#   type   = "A"
#   name   = "@"
#   value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
# }

resource "digitalocean_domain" "fugue-state" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  name       = "fugue-state.io"
}

resource "digitalocean_domain" "fuguestate" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  name       = "fuguestate.io"
}

resource "digitalocean_record" "a-fugue-state" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  domain     = digitalocean_domain.fugue-state.id
  type       = "A"
  name       = "*"
  value      = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "a-fuguestate" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  domain     = digitalocean_domain.fuguestate.id
  type       = "A"
  name       = "*"
  value      = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "at-fugue-state" {
  domain = digitalocean_domain.fugue-state.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "at-fuguestate" {
  domain = digitalocean_domain.fuguestate.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

# Domains
resource "digitalocean_project_resources" "networking_resources" {
  project = digitalocean_project.fugue-state-io.id
  resources = [
    digitalocean_domain.fugue-state.urn,
    digitalocean_domain.fuguestate.urn
  ]
}
# SendGrid DNS records for fugue-state.io
resource "digitalocean_record" "sendgrid_url8690" {
  domain = digitalocean_domain.fugue-state.id
  type   = "CNAME"
  name   = "url8690"
  value  = "sendgrid.net."
}

resource "digitalocean_record" "sendgrid_54902605" {
  domain = digitalocean_domain.fugue-state.id
  type   = "CNAME"
  name   = "54902605"
  value  = "sendgrid.net."
}

resource "digitalocean_record" "sendgrid_em5585" {
  domain = digitalocean_domain.fugue-state.id
  type   = "CNAME"
  name   = "em5585"
  value  = "u54902605.wl106.sendgrid.net."
}

resource "digitalocean_record" "sendgrid_domainkey_s1" {
  domain = digitalocean_domain.fugue-state.id
  type   = "CNAME"
  name   = "s1._domainkey"
  value  = "s1.domainkey.u54902605.wl106.sendgrid.net."
}

resource "digitalocean_record" "sendgrid_domainkey_s2" {
  domain = digitalocean_domain.fugue-state.id
  type   = "CNAME"
  name   = "s2._domainkey"
  value  = "s2.domainkey.u54902605.wl106.sendgrid.net."
}

resource "digitalocean_record" "dmarc_policy" {
  domain = digitalocean_domain.fugue-state.id
  type   = "TXT"
  name   = "_dmarc"
  value  = "v=DMARC1; p=none;"
}

resource "digitalocean_record" "google_site_verification" {
  domain = digitalocean_domain.fugue-state.id
  type   = "TXT"
  name   = "@"
  value  = "google-site-verification=IPVipm8BJEJ3Pigjkw9zO0I3DkVwQ4NMXprk4B6OwO0"
}

resource "digitalocean_record" "bing_site_verification" {
  domain = digitalocean_domain.fugue-state.id
  type   = "TXT"
  name   = "@"
  value  = "a3c7e94751bb14de8973b3f023ef780c"
}