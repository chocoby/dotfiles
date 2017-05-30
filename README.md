# dotfiles

https://github.com/chocoby/dotfiles

## Install

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chocoby/dotfiles/master/scripts/install)"
```

## Usage

### Update

```
cd ~/src/github.com/chocoby/dotfiles
make install
```

### Homebrew

```
brew bundle
```

### Testing on Docker

```
docker build -t chocoby/dotfiles .
docker run -it chocoby/dotfiles
```

## Git hooks

* **prepare-commit-msg** : Add an issue id to commit comment from parsed branch name

  ```
  ln -s ~/src/github.com/chocoby/dotfiles/git/hooks/prepare-commit-msg `pwd`/.git/hooks/
  ```
