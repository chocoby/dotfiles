ghq-fzf_change_directory() {
  local destination_dir=$(echo "$(ghq list --full-path)" | fzf)
  if [ -n "$destination_dir" ]; then
    BUFFER="cd $destination_dir"
    zle accept-line
  fi
}

zle -N ghq-fzf_change_directory
bindkey '^]' ghq-fzf_change_directory
bindkey 'C-]' ghq-fzf_change_directory
