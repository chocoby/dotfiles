function _filter_ssh_configs() {
  awk '
    $1 == "Host" {
        host = $2;
        next;
    }
    $1 == "User" {
        $1 = "";
        sub( /^[[:space:]]*/, "" );
        printf "%s@%s\n", $0, host;
    }
  '
}

function peco-ssh () {
  local selected_host="$(cat ~/.ssh/config ~/.ssh/conf.d/**/* | _filter_ssh_configs | sort | peco)"
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
   zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ssh
bindkey '^\' peco-ssh
