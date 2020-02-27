FROM node:12-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install --only=production
ENV PORT 3002
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . ./
CMD [ "npm", "start" ]