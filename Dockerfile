FROM node:14

WORKDIR /app

RUN apt-get update && \
    apt-get install -qq tini build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev python3 g++ make && \
    yarn global add node-gyp canvas@2.9.3 && \
    apt clean && rm -rf /var/lib/apt/lists/\*

# workspace の先の package.json と lock までほしいのでパフォーマンスは悪いが先に全部COPYする
COPY . .

RUN yarn install
RUN cp examples/discovery-search-app/.env examples/discovery-search-app/.env.local
# RUN yarn workspace discovery-search-app run build

EXPOSE 4000
#RUN yarn run server:setup
ENTRYPOINT ["tini", "--"]
CMD ["yarn", "workspace", "discovery-search-app", "run", "server"]
