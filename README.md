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

## 管理ファイル一覧

| dotfiles パス             | リンク先                                                     |
| ------------------------- | ------------------------------------------------------------ |
| `zsh/.zshrc`              | `~/.zshrc`                                                   |
| `git/.gitconfig`          | `~/.gitconfig`                                               |
| `vim/.vimrc`              | `~/.vimrc`                                                   |
| `mise/config.toml`        | `~/.config/mise/config.toml`                                 |
| `ghostty/config`          | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `starship/starship.toml`  | `~/.config/starship.toml`                                    |
| `neovim/.config/nvim`     | `~/.config/nvim`                                             |
| `zellij/config.kdl`       | `~/.config/zellij/config.kdl`                                |
| `shared/AGENTS.md`        | `~/.claude/CLAUDE.md` と `~/.codex/AGENTS.md`                |
| `shared/skills/`          | `~/.claude/skills/` と `~/.agents/skills/`                   |
| `claude/settings.json`    | `~/.claude/settings.json`                                    |
| `claude/statusline.sh`    | `~/.claude/statusline.sh`                                    |
| `claude/commands/`        | `~/.claude/commands/`                                        |
| `claude/agents/`          | `~/.claude/agents/`                                          |
| `vscode/settings.json`    | `~/Library/Application Support/Code/User/settings.json`      |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json`   |

## ディレクトリ構造

```
dotfiles/
├── install.sh               # セットアップスクリプト（メインエントリポイント）
├── link.sh                  # シンボリックリンク作成スクリプト
├── Brewfile                 # Homebrew パッケージリスト
├── .gitignore
├── README.md
├── CLAUDE.md
├── zsh/
│   ├── .zshrc
│   └── .zprofile
├── git/
│   └── .gitconfig
├── vim/
│   └── .vimrc
├── mise/
│   └── config.toml
├── ghostty/
│   └── config
├── starship/
│   └── starship.toml
├── neovim/
│   └── .config/nvim/        # lazy.nvim ベースの Neovim 設定
├── zellij/
│   └── config.kdl
├── shared/                  # Claude Code / Codex 共有の AI エージェント資産
│   ├── AGENTS.md            # 共通グローバル指示（~/.claude/CLAUDE.md と ~/.codex/AGENTS.md の実体）
│   └── skills/              # Agent Skills 標準（SKILL.md）のスキル群
├── claude/                  # Claude Code 固有設定
│   ├── settings.json
│   ├── statusline.sh
│   ├── setup-mcp.sh        # MCP サーバー登録スクリプト
│   ├── commands/
│   └── agents/
├── via/
│   └── EPOMAKER Split65/    # キーボードレイアウト設定
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
