#!/bin/bash

# Replace session_token with your actual values
session_token=""

# Inform the user that the request is being made
echo "Making a GET request to fetch scan data..."

# Make the GET request and save the response to scans.json and change "xxx".checkmarx.net with your url
response=$(curl -s "https://xxx.checkmarx.net/cxrestapi/sast/scans" -H "Authorization: Bearer $session_token" -H "Content-Type: application/json")

# Check if authorization failed
if [[ "$response" == *"Authorization has been denied"* ]]; then
    echo "Error: Authorization failed. Please provide a valid session token."
    echo "Exiting the process. Please provide fresh/new session token."
    exit 1
fi

# Check if the request was successful
if [ $? -eq 0 ]; then
    echo "Scan data successfully downloaded."
else
    echo "Error: Failed to download scan data."
    exit 1
fi

# Save the response to scans.json
echo "$response" > scans.json

# Validate JSON structure
echo "Validating JSON structure..."
if ! jq empty scans.json; then
    echo "Error: Invalid JSON structure in scans.json"
    exit 1
else
    echo "JSON structure validated."
fi

# Inform the user that extraction is starting
echo "Extracting data and creating CSV file..."

# Extract the mentioned parameters using jq and create a CSV file
jq -r '
  ["Project Name", "Scan Type", "Comment", "Path", "CxVersion", "Owner", "Origin"],
  (.[] 
  | select(type == "object")
  | [
      .project.name // "null",
      .scanType.value // "null",
      .comment // "null",
      .scanState.path // "null",
      .scanState.cxVersion // "null",
      .owner // "null",
      .origin // "null"
    ]) 
  | @csv
' scans.json > scans.csv

# Check if CSV file was successfully created
if [ $? -eq 0 ]; then
    echo "Data extracted and saved to scans.csv."
else
    echo "Error: Failed to create scans.csv."
fi

echo "Process complete."
