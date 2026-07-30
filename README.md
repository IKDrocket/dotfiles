# dotfiles

新しい Mac での開発環境を素早く再現するための設定ファイル集。

## セットアップ

```bash
git clone https://github.com/ikdrocket/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` を実行すると以下が自動で行われます:

1. **Xcode CLI ツール** と **Rosetta**（Apple Silicon）のインストール
2. **Homebrew** のインストール（未インストール時）と Brewfile パッケージの一括インストール
3. **mise** による開発ランタイムのインストール
4. **シンボリックリンク** の作成（link.sh 実行）
5. **Claude Code MCP サーバー** の登録（claude/setup-mcp.sh 実行）
6. **VS Code 拡張機能** の一括インストール

### シンボリックリンクの再作成（メンテナンス時）

`link.sh` はデフォルトで **dry-run**（実行予定の操作を表示するだけで何も変更しない）。削除対象を確認してから反映できます。

```bash
./link.sh           # dry-run: 何をするか表示するだけ
./link.sh --apply   # 実際にリンクを作成・削除する
```

## 管理ファイル一覧

`home/` 配下は `$HOME` のミラーで、リポジトリ上の階層がそのまま配置先になります（`home/.config/nvim` → `~/.config/nvim`）。`shared/` と Library 配下のアプリ設定は 1 対多・特殊パスのため例外扱いです。

| dotfiles パス                    | リンク先                                                     |
| -------------------------------- | ------------------------------------------------------------ |
| `home/.zshrc`                    | `~/.zshrc`                                                   |
| `home/.gitconfig`                | `~/.gitconfig`                                               |
| `home/.vimrc`                    | `~/.vimrc`                                                   |
| `home/.config/mise/config.toml`  | `~/.config/mise/config.toml`                                 |
| `home/.config/starship.toml`     | `~/.config/starship.toml`                                    |
| `home/.config/nvim/`             | `~/.config/nvim/`                                            |
| `home/.config/zellij/config.kdl` | `~/.config/zellij/config.kdl`                                |
| `home/.claude/settings.json`     | `~/.claude/settings.json`                                    |
| `home/.claude/statusline.sh`     | `~/.claude/statusline.sh`                                    |
| `home/.claude/commands/`         | `~/.claude/commands/`                                        |
| `shared/AGENTS.md`               | `~/.claude/CLAUDE.md` と `~/.codex/AGENTS.md`                |
| `shared/skills/`                 | `~/.claude/skills/` と `~/.agents/skills/`                   |
| `ghostty/config`                 | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `vscode/settings.json`           | `~/Library/Application Support/Code/User/settings.json`      |
| `vscode/keybindings.json`        | `~/Library/Application Support/Code/User/keybindings.json`   |

## ディレクトリ構造

```
dotfiles/
├── install.sh               # セットアップスクリプト（メインエントリポイント）
├── link.sh                  # シンボリックリンク作成スクリプト
├── Brewfile                 # Homebrew パッケージリスト
├── .gitignore
├── README.md
├── CLAUDE.md
├── home/                    # $HOME のミラー（配下がそのまま ~ に配置される）
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .vimrc
│   ├── .config/
│   │   ├── mise/config.toml
│   │   ├── starship.toml
│   │   ├── nvim/            # lazy.nvim ベースの Neovim 設定
│   │   └── zellij/config.kdl
│   └── .claude/
│       ├── settings.json
│       ├── statusline.sh
│       └── commands/
├── shared/                  # Claude Code / Codex 共有の AI エージェント資産（1 実体を複数箇所へ配布）
│   ├── AGENTS.md            # 共通グローバル指示（~/.claude/CLAUDE.md と ~/.codex/AGENTS.md の実体）
│   └── skills/              # Agent Skills 標準（SKILL.md）のスキル群
├── claude/                  # Claude Code 関連の repo ツール（$HOME には配置しない）
│   ├── setup-mcp.sh         # MCP サーバー登録スクリプト
│   ├── sync-skills.sh       # 外部 skills 同期スクリプト
│   └── skills-manifest.txt  # 外部 skills の一覧
├── via/
│   └── EPOMAKER Split65/    # キーボードレイアウト設定
├── ghostty/
│   └── config
└── vscode/
    ├── settings.json
    ├── keybindings.json
    └── extensions.txt
```

## 除外ファイル（機密情報）

以下のファイルは機密情報を含むため管理対象外:

- `~/.npmrc` — npm 認証トークン
- `~/.ssh/` — SSH 秘密鍵
- `~/.aws/credentials` — AWS 認証情報

## シンボリックリンクの確認

```bash
ls -la ~ | grep '\->'
ls -la ~/.config/mise/
ls -la ~/Library/Application\ Support/Code/User/
```
