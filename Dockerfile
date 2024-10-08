# Use the latest Crystal image
FROM crystallang/crystal:latest

# Set the working directory
WORKDIR /app

# Copy all project files to the container
COPY . .

# Set the environment for production
ENV MARTEN_ENV=production

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl cmake build-essential gnupg

# Install Node.js and PNPM
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g pnpm

# Install PNPM dependencies
RUN pnpm install --frozen-lockfile

# Build the Tailwind CSS and JavaScript assets
RUN pnpm run build

# Install Crystal dependencies
RUN shards install

# Collect assets (assumes you are using marten's collectassets command)
RUN --mount=type=secret,id=DATABASE__URL \
    --mount=type=secret,id=SELF__ALLOWED_HOSTS \
    --mount=type=secret,id=SELF__SECRET_KEY_BASE \
    DATABASE__URL=$(cat /run/secrets/DATABASE__URL) \
    SELF__ALLOWED_HOSTS=$(cat /run/secrets/SELF__ALLOWED_HOSTS) \
    SELF__SECRET_KEY_BASE=$(cat /run/secrets/SELF__SECRET_KEY_BASE) \
    bin/marten collectassets --no-input

# Compile the Crystal application
RUN crystal build manage.cr -o bin/manage
RUN crystal build src/server.cr -o bin/server --release

EXPOSE 3000

# Set the command to run your server
CMD ["/app/bin/server"]
