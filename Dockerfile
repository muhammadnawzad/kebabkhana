# Use the latest Crystal image
FROM crystallang/crystal:1.13

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
RUN --mount=type=secret,id=KEBABKHANA__DATABASE__URL \
    --mount=type=secret,id=KEBABKHANA__SELF__ALLOWED_HOSTS \
    --mount=type=secret,id=KEBABKHANA__SELF__SECRET_KEY_BASE \
    --mount=type=secret,id=KEBABKHANA__RESEND__API_KEY \
    --mount=type=secret,id=KEBABKHANA__OTP__BASE_URL \
    --mount=type=secret,id=KEBABKHANA__OTP__API_KEY \
    --mount=type=secret,id=KEBABKHANA__OTP__SERVICE_ID \
    KEBABKHANA__DATABASE__URL=$(cat /run/secrets/KEBABKHANA__DATABASE__URL) \
    KEBABKHANA__SELF__ALLOWED_HOSTS=$(cat /run/secrets/KEBABKHANA__SELF__ALLOWED_HOSTS) \
    KEBABKHANA__SELF__SECRET_KEY_BASE=$(cat /run/secrets/KEBABKHANA__SELF__SECRET_KEY_BASE) \
    KEBABKHANA__RESEND__API_KEY=$(cat /run/secrets/KEBABKHANA__RESEND__API_KEY) \
    KEBABKHANA__OTP__BASE_URL=$(cat /run/secrets/KEBABKHANA__OTP__BASE_URL) \
    KEBABKHANA__OTP__API_KEY=$(cat /run/secrets/KEBABKHANA__OTP__API_KEY) \
    KEBABKHANA__OTP__SERVICE_ID=$(cat /run/secrets/KEBABKHANA__OTP__SERVICE_ID) \
    bin/marten collectassets --no-input

# Compile the Crystal application
RUN crystal build manage.cr -o bin/manage
RUN crystal build src/server.cr -o bin/server --release

EXPOSE 3000

# Set the command to run your server
CMD ["/app/bin/server"]
