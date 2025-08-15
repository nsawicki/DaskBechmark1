#!/bin/bash

# -----------------------------
# Update system and install tools
# -----------------------------
apt-get update -y
apt-get upgrade -y
apt-get install -y python3-pip python3-dev python3-venv git unzip

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
# Start Ray head node
# -----------------------------
PRIVATE_IP=$(hostname -I | awk '{print $1}')
ray start --head --node-ip-address=${PRIVATE_IP} --port=6379 --dashboard-host=0.0.0.0

echo "✅ Ray head node started at ${PRIVATE_IP}:6379"
