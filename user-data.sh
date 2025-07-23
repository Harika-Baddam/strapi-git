#!/bin/bash
# Update and install Docker
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install AWS CLI v2 (if not already available)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Authenticate with ECR
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 607700977843.dkr.ecr.us-east-2.amazonaws.com

# Pull and run Strapi container
docker pull 607700977843.dkr.ecr.us-east-2.amazonaws.com/strapi-app:latest
docker run -d -p 80:1337 --name strapi 607700977843.dkr.ecr.us-east-2.amazonaws.com/strapi-app:latest