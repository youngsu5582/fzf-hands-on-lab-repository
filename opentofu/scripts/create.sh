#!/bin/bash

set -e

echo "========================================="
echo "  AWS EC2 Instance Creation Script"
echo "========================================="
echo ""

# Change to opentofu directory
cd "$(dirname "$0")/.."

# Check if tofu is installed
if ! command -v tofu &> /dev/null; then
    echo "Error: OpenTofu is not installed."
    echo "Please install OpenTofu first: https://opentofu.org/docs/intro/install/"
    exit 1
fi

# Check if AWS profile exists
if ! aws configure list --profile joyson &> /dev/null; then
    echo "Error: AWS profile 'joyson' not found."
    echo "Please configure your AWS profile first:"
    echo "  aws configure --profile joyson"
    exit 1
fi

# Check and delete existing key pair if it exists
KEY_NAME="fzf-lab-key"
echo "Checking for existing key pair..."
if aws ec2 describe-key-pairs --key-names "$KEY_NAME" --profile joyson --region ap-northeast-2 &> /dev/null; then
    echo "Found existing key pair '$KEY_NAME'. Deleting..."
    aws ec2 delete-key-pair --key-name "$KEY_NAME" --profile joyson --region ap-northeast-2
    echo "Deleted existing key pair."
fi

# Initialize OpenTofu
echo "Initializing OpenTofu..."
tofu init

# Plan the infrastructure
echo ""
echo "Planning infrastructure changes..."
tofu plan

# Ask for confirmation
echo ""
read -p "Do you want to create this infrastructure? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Apply the configuration
echo ""
echo "Creating infrastructure..."
tofu apply -auto-approve

# Display connection information
echo ""
echo "========================================="
echo "  EC2 Instance Created Successfully!"
echo "========================================="
echo ""
tofu output -json | jq -r '.ssh_command.value' | xargs -I {} echo "Connect using: {}"
echo ""
echo "To connect later, run: ./scripts/connect.sh"
echo "To destroy, run: ./scripts/destroy.sh"
echo ""
