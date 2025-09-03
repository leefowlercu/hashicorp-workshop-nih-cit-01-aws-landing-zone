variable "account_name" {
  type        = string
  description = "Friendly name for the AWS Account. Should not include the Account Class (nonprod|prod)."

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.account_name))
    error_message = "The account_name must be a lowercase, hyphen-delimited alphanumeric string (e.g., 'my-account-01')."
  }
}

variable "account_class" {
  type        = string
  description = "The Classification (nonprod|prod) of the Account."

  validation {
    condition     = contains(["nonprod", "prod"], var.account_class)
    error_message = "The account_class must be either 'nonprod' or 'prod'."
  }
}

variable "region" {
  type        = string
  description = "The primary AWS region to deploy the Landing Zone resources in."
}

variable "vpc_offset" {
  type        = number
  description = "The offset for CIDR block calculation"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
