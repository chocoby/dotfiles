# dotfiles

https://github.com/chocoby/dotfiles

## Install

```
curl -sS https://starship.rs/install.sh | sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chocoby/dotfiles/main/scripts/install)"
```

## Usage

### Setup

```
cd ~/src/github.com/chocoby/dotfiles
make install
```

### Update submodules

```
make update
```

### Test on Docker

```
docker build -t chocoby/dotfiles .
docker run -it chocoby/dotfiles
```

## Git hooks

* **prepare-commit-msg** : Add an issue id to commit comment from parsed branch name with [buranko](https://github.com/chocoby/buranko)

  ```
  ln -s ~/src/github.com/chocoby/dotfiles/git/hooks/prepare-commit-msg `pwd`/.git/hooks/
  ```
