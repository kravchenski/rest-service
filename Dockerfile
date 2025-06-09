# Use a lightweight Node.js image
FROM node:22-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json tsconfig*.json ./
RUN npm install --legacy-peer-deps --omit=dev

# Copy the rest of the application files
COPY . .

# Build the application
RUN npm run build

# Use a separate stage for production
FROM node:22-alpine AS production
WORKDIR /app

# Copy built files and production dependencies from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
RUN npm install --legacy-peer-deps --production

# Expose the application port
EXPOSE 4000

# Start the application
CMD ["node", "dist/main.js"]