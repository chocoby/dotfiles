# dotfiles

https://github.com/chocoby/dotfiles

## Setup

```
DOTFILES_DIR=~/src/github.com/chocoby/dotfiles
mkdir -p $DOTFILES_DIR
git clone git@github.com:chocoby/dotfiles.git $DOTFILES_DIR
cd $DOTFILES_DIR
./setup.sh
```

## Git hooks

* **prepare-commit-msg** : Add an issue id to commit comment from parsed branch name

  ```
  ln -s ~/src/github.com/chocoby/dotfiles/samples/git/hooks/prepare-commit-msg $GIT_REPO/.git/hooks/
  ```
