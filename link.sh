#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_MIRROR="$DOTFILES_DIR/home"

# デフォルトは dry-run（削除・退避・リンク作成を一切行わず「何をするか」だけ表示）。
# 実際に反映するには --apply を渡す。削除対象を事前確認してから反映できる。
#   ./link.sh            # dry-run: 実行予定の操作を表示するだけ（デフォルト）
#   ./link.sh --apply    # 実際にリンクを作成・削除する
case "${1:-}" in
  --apply|-a)      DRY_RUN=0 ;;
  ""|--dry-run|-n) DRY_RUN=1 ;;
  *) echo "Usage: ${BASH_SOURCE[0]} [--apply|--dry-run]" >&2; exit 1 ;;
esac

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "      [dry-run] $*"
  else
    "$@"
  fi
}

if [[ "$DRY_RUN" == "1" ]]; then
  echo "==> [DRY-RUN] 実際の変更は行いません。反映するには: ./link.sh --apply"
fi

echo "==> Creating symlinks..."

LINKED_DESTS=()

link() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  run mkdir -p "$dest_dir"

  # 既存リンクは有効/壊れ問わず先に除去してから貼り直す。
  # ln -sf は dest がディレクトリを指すリンクだとその中に入れ子リンクを
  # 作ってしまう（BSD/macOS ln の仕様）ため、rm で明示的に消してから ln -s する。
  if [[ -L "$dest" ]]; then
    local cur
    cur="$(readlink "$dest")"
    if [[ "$cur" == "$src" ]]; then
      echo "    OK (既に正しいリンク): $dest -> $src"
      LINKED_DESTS+=("$dest")
      return
    fi
    echo "    既存リンクを削除して差し替え: $dest (現在 -> $cur)"
    run rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    echo "    実ファイルを退避: $dest -> ${dest}.bak"
    run mv "$dest" "${dest}.bak"
  fi

  run ln -s "$src" "$dest"
  echo "    リンク作成: $dest -> $src"
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
      echo "    管理外の stale リンクを削除: $link_path -> $target"
      run rm "$link_path"
    fi
  done < <(find "$dir" -maxdepth 1 -type l -print0)
done

echo "==> Done."
