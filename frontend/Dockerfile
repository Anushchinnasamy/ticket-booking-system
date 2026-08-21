# Vite build baked with the gateway's public URL, then served as static
# files — VITE_API_BASE_URL is a build-time value (Vite inlines
# import.meta.env.* at build), so it must be passed as a build arg, not a
# runtime container env var.
FROM node:20-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
ARG VITE_API_BASE_URL=http://localhost:8080
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
