#--------------------------------------
# Environment
#--------------------------------------
# LANG
export LANG=en_US.UTF-8

# PATH
PATH=$HOME/local/bin:/usr/local/bin:/sbin:/usr/bin:$PATH
PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
export PATH

export MANPATH=/usr/local/man:/usr/share/man

# Editor
case "${OSTYPE}" in
  darwin*)
    export EDITOR="/Applications/MacVim.app/Contents/MacOS/Vim"
    ;;
  linux*)
    export EDITOR=vim
    ;;
esac

# ls
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

# less
export LESS='-R'

# direnv
if builtin command -v direnv > /dev/null; then
  eval "$(direnv hook $SHELL)"
fi

## Ruby
# rbenv
if [[ -s "$HOME/.rbenv/bin/rbenv" ]]; then
  eval "$(rbenv init -)"
fi

## Golang
if [[ -s "$HOME/local/go" ]]; then
  export GOROOT=$HOME/local/go
  export PATH=$PATH:$GOROOT/bin
fi

export GOPATH=$HOME/.go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin

## Node
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"

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
elif [[ -s "/Applications/MacVim.app/Contents/MacOS/Vim" ]]; then
  alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
fi

# tmux
case "${OSTYPE}" in
  linux*)
    alias tmux='TERM=screen-256color tmux'
    ;;
esac

alias tm='tmux a -t'
alias tml='tmux list-sessions'

# Ruby
alias be='bundle exec'

# Rails
alias brs='be rails s'
alias brc='be rails c'
alias bsp='be rspec'
alias bra='be rake'

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

#--------------------------------------
# Prompt
#--------------------------------------
autoload -Uz colors
colors
# 色を %{fg[green]%} のように指定する
setopt prompt_subst

# root の場合は # / その他は % でプロンプトを表示
case ${UID} in
  0)
    PROMPT="%{$fg[red]%}#%{$reset_color%} "
    PROMPT2="%{$fg[red]%}%{$reset_color%} "
    SPROMPT="%{$fg[red]%}%R -> %r? [n, y, a, e]:%{$reset_color%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
      PROMPT="%{$fg[red]%}${HOST%%.*} $PROMPT"
    ;;
  *)
    PROMPT="%{$fg[green]%}%%%{$reset_color%} "
    PROMPT2="%{$fg[green]%}%{$reset_color%} "
    SPROMPT="%{$fg[green]%}%R -> %r? [n, y, a, e]:%{$reset_color%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
      PROMPT="%{$fg[green]%}${HOST%%.*} $PROMPT"
    ;;
esac

# vcs_info を表示
# http://d.hatena.ne.jp/tarao/20100114/1263436661
if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' max-exports 4
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "!"
  zstyle ':vcs_info:git:*' unstagedstr "+"
  zstyle ':vcs_info:git:*' formats '%R' '%S' '%b' '%c%u'
  zstyle ':vcs_info:git:*' actionformats '%R' '%S' '%b|%a' '%c%u'
  precmd_vcs_info() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    repos=`print -nD "$vcs_info_msg_0_"`
    [[ -n "$repos" ]] && psvar[2]="$repos"
    [[ -n "$vcs_info_msg_1_" ]] && psvar[3]="$vcs_info_msg_1_"
    [[ -n "$vcs_info_msg_2_" ]] && psvar[1]="$vcs_info_msg_2_"
    [[ -n "$vcs_info_msg_3_" ]] && psvar[4]="$vcs_info_msg_3_"
  }
  typeset -ga precmd_functions
  precmd_functions+=precmd_vcs_info

  local dirs='[%F{yellow}%3(v|%32<..<%3v%<<|%60<..<%~%<<)%f]'
  local vcs='%3(v|[%10<\<<%F{yellow}%2v%f%<<@%F{blue}%1v%f%4(v|:%4v|)]|)'
  local datetime="[%D{%m/%d %T}]"
  RPROMPT="$dirs$vcs$datetime"
else
  # 右プロンプトにカレントディレクトリを表示
  RPROMPT=" [%~]"
fi

#--------------------------------------
# History
#--------------------------------------
HISTFILE=$HOME/.zsh/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# 同じコマンドを重複して記録しない
setopt hist_ignore_dups
# 履歴ファイルに時刻を記録
setopt extended_history
# ヒストリファイルを共有する
setopt share_history
# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history
# root のコマンドはヒストリに追加しない
if [ $UID = 0 ]; then
  unset HISTFILE
  SAVEHIST=0
fi

#--------------------------------------
# Completion
#--------------------------------------
autoload -Uz compinit
compinit -u
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

# z.sh
_Z_CMD=j
source $HOME/.zsh/z/z.sh
precmd() {
  _z --add "$(pwd -P)"
}

# C-s でロックされるのを防ぐ
stty stop undef

# peco
for f (~/.zsh/peco-sources/*) source "${f}"

# Git: ブランチ checkout/pull(origin)
function git-co-pull-origin() {
  git checkout $1
  git pull origin $1
}

# Git: ブランチ checkout/pull(upstream)
function git-co-pull-upstream() {
  git checkout $1
  git pull upstream $1
}

# Git: 現在のブランチ
function git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

# Git: 整形されたログを出力
function git-log-graph() {
  git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ci) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit
}
