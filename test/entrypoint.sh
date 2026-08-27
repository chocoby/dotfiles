#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

SRC_DIR=/src
DEST_DIR="${HOME}/.local/share/chezmoi"

# /src is mounted read-only, so copy it to the place chezmoi expects on a real
# machine. .git and .omc are not needed to apply and only slow the copy down.
mkdir -p "${DEST_DIR}"
tar -c -C "${SRC_DIR}" --exclude=./.git --exclude=./.omc . | tar -x -C "${DEST_DIR}"

exec "${DEST_DIR}/install.sh"
