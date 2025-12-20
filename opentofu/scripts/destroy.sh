#!/bin/bash

set -e

echo "========================================="
echo "  AWS EC2 Instance Deletion Script"
echo "========================================="
echo ""

# Change to opentofu directory
cd "$(dirname "$0")/.."

# Check if infrastructure exists
if [ ! -f "terraform.tfstate" ]; then
    echo "No infrastructure found. Nothing to destroy."
    exit 0
fi

# Check if tofu is installed
if ! command -v tofu &> /dev/null; then
    echo "Error: OpenTofu is not installed."
    exit 1
fi

# Display current infrastructure
echo "Current infrastructure:"
tofu show -no-color | grep -E "(instance_id|instance_public_ip)" || true
echo ""

# Ask for confirmation
read -p "Are you sure you want to DESTROY all resources? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Destroy the infrastructure
echo ""
echo "Destroying infrastructure..."
tofu destroy -auto-approve

# Cleanup
echo ""
echo "Cleaning up local files..."
rm -f *.pem

echo ""
echo "========================================="
echo "  All resources have been destroyed!"
echo "========================================="
echo ""
