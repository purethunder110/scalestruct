# ---- Build Stage ----
FROM node:20-slim AS build

# Install git (needed only for build)
RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/p-stream/simple-proxy.git

WORKDIR /simple-proxy

# If your dependencies need git (e.g., "git+https://..."), git must be here
RUN npm install -g pnpm@latest-10

RUN pnpm i

# Build your app (if applicable, e.g. for Next.js, React, etc.)
RUN pnpm build

# ---- Runtime Stage ----
FROM node:20-slim AS runtime

RUN npm install -g pnpm@latest-10

WORKDIR /app

COPY --from=build /simple-proxy ./

# Start command
CMD ["pnpm", "start"]
