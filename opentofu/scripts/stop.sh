#!/bin/bash

set -e

echo "========================================="
echo "  EC2 Instance Stop Script"
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

# Check current state
CURRENT_STATE=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --profile joyson \
    --region ap-northeast-2 \
    --query 'Reservations[0].Instances[0].State.Name' \
    --output text 2>/dev/null)

echo "Instance ID: $INSTANCE_ID"
echo "Current State: $CURRENT_STATE"
echo ""

if [ "$CURRENT_STATE" = "stopped" ]; then
    echo "Instance is already stopped."
    exit 0
fi

if [ "$CURRENT_STATE" = "stopping" ]; then
    echo "Instance is already stopping. Please wait."
    exit 0
fi

# Ask for confirmation
read -p "Do you want to stop this instance? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Stop instance
echo ""
echo "Stopping instance..."
aws ec2 stop-instances \
    --instance-ids "$INSTANCE_ID" \
    --profile joyson \
    --region ap-northeast-2

echo ""
echo "Instance is stopping. This may take a few minutes."
echo "Check status with: ./scripts/status.sh"
echo ""
