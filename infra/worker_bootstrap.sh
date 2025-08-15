#!/bin/bash

# -----------------------------
# Update system and install tools
# -----------------------------
apt-get update -y
apt-get upgrade -y
apt-get install -y python3-pip python3-dev git unzip
pip install awscli --upgrade --user

# -----------------------------
# Install Python packages
# -----------------------------
python3 -m pip install --upgrade pip
pip3 install ray[default] daft pillow boto3

# -----------------------------
# Configure AWS CLI
# -----------------------------
# Assumes an IAM role is attached to the EC2 instance with S3 access
aws configure set default.region us-east-2

# -----------------------------
# Join Ray cluster
# -----------------------------
HEAD_NODE_PRIVATE_IP=  # <-- Replace with head node private IP
PRIVATE_IP=$(hostname -I | awk '{print $1}')
ray start --address="${HEAD_NODE_PRIVATE_IP}:6379" --node-ip-address=${PRIVATE_IP}

echo "✅ Worker node connected to head node at ${HEAD_NODE_PRIVATE_IP}:6379"
