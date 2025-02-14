
#!/bin/bash

# Set API URL
CHECKMARX_URL="https://us.ast.checkmarx.net/api"
AUTH_TOKEN="your-auth-token-here-which-can-be-fetched-from-inspect-network-headers"

# Headers for API requests
HEADERS=(
  -H "Authorization: Bearer $AUTH_TOKEN"
  -H "Accept: application/json; version=1.0"
  -H "Content-Type: application/json"
)

# Prompt for Dry Run
read -p "Enable dry-run mode? (yes/no): " DRY_RUN

# Fetch all project IDs
fetch_project_ids() {
  echo "Fetching all project IDs..."
  PROJECT_IDS=$(curl -s -X GET "$CHECKMARX_URL/api/projects/?offset=0&limit=99999" "${HEADERS[@]}" | jq -r '.projects[] | "\(.id) \(.name)"')
  echo "$PROJECT_IDS"
}

# Log responses
log_response() {
  local RESPONSE="$1"
  local PROJECT_ID="$2"
  local HTTP_CODE=$(echo "$RESPONSE" | jq -r '.statusCode // empty')

  if [[ "$HTTP_CODE" == "200" || "$HTTP_CODE" == "204" ]]; then
    echo "✅ [$PROJECT_ID] Successfully updated." | tee -a update_log.txt
  else
    echo "❌ [$PROJECT_ID] Failed with HTTP Code: $HTTP_CODE" | tee -a update_errors.txt
    echo "Response: $RESPONSE" >> update_errors.txt
  fi
}

# Function to update repository settings
update_repo_settings() {
  local PROJECT_ID=$1

  echo "Updating settings for Project ID: $PROJECT_ID"

  if [[ "$DRY_RUN" == "yes" ]]; then
    echo "🔹 [DRY RUN] Would have updated: $PROJECT_ID"
    return
  fi

  local RESPONSE=$(curl -s -X PUT "$CHECKMARX_URL/api/repos-manager/repo/$PROJECT_ID?projectId=$PROJECT_ID" \
    "${HEADERS[@]}" \
    --data-raw '{
      "branches": [{"name":"develop","isDefaultBranch":false}, {"name":"master","isDefaultBranch":false}],
      "sastIncrementalScan": true,
      "sastScannerEnabled": true,
      "scaScannerEnabled": true,
      "apiSecScannerEnabled": true,
      "webhookEnabled": true,
      "secretsDerectionScannerEnabled": true,
      "containerScannerEnabled": false
    }')

  log_response "$RESPONSE" "$PROJECT_ID"
}

# Ask if user wants global updates or per-project updates
read -p "Apply same settings to all projects? (yes/no): " APPLY_ALL

# Fetch Project IDs
PROJECT_LIST=$(fetch_project_ids)

if [[ "$APPLY_ALL" == "no" ]]; then
  echo "⚠️ You will be prompted for each project."
  while read -r PROJECT_ID PROJECT_NAME; do
    read -p "Update settings for '$PROJECT_NAME' (ID: $PROJECT_ID)? (yes/no): " CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
      update_repo_settings "$PROJECT_ID"
    fi
  done <<< "$PROJECT_LIST"
else
  echo "Updating all projects in parallel..."
  echo "$PROJECT_LIST" | awk '{print $1}' | xargs -I {} -P 10 bash -c 'update_repo_settings "{}"'
fi

echo "✅ Update process completed!"