#!/bin/bash

cd $(dirname "$0")

if [ "$(uname)" == 'Darwin' ]; then
    VIM=/Applications/MacVim.app/Contents/MacOS/Vim
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    VIM=$HOME/local/bin/vim

    export VIM_REPO=https://github.com/vim/vim.git
    export VIM_SRC_PATH=../tmp/vim_src
    export NUMCPUS=`grep -c '^processor' /proc/cpuinfo`
    export PYTHON_CONFIG_DIR=/usr/lib/python2.7/config-x86_64-linux-gnu

    mkdir ../tmp

    git clone $VIM_REPO $VIM_SRC_PATH
    cd $VIM_SRC_PATH

    git fetch origin
    git reset --hard origin/master

    make clean

    ./configure \
        --with-features=huge \
        --enable-multibyte \
        --enable-fontset \
        --enable-pythoninterp \
        --with-python-config-dir=$PYTHON_CONFIG_DIR \
        --prefix=$HOME/local

    make -j $NUMCPUS
    make install
fi

mkdir -p $HOME/.vim_swap
mkdir -p $HOME/.vim_backup

mkdir -p $HOME/.vim/plugged
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$VIM --version
$VIM +PlugUpgrade +PlugUpdate +PlugClean! +qall > /dev/null
