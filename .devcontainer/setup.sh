#!/bin/bash
set -e

echo "🔧 Installing Blender and MCP for Blender..."

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    libgl1-mesa-glx \
    libxi6 \
    libxxf86vm1 \
    libxrender1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxfixes3 \
    libxcb1 \
    libx11-6 \
    xvfb

# Install Blender (headless)
BLENDER_VERSION="4.3.2"
wget -q "https://download.blender.org/release/Blender4.3/blender-${BLENDER_VERSION}-linux-x64.tar.xz" -O /tmp/blender.tar.xz
tar -xf /tmp/blender.tar.xz -C /opt
mv /opt/blender-${BLENDER_VERSION}-linux-x64 /opt/blender
ln -sf /opt/blender/blender /usr/local/bin/blender

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Install mcp-for-blender
uv pip install mcp-for-blender --system

# Install Blender addon
BLENDER_ADDON_DIR="/home/vscode/.config/blender/${BLENDER_VERSION}/scripts/addons"
mkdir -p "$BLENDER_ADDON_DIR"
cp "$(uv pip show -f mcp-for-blender | grep addon.py | head -1 | awk '{print $2}')" "$BLENDER_ADDON_DIR/mcp_for_blender.py" 2>/dev/null || \
    cp /usr/local/lib/python3.10/dist-packages/blender_mcp/addon.py "$BLENDER_ADDON_DIR/mcp_for_blender.py" 2>/dev/null || \
    find / -name "addon.py" -path "*blender_mcp*" 2>/dev/null | head -1 | xargs -I {} cp {} "$BLENDER_ADDON_DIR/mcp_for_blender.py"

# Enable addon
blender --background --python-expr "
import bpy
bpy.ops.preferences.addon_enable(module='mcp_for_blender')
bpy.ops.wm.save_userpref()
"

echo "✅ Blender MCP setup complete!"
echo "📝 To start MCP server: blender --background --python /usr/local/lib/python3.10/dist-packages/blender_mcp/server.py"
echo "🔗 Then forward port 3001 and configure your MCP client"
