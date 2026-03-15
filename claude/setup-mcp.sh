#!/bin/bash
# Register user-scoped MCP servers for Claude Code.
# Run this script after setting up a new Mac:  ./claude/setup-mcp.sh

set -e

echo "Registering MCP servers..."

claude mcp add --scope user playwright -- npx @playwright/mcp@latest
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server
claude mcp add --scope user chrome-devtools -- npx -y @chrome-devtools/mcp@latest

echo "Done. Run 'claude mcp list' to verify."
