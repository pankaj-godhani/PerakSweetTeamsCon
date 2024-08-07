FROM node:14 AS BUILD_IMAGE

RUN curl -sfL https://gobinaries.com/tj/node-prune | bash -s -- -b /usr/local/bin

WORKDIR /app

COPY . /app/

# install
RUN npm install

# build
RUN npm run build

# remove development dependencies
RUN npm prune --production

# run node prune
RUN /usr/local/bin/node-prune

FROM node:14-alpine

WORKDIR /app

# copy from build image
COPY --from=BUILD_IMAGE /app/dist ./dist
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules

ENV DEBUG msteams

EXPOSE 80

CMD [ "node", "dist/server.js" ]
