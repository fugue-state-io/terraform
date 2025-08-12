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

resource "digitalocean_domain" "practice-music" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  name       = "practice-music.io"
}

resource "digitalocean_domain" "practicemusic" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  name       = "practicemusic.io"
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

resource "digitalocean_record" "a-practice-music" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  domain     = digitalocean_domain.practice-music.id
  type       = "A"
  name       = "*"
  value      = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "a-practicemusic" {
  depends_on = [data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer]
  domain     = digitalocean_domain.practicemusic.id
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

resource "digitalocean_record" "at-practice-music" {
  domain = digitalocean_domain.practice-music.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "at-practicemusic" {
  domain = digitalocean_domain.practicemusic.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

# Domains
resource "digitalocean_project_resources" "networking_resources" {
  project = digitalocean_project.fugue-state-io.id
  resources = [
    digitalocean_domain.fugue-state.urn,
    digitalocean_domain.fuguestate.urn,
    digitalocean_domain.practice-music.urn,
    digitalocean_domain.practicemusic.urn
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
  type   = "CNAME"
  name   = "a3c7e94751bb14de8973b3f023ef780c"
  value  = "verify.bing.com."
}

resource "digitalocean_record" "mx_google_1" {
  domain   = digitalocean_domain.fugue-state.id
  type     = "MX"
  name     = "@"
  value    = "aspmx.l.google.com."
  priority = 1
}

resource "digitalocean_record" "mx_google_5" {
  domain   = digitalocean_domain.fugue-state.id
  type     = "MX"
  name     = "@"
  value    = "alt1.aspmx.l.google.com."
  priority = 5
}

resource "digitalocean_record" "mx_google_5_alt2" {
  domain   = digitalocean_domain.fugue-state.id
  type     = "MX"
  name     = "@"
  value    = "alt2.aspmx.l.google.com."
  priority = 5
}

resource "digitalocean_record" "mx_google_10_alt3" {
  domain   = digitalocean_domain.fugue-state.id
  type     = "MX"
  name     = "@"
  value    = "alt3.aspmx.l.google.com."
  priority = 10
}

resource "digitalocean_record" "mx_google_10_alt4" {
  domain   = digitalocean_domain.fugue-state.id
  type     = "MX"
  name     = "@"
  value    = "alt4.aspmx.l.google.com."
  priority = 10 
}
resource "digitalocean_record" "spf_record" {
  domain = digitalocean_domain.fugue-state.id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:_spf.google.com include:sendgrid.net ~all"
}

resource "digitalocean_record" "google_domainkey" {
  domain = digitalocean_domain.fugue-state.id
  type   = "TXT"
  name   = "google._domainkey"
  value  = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjaTbDo0dIgfl2C/r6Z2nvtNVsyz0ivfczn4E4eGpIMfeEw3lOF6VFYXnw7I32KDsw6+MU3GCoyOP4LwLQ6U9NrTJAQpn8JSsDoTig+N5zcz6Gf8n4bXveIifjrPfOpXnqoEK/wMToSXYIDpp0uhS9y04lsi33xzmfUrrSS6duEUPlr0E3K54nJDf8lGjcwPhRSufNVREELAh2pv2TXUyKpe/aMkI6A2APKr+xF/T85OxV9f9xCy0Nkjv2rMd3Uba2IZ+o3XI3m2LeDRGyksDVXpZ3OV+LSUj3y3IFrUMyr/3OOjNr99uPVmONZC2Wc70Mdi+FdY04a090jX5mldPbwIDAQAB"
}

# Email configuration for practicemusic.io
resource "digitalocean_record" "mx_google_1_practicemusic" {
  domain   = digitalocean_domain.practicemusic.id
  type     = "MX"
  name     = "@"
  value    = "aspmx.l.google.com."
  priority = 1
}

resource "digitalocean_record" "mx_google_5_practicemusic" {
  domain   = digitalocean_domain.practicemusic.id
  type     = "MX"
  name     = "@"
  value    = "alt1.aspmx.l.google.com."
  priority = 5
}

resource "digitalocean_record" "mx_google_5_alt2_practicemusic" {
  domain   = digitalocean_domain.practicemusic.id
  type     = "MX"
  name     = "@"
  value    = "alt2.aspmx.l.google.com."
  priority = 5
}

resource "digitalocean_record" "mx_google_10_alt3_practicemusic" {
  domain   = digitalocean_domain.practicemusic.id
  type     = "MX"
  name     = "@"
  value    = "alt3.aspmx.l.google.com."
  priority = 10
}

resource "digitalocean_record" "mx_google_10_alt4_practicemusic" {
  domain   = digitalocean_domain.practicemusic.id
  type     = "MX"
  name     = "@"
  value    = "alt4.aspmx.l.google.com."
  priority = 10 
}

resource "digitalocean_record" "spf_record_practicemusic" {
  domain = digitalocean_domain.practicemusic.id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:_spf.google.com include:sendgrid.net ~all"
}

resource "digitalocean_record" "dmarc_policy_practicemusic" {
  domain = digitalocean_domain.practicemusic.id
  type   = "TXT"
  name   = "_dmarc"
  value  = "v=DMARC1; p=none;"
}

# SendGrid DNS records for practice-music.io
resource "digitalocean_record" "sendgrid_url144_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "CNAME"
  name   = "url144"
  value  = "sendgrid.net."
}

resource "digitalocean_record" "sendgrid_54902605_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "CNAME"
  name   = "54902605"
  value  = "sendgrid.net."
}

resource "digitalocean_record" "sendgrid_em8521_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "CNAME"
  name   = "em8521"
  value  = "u54902605.wl106.sendgrid.net."
}

resource "digitalocean_record" "sendgrid_domainkey_s1_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "CNAME"
  name   = "s1._domainkey"
  value  = "s1.domainkey.u54902605.wl106.sendgrid.net."
}

resource "digitalocean_record" "sendgrid_domainkey_s2_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "CNAME"
  name   = "s2._domainkey"
  value  = "s2.domainkey.u54902605.wl106.sendgrid.net."
}

resource "digitalocean_record" "dmarc_policy_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "TXT"
  name   = "_dmarc"
  value  = "v=DMARC1; p=none;"
}

resource "digitalocean_record" "google_site_verification_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "TXT"
  name   = "@"
  value  = "google-site-verification=2kWN9xZBrL5pv2qLgffQi-RdVGHhe_qpa6eulAY7Gks"
}

resource "digitalocean_record" "google_domain_verification_practice_music" {
  domain = digitalocean_domain.practice-music.id
  type   = "CNAME"
  name   = "zlzn6xio2vbn"
  value  = "gv-hmxx2k6u6w4y73.dv.googlehosted.com."
}