#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Creating symlinks..."

LINKED_DESTS=()

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
  LINKED_DESTS+=("$dest")
}

link "$DOTFILES_DIR/zsh/.zshrc"             "$HOME/.zshrc"
link "$DOTFILES_DIR/git/.gitconfig"         "$HOME/.gitconfig"
link "$DOTFILES_DIR/vim/.vimrc"             "$HOME/.vimrc"
link "$DOTFILES_DIR/mise/config.toml"       "$HOME/.config/mise/config.toml"
link "$DOTFILES_DIR/ghostty/config"         "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/neovim/.config/nvim"   "$HOME/.config/nvim"
link "$DOTFILES_DIR/zellij/config.kdl"    "$HOME/.config/zellij/config.kdl"

# VS Code 設定（macOS のパス）
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
link "$DOTFILES_DIR/vscode/settings.json"    "$VSCODE_USER_DIR/settings.json"
link "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

# 共通 AI エージェント資産（Claude Code / Codex で共有）
# skills は Agent Skills 標準（SKILL.md）なので両ツールから同じ実体を参照する
link "$DOTFILES_DIR/shared/AGENTS.md"      "$HOME/.claude/CLAUDE.md"
link "$DOTFILES_DIR/shared/AGENTS.md"      "$HOME/.codex/AGENTS.md"
link "$DOTFILES_DIR/shared/skills"         "$HOME/.claude/skills"
link "$DOTFILES_DIR/shared/skills"         "$HOME/.agents/skills"

# Claude Code 固有設定
CLAUDE_DIR="$HOME/.claude"
link "$DOTFILES_DIR/claude/settings.json"  "$CLAUDE_DIR/settings.json"
link "$DOTFILES_DIR/claude/statusline.sh"  "$CLAUDE_DIR/statusline.sh"
chmod +x "$DOTFILES_DIR/claude/statusline.sh"
link "$DOTFILES_DIR/claude/commands"       "$CLAUDE_DIR/commands"

echo "==> Symlinks created."

echo "==> Removing links no longer managed by link.sh..."

is_linked_dest() {
  local needle="$1"
  local item
  for item in "${LINKED_DESTS[@]}"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

# link() で作成しうる場所だけを走査し、$DOTFILES_DIR を指すが
# 今回のリンク一覧に含まれなくなったシンボリックリンク（リンク元の削除・
# リンク先の変更などで不要になったもの）を削除する。
SCAN_DIRS=(
  "$HOME"
  "$HOME/.config"
  "$HOME/.config/mise"
  "$HOME/.config/zellij"
  "$HOME/Library/Application Support/com.mitchellh.ghostty"
  "$VSCODE_USER_DIR"
  "$HOME/.claude"
  "$HOME/.codex"
  "$HOME/.agents"
)

for dir in "${SCAN_DIRS[@]}"; do
  [[ -d "$dir" ]] || continue
  while IFS= read -r -d '' link_path; do
    target="$(readlink "$link_path")"
    [[ "$target" == "$DOTFILES_DIR"/* ]] || continue
    if ! is_linked_dest "$link_path"; then
      echo "    Removing stale link: $link_path -> $target"
      rm "$link_path"
    fi
  done < <(find "$dir" -maxdepth 1 -type l -print0)
done

echo "==> Done."
