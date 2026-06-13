FROM ubuntu:latest

# Install dependencies and build tools
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    software-properties-common \
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

# Verify installations
RUN node --version && npm --version && python --version && git --version

WORKDIR /workspace

# Start the tunnel (requires user license acceptance)
CMD ["code", "tunnel", "--accept-server-license-terms"]
