#!/bin/bash

for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ] && [ $dotfile != '.gitmodules' ]
    then
        ln -sfnv "$PWD/$dotfile" $HOME
    fi
done

mkdir -p $PWD/.config

for dir in $PWD/.config/*
do
    ln -sfnv $dir $HOME/.config
done

for file in $PWD/bin/*
do
    ln -sfnv $file /usr/local/bin
done
