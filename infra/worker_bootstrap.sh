#!/bin/bash

# -----------------------------
# Update system and install tools
# -----------------------------
apt-get update -y
apt-get upgrade -y
apt-get install -y git unzip
sudo apt install python3-dev
sudo apt install python3-venv

# -----------------------------
# Python venv won't conflict with apt
# -----------------------------
python3 -m venv daskbenchmarkenv
source daskbenchmarkenv/bin/activate

# -----------------------------
# Install AWS CLI
# -----------------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# -----------------------------
# Install Python packages
# -----------------------------
sudo apt install --upgrade python3-pip
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
