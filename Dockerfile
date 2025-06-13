FROM node:22-alpine AS builder
WORKDIR /app

COPY package*.json tsconfig*.json ./
RUN npm install --legacy-peer-deps --omit=dev

COPY . .

RUN npm run build

FROM node:22-alpine AS production
WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
RUN npm install --legacy-peer-deps --production

RUN rm -rf /app/node_modules/.cache /app/.git /app/test

EXPOSE 4000

CMD ["node", "dist/main.js"]