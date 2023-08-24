FROM ubuntu:16.04

ENV \
  TZ=Asia/Tokyo \
  TERM=screen-256color

RUN \
  sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list && \

  apt update && \
  apt install --no-install-recommends -y \
    software-properties-common && \
  add-apt-repository ppa:git-core/ppa -y && \

  apt update && \
  apt -y upgrade && \
  apt install --no-install-recommends -y \
    software-properties-common locales \
    build-essential python-dev libncurses-dev \
    ca-certificates \
    unzip \
    exuberant-ctags less vim git curl zsh tmux && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \

  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8 && \

  # FIXME
  chmod 777 /usr/local/bin && \

  ln -s /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/local/bin && \
  chmod a+x /usr/local/bin/diff-highlight && \

  useradd -m user && \
  chsh -s /bin/zsh user

ENV \
  HOME=/home/user

USER user

RUN \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/chocoby/dotfiles/main/scripts/install)"

RUN \
  mkdir -p $HOME/local/src && \
  mkdir -p $HOME/local/bin

WORKDIR /home/user/local/src

RUN \
  curl -fLo $HOME/local/src/ghq_linux_amd64.zip https://github.com/motemen/ghq/releases/download/v0.7.4/ghq_linux_amd64.zip && \
  unzip $HOME/local/src/ghq_linux_amd64.zip -d ghq_linux_amd64 && \
  cp $HOME/local/src/ghq_linux_amd64/ghq $HOME/local/bin/ && \

  curl -fLo $HOME/local/src/peco_linux_amd64.tar.gz https://github.com/peco/peco/releases/download/v0.3.6/peco_linux_amd64.tar.gz && \
  tar zxvf $HOME/local/src/peco_linux_amd64.tar.gz && \
  cp peco_linux_amd64/peco $HOME/local/bin

WORKDIR /home/user

CMD ["/bin/zsh"]
