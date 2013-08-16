# dotfiles

https://github.com/chocoby/dotfiles

## セットアップ

```
git clone git@github.com:chocoby/dotfiles.git ~/dotfiles
cd ~/dotfiles
sh setup.sh
```

## サンプルファイル

`samples` ディレクトリ以下に格納

### git

* **git/hooks/prepare-commit-msg** : ブランチ名からチケット番号をパースし、コメントに付加してエディタを起動する git の hook

  ```
  ln -s ~/dotfiles/samples/git/hooks/prepare-commit-msg /path/to/.git/hooks/
  ```
