FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

# Download and extract the VS Code CLI for Linux x64
RUN curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-linux-x64' --output vscode_cli.tar.gz \
    && tar -xf vscode_cli.tar.gz -C /usr/local/bin \
    && rm vscode_cli.tar.gz

WORKDIR /workspace

# Start the tunnel (requires user license acceptance)
CMD ["code", "tunnel", "--accept-server-license-terms"]
