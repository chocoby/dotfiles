#!/bin/sh
cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

mkdir -p $HOME/.vim_swap
mkdir -p $HOME/.vim_backup

mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
