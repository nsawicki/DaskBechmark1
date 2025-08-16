# Distributed Image Benchmark with Daft on AWS

This project demonstrates a basic distributed benchmark using Daft to process images across multiple AWS EC2 instances.
We use a simple operation — finding the mean pixel value per image — to highlight cluster setup, distributed execution, and performance benchmarking.

# Bootstrap Scripts

When AWS launching servers, run the appropriate script into User Data:

Head node: head_bootstrap.sh

Worker nodes: worker_bootstrap.sh (replace HEAD_NODE_PRIVATE_IP with the actual private IP of the head node)

Both scripts will:

Update and install system dependencies

Install Ray, Daft, and Pillow

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

Distribute the task of finding the mean pixel per image across the Ray cluster using Daft.

Report runtime statistics (load time, processing time, speedup).

⚠️ Notes

Uploading data to S3 is free, but storing it and downloading from S3 incurs costs.

t3.micro instances are very RAM-constrained. For smoother runs, start with t3.small or t3.medium.

If using S3, ensure your EC2 instances have IAM roles with S3 read permissions.

✅ With this setup, you now have a minimal but real distributed benchmark running on AWS.
