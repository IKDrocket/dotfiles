# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

新しい Mac での開発環境を素早く再現するための dotfiles リポジトリ。シンボリックリンクで設定ファイルを管理し、`install.sh` が唯一のエントリポイント。

## Setup

```bash
# 新規 Mac セットアップ（全工程）
./install.sh

# シンボリックリンクのみ再作成（dotfiles メンテナンス時）
./link.sh
```

このスクリプトは以下を順番に実行する:

1. Xcode CLI ツールと Rosetta（Apple Silicon）のインストール
2. Homebrew と `Brewfile` 記載のパッケージを一括インストール
3. `mise` で開発ランタイムをインストール
4. リポジトリ内のファイルをシンボリックリンクで配置
5. `vscode/extensions.txt` から VS Code 拡張機能を一括インストール

## Architecture

各ツールの設定はサブディレクトリに置き、`install.sh` がシンボリックリンクを張る構成:

| Source | Symlink target |
|---|---|
| `zsh/.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig` |
| `mise/config.toml` | `~/.config/mise/config.toml` |
| `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `vim/.vimrc` | `~/.vimrc` |
| `zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| `neovim/.config/nvim` | `~/.config/nvim` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/commands/` | `~/.claude/commands/` |
| `claude/skills/` | `~/.claude/skills/` |
| `claude/agents/` | `~/.claude/agents/` |

## Key Files

- **`Brewfile`** — Homebrew パッケージ・cask の一覧。新しいツールはここに追加する。
- **`mise/config.toml`** — ランタイムバージョン管理（Node 24 / Python 3.13 / Go 1 / AWS CLI 2.22.12）。
- **`neovim/.config/nvim/`** — lazy.nvim を使った Neovim 設定。エントリポイントは `init.lua`、プラグインは `lua/plugins/init.lua`、オプションは `lua/options.lua`、キーマップは `lua/keymaps.lua`。
- **`claude/`** — Claude Code グローバル設定（設定・スラッシュコマンド・スキル・エージェント）。

## Neovim Plugin Stack

- **Plugin manager**: lazy.nvim（自動ブートストラップ）
- **LSP**: mason.nvim + mason-lspconfig + nvim-lspconfig
- **Completion**: nvim-cmp（ソース: copilot-cmp・cmp-nvim-lsp）
- **AI**: GitHub Copilot（copilot.lua）— Tab で確定、C-] で却下
- **Fuzzy find**: Telescope
- **Syntax**: Treesitter（lua / python / go / typescript / javascript / json / yaml / markdown）
- **Theme**: Catppuccin

## Verifying Symlinks

```bash
ls -la ~ | grep '\->'
ls -la ~/.config/mise/
ls -la ~/Library/Application\ Support/Code/User/
```

## Adding a New Dotfile

1. 対応するサブディレクトリに設定ファイルを配置する
2. `link.sh` に `link` 呼び出しを追加する
3. `README.md` のシンボリックリンク一覧を更新する
