FROM node:alpine
WORKDIR /home/cert-provider
COPY package*.json ./
RUN apk --no-cache add --virtual native-deps \
  g++ gcc libgcc libstdc++ linux-headers make python && \
  npm install node-gyp -g && \
  npm install --only=production && \
  apk del native-deps
COPY ./src ./src
EXPOSE 7059
CMD [ "npm", "start" ]
