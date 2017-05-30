function git-co-pull-origin() {
  git checkout $1
  git pull origin $1
}

function git-co-pull-upstream() {
  git checkout $1
  git pull upstream $1
}

function git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

function git-log-graph() {
  git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ci) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit
}
