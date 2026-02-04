# 基础镜像
FROM node:20-alpine AS base
RUN apk add --no-cache libc6-compat python3 make g++
WORKDIR /app

# 依赖安装阶段
FROM base AS deps
COPY package.json yarn.lock ./
COPY apps/agents/package.json ./apps/agents/
COPY apps/web/package.json ./apps/web/
COPY packages ./packages
RUN yarn install --frozen-lockfile

# 构建阶段
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

# Agents 服务镜像
FROM base AS agents
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/agents ./apps/agents
COPY --from=builder /app/packages ./packages
COPY --from=builder /app/package.json ./
COPY --from=builder /app/langgraph.json ./
WORKDIR /app/apps/agents
EXPOSE 54367
CMD ["yarn", "dev"]

# Web 服务镜像
FROM base AS web
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/web ./apps/web
COPY --from=builder /app/packages ./packages
COPY --from=builder /app/package.json ./
WORKDIR /app/apps/web
EXPOSE 3000
ENV NODE_ENV=production
CMD ["yarn", "start"]