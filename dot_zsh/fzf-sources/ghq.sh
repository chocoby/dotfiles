fzf_change_ghq_directory() {
  local destination_dir=$(echo "$(ghq list --full-path)" | fzf --tmux=center,60%,60% --height=60% --border)
  if [ -n "$destination_dir" ]; then
    BUFFER="cd $destination_dir"
    zle accept-line
  fi
}

zle -N fzf_change_ghq_directory
bindkey '^]' fzf_change_ghq_directory
bindkey 'C-]' fzf_change_ghq_directory
