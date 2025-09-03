terraform {
  required_version = ">= 1.13.1"

  required_providers {
    aws = {
      source           = "hashicorp/aws"
      required_version = ">= 5.0.0, < 6.0.0"
    }
  }
}
