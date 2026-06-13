FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Download VS Code CLI
RUN curl -Lks 'https://code.visualstudio.com/sha/download?build=stable&os=cli-linux-x64' -o vscode_cli.tar.gz

# Extract the binary directly to /usr/local/bin
RUN tar -xzf vscode_cli.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/code && \
    rm vscode_cli.tar.gz

WORKDIR /workspace

# Start the tunnel (requires user license acceptance)
CMD ["code", "tunnel", "--accept-server-license-terms"]
