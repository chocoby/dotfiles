######
# Envs
######
# LANG
export LANG=en_US.UTF-8
# PATH
case "${OSTYPE}" in
darwin*)
    PATH=$PATH:/usr/local/bin:/sbin:/usr/bin:/usr/local/git/bin:/opt/local/bin
    export MANPATH=/usr/local/man:/usr/share/man
    ;;
linux*)
    PATH=$PATH:/usr/local/bin:/sbin:/usr/bin:/usr/local/git/bin:/opt/local/bin
    export MANPATH=/usr/local/man:/usr/share/man
    ;;
esac
# Editor
export EDITOR=vim
# ls
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad
# git
export GIT_PAGER="lv -c"

## Python
# pip
export PIP_DOWNLOAD_CACHE=$HOME/.pip_cache
export PIP_RESPECT_VIRTUALENV=true
export PIP_REQUIRE_VIRTUALENV=true
export VIRTUALENV_USE_DISTRIBUTE=true
# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
if [[ -s "/usr/local/bin/virtualenvwrapper.sh" ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
# Mercurial
HGENCODING=utf-8
export HGENCODING

## Ruby
# rvm
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
fi

######
# Alias
######
if [[ -s "$HOME/local/bin/vim" ]]; then
    alias vim="$HOME/local/bin/vim"
elif [[ -s "/Applications/MacVim.app/Contents/MacOS/Vim" ]]; then
    alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
fi

case "${OSTYPE}" in
darwin*)
    alias ls='ls -GF'
    ;;
linux*)
    alias ls='ls --color -F'
    ;;
esac

alias ll='ls -lh'
alias la='ls -lha'

alias p='popd'

alias r='rails'

alias rgem='rvm gemset'

alias gco='git checkout'
alias gst='git status'
alias gci='git commit'
alias gme='git merge'
alias gdi='git diff'
alias gbr='git branch'
alias gps='git push'
alias gpl='git pull'
alias gad='git add'
alias glo='git log'
alias gbr='git branch'
alias gsh='git show'
alias gfl='git flow'
alias gcp='git cherry-pick'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ci) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit"

######
# Prompt
######
autoload -Uz colors
colors
# 色を %{fg[green]%} のように指定する
setopt prompt_subst
# vcs_info を表示
# http://d.hatena.ne.jp/tarao/20100114/1263436661
if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' formats '%R' '%S' '%s:%b'
    zstyle ':vcs_info:*' actionformats '%R' '%S' '%s:%b|%a'
    precmd_vcs_info () {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        repos=`print -nD "$vcs_info_msg_0_"`
        [[ -n "$repos" ]] && psvar[2]="$repos"
        [[ -n "$vcs_info_msg_1_" ]] && psvar[3]="$vcs_info_msg_1_"
        [[ -n "$vcs_info_msg_2_" ]] && psvar[1]="$vcs_info_msg_2_"
    }
    typeset -ga precmd_functions
    precmd_functions+=precmd_vcs_info

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

    local dirs='[%F{yellow}%3(v|%32<..<%3v%<<|%60<..<%~%<<)%f]'
    local vcs='%3(v|[%25<\<<%F{yellow}%2v%f@%F{blue}%1v%f%<<]|)'
    RPROMPT="$dirs$vcs"
else
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
    # 右プロンプトにカレントディレクトリを表示
    RPROMPT=" [%~]"
fi

######
# コマンドヒストリ
######
HISTFILE=$HOME/.zsh/.zsh_history
HISESIZE=100000
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

######
# 自動補完
######
autoload -U compinit
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

######
# キーバインド
######
# Emacs 風のキーバインド
bindkey -e
# ^ を入力で cd ..
bindkey '\^' cdup

######
# いろいろ
######
# cd を押さずに cd
setopt auto_cd
# 移動したディレクトリを記録しておく
setopt auto_pushd
# 自動修正
setopt correct

# ^ で cd ..
function cdup() {
    echo
    cd ..
    zle reset-prompt
}
zle -N cdup

# z.sh
_Z_CMD=j
source $HOME/.zsh/z.sh
precmd() {
    _z --add "$(pwd -P)"
}
