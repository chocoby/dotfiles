function peco-git-checkout-branch() {
  git checkout $(git branch | peco | awk '{sub("*", ""); print $0;}')
}
