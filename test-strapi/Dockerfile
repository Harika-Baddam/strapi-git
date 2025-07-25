FROM node:22-alpine
 
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
 
# -------- ENV for database config --------
ENV DATABASE_CLIENT=mysql
ENV DATABASE_HOST=mysql
ENV DATABASE_PORT=3306
ENV DATABASE_NAME=strapi
ENV DATABASE_USERNAME=strapi
ENV DATABASE_PASSWORD=password
ENV DATABASE_SSL=false
 
#--------Copying Local App directory--------------
WORKDIR /strapi/
COPY . /strapi/
 
#--------Installing dependencies--------------
RUN npm install && npm install pg --save
 
EXPOSE 1337
 
CMD ["npm", "run", "develop"]
 