#!/bin/bash

set -e

# Change to opentofu directory
cd "$(dirname "$0")/.."

# Check if infrastructure exists
if [ ! -f "terraform.tfstate" ]; then
    echo "Error: No infrastructure found."
    echo "Please run ./scripts/create.sh first."
    exit 1
fi

# Check if tofu is installed
if ! command -v tofu &> /dev/null; then
    echo "Error: OpenTofu is not installed."
    exit 1
fi

# Get connection info
PUBLIC_IP=$(tofu output -raw instance_public_ip 2>/dev/null)
KEY_FILE=$(tofu output -raw key_file 2>/dev/null)

if [ -z "$PUBLIC_IP" ]; then
    echo "Error: Could not retrieve instance IP."
    echo "Make sure the infrastructure is created and running."
    exit 1
fi

echo "Connecting to EC2 instance..."
echo "IP: $PUBLIC_IP"
echo ""

# Connect via SSH
ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no ubuntu@"$PUBLIC_IP"
