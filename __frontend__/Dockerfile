# pull official base image
FROM node:13.12.0-alpine

# set working directory
WORKDIR /app

# add app
COPY . ./

RUN npm install --global http-server

# start app
CMD ["http-server", "./build", "-p", "3000", "--proxy", "http://localhost:3000?"]
