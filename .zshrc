######
# 環境変数
######
# LANG
export LANG=ja_JP.UTF-8
# PATH
case "${OSTYPE}" in
darwin*)
    PATH=$PATH:/usr/local/bin:/sbin:/usr/bin:/usr/local/git/bin:/opt/local/bin
    export MANPATH=/usr/local/man:/usr/share/man
    ;;
linux*)
    ;;
esac
# エディタ
export EDITOR="vim"
# ls をカラー表示
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

## Python
# pip
export PIP_DOWNLOAD_CACHE=$HOME/.pip_cache
export PIP_RESPECT_VIRTUALENV=true
# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
case "${OSTYPE}" in
darwin*)
    source /usr/local/bin/virtualenvwrapper.sh
    ;;
linux*)
    ;;
esac

## Ruby
## rvm
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
fi

######
# エイリアス
######
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

######
# プロンプト
######
autoload -Uz colors
colors
# 色を %{fg[green]%} のように指定ができる
setopt prompt_subst
# root の場合は # / その他は % でプロンプトを表示
case ${UID} in
0)
    PROMPT="%{$fg_bold[red]%}#%{$reset_color%} "
    PROMPT2="%{$fg_bold[red]%}%{$reset_color%} "
    SPROMPT="%{$fg_bold[red]%}%R -> %r? [n, y, a, e]:%{$reset_color%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{$fg_bold[red]%}${HOST%%.*} $PROMPT"
    ;;
*)
    PROMPT="%{$fg_bold[green]%}%%%{$reset_color%} "
    PROMPT2="%{$fg_bold[green]%}%{$reset_color%} "
    SPROMPT="%{$fg_bold[green]%}%R -> %r? [n, y, a, e]:%{$reset_color%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{$fg_bold[green]%}${HOST%%.*} $PROMPT"
    ;;
esac
# 右プロンプトにカレントディレクトリを表示
RPROMPT=" [%~]"

######
# コマンドヒストリ
######
HISTFILE=$HOME/.zsh/.zsh_history
HISESIZE=10000
SAVEHIST=10000
# 同じコマンドを重複して記録しない
setopt hist_ignore_dups
# ヒストリファイルを共有する
setopt share_history
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
