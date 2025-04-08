fzf_git_checkout_branch() {
  git checkout $(git branch | fzf)
}

fzf_git_status_add() {
  git add -A $(git status --short | fzf | awk '{ print $2 }')
}

zle -N fzf_git_checkout_branch
zle -N fzf_git_status_add
