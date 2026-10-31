# syntax=docker/dockerfile:1

ARG NODE_VERSION=26.13.0

# 依存パッケージをインストールする
FROM node:${NODE_VERSION}-slim AS deps
COPY --from=ghcr.io/pnpm/pnpm:12 /opt/pnpm /opt/pnpm
ENV PATH="/opt/pnpm:$PATH"
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,id=pnpm,target=/var/cache/pnpm \
    pnpm install --frozen-lockfile --store-dir /var/cache/pnpm

# ビルドする
FROM deps AS builder
COPY . .
RUN pnpm build

# 実行する（standalone の成果物だけを持ってくる）
FROM node:${NODE_VERSION}-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
COPY --from=builder --chown=node:node /app/.next/standalone ./
COPY --from=builder --chown=node:node /app/.next/static ./.next/static
USER node
EXPOSE 3000
CMD ["node", "server.js"]
