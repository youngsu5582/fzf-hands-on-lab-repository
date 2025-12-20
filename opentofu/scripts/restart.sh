#!/bin/bash

set -e

echo "========================================="
echo "  EC2 Instance Restart Script"
echo "========================================="
echo ""

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

# Get instance ID
INSTANCE_ID=$(tofu output -raw instance_id 2>/dev/null)

if [ -z "$INSTANCE_ID" ]; then
    echo "Error: Could not retrieve instance ID."
    echo ""
    echo "This usually means:"
    echo "  1. No instance has been created yet"
    echo "  2. The instance was destroyed"
    echo ""
    echo "Please run: ./scripts/create.sh"
    echo ""
    exit 1
fi

# Ask for confirmation
read -p "Do you want to restart this instance? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Reboot instance
echo ""
echo "Restarting instance..."
aws ec2 reboot-instances \
    --instance-ids "$INSTANCE_ID" \
    --profile joyson \
    --region ap-northeast-2

echo ""
echo "Instance is restarting. This may take a few minutes."
echo ""
echo "Waiting for instance to be ready..."

# Wait for instance to be running again
sleep 10
aws ec2 wait instance-running \
    --instance-ids "$INSTANCE_ID" \
    --profile joyson \
    --region ap-northeast-2

echo ""
echo "========================================="
echo "  Instance Restarted Successfully!"
echo "========================================="
echo ""
echo "To connect: ./scripts/connect.sh"
echo ""
