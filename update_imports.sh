#!/bin/sh

# Read importids.json and replace placeholders in imports-nonprod.tf or imports-prod.tf

# Check for environment argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <nonprod|prod>"
    echo "Example: $0 nonprod"
    exit 1
fi

ENVIRONMENT=$1
IMPORTS_FILE=""

# Determine which imports file to update based on environment
if [ "$ENVIRONMENT" = "nonprod" ]; then
    IMPORTS_FILE="imports-nonprod.tf"
elif [ "$ENVIRONMENT" = "prod" ]; then
    IMPORTS_FILE="imports-prod.tf"
else
    echo "Error: Environment must be 'nonprod' or 'prod'"
    exit 1
fi

# Check if imports file exists
if [ ! -f "$IMPORTS_FILE" ]; then
    echo "Error: File $IMPORTS_FILE does not exist"
    exit 1
fi

# Check if importids.json exists
if [ ! -f "importids.json" ]; then
    echo "Error: importids.json file not found"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Create backup of original imports file
cp "$IMPORTS_FILE" "${IMPORTS_FILE}.bak"

# Create a temporary file for processing
TEMP_FILE=$(mktemp)
cp "$IMPORTS_FILE" "$TEMP_FILE"

echo "Processing $ENVIRONMENT environment imports..."

# Extract resource IDs from importids.json
vpc_id=$(jq -r '.vpc' importids.json)
internet_gateway_id=$(jq -r '.internet_gateway' importids.json)
s3_bucket_id=$(jq -r '.s3_bucket' importids.json)
s3_bucket_versioning_id=$(jq -r '.s3_bucket_versioning' importids.json)
s3_bucket_encryption_id=$(jq -r '.s3_bucket_server_side_encryption_configuration' importids.json)
s3_bucket_public_access_id=$(jq -r '.s3_bucket_public_access_block' importids.json)
route_table_web_id=$(jq -r '.route_table_web' importids.json)

# Extract subnet IDs
web_subnet_a_id=$(jq -r '.web_subnets.a' importids.json)
web_subnet_b_id=$(jq -r '.web_subnets.b' importids.json)
web_subnet_c_id=$(jq -r '.web_subnets.c' importids.json)
app_subnet_a_id=$(jq -r '.app_subnets.a' importids.json)
app_subnet_b_id=$(jq -r '.app_subnets.b' importids.json)
app_subnet_c_id=$(jq -r '.app_subnets.c' importids.json)
data_subnet_a_id=$(jq -r '.data_subnets.a' importids.json)
data_subnet_b_id=$(jq -r '.data_subnets.b' importids.json)
data_subnet_c_id=$(jq -r '.data_subnets.c' importids.json)

# Extract route table IDs
route_table_app_a_id=$(jq -r '.route_tables_app.a' importids.json)
route_table_app_b_id=$(jq -r '.route_tables_app.b' importids.json)
route_table_app_c_id=$(jq -r '.route_tables_app.c' importids.json)
route_table_data_a_id=$(jq -r '.route_tables_data.a' importids.json)
route_table_data_b_id=$(jq -r '.route_tables_data.b' importids.json)
route_table_data_c_id=$(jq -r '.route_tables_data.c' importids.json)

# Extract route table association IDs
route_table_assoc_web_a_id=$(jq -r '.route_table_associations_web.a' importids.json)
route_table_assoc_web_b_id=$(jq -r '.route_table_associations_web.b' importids.json)
route_table_assoc_web_c_id=$(jq -r '.route_table_associations_web.c' importids.json)
route_table_assoc_app_a_id=$(jq -r '.route_table_associations_app.a' importids.json)
route_table_assoc_app_b_id=$(jq -r '.route_table_associations_app.b' importids.json)
route_table_assoc_app_c_id=$(jq -r '.route_table_associations_app.c' importids.json)
route_table_assoc_data_a_id=$(jq -r '.route_table_associations_data.a' importids.json)
route_table_assoc_data_b_id=$(jq -r '.route_table_associations_data.b' importids.json)
route_table_assoc_data_c_id=$(jq -r '.route_table_associations_data.c' importids.json)

# Extract NAT Gateway and Elastic IP IDs based on environment
elastic_ip_a_id=$(jq -r '.elastic_ips.a' importids.json)
nat_gateway_a_id=$(jq -r '.nat_gateways.a' importids.json)

# Function to perform sed replacement (compatible with both Mac and Linux)
replace_placeholder() {
    local placeholder="$1"
    local value="$2"
    if [ "$(uname)" = "Darwin" ]; then
        # macOS
        sed -i '' "s|${placeholder}|${value}|g" "$TEMP_FILE"
    else
        # Linux
        sed -i "s|${placeholder}|${value}|g" "$TEMP_FILE"
    fi
}

# Replace common placeholder IDs with actual resource IDs
replace_placeholder "<vpc_import_id>" "$vpc_id"
replace_placeholder "<internet_gateway_import_id>" "$internet_gateway_id"

# Replace subnet IDs
replace_placeholder "<subnet_web_a_import_id>" "$web_subnet_a_id"
replace_placeholder "<subnet_web_b_import_id>" "$web_subnet_b_id"
replace_placeholder "<subnet_web_c_import_id>" "$web_subnet_c_id"
replace_placeholder "<subnet_app_a_import_id>" "$app_subnet_a_id"
replace_placeholder "<subnet_app_b_import_id>" "$app_subnet_b_id"
replace_placeholder "<subnet_app_c_import_id>" "$app_subnet_c_id"
replace_placeholder "<subnet_data_a_import_id>" "$data_subnet_a_id"
replace_placeholder "<subnet_data_b_import_id>" "$data_subnet_b_id"
replace_placeholder "<subnet_data_c_import_id>" "$data_subnet_c_id"

# Replace route table IDs
replace_placeholder "<route_table_web_import_id>" "$route_table_web_id"
replace_placeholder "<route_table_app_a_import_id>" "$route_table_app_a_id"
replace_placeholder "<route_table_app_b_import_id>" "$route_table_app_b_id"
replace_placeholder "<route_table_app_c_import_id>" "$route_table_app_c_id"
replace_placeholder "<route_table_data_a_import_id>" "$route_table_data_a_id"
replace_placeholder "<route_table_data_b_import_id>" "$route_table_data_b_id"
replace_placeholder "<route_table_data_c_import_id>" "$route_table_data_c_id"

# Replace route table association IDs
replace_placeholder "<route_table_association_web_a_import_id>" "$route_table_assoc_web_a_id"
replace_placeholder "<route_table_association_web_b_import_id>" "$route_table_assoc_web_b_id"
replace_placeholder "<route_table_association_web_c_import_id>" "$route_table_assoc_web_c_id"
replace_placeholder "<route_table_association_app_a_import_id>" "$route_table_assoc_app_a_id"
replace_placeholder "<route_table_association_app_b_import_id>" "$route_table_assoc_app_b_id"
replace_placeholder "<route_table_association_app_c_import_id>" "$route_table_assoc_app_c_id"
replace_placeholder "<route_table_association_data_a_import_id>" "$route_table_assoc_data_a_id"
replace_placeholder "<route_table_association_data_b_import_id>" "$route_table_assoc_data_b_id"
replace_placeholder "<route_table_association_data_c_import_id>" "$route_table_assoc_data_c_id"

# Replace S3 bucket IDs
replace_placeholder "<s3_bucket_import_id>" "$s3_bucket_id"
replace_placeholder "<s3_bucket_versioning_import_id>" "$s3_bucket_versioning_id"
replace_placeholder "<s3_bucket_server_side_encryption_configuration_import_id>" "$s3_bucket_encryption_id"
replace_placeholder "<s3_bucket_public_access_block_import_id>" "$s3_bucket_public_access_id"

# Replace NAT Gateway and Elastic IP IDs
replace_placeholder "<elastic_ip_a_import_id>" "$elastic_ip_a_id"
replace_placeholder "<nat_gateway_a_import_id>" "$nat_gateway_a_id"

# For prod environment, also extract and replace additional NAT Gateways and EIPs
if [ "$ENVIRONMENT" = "prod" ]; then
    elastic_ip_b_id=$(jq -r '.elastic_ips.b' importids.json)
    elastic_ip_c_id=$(jq -r '.elastic_ips.c' importids.json)
    nat_gateway_b_id=$(jq -r '.nat_gateways.b' importids.json)
    nat_gateway_c_id=$(jq -r '.nat_gateways.c' importids.json)
    
    # Check if prod-specific resources exist in importids.json
    if [ "$elastic_ip_b_id" = "null" ] || [ "$elastic_ip_c_id" = "null" ] || \
       [ "$nat_gateway_b_id" = "null" ] || [ "$nat_gateway_c_id" = "null" ]; then
        echo "Warning: Production environment requires additional NAT Gateways and Elastic IPs in AZs b and c"
        echo "         These are not present in importids.json (likely because resources were created as nonprod)"
        echo "         You'll need to update importids.json with production resource IDs"
    else
        replace_placeholder "<elastic_ip_b_import_id>" "$elastic_ip_b_id"
        replace_placeholder "<elastic_ip_c_import_id>" "$elastic_ip_c_id"
        replace_placeholder "<nat_gateway_b_import_id>" "$nat_gateway_b_id"
        replace_placeholder "<nat_gateway_c_import_id>" "$nat_gateway_c_id"
    fi
fi

# Copy the updated content back to the imports file
cp "$TEMP_FILE" "$IMPORTS_FILE"

# Clean up temporary file
rm -f "$TEMP_FILE"

echo "Successfully updated $IMPORTS_FILE with resource IDs from importids.json"

# Check for any remaining placeholders
if grep -q "<.*_import_id>" "$IMPORTS_FILE"; then
    echo ""
    echo "Warning: Some placeholders remain in $IMPORTS_FILE:"
    grep -o "<.*_import_id>" "$IMPORTS_FILE" | sort | uniq
    echo ""
    echo "This may indicate missing resource IDs in importids.json"
fi