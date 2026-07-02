#!/bin/bash
# Register user-scoped MCP servers for Claude Code.
# Run this script after setting up a new Mac:  ./claude/setup-mcp.sh

set -e

echo "Registering MCP servers..."

claude mcp add --scope user playwright mise x -- npx -y @playwright/mcp@latest
claude mcp add --scope user context7 mise x -- npx -y @upstash/context7-mcp
# claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server
claude mcp add --scope user chrome-devtools mise x -- npx -y chrome-devtools-mcp@latest

# claude mcp add notion --scope user --transport http https://mcp.notion.com/mcp
# claude mcp add figma --scope user --transport http https://mcp.figma.com/mcp
# claude mcp add atlassian --scope user --transport http https://mcp.atlassian.com/v1/mcp/authv2

echo "Done. Run 'claude mcp list' to verify."
