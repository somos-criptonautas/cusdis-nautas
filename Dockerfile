# ---- Builder ----
FROM node:18-alpine3.18 AS builder

# Install dependencies
RUN apk add --no-cache openssl openssl1.1-compat python3 py3-pip make gcc g++

# Set build-time arguments
ARG DB_TYPE=sqlite
ENV DB_TYPE=$DB_TYPE
ENV DB_URL=file:/data/cusdis.db

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Install and build
RUN npm install -g pnpm@8
RUN pnpm install
RUN npm run build

# ---- Runner ----
FROM node:18-alpine3.18 AS runner

# Set environment variables
ENV NODE_ENV=production
ARG DB_TYPE=sqlite
ENV DB_TYPE=$DB_TYPE
ENV DB_URL=file:/data/cusdis.db

# Set working directory
WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Create data directory and set permissions
RUN mkdir -p /data && chown -R node:node /data

# Install OpenSSL 1.1 for Prisma
RUN apk add --no-cache openssl1.1-compat

# Expose port
EXPOSE 3000/tcp

# Run as non-root user
USER node

# Start the application
CMD ["npm", "run", "start"]
