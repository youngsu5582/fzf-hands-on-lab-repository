#!/bin/bash

set -e

echo "========================================="
echo "  EC2 Instance Start Script"
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

if [ "$CURRENT_STATE" = "running" ]; then
    echo "Instance is already running."
    echo ""
    tofu output -json | jq -r 'to_entries[] | "\(.key): \(.value.value)"'
    exit 0
fi

if [ "$CURRENT_STATE" = "pending" ]; then
    echo "Instance is already starting. Please wait."
    exit 0
fi

# Start instance
echo "Starting instance..."
aws ec2 start-instances \
    --instance-ids "$INSTANCE_ID" \
    --profile joyson \
    --region ap-northeast-2

echo ""
echo "Instance is starting. This may take a few minutes."
echo ""
echo "Waiting for instance to be ready..."

# Wait for instance to be running
aws ec2 wait instance-running \
    --instance-ids "$INSTANCE_ID" \
    --profile joyson \
    --region ap-northeast-2

# Refresh terraform state to get new IP
echo ""
echo "Refreshing state to get new IP address..."
tofu refresh > /dev/null

echo ""
echo "========================================="
echo "  Instance Started Successfully!"
echo "========================================="
echo ""
tofu output -json | jq -r 'to_entries[] | "\(.key): \(.value.value)"'
echo ""
echo "To connect: ./scripts/connect.sh"
echo ""
