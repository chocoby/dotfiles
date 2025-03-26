# dotfiles

https://github.com/chocoby/dotfiles

## Install

```sh
cd ~
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply git@github.com:chocoby/dotfiles.git
```

## Git hooks

* **prepare-commit-msg** : Add an issue id to commit comment from parsed branch name with [buranko](https://github.com/chocoby/buranko)

  ```sh
  ln -s ~/src/github.com/chocoby/dotfiles/git/hooks/prepare-commit-msg `pwd`/.git/hooks/
  ```
