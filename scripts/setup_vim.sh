#!/bin/bash

cd $(dirname "$0")

if [ "$(uname)" == 'Darwin' ]; then
    VIM=vim
    ln -s $(brew --prefix macvim)/MacVim.app /Applications
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    VIM=/usr/bin/vim
fi

mkdir -p $HOME/.vim_swap
mkdir -p $HOME/.vim_backup

mkdir -p $HOME/.vim/plugged
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$VIM --version
$VIM +PlugUpgrade +PlugUpdate +PlugClean! +qall > /dev/null
