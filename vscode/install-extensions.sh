#!/usr/bin/env bash
# vscode/extensions.txt の拡張機能を一括インストールする。
#   ./vscode/install-extensions.sh
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v code &>/dev/null; then
  echo "error: VS Code CLI (code) がありません。code コマンドを有効にしてから再実行してください。" >&2
  exit 1
fi

echo "==> Installing VS Code extensions..."
xargs -L 1 code --install-extension < "$DOTFILES_DIR/vscode/extensions.txt"
