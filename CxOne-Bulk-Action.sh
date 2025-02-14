#!/bin/bash

# Define API Token and Base URL
API_TOKEN="your-auth-token-here-which-can-be-fetched-from-inspect-network-headers"
BASE_URL="https://us.ast.checkmarx.net/api"
HEADERS=(-H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json")

# API endpoint to fetch all projects
PROJECTS_ENDPOINT="$BASE_URL/projects/?offset=0&limit=99999"

# Function to log response
log_response() {
  local RESPONSE=$1
  if [[ "$RESPONSE" == *"200"* ]] || [[ "$RESPONSE" == *"204"* ]]; then
    echo "✅ Successfully updated settings."
  else
    echo "❌ Failed to update settings - Response: $RESPONSE"
  fi
}

# Function to update repository settings
update_repo_settings() {
  local PROJECT_ID=$1

  echo "Updating settings for Project ID: $PROJECT_ID"

  # Apply user-selected settings
  local UPDATE_PAYLOAD="{
    \"branches\": [
      {\"name\":\"develop\", \"isDefaultBranch\":false}, 
      {\"name\":\"master\", \"isDefaultBranch\":false}
    ],
    \"sastIncrementalScan\": $SAST_INCREMENTAL,
    \"sastScannerEnabled\": $SAST_SCANNER,
    \"scaScannerEnabled\": $SCA_SCANNER,
    \"apiSecScannerEnabled\": $APISEC_SCANNER,
    \"webhookEnabled\": $WEBHOOK_ENABLED,
    \"secretsDerectionScannerEnabled\": $SECRETS_DETECTION,
    \"containerScannerEnabled\": $CONTAINER_SCANNER
  }"

  RESPONSE=$(curl -s -X PUT "$BASE_URL/repos-manager/repo/$PROJECT_ID?projectId=$PROJECT_ID" "${HEADERS[@]}" --data-raw "$UPDATE_PAYLOAD")

  log_response "$RESPONSE"
}

# Function to prompt user to select settings
select_settings() {
  echo "Select which settings you want to update (yes/no for each):"

  read -p "Enable SAST Incremental Scan? (true/false): " SAST_INCREMENTAL
  read -p "Enable SAST Scanner? (true/false): " SAST_SCANNER
  read -p "Enable SCA Scanner? (true/false): " SCA_SCANNER
  read -p "Enable API Security Scanner? (true/false): " APISEC_SCANNER
  read -p "Enable Webhook? (true/false): " WEBHOOK_ENABLED
  read -p "Enable Secrets Detection Scanner? (true/false): " SECRETS_DETECTION
  read -p "Enable Container Scanner? (true/false): " CONTAINER_SCANNER
}

# Main script execution
echo "Fetching all project IDs..."
PROJECT_IDS=$(curl -s -X GET "$PROJECTS_ENDPOINT" "${HEADERS[@]}" | jq -r '.projects[].id')

# Let user select update settings
select_settings

echo "Updating settings for all projects..."
for PROJECT_ID in $PROJECT_IDS; do
  update_repo_settings "$PROJECT_ID"
done

echo "✅ All projects updated successfully!"