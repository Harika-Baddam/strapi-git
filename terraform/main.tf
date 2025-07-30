provider "aws" {
  region = "us-east-2"
}
 
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-shr"
  description = "Allows SSH and Strapi Access"
 
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name  = "Strapi_Instance(shr)"
    Owner = "shr"
  }
}
 
resource "aws_instance" "strapi" {
  ami                         = var.ami_id
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id] # I am using default VPC and Default Subnet
  key_name                    = var.ssh_key_name
 
  root_block_device {
    volume_size = 20
  }
 
  user_data = templatefile("./strapi-deployment.sh", {
    image_tag = var.image_tag
  })
 
  tags = {
    Name  = "Strapi_Instance(shr)"
    Owner = "shr"
  }
}
 
output "strapi_address" {
  value = "http://${aws_instance.strapi.public_ip}:1337/admin"
}
 
variable "aws_region" {
  description = "AWS Resources deployment region"
  type        = string
  default     = "us-east-2"
}
 
variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0eb9d6fc9fab44d24" #Amazon Linux 2023 AMI for us-east-2
}
 
variable "ssh_key_name" {
  description = "SSH key name"
  type        = string
  default     = "hrk-strapikey" #Create own keypair to have SSH access
}
 
variable "image_tag" {
  description = "Docker image tag" #Will be passed by Github Actions
  type        = string
}
 
 
