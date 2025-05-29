# Multi-stage build to optimize the Docker image size and security
FROM node:22-bullseye-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production && npm cache clean --force

# Main application code
FROM node:22-bullseye-slim AS production

RUN addgroup -g 1001 -S nodejs && adduser -S nodeuser -u 1001

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules

COPY --chown=nodeuser:nodejs . .

RUN rm -rf docker/ terraform/ helm/ .git*

USER nodeuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f --max-time 2 http://localhost:3000/ping || exit 1

CMD ["node", "server.js"]