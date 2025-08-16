# Distributed Image Benchmark with Daft on AWS

This project demonstrates a basic distributed benchmark using Daft to process images across multiple AWS EC2 instances.
We use a simple operation — finding the mean pixel value per image — to highlight cluster setup, distributed execution, and performance benchmarking.

📂 Project Structure
.
├── head_bootstrap.sh   # Bootstrap script for head node
├── worker_bootstrap.sh # Bootstrap script for worker nodes
├── run.py              # Python benchmark (Daft)
└── README.md

# 🚀 Setup Instructions
1. Launch AWS EC2 Instances

Use Ubuntu 22.04 LTS AMI.

Choose small instances (e.g., t3.small or t3.medium).

Create:

1 head node

2+ worker nodes

2. Security Groups

Configure the EC2 security group:

Allow inbound TCP 6379 from worker nodes to the head node (Ray cluster port).

Allow inbound TCP 8265 (optional) for Ray Dashboard access.

Restrict access with /32 CIDR masks where possible (for single-IP rules).

3. Bootstrap Scripts

When launching EC2s, paste the appropriate script into User Data:

Head node: head_bootstrap.sh

Worker nodes: worker_bootstrap.sh (replace HEAD_NODE_PRIVATE_IP with the actual private IP of the head node)

Both scripts will:

Update and install system dependencies

Install Ray, Daft, and Pillow

Configure swap (optional)

Start Ray cluster services

4. Verify Cluster

SSH into the head node and run:

ray status


You should see the worker nodes listed as connected.

▶️ Run Benchmark

On the head node, run:

python3 run.py


This script will:

Load images (from local disk or S3).

Distribute the task of finding the max pixel per image across the Ray cluster using Daft.

Report runtime statistics (load time, processing time, speedup).

📊 Next Steps

Swap in larger datasets (e.g., Cityscapes in S3).

Scale up worker nodes to test distributed performance.

Add GPU-backed nodes for image-heavy deep learning tasks.

⚠️ Notes

Uploading data to S3 is free, but storing it and downloading from S3 incurs costs.

t3.micro instances are very RAM-constrained. For smoother runs, start with t3.small or t3.medium.

If using S3, ensure your EC2 instances have IAM roles with S3 read permissions.

✅ With this setup, you now have a minimal but real distributed benchmark running on AWS.
