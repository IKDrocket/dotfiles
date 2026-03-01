#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Creating symlinks..."

link() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  mkdir -p "$dest_dir"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "    Backing up existing $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
  echo "    $dest -> $src"
}

link "$DOTFILES_DIR/zsh/.zshrc"             "$HOME/.zshrc"
link "$DOTFILES_DIR/git/.gitconfig"         "$HOME/.gitconfig"
link "$DOTFILES_DIR/vim/.vimrc"             "$HOME/.vimrc"
link "$DOTFILES_DIR/mise/config.toml"       "$HOME/.config/mise/config.toml"
link "$DOTFILES_DIR/ghostty/config"         "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/neovim/.config/nvim"   "$HOME/.config/nvim"

# VS Code 設定（macOS のパス）
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
link "$DOTFILES_DIR/vscode/settings.json"    "$VSCODE_USER_DIR/settings.json"
link "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

# Claude Code 設定
CLAUDE_DIR="$HOME/.claude"
link "$DOTFILES_DIR/claude/settings.json"  "$CLAUDE_DIR/settings.json"
link "$DOTFILES_DIR/claude/statusline.sh"  "$CLAUDE_DIR/statusline.sh"
chmod +x "$DOTFILES_DIR/claude/statusline.sh"
link "$DOTFILES_DIR/claude/CLAUDE.md"      "$CLAUDE_DIR/CLAUDE.md"
link "$DOTFILES_DIR/claude/commands"       "$CLAUDE_DIR/commands"
link "$DOTFILES_DIR/claude/skills"         "$CLAUDE_DIR/skills"
link "$DOTFILES_DIR/claude/agents"         "$CLAUDE_DIR/agents"

echo "==> Symlinks created."
