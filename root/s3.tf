resource "digitalocean_spaces_bucket" "fugue-state-s3" {
  name   = "fugue-state-artifacts"
  region = "nyc3"
}

resource "digitalocean_spaces_bucket" "fugue-state-cdn" {
  name   = "fugue-state-cdn"
  region = "nyc3"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["http://localhost:3000"]
    max_age_seconds = 30000
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["https://fugue-state.io"]
    max_age_seconds = 30000
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 1
    enabled                                = true
  }
}

resource "digitalocean_spaces_bucket" "fugue-state-cdn-dev" {
  name   = "fugue-state-cdn-dev"
  region = "nyc3"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["http://localhost:3000"]
    max_age_seconds = 30000
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["https://dev.fugue-state.io"]
    max_age_seconds = 30000
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 1
    enabled                                = true
  }
}
