#!/bin/bash

set -e

# Change to opentofu directory
cd "$(dirname "$0")/.."

# Check if infrastructure exists
if [ ! -f "terraform.tfstate" ]; then
    echo "No infrastructure found."
    echo "Run ./scripts/create.sh to create EC2 instance."
    exit 0
fi

# Check if tofu is installed
if ! command -v tofu &> /dev/null; then
    echo "Error: OpenTofu is not installed."
    exit 1
fi

echo "========================================="
echo "  EC2 Instance Status"
echo "========================================="
echo ""

# Display outputs
tofu output -json | jq -r 'to_entries[] | "\(.key): \(.value.value)"'

echo ""
echo "========================================="
