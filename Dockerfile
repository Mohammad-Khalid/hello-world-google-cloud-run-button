FROM debian:jessie-slim

RUN apt-get update && \
apt-get install -y ca-certificates && \
rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0C49F3730359A14518585931BC711F9BA15703C6 && \
gpg --export $GPG_KEYS > /etc/apt/trusted.gpg.d/mongodb.gpg

ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org
ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}
ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.18

RUN echo "deb http://$MONGO_REPO/apt/debian jessie/${MONGO_PACKAGE%-unstable}/$MONGO_MAJOR main" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list"

RUN echo "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list"

RUN apt-get update

RUN apt-get install -y ${MONGO_PACKAGE}=$MONGO_VERSION

VOLUME ["/data/db"]

RUN apt-get update

RUN apt-get install -y curl
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN mkdir -p /usr/src/app

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install --only=production
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . ./
CMD [ "npm", "start" ]