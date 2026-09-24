# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
Think in English, interact with the user in Japanese.

## Overview

新しい Mac での開発環境を素早く再現するための dotfiles リポジトリ。シンボリックリンクで設定ファイルを管理し、全工程の入口は `setup.sh`。再実行したい工程は単体スクリプトに切り出してある。

## Setup

```bash
# 新規 Mac セットアップ（全工程）
# 先に見本をコピーする。無いと setup.sh はエラーで止まる。
# 引数は private か work。zsh の選択は .zshrc.local の source。
cp home/.zshrc.local.sample home/.zshrc.local
cp home/.gitconfig.sample home/.gitconfig
./setup.sh private

# シンボリックリンクのみ再作成（dotfiles メンテナンス時）
./link.sh           # デフォルトは dry-run（実行予定の操作を表示するだけ）
./link.sh --apply   # 実際に反映する

# 一部だけ再実行
./brew.sh private                  # Brewfile（引数は private か work）
./claude/setup-mcp.sh
./claude/sync-skills.sh
./vscode/install-extensions.sh
```

`link.sh` はデフォルトで dry-run。削除・退避・リンク作成の予定を表示するだけで何も変更しない。実際に反映するには `--apply` を渡す（`setup.sh` は `--apply` 付きで呼ぶ）。

このスクリプトは以下を順番に実行する:

1. Xcode CLI ツールと Rosetta（Apple Silicon）のインストール
2. Homebrew と `Brewfile`（共通）に加え、引数 `private` または `work` に対応する Brewfile をインストール
3. `mise` で開発ランタイムをインストール
4. リポジトリ内のファイルをシンボリックリンクで配置
5. `vscode/extensions.txt` から VS Code 拡張機能を一括インストール

## Architecture

`setup.sh` が `link.sh` を呼び、リポジトリ内のファイルを `$HOME` にシンボリックリンクで配置する構成。設定の大多数は `home/`（`$HOME` のミラー）に置き、リポジトリ上の階層がそのまま配置先になる（`home/.config/nvim` → `~/.config/nvim`）。`link.sh` の `link_home` は home 相対パス 1 つから配置先を自動導出する。ミラーで表現できない 2 種類は例外として明示的に `link` する:

- **1 実体 → 複数箇所のファンアウト**: `shared/`（`AGENTS.md`・`skills/`）
- **Library 配下の特殊パス**: `vscode/`・`ghostty/`

| Source | Symlink target |
|---|---|
| `home/.zshrc` | `~/.zshrc` |
| `home/.zshrc.local` | `~/.zshrc.local`（gitignore） |
| `home/.zshrc.local.sample` | `~/.zshrc.local.sample` |
| `home/.config/zsh/private.zsh` | `~/.config/zsh/private.zsh` |
| `home/.config/zsh/work.zsh` | `~/.config/zsh/work.zsh` |
| `home/.gitconfig` | `~/.gitconfig`（gitignore） |
| `home/.gitconfig.sample` | `~/.gitconfig.sample` |
| `home/.vimrc` | `~/.vimrc` |
| `home/.config/mise/config.toml` | `~/.config/mise/config.toml` |
| `home/.config/starship.toml` | `~/.config/starship.toml` |
| `home/.config/nvim` | `~/.config/nvim` |
| `home/.config/zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| `home/.claude/settings.json` | `~/.claude/settings.json` |
| `home/.claude/statusline.sh` | `~/.claude/statusline.sh` |
| `home/.claude/commands/` | `~/.claude/commands/` |
| `shared/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `shared/AGENTS.md` | `~/.claude/AGENTS.md`, `~/.codex/AGENTS.md` |
| `shared/skills/` | `~/.claude/skills/`, `~/.agents/skills/` |
| `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |

## Key Files

- **`home/`** — `$HOME` のミラー。配下のファイルは同じ相対パスで `~` にリンクされる。
- **`Brewfile`** — Homebrew の共通パッケージ。環境差分は `Brewfile.private` か `Brewfile.work`。どちらを入れるかは `./setup.sh private` または `./setup.sh work`。zsh の選択は `~/.zshrc.local` が `private.zsh` か `work.zsh` を source する。
- **`home/.config/mise/config.toml`** — ランタイムバージョン管理（Node 24 / Python 3.13 / Go 1 / AWS CLI 2.22.12）。
- **`home/.config/nvim/`** — lazy.nvim を使った Neovim 設定。エントリポイントは `init.lua`、プラグインは `lua/plugins/init.lua`、オプションは `lua/options.lua`、キーマップは `lua/keymaps.lua`。
- **`shared/`** — Claude Code / Codex 共有の AI エージェント資産。`AGENTS.md`（共通グローバル指示）と `skills/`（Agent Skills 標準の SKILL.md 群）。両ツールのグローバルパスに同じ実体をリンクする（1 実体 → 複数箇所なので `home/` ミラーではなく例外扱い）。Claude Code は `AGENTS.md` を読まないため、`CLAUDE.md`（`@~/.claude/AGENTS.md` を import するだけの薄いファイル）を経由させる。
- **`claude/`** — Claude Code 関連の repo ツールで `$HOME` には配置しない（`setup-mcp.sh`・`sync-skills.sh`・`skills-manifest.txt`）。グローバル設定の実体は `home/.claude/` 側にある。

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

1. `home/` 配下に、`$HOME` での配置先と同じ相対パスで設定ファイルを置く（例: `~/.config/foo/bar` → `home/.config/foo/bar`）
2. `link.sh` に `link_home "<home 相対パス>"` を 1 行追加する（Library 配下やファンアウトが必要な場合のみ例外セクションに `link` を追加）
3. `.gitignore` は `/*` のホワイトリスト方式。`home/` 配下は追跡対象だが、`home/.claude/commands/*` のように個別許可している箇所へ追加する場合は `!` 行も足す
4. `README.md` / この表のリンク一覧を更新する
