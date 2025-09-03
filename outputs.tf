output "vpc_id" {
  description = "VPC ID"
  value       = module.landing_zone.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR Block"
  value       = module.landing_zone.vpc_cidr
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.landing_zone.internet_gateway_id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.landing_zone.nat_gateway_ids
}

output "web_subnet_ids" {
  description = "Web Tier Subnet IDs"
  value       = module.landing_zone.web_subnet_ids
}

output "app_subnet_ids" {
  description = "App Tier Subnet IDs"
  value       = module.landing_zone.app_subnet_ids
}

output "data_subnet_ids" {
  description = "Data Tier Subnet IDs"
  value       = module.landing_zone.data_subnet_ids
}

output "web_subnet_cidrs" {
  description = "Web Tier Subnet CIDR Blocks"
  value       = module.landing_zone.web_subnet_cidrs
}

output "app_subnet_cidrs" {
  description = "App Tier Subnet CIDR Blocks"
  value       = module.landing_zone.app_subnet_cidrs
}

output "data_subnet_cidrs" {
  description = "Data Tier Subnet CIDR Blocks"
  value       = module.landing_zone.data_subnet_cidrs
}

output "s3_bucket_id" {
  description = "S3 Bucket ID"
  value       = module.landing_zone.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "S3 Bucket ARN"
  value       = module.landing_zone.s3_bucket_arn
}

output "availability_zones" {
  description = "Availability Zones"
  value       = module.landing_zone.availability_zones
}

output "import_ids" {
  description = "Import IDs"
  value       = module.landing_zone.import_ids
}
