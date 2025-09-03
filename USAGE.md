# HashiCorp Customer Workshop TF Module - AWS Landing Zone

## Overview

This repository manages a Terraform Module that creates a very simple "Landing Zone" (Base Infrastructure) in an AWS Account. It is meant to be used with the [HashiCorp Customer Workshop TF Registry Module - AWS Landing Zone](https://github.com/leefowlercu/hashicorp-workshop-tf-registry-module-aws-landing-zone) Module to showcase:

- Private Registry Module Usage
- Landing Zone Strategies
- Conditional Configuration
- Config-Driven Import

## Usage

### Standard Module Showcase Usage

Fork this repository (including all branches), then, in your fork, replace `<tf-hostname>`, `<tf-organization-name>`, `<tf-registry-module-name>`, and `<tf-registry-module-version>` in `main.tf` with the correct values for your workshop, then create two workspaces in the customer workshop HCPTF/TFE organization. One will target the forked repository's `nonprod` branch and the other will target the forked repository's default (`master`/`main`) branch. Add the required variables on the workspaces and authenticate the `aws` provider using environment variables in either the workspace variables or a variable set.

### Config-Driven Import Showcase Usage

This module, and the "Landing Zone" child module which it uses ([HashiCorp Customer Workshop TF Registry Module - AWS Landing Zone](https://github.com/leefowlercu/hashicorp-workshop-tf-registry-module-aws-landing-zone)), include a helper output that, after the module is successfully applied, will provide a JSON representation of the import IDs necessary to populate the import files. We also include helper scripts in this repository (`update_imports.sh`/`update_imports.ps1`) that automatically update the correct import file based on the environment parameter you provide. To showcase config-driven imports in Terraform, create the resources using this module as per the standard usage instructions above, and then perform the following actions (in your Fork, on the appropriate Branch):

1. Copy the `import_ids` object value from the outputs of the workspace and paste it directly into `importids.json`. Save the file.
2. Run either of the `update_imports` scripts with the environment parameter matching your deployment's `account_class`:
   - Shell: `./update_imports.sh nonprod` or `./update_imports.sh prod`
   - PowerShell: `./update_imports.ps1 -Environment nonprod` or `./update_imports.ps1 -Environment prod`
3. The script will automatically update the appropriate import file (`imports-nonprod.tf` for nonprod or `imports-prod.tf` for prod) with the resource IDs from `importids.json`.
4. Validate the import file contains the correct import IDs.
5. *Force Delete the existing Workspace*. Yes, *Force Delete* it! The goal is to showcase importing existing, unmanaged infrastructure into Terraform management.
6. Commit and push the changes including the updated import file to your Fork's remote repo, on the appropriate branch.
7. Remake your workspace in HCPTF/TFE using the same variable values. This time instead of creating new infrastructure the module should read the import blocks and import the infrastructure into Terraform management.

### Important Notes on NonProd vs Prod

The AWS Landing Zone module creates different infrastructure based on the `account_class` variable:

- **NonProd (`account_class = "nonprod"`)**: 
  - Creates 1 NAT Gateway and 1 Elastic IP (in Availability Zone 'a' only)
  - S3 bucket versioning is disabled
  - All private subnets route through the single NAT Gateway

- **Prod (`account_class = "prod"`)**:
  - Creates 3 NAT Gateways and 3 Elastic IPs (one in each Availability Zone)
  - S3 bucket versioning is enabled
  - Each AZ's private subnets route through their respective NAT Gateway for high availability

The update scripts automatically select the correct import file based on the environment parameter you provide, ensuring the import blocks match your deployed infrastructure.

## Example

```
customer-workshop-organization                      # HCPTF/TFE Workshop Organization 
└── landing-zones                                   # HCPTF/TFE Project for Landing Zones/Base Infrastructure
    ├── aws-customer-workshop-nonprod-landing-zone  # NonProd Landing Zone Workspace -> Targets `nonprod` Branch on Fork
    └── aws-customer-workshop-prod-landing-zone     # Prod Landing Zone Workspace -> Targets `master/main` Branch on Fork
```