# PowerShell script to update imports-nonprod.tf or imports-prod.tf with resource IDs from importids.json

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("nonprod", "prod")]
    [string]$Environment
)

# Determine which imports file to update based on environment
$ImportsFile = ""
if ($Environment -eq "nonprod") {
    $ImportsFile = "imports-nonprod.tf"
} elseif ($Environment -eq "prod") {
    $ImportsFile = "imports-prod.tf"
}

# Check if imports file exists
if (-not (Test-Path -Path $ImportsFile)) {
    Write-Error "Error: File $ImportsFile does not exist"
    exit 1
}

# Check if importids.json exists
if (-not (Test-Path -Path "importids.json")) {
    Write-Error "Error: importids.json file not found"
    exit 1
}

Write-Host "Processing $Environment environment imports..." -ForegroundColor Green

# Create backup of original imports file
Copy-Item -Path $ImportsFile -Destination "$ImportsFile.bak" -Force

# Read the importids.json file
$jsonContent = Get-Content -Path "importids.json" -Raw | ConvertFrom-Json

# Extract resource IDs
$vpcId = $jsonContent.vpc
$internetGatewayId = $jsonContent.internet_gateway
$s3BucketId = $jsonContent.s3_bucket
$s3BucketVersioningId = $jsonContent.s3_bucket_versioning
$s3BucketEncryptionId = $jsonContent.s3_bucket_server_side_encryption_configuration
$s3BucketPublicAccessId = $jsonContent.s3_bucket_public_access_block
$routeTableWebId = $jsonContent.route_table_web

# Extract subnet IDs
$webSubnetAId = $jsonContent.web_subnets.a
$webSubnetBId = $jsonContent.web_subnets.b
$webSubnetCId = $jsonContent.web_subnets.c
$appSubnetAId = $jsonContent.app_subnets.a
$appSubnetBId = $jsonContent.app_subnets.b
$appSubnetCId = $jsonContent.app_subnets.c
$dataSubnetAId = $jsonContent.data_subnets.a
$dataSubnetBId = $jsonContent.data_subnets.b
$dataSubnetCId = $jsonContent.data_subnets.c

# Extract route table IDs
$routeTableAppAId = $jsonContent.route_tables_app.a
$routeTableAppBId = $jsonContent.route_tables_app.b
$routeTableAppCId = $jsonContent.route_tables_app.c
$routeTableDataAId = $jsonContent.route_tables_data.a
$routeTableDataBId = $jsonContent.route_tables_data.b
$routeTableDataCId = $jsonContent.route_tables_data.c

# Extract route table association IDs
$routeTableAssocWebAId = $jsonContent.route_table_associations_web.a
$routeTableAssocWebBId = $jsonContent.route_table_associations_web.b
$routeTableAssocWebCId = $jsonContent.route_table_associations_web.c
$routeTableAssocAppAId = $jsonContent.route_table_associations_app.a
$routeTableAssocAppBId = $jsonContent.route_table_associations_app.b
$routeTableAssocAppCId = $jsonContent.route_table_associations_app.c
$routeTableAssocDataAId = $jsonContent.route_table_associations_data.a
$routeTableAssocDataBId = $jsonContent.route_table_associations_data.b
$routeTableAssocDataCId = $jsonContent.route_table_associations_data.c

# Extract NAT Gateway and Elastic IP IDs
$elasticIpAId = $jsonContent.elastic_ips.a
$natGatewayAId = $jsonContent.nat_gateways.a

# Read the imports file content
$importsContent = Get-Content -Path $ImportsFile -Raw

# Replace common placeholder IDs with actual resource IDs
$importsContent = $importsContent -replace '<vpc_import_id>', $vpcId
$importsContent = $importsContent -replace '<internet_gateway_import_id>', $internetGatewayId

# Replace subnet IDs
$importsContent = $importsContent -replace '<subnet_web_a_import_id>', $webSubnetAId
$importsContent = $importsContent -replace '<subnet_web_b_import_id>', $webSubnetBId
$importsContent = $importsContent -replace '<subnet_web_c_import_id>', $webSubnetCId
$importsContent = $importsContent -replace '<subnet_app_a_import_id>', $appSubnetAId
$importsContent = $importsContent -replace '<subnet_app_b_import_id>', $appSubnetBId
$importsContent = $importsContent -replace '<subnet_app_c_import_id>', $appSubnetCId
$importsContent = $importsContent -replace '<subnet_data_a_import_id>', $dataSubnetAId
$importsContent = $importsContent -replace '<subnet_data_b_import_id>', $dataSubnetBId
$importsContent = $importsContent -replace '<subnet_data_c_import_id>', $dataSubnetCId

# Replace route table IDs
$importsContent = $importsContent -replace '<route_table_web_import_id>', $routeTableWebId
$importsContent = $importsContent -replace '<route_table_app_a_import_id>', $routeTableAppAId
$importsContent = $importsContent -replace '<route_table_app_b_import_id>', $routeTableAppBId
$importsContent = $importsContent -replace '<route_table_app_c_import_id>', $routeTableAppCId
$importsContent = $importsContent -replace '<route_table_data_a_import_id>', $routeTableDataAId
$importsContent = $importsContent -replace '<route_table_data_b_import_id>', $routeTableDataBId
$importsContent = $importsContent -replace '<route_table_data_c_import_id>', $routeTableDataCId

# Replace route table association IDs
$importsContent = $importsContent -replace '<route_table_association_web_a_import_id>', $routeTableAssocWebAId
$importsContent = $importsContent -replace '<route_table_association_web_b_import_id>', $routeTableAssocWebBId
$importsContent = $importsContent -replace '<route_table_association_web_c_import_id>', $routeTableAssocWebCId
$importsContent = $importsContent -replace '<route_table_association_app_a_import_id>', $routeTableAssocAppAId
$importsContent = $importsContent -replace '<route_table_association_app_b_import_id>', $routeTableAssocAppBId
$importsContent = $importsContent -replace '<route_table_association_app_c_import_id>', $routeTableAssocAppCId
$importsContent = $importsContent -replace '<route_table_association_data_a_import_id>', $routeTableAssocDataAId
$importsContent = $importsContent -replace '<route_table_association_data_b_import_id>', $routeTableAssocDataBId
$importsContent = $importsContent -replace '<route_table_association_data_c_import_id>', $routeTableAssocDataCId

# Replace S3 bucket IDs
$importsContent = $importsContent -replace '<s3_bucket_import_id>', $s3BucketId
$importsContent = $importsContent -replace '<s3_bucket_versioning_import_id>', $s3BucketVersioningId
$importsContent = $importsContent -replace '<s3_bucket_server_side_encryption_configuration_import_id>', $s3BucketEncryptionId
$importsContent = $importsContent -replace '<s3_bucket_public_access_block_import_id>', $s3BucketPublicAccessId

# Replace NAT Gateway and Elastic IP IDs
$importsContent = $importsContent -replace '<elastic_ip_a_import_id>', $elasticIpAId
$importsContent = $importsContent -replace '<nat_gateway_a_import_id>', $natGatewayAId

# For prod environment, also extract and replace additional NAT Gateways and EIPs
if ($Environment -eq "prod") {
    $elasticIpBId = $jsonContent.elastic_ips.b
    $elasticIpCId = $jsonContent.elastic_ips.c
    $natGatewayBId = $jsonContent.nat_gateways.b
    $natGatewayCId = $jsonContent.nat_gateways.c
    
    # Check if prod-specific resources exist in importids.json
    if ($null -eq $elasticIpBId -or $null -eq $elasticIpCId -or 
        $null -eq $natGatewayBId -or $null -eq $natGatewayCId) {
        Write-Warning "Production environment requires additional NAT Gateways and Elastic IPs in AZs b and c"
        Write-Warning "These are not present in importids.json (likely because resources were created as nonprod)"
        Write-Warning "You'll need to update importids.json with production resource IDs"
    } else {
        $importsContent = $importsContent -replace '<elastic_ip_b_import_id>', $elasticIpBId
        $importsContent = $importsContent -replace '<elastic_ip_c_import_id>', $elasticIpCId
        $importsContent = $importsContent -replace '<nat_gateway_b_import_id>', $natGatewayBId
        $importsContent = $importsContent -replace '<nat_gateway_c_import_id>', $natGatewayCId
    }
}

# Write the updated content back to the imports file
Set-Content -Path $ImportsFile -Value $importsContent -NoNewline

Write-Host "Successfully updated $ImportsFile with resource IDs from importids.json" -ForegroundColor Green

# Check for any remaining placeholders
$remainingPlaceholders = Select-String -Pattern "<.*_import_id>" -Path $ImportsFile
if ($remainingPlaceholders) {
    Write-Host ""
    Write-Warning "Some placeholders remain in $ImportsFile :"
    $uniquePlaceholders = $remainingPlaceholders | ForEach-Object { $_.Matches[0].Value } | Sort-Object -Unique
    foreach ($placeholder in $uniquePlaceholders) {
        Write-Warning "  $placeholder"
    }
    Write-Host ""
    Write-Warning "This may indicate missing resource IDs in importids.json"
}