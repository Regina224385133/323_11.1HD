   # Dockerfile
   FROM node:20-alpine AS base
   
   # 安装依赖
   FROM base AS deps
   WORKDIR /app
   COPY package.json bun.lock ./
   RUN bun install
   
   # 构建应用
   FROM base AS builder
   WORKDIR /app
   COPY --from=deps /app/node_modules ./node_modules
   COPY . .
   RUN bun run build
   
   # 生产环境
   FROM base AS runner
   WORKDIR /app
   COPY --from=builder /app/.next ./.next
   COPY --from=builder /app/public ./public
   COPY --from=builder /app/package.json ./package.json
   
   EXPOSE 3000
   CMD ["bun", "start"]