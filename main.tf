module "landing_zone" {
  source  = "app.terraform.io/nih-cit-workshop/landing-zone/aws"
  version = "1.0.0"

  account_name  = var.account_name
  account_class = var.account_class
  region        = var.region
  vpc_offset    = var.vpc_offset
  tags          = var.tags
}
