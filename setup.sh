#!/bin/sh
cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

mkdir -p $HOME/.zsh
mkdir -p $HOME/.vim_swap
mkdir -p $HOME/.vim_backup

git submodule init
git submodule update
