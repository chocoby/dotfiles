fzf_git_checkout_branch() {
  git checkout $(git branch | fzf --tmux=center,60%,60%)
}

fzf_git_status_add() {
  git add -A $(git status --short | fzf | awk '{ print $2 }')
}

fzf_git_change_worktree() {
  local worktrees entry destination_dir repo_root common_dir relative_dir
  local -a directories

  repo_root=$(git rev-parse --show-toplevel) || return
  worktrees=$(git worktree list --porcelain -z) || return
  for entry in "${(@0)worktrees}"; do
    if [[ "$entry" == 'worktree '* ]]; then
      destination_dir=${entry#worktree }
      common_dir=$repo_root
      relative_dir=''
      while [[ "$destination_dir" != "$common_dir" && "$destination_dir" != "${common_dir%/}/"* ]]; do
        common_dir=${common_dir:h}
        relative_dir+='../'
      done
      if [[ "$destination_dir" != "$common_dir" ]]; then
        relative_dir+=${destination_dir#"${common_dir%/}/"}
      fi
      directories+=("${relative_dir:-.}")
    fi
  done

  destination_dir=$(
    printf '%s\0' "${directories[@]}" |
      fzf --tmux=center,60%,60% --read0 --print0 --no-multi --prompt='Worktree> '
  ) || return

  builtin cd -- "$repo_root/${destination_dir%$'\0'}"
}

zle -N fzf_git_checkout_branch
zle -N fzf_git_status_add
