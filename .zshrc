#--------------------------------------
# Environment
#--------------------------------------
# LANG
export LANG=en_US.UTF-8

# PATH
PATH=$HOME/local/bin:$HOME/.local/bin:/usr/local/bin:/sbin:/usr/bin:$PATH

# Homebrew
if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/bin:$PATH"
elif [ "$(uname -m)" = "darwin" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH

# Editor
export EDITOR=vim

# less
export LESS='-R'

# GPG
export GPG_TTY=$(tty)

# evalcache
source $HOME/.zsh/evalcache/evalcache.plugin.zsh

# direnv
if builtin command -v direnv > /dev/null; then
  _evalcache direnv hook zsh
fi

# Ruby
PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
if builtin command -v rbenv > /dev/null; then
  _evalcache rbenv init -
fi

# Python
if builtin command -v pyenv > /dev/null; then
  _evalcache pyenv init -
fi

# Node
function load-nvm () {
  export NVM_DIR="$HOME/.nvm"

  case "${OSTYPE}" in
    darwin*)
      [[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh
      ;;
    linux*)
      [[ -s ~/.nvm/nvm.sh ]] && source ~/.nvm/nvm.sh
      ;;
  esac
}

load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    if ! type nvm >/dev/null; then
      load-nvm
    fi
    nvm use
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd load-nvmrc

# Rust
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Visual Studio Code
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"


#--------------------------------------
# Alias
#--------------------------------------
# ls
case "${OSTYPE}" in
  darwin*)
    alias ls='ls -GF'
    ;;
  linux*)
    alias ls='ls --color -F'
    ;;
esac

alias ll='ls -lh'
alias la='ll -a'

alias p='popd'

# vim
if [[ -s "$HOME/local/bin/vim" ]]; then
  alias vim="$HOME/local/bin/vim"
fi

alias tm='tmux a -t'
alias tml='tmux list-sessions'

# Ruby
alias be='bundle exec'
alias rr='be rubocop -A $(git status -s "*.rb" | cut -c4-)'

# Git
alias gg='git grep'
alias gfe='git fetch'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gst='git status'
alias gci='git commit'
alias gcia='git commit --amend'
alias gme='git merge'
alias gdi='git diff'
alias gdic='gdi --cached'
alias gbr='git branch'
alias gsh='git show'
alias gps='git push'
alias gpsu='gps upstream'
alias gpso='gps origin'
alias gpsoc='git push origin `git-current-branch`'
alias gpsocf='git push -f origin `git-current-branch`'
alias gpl='git pull'
alias gplu='gpl upstream'
alias gplo='gpl origin'
alias gad='git add'
alias gadp='git add -p'
alias glo='git log'
alias gcp='git cherry-pick'
alias gre='git rebase'
alias grei='git rebase -i'
alias gres='git reset'
alias gwc='git whatchanged'
alias glog='git-log-graph'
alias gcpo='git-co-pull-origin'
alias gcpu='git-co-pull-upstream'

# peco
alias pgco='peco-git-checkout-branch'
alias pgadd='peco-git-status-add'

alias pdrm='peco-rm-docker-ps'
alias pdrmi='peco-rm-docker-images'

# Docker
alias dc='docker compose'

# Terraform
alias tf='terraform'

# ripgrep
alias rga='rg --hidden --no-ignore'

#--------------------------------------
# Prompt
#--------------------------------------
eval "$(starship init zsh)"

#--------------------------------------
# History
#--------------------------------------
HISTFILE=$HOME/.zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
# history に保存しないコマンド
HISTORY_IGNORE="(ls|ll|cd|pwd|gst|gdi|gdic|gpsoc|gfe|glo|grei|gci|gcia|gco|gsh)"
# 同じコマンドを重複して記録しない
setopt hist_ignore_dups
# 履歴ファイルに時刻を記録
setopt extended_history
# ヒストリファイルを共有する
setopt share_history
# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history
# history コマンドを記録しない
setopt hist_no_store
# 余分な空白を詰めて記録
setopt hist_reduce_blanks
# 履歴検索中、重複を飛ばす
setopt hist_find_no_dups
# 行頭がスペースのコマンドは記録しない
setopt hist_ignore_space
# root のコマンドはヒストリに追加しない
if [ $UID = 0 ]; then
  unset HISTFILE
  SAVEHIST=0
fi

#--------------------------------------
# Completion
#--------------------------------------
autoload -Uz compinit
compinit
# ビープ音を鳴らさないようにする
setopt nolistbeep
# 補完候補を一覧表示
setopt auto_list
# 補完候補を詰めて表示
setopt list_packed
# 補完候補の色付け
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を矢印キーなどで選択できるようにする
zstyle ':completion:*:default' menu select
# --prefix=/usr などの = 以降でも補完
setopt magic_equal_subst
# カッコの対応などを自動的に補完する
setopt auto_param_keys

#--------------------------------------
# Keybind
#--------------------------------------
# Emacs 風のキーバインド
bindkey -e

# glob (*) でヒストリをインクリメンタル検索
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

#--------------------------------------
# Other
#--------------------------------------
# cd を押さずに cd
setopt auto_cd
# 移動したディレクトリを記録しておく
setopt auto_pushd
# 自動修正
setopt correct

# C-s でロックされるのを防ぐ
stty stop undef

# peco
for f (~/.zsh/peco-sources/*) source "${f}"

# git
for f (~/.zsh/git-scripts/*) source "${f}"
