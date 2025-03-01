# Dockerfile

# Stage 1: Build
FROM node:22.14-alpine AS builder
WORKDIR /app
# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm install

# Copy the rest of the code and build the project
COPY . .
RUN npm run build

# Stage 2: Run
FROM node:22.14-alpine AS runner
WORKDIR /app
ENV NODE_ENV=${NODE_ENV}

# Copy only the necessary files from the builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Install production dependencies only
RUN npm install --omit=dev

EXPOSE 3000
CMD ["npm", "start"]