#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Starting dotfiles setup from: $DOTFILES_DIR"

# ──────────────────────────────────────────
# 1. Xcode Command Line Tools のインストール
# ──────────────────────────────────────────
xcode-select -p &>/dev/null || {
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
}

# ──────────────────────────────────────────
# 2. Rosetta のインストール（Apple Silicon 向け）
# ──────────────────────────────────────────
# Intel 製アプリの互換実行が不要な場合はコメントアウト
if [[ "$(uname -m)" == "arm64" ]] && ! pgrep -q oahd; then
  echo "==> Installing Rosetta..."
  softwareupdate --install-rosetta --agree-to-license
fi

# ──────────────────────────────────────────
# 3. Homebrew のインストール
# ──────────────────────────────────────────
command -v brew &>/dev/null || {
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ "$(uname -m)" == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
}

# ──────────────────────────────────────────
# 4. brew bundle でパッケージ一括インストール
# ──────────────────────────────────────────
echo "==> Updating Homebrew..."
brew update

echo "==> Installing packages from Brewfile..."
brew bundle install --file="$DOTFILES_DIR/Brewfile" || echo "==> Some packages failed (may already be installed). Continuing..."

echo "==> Cleaning up Homebrew cache..."
brew cleanup

# ──────────────────────────────────────────
# 5. mise でツールのインストール
# ──────────────────────────────────────────
if command -v mise &>/dev/null; then
  echo "==> Installing tools via mise..."
  mise install --config "$DOTFILES_DIR/mise/config.toml"
else
  echo "==> mise not found. Skipping tool installation. Install mise and re-run."
fi

# ──────────────────────────────────────────
# 6. シンボリックリンクの作成
# ──────────────────────────────────────────
bash "$DOTFILES_DIR/link.sh" --apply

# ──────────────────────────────────────────
# 7. Claude Code MCP サーバーの登録
# ──────────────────────────────────────────
if command -v claude &>/dev/null; then
  echo "==> Registering Claude Code MCP servers..."
  bash "$DOTFILES_DIR/claude/setup-mcp.sh"
else
  echo "==> Claude Code not found. Skipping MCP server registration."
fi

# ──────────────────────────────────────────
# 8. 外部 Claude Code スキルの取得
# ──────────────────────────────────────────
bash "$DOTFILES_DIR/claude/sync-skills.sh" || echo "==> Skipping external skills."

# ──────────────────────────────────────────
# 9. VS Code 拡張機能の一括インストール
# ──────────────────────────────────────────
if command -v code &>/dev/null; then
  echo "==> Installing VS Code extensions..."
  xargs -L 1 code --install-extension < "$DOTFILES_DIR/vscode/extensions.txt"
else
  echo "==> VS Code CLI (code) not found. Skipping extension installation."
fi

echo ""
echo "==> Setup complete! Reloading shell..."
exec $SHELL -l
