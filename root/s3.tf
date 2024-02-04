resource "digitalocean_spaces_bucket" "fugue-state-s3" {
  name   = "fugue-state-artifacts"
  region = "nyc3"
}

resource "digitalocean_spaces_bucket" "fugue-state-cdn" {
  name   = "fugue-state-cdn"
  region = "nyc3"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 1
    enabled = true
  }
}