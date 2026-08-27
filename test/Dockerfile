# Minimal Linux box for verifying `chezmoi apply` end to end.
# Only preinstalls what a real machine would already have out of the box;
# everything else must be installed by .chezmoiscripts/*-linux.sh.tmpl.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        sudo \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# ubuntu:24.04 ships a uid 1000 "ubuntu" user; give it passwordless sudo.
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
