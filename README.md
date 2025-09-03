# hashicorp-workshop-tf-module-aws-landing-zone

This Terraform module provisions an AWS Landing Zone foundation. It's designed for workshop scenarios and provides a standardized approach to deploying AWS infrastructure with multi-tier networking architecture.

## Requirements

- Terraform >= 1.13.1
- AWS Provider >= 5.0.0, < 6.0.0

## Authentication

This module uses the AWS provider without explicit configuration, expecting authentication through:
- Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
- AWS CLI authentication and profiles
- IAM Instance Profiles (when running on EC2)
- HCP Terraform/Terraform Enterprise Dynamic Credentials

## Usage

### Basic Example

```hcl
module "landing_zone" {
  source = "<terraform-endpoint>/<terraform-organization>/landing-zone/aws"

  account_name  = "my-workshop"
  account_class = "nonprod"
  region        = "us-east-1"
  vpc_offset    = 1
  tags = {
    Environment = "nonprod"
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}
```

### Production Example

```hcl
module "landing_zone" {
  source = "<terraform-endpoint>/<terraform-organization>/landing-zone/aws"

  account_name  = "production-workload"
  account_class = "prod"
  region        = "us-west-2"
  vpc_offset    = 10
  tags = {
    Environment = "production"
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| account_name | Friendly name for the AWS Account. Should not include the Account Class (nonprod\|prod). Must be lowercase, hyphen-delimited alphanumeric string. | `string` | n/a | yes |
| account_class | The Classification (nonprod\|prod) of the Account. | `string` | n/a | yes |
| region | The primary AWS region to deploy the Landing Zone resources in. | `string` | n/a | yes |
| vpc_offset | The offset for CIDR block calculation | `number` | n/a | yes |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| vpc_id | VPC ID | no |
| vpc_cidr | VPC CIDR Block | no |
| internet_gateway_id | Internet Gateway ID | no |
| nat_gateway_ids | NAT Gateway IDs | no |
| web_subnet_ids | Web Tier Subnet IDs | no |
| app_subnet_ids | App Tier Subnet IDs | no |
| data_subnet_ids | Data Tier Subnet IDs | no |
| web_subnet_cidrs | Web Tier Subnet CIDR Blocks | no |
| app_subnet_cidrs | App Tier Subnet CIDR Blocks | no |
| data_subnet_cidrs | Data Tier Subnet CIDR Blocks | no |
| s3_bucket_id | S3 Bucket ID | no |
| s3_bucket_arn | S3 Bucket ARN | no |
| availability_zones | Availability Zones | no |
| import_ids | Import IDs | no |

## Architecture

This module creates a three-tier network architecture in AWS:

- **Web Tier**: Public subnets with Internet Gateway connectivity
- **App Tier**: Private subnets with NAT Gateway for outbound connectivity
- **Data Tier**: Private subnets for database and storage resources
- **Storage**: S3 bucket for object storage needs

## Variable Constraints

### account_name
- Must be lowercase
- Must use hyphens as delimiters
- Must contain only alphanumeric characters and hyphens
- Example: `my-account-01`

### account_class
- Must be either `nonprod` or `prod`
- Used for environment classification and naming conventions

### region
- Must be a valid AWS region
- Examples: `us-east-1`, `us-west-2`, `eu-west-1`

### vpc_offset
- Used to calculate unique CIDR blocks for the VPC
- Should be a positive integer
- Each environment should use a different offset to avoid CIDR conflicts

## Tags

The module supports comprehensive tagging through the `tags` variable. All resources created by the module will inherit these tags. Common tag examples:

```hcl
tags = {
  Environment = "production"
  Owner       = "platform-team"
  CostCenter  = "engineering"
  Project     = "landing-zone"
  Compliance  = "pci-dss"
}
```
