FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
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
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Blender
ARG BLENDER_VERSION=4.3.2
RUN wget -q "https://download.blender.org/release/Blender4.3/blender-${BLENDER_VERSION}-linux-x64.tar.xz" -O /tmp/blender.tar.xz \
    && tar -xf /tmp/blender.tar.xz -C /opt \
    && mv /opt/blender-${BLENDER_VERSION}-linux-x64 /opt/blender \
    && ln -sf /opt/blender/blender /usr/local/bin/blender \
    && rm /tmp/blender.tar.xz

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# Install mcp-for-blender
RUN uv pip install mcp-for-blender --system

# Install Blender addon
RUN BLENDER_ADDON_DIR="/root/.config/blender/${BLENDER_VERSION}/scripts/addons" && \
    mkdir -p "$BLENDER_ADDON_DIR" && \
    cp /usr/local/lib/python3.10/dist-packages/blender_mcp/addon.py "$BLENDER_ADDON_DIR/mcp_for_blender.py" && \
    blender --background --python-expr "import bpy; bpy.ops.preferences.addon_enable(module='mcp_for_blender'); bpy.ops.wm.save_userpref()"

# Expose MCP port
EXPOSE 3001

# Start MCP server on container start
CMD ["blender", "--background", "--python", "/usr/local/lib/python3.10/dist-packages/blender_mcp/server.py"]
