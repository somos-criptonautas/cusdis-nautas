FROM node:18-alpine as builder

VOLUME [ "/data" ]

ARG DB_TYPE=sqlite
ENV DB_TYPE=$DB_TYPE

RUN apk add --no-cache python3 py3-pip make gcc g++ openssl

COPY . /app

COPY package.json yarn.lock /app/

WORKDIR /app

RUN npm install -g pnpm
RUN yarn install --frozen-lockfile
RUN npm run build:without-migrate

FROM node:18-alpine as runner

ENV NODE_ENV=production
ARG DB_TYPE=sqlite
ENV DB_TYPE=$DB_TYPE
ENV DB_URL=file:/data/cusdis.db

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY . /app

RUN mkdir -p /data && chown -R node:node /data
RUN chown -R node:node /app

EXPOSE 3000/tcp

USER node

CMD ["npm", "run", "start:with-migrate"]
