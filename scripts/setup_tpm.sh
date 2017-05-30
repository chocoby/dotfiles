#!/bin/bash

cd $(dirname "$0")

TPM_REPO=https://github.com/tmux-plugins/tpm
TPM_PATH=$HOME/.tmux/plugins/tpm

git clone $TPM_REPO $TPM_PATH
cd $TPM_PATH

git fetch origin
git reset --hard origin/master

$TPM_PATH/bin/install_plugins > /dev/null
$TPM_PATH/bin/clean_plugins > /dev/null
$TPM_PATH/bin/update_plugins all > /dev/null
