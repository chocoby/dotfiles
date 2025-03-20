# dotfiles

https://github.com/chocoby/dotfiles

## Install

```sh
# Linux
curl -sS https://starship.rs/install.sh | sh
curl https://mise.run | sh

# Mac
brew install mise starship

bash -c "$(curl -fsSL https://raw.githubusercontent.com/chocoby/dotfiles/main/scripts/install)"
```

## Usage

### Setup

```sh
cd ~/src/github.com/chocoby/dotfiles
make install
```

### Update submodules

```sh
make update
```

### Test on Docker

```sh
docker build -t chocoby/dotfiles .
docker run -it chocoby/dotfiles
```

## Git hooks

* **prepare-commit-msg** : Add an issue id to commit comment from parsed branch name with [buranko](https://github.com/chocoby/buranko)

  ```sh
  ln -s ~/src/github.com/chocoby/dotfiles/git/hooks/prepare-commit-msg `pwd`/.git/hooks/
  ```
