#!/bin/bash
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ] && [ $dotfile != '.gitmodules' ]
    then
        ln -sfnv "$PWD/$dotfile" $HOME
    fi
done

ln -sfnv $PWD/bin/multi_ssh /usr/local/bin
ln -sfnv $PWD/bin/pero /usr/local/bin
