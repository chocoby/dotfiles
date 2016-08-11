#!/bin/bash
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ] && [ $dotfile != '.gitmodules' ]
    then
        ln -sfnv "$PWD/$dotfile" $HOME
    fi
done
