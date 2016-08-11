FROM ubuntu:16.04

RUN \
  sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list && \

  apt update && \
  apt install --no-install-recommends -y \
    software-properties-common && \
  add-apt-repository ppa:git-core/ppa -y && \

  apt update && \
  apt -y upgrade && \
  apt install --no-install-recommends -y \
    software-properties-common \
    build-essential python-dev libncurses-dev \
    ca-certificates \
    exuberant-ctags less vim git curl zsh tmux && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \

  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8 && \

  ln -s /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/local/bin && \
  chmod a+x /usr/local/bin/diff-highlight && \

  useradd -m user && \
  chsh -s /bin/zsh user

ENV \
  TERM=screen-256color \
  HOME=/home/user

WORKDIR /home/user
USER user

RUN \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/chocoby/dotfiles/master/scripts/install)"

CMD ["/bin/zsh"]
