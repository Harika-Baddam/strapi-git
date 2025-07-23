provider "aws" {
  region = "us-east-2"
}
resource "aws_security_group" "strapi_sg" {

  name        = "strapi-sg"

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

    Name  = "Strapi_Instance"

    Owner = "ec2-user"

  }

}
 

resource "aws_instance" "strapi" {
  ami           = "ami-0cd582ee8a22cc7be" # Amazon Linux 2 AMI in us-east-2
  instance_type = "t3.medium"
  key_name      = "terraform-strapi"
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]

  user_data = <<-EOF
#!/bin/bash
###########
 
#This will log the script output.
LOGFILE="/var/log/strapi-deployment.log"
exec > >(tee -a "$LOGFILE") 2>&1
 
echo "Script started at $(date)"
 
########################################
 
#These commands will install and start docker.
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker
 
######################
 
#These commands will deploy the complete strapi setup.
docker network create strapi
docker volume create mysql_data

docker run -d --name mysql --network strapi -e MYSQL_DATABASE=strapi -e MYSQL_USER=strapi -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=password -v mysql_data:/var/lib/mysql mysql:8 
#Strapi
docker run -d --name strapi -e DATABASE_CLIENT=mysql -e DATABASE_HOST=mysql -e DATABASE_PORT=3306 -e DATABASE_NAME=strapi -e DATABASE_USERNAME=strapi -e DATABASE_PASSWORD=password -p 1337:1337 baddamharika/strapi-app:v2 
  EOF

  tags = {
    Name = "StrapiProdEC2"
  }
}