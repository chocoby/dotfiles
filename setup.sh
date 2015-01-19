#!/bin/sh
cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ] && [ $dotfile != '.gitmodules' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

git submodule init
git submodule update

# Vim
mkdir -p $HOME/.vim_swap
mkdir -p $HOME/.vim_backup

mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# Git
git config --global core.excludesfile ~/.gitignore_global
git config --global color.ui auto
