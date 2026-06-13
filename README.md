# VS Code Tunnel Server

VS Code Tunnel server that allows you to access your development environment from anywhere using Visual Studio Code.

## Features

- 🚀 VS Code CLI with Remote Tunnels support
- 🐳 Docker-based setup for easy deployment
- 🔄 Auto-restart on failure
- 📁 Workspace volume mounted for persistent code

## Quick Start

```bash
# Clone the repository
git clone https://github.com/ngupuk/code-server.git
cd code-server

# Build and start the container
docker-compose up --build -d

# View logs to get the tunnel URL
docker-compose logs -f
```

## Connect to Tunnel

Once the container is running, you'll see a tunnel URL in the logs. To connect from your local VS Code:

```bash
# Install VS Code CLI (if not already installed)
# Then connect to your tunnel
code tunnel jekyll
```

Or use the "Connect to Tunnel" feature in VS Code's Remote Explorer.

## Configuration

### Ports

- `8080` - Default port for VS Code tunnel connections

### Volumes

- `./workspace` - Mounted to `/workspace` in container for persistent development files

### Environment Variables (Optional)

You can add these to `docker-compose.yml`:

```yaml
environment:
  - GITHUB_TOKEN=your_token  # For GitHub Copilot integration
```

## Docker Image

You can also pull the pre-built image from GHCR:

```bash
docker pull ghcr.io/ngupuk/code-server:latest
docker run -d -p 8080:8080 ghcr.io/ngupuk/code-server:latest
```

## Development

To rebuild the image after making changes:

```bash
docker-compose build
docker-compose up -d
```

## Troubleshooting

### Container won't start

Check the logs:
```bash
docker-compose logs
```

### Can't connect to tunnel

1. Ensure port 8080 is accessible from your network
2. Check firewall rules
3. Verify the tunnel URL in the container logs

## License

This project uses VS Code CLI. By using this tunnel, you agree to the VS Code license terms.

## Links

- [VS Code Remote Tunnels Documentation](https://code.visualstudio.com/docs/remote/tunnels)
- [GitHub Container Registry](https://github.com/ngupuk/code-server/pkgs/container/code-server)

---

**Note:** This project was converted from code-server to VS Code Tunnel Server.
