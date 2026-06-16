# VS Code Tunnel Server

VS Code Tunnel server that allows you to access your development environment from anywhere using Visual Studio Code.

## Features

- 🚀 VS Code CLI with Remote Tunnels support
- 🐳 Docker-based setup for easy deployment
- 🔄 Auto-restart on failure
- 📁 Workspace volume mounted for persistent code
- 💾 Persistent VS Code settings and tunnel credentials across container restarts

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

## Docker Support

This container includes Docker CLI and docker-compose, allowing you to run Docker commands inside the development environment.

### Using Docker Inside the Container

The container is configured with access to the host machine's Docker daemon via socket mounting (`/var/run/docker.sock`). This means:

- ✅ You can run `docker` commands inside the container
- ✅ Containers built/run inside use the host's Docker daemon
- ✅ No Docker-in-Docker overhead or additional setup needed

### Example Usage

Once connected to your tunnel, you can run Docker commands:

```bash
# List running containers
docker ps

# Build an image
docker build -t my-image .

# Run a container
docker run -it my-image bash

# Use docker-compose
docker-compose up
```

### Permissions

The non-root user is automatically added to the `docker` group, allowing Docker commands to be run without `sudo`.

## Configuration

### Ports

- `8080` - Default port for VS Code tunnel connections

## Volumes

The docker-compose.yml includes three named volumes for data persistence:

- `vscode_data` - Mounted to `/home/vscode/.local/share/code-cli` - **Persists VS Code tunnel credentials and connection settings** (prevents needing to reconnect after restart)
- `vscode_config` - Mounted to `/home/vscode/.config/code-server` - **Persists VS Code extensions and user settings**
- `vscode_home` - Mounted to `/home/vscode` - **Persists shell history and other user data**
- `./workspace` - Mounted to `/workspace` - Contains your development files

### Why These Volumes?

When you restart a Docker container without volumes, all data inside the container is lost. This means:
- ❌ Without `vscode_data` volume: You'd need to reconnect to the tunnel again after each restart
- ❌ Without `vscode_config` volume: Your VS Code extensions and settings would be lost
- ✅ With these volumes: Everything persists across container restarts

### Managing Volumes

List all volumes:
```bash
docker volume ls | grep vscode
```

Remove all VS Code volumes (be careful - this deletes saved data):
```bash
docker-compose down -v
```

Clean up unused volumes:
```bash
docker volume prune
```

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

### Need to reconnect to tunnel after restart?

This indicates the volumes are not properly persisting data. To fix:

1. **First run**: When you start the container for the first time, follow the tunnel setup instructions in the logs
2. **Restart**: Subsequent restarts should NOT require reconnection because volumes persist the credentials
3. **If still reconnecting**: Check that volumes are properly created:
   ```bash
   docker volume ls | grep vscode
   ```

### Delete tunnel credentials and start fresh

If you need to reset the tunnel connection:

```bash
# Stop the container
docker-compose down

# Remove specific volumes
docker volume rm $(docker volume ls -q | grep vscode_data)

# Start fresh
docker-compose up -d
```

## License

This project uses VS Code CLI. By using this tunnel, you agree to the VS Code license terms.

## Links

- [VS Code Remote Tunnels Documentation](https://code.visualstudio.com/docs/remote/tunnels)
- [GitHub Container Registry](https://github.com/ngupuk/code-server/pkgs/container/code-server)

---

**Note:** This project was converted from code-server to VS Code Tunnel Server.
