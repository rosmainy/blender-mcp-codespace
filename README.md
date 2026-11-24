# Blender MCP on GitHub Codespaces

Free 60 hours/month for personal accounts.

## Quick Start

1. **Push this folder to a new GitHub repo** (or fork an existing one)
2. **Open in Codespaces**: Click **Code → Codespaces → Create codespace on main**
3. **Wait for build** (~5-10 min first time)
4. **Start MCP server** in terminal:
   ```bash
   blender --background --python /usr/local/lib/python3.10/dist-packages/blender_mcp/server.py
   ```
5. **Forward port 3001** (Codespaces auto-prompts, or Ports tab → right-click 3001 → "Port Visibility: Public")
6. **Configure your local Claude Code** to connect to the forwarded URL

## Configure Claude Code (local machine)

Add to `~/.claude/mcp.json` (or via `claude mcp add`):

```json
{
  "mcpServers": {
    "blender": {
      "type": "http",
      "url": "https://<codespace-name>-3001.app.github.dev/mcp"
    }
  }
}
```

Replace `<codespace-name>` with your actual codespace URL (shown in Ports tab).

## Test

In Claude Code:
> Buat kubus merah berputar di Blender

## Notes

- **GPU**: Codespaces free tier = CPU only. Rendering will be slow.
- **Persistence**: `/home/vscode/.config/blender` is persisted in a Docker volume.
- **Timeout**: Codespaces stops after 30 min inactivity. Commit/push to save work.
- **Free tier**: 60 hours/month personal, 50 hours/month organization.

## Alternative: Use devcontainer locally

If you have Docker Desktop:
```bash
cd .devcontainer
docker compose up --build
```
Then connect to `http://localhost:3001/mcp`
