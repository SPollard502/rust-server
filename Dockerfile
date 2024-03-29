FROM didstopia/base:nodejs-12-steamcmd-ubuntu-18.04

LABEL maintainer="Whisper <ogwhisper@gmail.com>"

# Fix apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        expect \
        tcl \
	libsdl2-2.0-0:i386 \
        libgdiplus && \
    rm -rf /var/lib/apt/lists/*

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy the Rust startup script
ADD start_rust.sh /app/start.sh

# Copy the Rust update check script
ADD update_check.sh /app/update_check.sh

# Set the current working directory
WORKDIR /

# Fix permissions
RUN chown -R 1000:1000 \
    /steamcmd \
    /app

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 28015
EXPOSE 28016
EXPOSE 28017
EXPOSE 28018
EXPOSE 28082

# Setup default environment variables for the server
ENV RUST_SERVER_STARTUP_ARGUMENTS "-batchmode -load -nographics"
ENV RUST_SERVER_IDENTITY "rust-server"
ENV RUST_SERVER_PORT "28015"
ENV RUST_SERVER_SEED "123"
ENV RUST_SERVER_NAME ""
ENV RUST_SERVER_DESCRIPTION "This is a brand spanking new Server"
ENV RUST_SERVER_URL ""
ENV RUST_SERVER_BANNER_URL ""
ENV RUST_SERVER_LEVEL_URL ""
ENV RUST_QUERY_PORT "28016"
ENV RUST_RCON_WEB "1"
ENV RUST_RCON_PORT "28017"
ENV RUST_RCON_PASSWORD "docker"
ENV RUST_APP_PORT "28018"
ENV RUST_UPDATE_CHECKING "0"
ENV RUST_UPDATE_BRANCH "public"
ENV RUST_START_MODE "0"
ENV RUST_OXIDE_ENABLED "0"
ENV RUST_OXIDE_UPDATE_ON_BOOT "1"
ENV RUST_SERVER_WORLDSIZE "4250"
ENV RUST_SERVER_MAXPLAYERS "500"
ENV RUST_SERVER_SAVE_INTERVAL "120"
ENV RUST_SERVER_EAC "1"

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

# Expose the volumes
# VOLUME [ "/steamcmd/rust" ]

# Start the server
CMD [ "bash", "/app/start.sh"]
