# syntax=docker/dockerfile:1

# base: common Node environment
FROM node:22-alpine AS base
WORKDIR /app


# deps: install node_modules (built for linux, inside the image)

FROM base AS deps
COPY package.json package-lock.json ./

RUN npm install --ignore-scripts --no-audit --no-fund

# dev: Nuxt dev server with HMR. Source is bind-mounted by docker-compose.
FROM base AS dev
ENV NODE_ENV=development \
    HOST=0.0.0.0 \
    PORT=3000 \
    # Reliable file watching for bind mounts on macOS/Windows
    CHOKIDAR_USEPOLLING=true \
    NUXT_TELEMETRY_DISABLED=1
COPY --from=deps /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "3000"]

# builder: produce the production build (.output)
FROM base AS builder
ENV NODE_ENV=production \
    NUXT_TELEMETRY_DISABLED=1
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# prod: minimal runtime serving the built Nuxt server
FROM node:22-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=3000
COPY --from=builder /app/.output ./.output
EXPOSE 3000
CMD ["node", ".output/server/index.mjs"]
