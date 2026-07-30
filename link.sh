#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_MIRROR="$DOTFILES_DIR/home"

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

# home/ 配下は $HOME のミラー。リポジトリ上の階層と配置先の階層が一致するので、
# home 相対パス1つだけで「どこに置かれるか」が自明になる（配置先は自動導出）。
link_home() {
  local rel="$1"
  link "$HOME_MIRROR/$rel" "$HOME/$rel"
}

# --- $HOME ミラー（home/ 配下 = ~ の実配置と同形）---
link_home ".zshrc"
link_home ".gitconfig"
link_home ".vimrc"
link_home ".config/mise/config.toml"
link_home ".config/starship.toml"
link_home ".config/nvim"
link_home ".config/zellij/config.kdl"
link_home ".claude/settings.json"
link_home ".claude/statusline.sh"
link_home ".claude/commands"
chmod +x "$HOME_MIRROR/.claude/statusline.sh"

# --- 例外1: 1つの実体を複数箇所へ別名で配る共有アセット（ミラーは1対1前提のため表現不可）---
# skills は Agent Skills 標準（SKILL.md）なので Claude Code / Codex から同じ実体を参照する。
link "$DOTFILES_DIR/shared/AGENTS.md"      "$HOME/.claude/CLAUDE.md"
link "$DOTFILES_DIR/shared/AGENTS.md"      "$HOME/.codex/AGENTS.md"
link "$DOTFILES_DIR/shared/skills"         "$HOME/.claude/skills"
link "$DOTFILES_DIR/shared/skills"         "$HOME/.agents/skills"

# --- 例外2: Library 配下のアプリ設定（空白入りの深いパスなのでミラーに載せない）---
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
link "$DOTFILES_DIR/vscode/settings.json"    "$VSCODE_USER_DIR/settings.json"
link "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
link "$DOTFILES_DIR/ghostty/config"          "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

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
