# ---- Build stage ----
FROM node:20-alpine AS build
WORKDIR /app

# Install deps first (better caching)
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Build production assets
RUN npm run build


# ---- Run stage (static hosting) ----
FROM nginx:alpine

# If your build output folder is "dist" (Vite default), this is correct
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: custom nginx config for SPA routing
# (Uncomment the next two lines if you add nginx.conf below)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
