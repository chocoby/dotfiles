function peco-git-checkout-branch() {
  git checkout $(git branch | peco)
}

function peco-git-status-add() {
  git add -A $(git status --short | peco | awk '{ print $2 }')
}
