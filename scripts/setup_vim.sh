#!/bin/bash

cd $(dirname "$0")

export VIM_REPO=https://github.com/vim/vim.git
export VIM_SRC_PATH=../tmp/vim_src
export NUMCPUS=`grep -c '^processor' /proc/cpuinfo`
export PYTHON_CONFIG_DIR=/usr/lib/python2.7/config-x86_64-linux-gnu

mkdir ../tmp

mkdir -p $HOME/.vim_swap
mkdir -p $HOME/.vim_backup

mkdir -p $HOME/.vim/plugged
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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

$HOME/local/bin/vim --version
$HOME/local/bin/vim +PlugUpgrade +PlugUpdate +PlugClean! +qall > /dev/null
