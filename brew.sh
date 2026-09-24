#!/usr/bin/env bash
# Homebrew パッケージの更新。共通 Brewfile と、引数の環境用 Brewfile を入れる。
#   ./brew.sh private
#   ./brew.sh work
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${1:-}" in
  private|work) ENV_NAME="$1" ;;
  *)
    echo "Usage: $0 private|work" >&2
    exit 1
    ;;
esac

if ! command -v brew &>/dev/null; then
  echo "error: brew がありません。先に Homebrew を入れてください。" >&2
  exit 1
fi

echo "==> Updating Homebrew..."
brew update

echo "==> Installing packages from Brewfile..."
brew bundle install --file="$DOTFILES_DIR/Brewfile" || echo "==> Some packages failed (may already be installed). Continuing..."

echo "==> Installing packages from Brewfile.$ENV_NAME..."
brew bundle install --file="$DOTFILES_DIR/Brewfile.$ENV_NAME" || echo "==> Some packages in Brewfile.$ENV_NAME failed. Continuing..."

echo "==> Cleaning up Homebrew cache..."
brew cleanup
