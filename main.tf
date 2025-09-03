module "landing_zone" {
  source  = "<tf-hostname>/<tf-organization-name>/<tf-registry-module-name>/aws"
  version = "<tf-registry-module-version>"

  account_name  = var.account_name
  account_class = var.account_class
  region        = var.region
  vpc_offset    = var.vpc_offset
  tags          = var.tags
}
