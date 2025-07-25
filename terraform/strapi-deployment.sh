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
docker volume create postgres_data
 
#PostgresDB
docker run -d --name postgres --network strapi -e POSTGRES_DB=strapi -e POSTGRES_USER=strapi -e POSTGRES_PASSWORD=password -v postgres_data:/var/lib/postgresql/data postgres:15
 
#Strapi
docker run -d --name strapi --network strapi -p 1337:1337 -e DATABASE_CLIENT=postgres -e DATABASE_HOST=postgres -e DATABASE_PORT=5432 -e DATABASE_NAME=strapi -e DATABASE_USERNAME=strapi -e DATABASE_PASSWORD=password  baddamharika/strapi-app:${image_tag}
 
 
# Configure the commands as needed :
 
# #PostgresDB
# POSTGRES_DB: strapi             #Enter Your DB Name - Default is "strapi"
# POSTGRES_USER: strapi           #Enter Your DB User - Default is "strapi"
# POSTGRES_PASSWORD: password     #Enter Your DB Password -Default is "password"
 
# #Strapi
# DATABASE_CLIENT: postgres       
# DATABASE_HOST: postgres         # Enter your DB host address (container name)
# DATABASE_PORT: 5432
# DATABASE_NAME: strapi           #Enter Your DB Name - Default is "strapi"
# DATABASE_USERNAME: strapi       #Enter Your DB User - Default is "strapi"
# DATABASE_PASSWORD: password     #Enter Your DB Password - Default is "password"
 