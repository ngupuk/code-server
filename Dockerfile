FROM ubuntu:latest

# Build-time arguments for user and hostname configuration
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install dependencies and build tools
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS (Iron) using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3.11 using deadsnakes PPA
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-venv python3.11-dev python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Create symlinks for convenience
RUN ln -sf /usr/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/bin/node /usr/local/bin/node

# Download VS Code CLI
RUN curl -fsSL 'https://update.code.visualstudio.com/latest/cli-linux-x64/stable' -o vscode_cli.tar.gz

# Extract the binary directly to /usr/local/bin
RUN tar -xzf vscode_cli.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/code && \
    rm vscode_cli.tar.gz

# Verify installations (run as root before switching user)
RUN node --version && npm --version && python --version && git --version

# Create non-root user FIRST, then setup directories
# Remove any existing user/group that conflicts with the desired UID/GID
# (ubuntu:latest ships with an 'ubuntu' user at UID/GID 1000)
RUN if getent passwd $USER_UID > /dev/null 2>&1; then userdel $(getent passwd $USER_UID | cut -d: -f1); fi && \
    if getent group $USER_GID > /dev/null 2>&1; then groupdel $(getent group $USER_GID | cut -d: -f1); fi && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup directories with proper permissions AFTER user creation
RUN mkdir -p /workspace && \
    chown -R $USERNAME:$USERNAME /workspace

# Switch to non-root user
USER $USERNAME

# Set working directory
WORKDIR /workspace

# Environment variables (can be overridden in docker-compose.yml)
ENV TUNNEL_NAME=vscode-tunnel

# Start the tunnel (requires user license acceptance)
CMD ["sh", "-c", "code tunnel --accept-server-license-terms --name ${TUNNEL_NAME}"]
