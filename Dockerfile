# Use the latest Crystal image for building the app
FROM crystallang/crystal:latest AS build

# Set the working directory
WORKDIR /app

# Copy only the necessary files for installing dependencies first (caching)
COPY shard.yml shard.lock ./

# Install Crystal dependencies
RUN shards install

# Copy the rest of the application source
COPY . .

# Install system dependencies for Crystal and build tools
RUN apt-get update && \
    apt-get install -y curl cmake build-essential gnupg

# Install Node.js and PNPM (using curl silently for cleaner logs)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g pnpm

# Install PNPM dependencies
RUN pnpm install --frozen-lockfile

# Build frontend assets like Tailwind CSS and JavaScript
RUN pnpm run build

# Collect assets (using Docker secrets for sensitive data)
RUN --mount=type=secret,id=DATABASE__URL \
    --mount=type=secret,id=SELF__ALLOWED_HOSTS \
    --mount=type=secret,id=SELF__SECRET_KEY_BASE \
    DATABASE__URL=$(cat /run/secrets/DATABASE__URL) \
    SELF__ALLOWED_HOSTS=$(cat /run/secrets/SELF__ALLOWED_HOSTS) \
    SELF__SECRET_KEY_BASE=$(cat /run/secrets/SELF__SECRET_KEY_BASE) \
    bin/marten collectassets --no-input

# Compile the Crystal application (release mode for production)
RUN crystal build src/server.cr -o bin/server --release

# Use a minimal Ubuntu 24.04 image for the final runtime (amd64 architecture)
FROM --platform=linux/amd64 ubuntu:24.04 AS production

# Install only the minimal dependencies for running Crystal apps
RUN apt-get update && \
    apt-get install -y libpcre3-dev libevent-dev libssl-dev zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the compiled binary from the build stage
COPY --from=build /app/bin/server /app/bin/server

# Set the environment to production
ENV MARTEN_ENV=production

# Expose the application port
EXPOSE 3000

# Command to run the Crystal server binary
CMD ["/app/bin/server"]
