function peco-kill-process() {
  ps -ef | peco | awk '{ print $2 }' | xargs kill -9
}
