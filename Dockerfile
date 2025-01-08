
FROM node:22.12-alpine3.21 AS dev-deps
WORKDIR /app
COPY package.json package.json
RUN npm install --frozen-lockfile


FROM node:22.12-alpine3.21 AS builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN npm test
RUN npm run build

FROM node:22.12-alpine3.21 AS prod-deps
WORKDIR /app
COPY package.json package.json
RUN npm install --prod --frozen-lockfile


FROM node:22.12-alpine3.21 AS prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]









