# ──────────────────────────────────────────
# 補完
# ──────────────────────────────────────────
autoload -U compinit && compinit -u

zstyle ':completion:*' list-colors "${LS_COLORS}"   # 補完候補に色をつける
zstyle ':completion:*:default' menu select=1         # 補完候補をハイライト
zstyle ':completion::complete:*' use-cache true      # キャッシュで高速化
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # 大文字小文字を区別しない

setopt complete_in_word  # 単語の途中でもTab補完を有効化
setopt list_packed       # 補完リストの表示間隔を狭くする

# ──────────────────────────────────────────
# ヒストリ
# ──────────────────────────────────────────
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

setopt hist_ignore_dups  # 重複するコマンドを記録しない
setopt share_history     # 複数のzshセッションで履歴を共有

# ──────────────────────────────────────────
# キーバインド
# ──────────────────────────────────────────
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search    # ↑ 入力中の文字列で履歴を絞り込む
bindkey "^[[B" down-line-or-beginning-search  # ↓

# Ctrl+R で peco を使ったヒストリ検索
function peco-history-selection() {
  BUFFER=$(fc -l -n 1 | tail -r | awk '!seen[$0]++' | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey "^R" peco-history-selection  # Ctrl+R でヒストリを peco で検索

# ──────────────────────────────────────────
# プラグイン
# ──────────────────────────────────────────
if type brew &>/dev/null; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if type brew &>/dev/null; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ──────────────────────────────────────────
# PATH / ツール
# ──────────────────────────────────────────
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

eval "$(direnv hook zsh)"

# ──────────────────────────────────────────
# エイリアス
# ──────────────────────────────────────────
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias zshconfig="vim ~/.zshrc"
alias dotfile="vim ~/dotfiles"
alias zshreload="source ~/.zshrc"
