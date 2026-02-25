# dotfiles

新しい Mac での開発環境を素早く再現するための設定ファイル集。

## セットアップ

```bash
git clone https://github.com/ikdrocket/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` を実行すると以下が自動で行われます:

1. **Homebrew** のインストール（未インストール時）
2. **Brewfile** に記載されたパッケージの一括インストール
3. **mise** による開発ツールのインストール
4. **シンボリックリンク** の作成
5. **VS Code 拡張機能** の一括インストール

## 管理ファイル一覧

| dotfiles パス             | リンク先                                                     |
| ------------------------- | ------------------------------------------------------------ |
| `zsh/.zshrc`              | `~/.zshrc`                                                   |
| `git/.gitconfig`          | `~/.gitconfig`                                               |
| `vim/.vimrc`              | `~/.vimrc`                                                   |
| `mise/config.toml`        | `~/.config/mise/config.toml`                                 |
| `ghostty/config`          | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `starship/starship.toml`  | `~/.config/starship.toml`                                    |
| `vscode/settings.json`    | `~/Library/Application Support/Code/User/settings.json`      |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json`   |

## ディレクトリ構造

```
dotfiles/
├── install.sh               # セットアップスクリプト（メインエントリポイント）
├── Brewfile                 # Homebrew パッケージリスト
├── .gitignore
├── README.md
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
