# Stage 1: Build Stage
FROM elixir:1.17-alpine AS build

# Install build dependencies (CentOS-based)
RUN apk add --update --no-cache build-base inotify-tools gcc && apk upgrade

# Set environment variables
ENV MIX_ENV=prod

# Set working directory
WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./


# Install dependencies
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Copy the rest of the application code
COPY . .

# Clean previous builds
RUN mix clean

# Compile the application
RUN mix compile

# Build the release
RUN mix release

# Stage 2: Runtime Image (CentOS-Based)
FROM alpine:latest

# Install runtime dependencies
RUN apk add --update libstdc++ openssl ncurses-libs

# Set environment variables
ENV MIX_ENV=prod

# Set working directory
WORKDIR /app

# Copy the release from the build stage
COPY --from=build /app/_build/prod/rel/flame_test ./

# Ensure all binaries are executable
RUN chmod +x /app/bin/flame_test



# Expose the application port
EXPOSE 4099

# Set the entrypoint to the release start script
CMD ["./bin/flame_test", "start"]

